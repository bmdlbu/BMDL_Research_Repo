#include <gtk/gtk.h>
#include <FlyCapture/FlyCapture2_C.h>
#include <stdio.h>
#include <fcntl.h>
#include <pthread.h>
#include <semaphore.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include "motor.h"
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <termios.h>


/* Creating pointers for the welcome screen */
GtkBuilder  *welcome_builder;
GtkWidget   *welcome_window;

/* Pointer for the start window to activate */
GtkBuilder  *start_builder;
GtkWidget   *start_window;

/* Pointers for the Instructions Menu */
GtkBuilder  *instructions_builder;
GtkWidget   *instructions_window;

/* Pointers for the Substrate Alignment Window */
GtkBuilder  *alignment_builder;
GtkWidget   *alignment_window;

/* Pointers for the Substrate Placement Window */
GtkBuilder  *placement_builder;
GtkWidget   *placement_window;

/* Pointers for the Saving Rate Window */
GtkBuilder  *rate_builder;
GtkWidget   *rate_window;

/* Pointers for the Saving Feature Window */
GtkBuilder  *save_builder;
GtkWidget   *save_window;

/* Pointers for the Report a Bug Window */
GtkBuilder  *report_builder;
GtkWidget   *report_window;

/* Pointers for the Test Collimation Window */
GtkBuilder  *collimation_builder;
GtkWidget   *collimation_window;

/* Pointers for the Sensing Mode */
GtkBuilder  *sensing_builder;
GtkWidget   *sensing_window;

/* Pointers to the Sensing objects */
GtkWidget*  sensing_image;
GtkButton*  sensing_resume_toggle;  
GtkWidget*  sensing_saving_toggle;
GtkLabel*   sensing_rate_number;
GtkLabel*   sensing_current_save_number;
GtkLabel*   sensing_diode_number;
GtkButton*  sensing_vacuum_toggle;

/* Pointers for the Stored Images Window */
GtkBuilder  *stored_builder;
GtkWidget   *stored_window;

/* FlyCapture 2 Variables */
fc2Error error;
fc2Context context;
fc2PGRGuid guid;

/* Display Image Buffer */
#define IMG_SIZE 3724896
unsigned char imgBuf[IMG_SIZE];

/* Image Thread Variables */
sem_t threadLock;
pthread_t imgThread;
int threadExit = 0;
int paused = 1;

/* Run-time variables */
int operating = 1;
int capturing = 0;
int saving = 0;
int vacuumActive = 0;
int saveRate = 1000000;
int count = 0;
int laser = 0;
float hertz = 1.0; 
gchar* entry_rate = NULL;
char saveRateText[10];

/* Timing variables */
struct timeval start;
struct timeval end;
int difference = 0;


/* Imaging initializations */
void* imgThreadMain(void* arg);
void updateImage();
gboolean gtkImageFunction(gpointer user_data);
gboolean gtkDiodeDisplayFunction(gpointer user_data);
void GrabImage(fc2Context context);
int maestroSetTarget(int fd, unsigned char channel, unsigned short target);
int maestroGetPosition(int fd, unsigned char channel);
char filename[25];
char saveCommand[80];



/* Diode Information */
enum Diode_t { lambda1, lambda2, lambda3 };
typedef enum Diode_t Diode;
const char* diodeWavelengths[] = {"780", "850", "904"};
const int numDiodes = 3;
Diode manDiode = lambda1;

int main(int argc, char *argv[])
{
    /* Initializing the gtk package based on the command line parameters given
     * */
    gtk_init(&argc, &argv);

/* Welcome Window */

    /* Creating a new welcome_builder based on the .glade file */
    welcome_builder = gtk_builder_new();
    gtk_builder_add_from_file(welcome_builder, "welcome_window_main.glade", NULL);

    /* Creating the welcome_window widget based on the welcome_builder */
    welcome_window = GTK_WIDGET(gtk_builder_get_object(welcome_builder,
                "welcome_screen_window"));
    gtk_builder_connect_signals(welcome_builder, NULL);
   
/* Start Menu */
    
    /* Creating a new start_builder based on the .glade file */
    start_builder = gtk_builder_new();
    gtk_builder_add_from_file(start_builder, "start_menu_window.glade", NULL);

    /* Creating a new start_window widget based on the start_builder */
    start_window = GTK_WIDGET(gtk_builder_get_object(start_builder, "start_menu_window"));
    gtk_builder_connect_signals(start_builder, NULL);

/* Instructions Menu */
    
    /* Creating a new instructions_builder based on the .glade file */
    instructions_builder = gtk_builder_new();
    gtk_builder_add_from_file(instructions_builder, "instructions_menu_window.glade", NULL);

   /* Creating a new instructions_window widget based on the instructions_builder */
    instructions_window = GTK_WIDGET(gtk_builder_get_object(instructions_builder,
                "instructions_window"));
    gtk_builder_connect_signals(instructions_builder, NULL);

/* Substrate Alignment Window */
    
    /* Creating a new alignment_builder based on the .glade file */
    alignment_builder = gtk_builder_new();
    gtk_builder_add_from_file(alignment_builder, "substrate_alignment_window.glade", NULL);

    /* Creating a new alignment_window widget based on the alignment_builder */
    alignment_window = GTK_WIDGET(gtk_builder_get_object(alignment_builder,
                "alignment_window"));
    gtk_builder_connect_signals(alignment_builder, NULL);

/* Substrate Placement Window */
    
    /* Creating a new placement_builder based on the .glade file */
    placement_builder = gtk_builder_new();
    gtk_builder_add_from_file(placement_builder, "substrate_placement_window.glade", NULL);

    /* Creating a new placement_window widget based on the placement_builder */
    placement_window = GTK_WIDGET(gtk_builder_get_object(placement_builder,
                "placement_window"));
    gtk_builder_connect_signals(placement_builder, NULL);

/* Save Feature Window */

    /* Creating a new save_builder based on the .glade file */
    save_builder = gtk_builder_new();
    gtk_builder_add_from_file(save_builder, "save_feature_window.glade", NULL);

    /* Creating a new save_window widget based on the save_builder */
    save_window = GTK_WIDGET(gtk_builder_get_object(save_builder,
                "save_window"));
    gtk_builder_connect_signals(save_builder, NULL);


/* Save Rate Window */

    /* Creating a new rate_builder based on the .glade file */
    rate_builder = gtk_builder_new();
    gtk_builder_add_from_file(rate_builder, "saving_rate_window.glade", NULL);

    /* Creating a new rate_window widget based on the rate_builder */
    rate_window = GTK_WIDGET(gtk_builder_get_object(rate_builder,
                "rate_window"));
    gtk_builder_connect_signals(rate_builder, NULL);

/* Report a Bug Window */

    /* Creating a new report_builder based on the .glade file */
    report_builder = gtk_builder_new();
    gtk_builder_add_from_file(report_builder, "report_a_bug_window.glade", NULL);

    /* Creating a new start_window widget based on the start_builder */
    report_window = GTK_WIDGET(gtk_builder_get_object(report_builder,
                "report_window"));
    gtk_builder_connect_signals(report_builder, NULL);

/* Test Collimation Window */

    /* Creating a new collimation_builder based on the .glade file */
    collimation_builder = gtk_builder_new();
    gtk_builder_add_from_file(collimation_builder, "test_collimation_window.glade", NULL);

    /* Creating a new collimation_window widget based on the collimation_builder */
    collimation_window = GTK_WIDGET(gtk_builder_get_object(collimation_builder,
                "collimation_window"));
    gtk_builder_connect_signals(collimation_builder, NULL);

/* Sensing Mode Window */

    /* Creating a new sensing_builder based on the .glade file */
    sensing_builder = gtk_builder_new();
    gtk_builder_add_from_file(sensing_builder, "sensing_mode_window.glade", NULL);

    /* Creating a new sensing_window widget based on the sensing_builder */
    sensing_window = GTK_WIDGET(gtk_builder_get_object(sensing_builder,
                "sensing_window"));
    gtk_builder_connect_signals(sensing_builder, NULL);
   
    // Connecting the Sensor widget to show the image to camera
    sensing_image = GTK_WIDGET(gtk_builder_get_object(sensing_builder, "sensing_image"));
    sensing_resume_toggle = GTK_BUTTON(gtk_builder_get_object(sensing_builder,"sensing_resume_toggle"));
    sensing_saving_toggle = GTK_WIDGET(gtk_builder_get_object(sensing_builder, "sensing_saving_toggle"));
    sensing_rate_number = GTK_LABEL(gtk_builder_get_object(sensing_builder,"sensing_rate_number"));
    sensing_current_save_number = GTK_LABEL(gtk_builder_get_object(sensing_builder,"sensing_current_save_number"));
    sensing_diode_number = GTK_LABEL(gtk_builder_get_object(sensing_builder,
                "sensing_diode_number"));
    sensing_vacuum_toggle = GTK_BUTTON(gtk_builder_get_object(sensing_builder,
                "sensing_vacuum_toggle"));

/* Stored Images Window */

    /* Creating a new stored_builder based on the .glade file */
    stored_builder = gtk_builder_new();
    gtk_builder_add_from_file(stored_builder, "stored_images_window.glade", NULL);

    /* Creating a new stored_window widget based on the stored_builder */
    stored_window = GTK_WIDGET(gtk_builder_get_object(stored_builder,
                "stored_window"));
    gtk_builder_connect_signals(stored_builder, NULL);


    /* Unreferencing the builder object to clear up the memory for the pointer*/
    g_object_unref(start_builder);
    g_object_unref(welcome_builder);
    g_object_unref(instructions_builder);
    g_object_unref(alignment_builder);
    g_object_unref(placement_builder);
    g_object_unref(save_builder);
    g_object_unref(rate_builder);
    g_object_unref(report_builder);
    g_object_unref(collimation_builder);
    g_object_unref(sensing_builder);
    g_object_unref(stored_builder);
    
    // Camera counter for copied FlyCap code
    unsigned int numCameras = 0;

    /* Setting up the Camera -- Based on API Example */
    // Creating the Context
    error = fc2CreateContext( &context );
    printf("Creating the context...");
    if (error != FC2_ERROR_OK) {
        printf("error in fc2CreateContext: %d\n", error);
    }
    printf("Done\n");

    // Getting the number of Cameras
    error = fc2GetNumOfCameras( context, &numCameras);
    printf("Gettin the Number of Cameras...");
    if (error != FC2_ERROR_OK) {
        printf("Error in fc2GetNumOfCameras: %d\n",error);
    }
    
    if (numCameras == 0) {
        // No cameras detected
        printf("No cameras detected.\n");
    
    }
    printf("Done\n");

    // Get the 0th Camera
    if (numCameras > 0) {
        // Getting the 0th Camera in the index
        printf("Getting the 0th Camera...");
        error = fc2GetCameraFromIndex( context, 0, &guid);
        if(error != FC2_ERROR_OK) {
            printf("Error in fc2GetCameraFromIndex: %d\n", error);
        }
        printf("Done\n");

        printf("Connecting the camera...");
        error = fc2Connect(context, &guid);
        if (error != FC2_ERROR_OK) {
            printf("Error in fc2Connect: %d\n", error);
        }
        else {
            printf("Done\n");

            // Set camera image settings
            fc2Property propSetting;
            propSetting.absControl = TRUE;
            propSetting.onePush = FALSE;
            propSetting.onOff = TRUE;
            propSetting.autoManualMode = FALSE;

            // Setting the brightness
            propSetting.type = FC2_BRIGHTNESS;
            propSetting.absValue = 0.367; 
            fc2SetProperty( context, &propSetting );

            // Setting the exposure
            propSetting.type = FC2_AUTO_EXPOSURE;
            propSetting.absValue = 1.625;
            fc2SetProperty( context, &propSetting );

            // Setting the sharpness
            propSetting.type = FC2_SHARPNESS;
            propSetting.absControl = FALSE;
            propSetting.valueA = 1800;
            fc2SetProperty(context, &propSetting);

            // Setting the shutter
            propSetting.type = FC2_SHUTTER;
            propSetting.absControl = TRUE;
            propSetting.absValue = 6.011;
            fc2SetProperty(context, &propSetting);

            // Setting the Gain
            propSetting.type = FC2_GAIN;
            propSetting.absValue = 0.0;
            fc2SetProperty(context, &propSetting);

            // Setting the Frame Rate
            propSetting.type = FC2_FRAME_RATE;
            propSetting.absValue = 1.50;
            fc2SetProperty(context, &propSetting);  
        }
    }
                                 
    sem_init(&threadLock, 0,1);
    if (pthread_create(&imgThread, NULL, imgThreadMain, NULL) != 0) {
        perror("Error");
    }

    printf("Initializd the sem_init\n");
    
    /* Setting up the wiring for the GPIO */ 
    wiringPiSetup();
    
    /* Setting up output pin for the vacuum */
    pinMode(0, OUTPUT);
    
    /* Opening the communication between the laser blocking driver */
    /* Pointer to the blocking system */
    const char * device = "/dev/ttyACM0";   
        
    /* Creating the file descriptor for communication with the driver */
    int fd = open(device, O_RDWR); 

    /* Checking to see if the driver was connected to */
    if(fd == -1) {
        perror("Error connecting to the driver");
    }

    /* Start testing the laser blocking system calls
    char * command;
    command = "./UscCmd --servo 0,7000";
    system(command);
    printf("Past first systen call\n");
       */

    /* Setting the settings for the driver  
    struct termios options;
    tcgetattr(fd, &options);
    options.c_iflag &= ~(INLCR | IGNCR | ICRNL | IXON | IXOFF);
    options.c_oflag &= ~(ONLCR| OCRNL);
    options.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
    tcsetattr(fd, TCSANOW, &options);

    printf("Made it thus far\n");
    
    int getPosition = maestroGetPosition(fd, 1);
    printf("Current position of channel 0: %d\n", getPosition);
    getPosition = maestroGetPosition(fd, 1);
    printf("Current position of channel 1: %d\n", getPosition);
    getPosition = maestroGetPosition(fd, 2);
    printf("Current position of channel 2: %d\n", getPosition);

    printf("Made it past the getPosition\n");

    int maestro_write_result = maestroSetTarget(fd, 0, 7000);
    printf("Maestro write result is %d\n",maestro_write_result);
    */
    

    /* Showing the window widget */
    gtk_widget_show(welcome_window);  
    gtk_main();

    return 0;
}


/* Windows being destroyed */

/* Called when the welcome window is closed */
void on_welcome_screen_window_destroy() 
{
    /* Quitting the gtk ensemble */
    gtk_main_quit();
}

/* Called when the start window is closed */
void on_start_menu_window_destroy()
{
    /* Quitting the gtk ensemble */
    gtk_main_quit();
}

/* Called when the instructions window is closed */
void on_instructions_window_destroy() {
    /* Quitting the gtk ensemble */
    gtk_main_quit();
}

/* Called when the sensing window is closed */
void on_sensing_window_destroy() {
    /* Quitting the gtk ensemble */
    gtk_main_quit();
}

/* Called when the stored images window is closed */
void on_stored_window_destroy() {
    /* Quitting the gtk ensemble */
    gtk_main_quit();
}

/* Called when the sensing window is closed */
void on_alignment_window_destroy() {
    /* Quitting the gtk ensemble */
    gtk_main_quit();
}

/* Called when the sensing window is closed */
void on_placement_window_destroy() {
    /* Quitting the gtk ensemble */
    gtk_main_quit();
}

/* Called when the sensing window is closed */
void on_save_window_destroy() {
    /* Quitting the gtk ensemble */
    gtk_main_quit();
}

/* Called when the sensing window is closed */
void on_rate_window_destroy() {
    /* Quitting the gtk ensemble */
    gtk_main_quit();
}

/* Called when the sensing window is closed */
void on_report_window_destroy() {
    /* Quitting the gtk ensemble */
    gtk_main_quit();
}

/* Called when the sensing window is closed */
void on_collimation_window_destroy() {
    /* Quitting the gtk ensemble */
    gtk_main_quit();
}

/* Navigational Buttons */

/*** Welcome Screen ***/

/* Handling the welcome button */
void on_welcome_to_start_button_clicked() {
    /* Hiding the welcome screen */
    gtk_widget_hide(welcome_window);
   
    /* Showing the start menu */
    gtk_widget_show(start_window);
}

/*** Start Menu Screen ***/

/* Moving from the the start menu back to the Welcome screen */
void on_start_to_welcome_button_clicked() {
    /* Hiding the start menu window */
    gtk_widget_hide(start_window);

    /* Reshowing the welcome screen */
    gtk_widget_show(welcome_window);

}

/* Start Menu to the Sensing Mode */
void on_start_to_sensing_button_clicked() {
    
    /* Hiding the Start Menu */
    gtk_widget_hide(start_window);

    /* Showing the Sensing Mode Window */
    gtk_widget_show(sensing_window);

}

/* Start Menu to Instructions Menu */
void on_start_to_instructions_button_clicked() {
    /* Hiding the Start Menu */
    gtk_widget_hide(start_window);
    
    /* Showing the Instructions Menu */
    gtk_widget_show(instructions_window);
}

/* Start Menu to Stored Images Mode */
void on_start_to_stored_button_clicked() {
    /* Hiding the Start Menu */
    gtk_widget_hide(start_window);

    /* Showing the Stored Images Window */
    gtk_widget_show(stored_window);
}

/* Start Menu to Report A Bug Screen */
void on_start_to_report_button_clicked() {
    /* Hiding the Start Menu */
    gtk_widget_hide(start_window);

    /* Showing the Report a Bug Window */
    gtk_widget_show(report_window);
}

/* Start Menu to Test Collimation Mode */
void on_start_to_collimation_button_clicked() {
    /* Hiding the Start Menu */
    gtk_widget_hide(start_window);

    /* Showing the Test Collimation Window */
    gtk_widget_show(collimation_window);
}

/*** Instructions Menu ***/

void on_instructions_to_placement_button_clicked() {
    /* Hiding the Instructions Menu */
    gtk_widget_hide(instructions_window);

    /* Showing the Substrate Placement Window */
    gtk_widget_show(placement_window);
}

void on_instructions_to_start_button_clicked() {
    /* Hiding the Instructions Window */
    gtk_widget_hide(instructions_window);

    /* Showing the Start Menu */
    gtk_widget_show(start_window);
}

void on_instructions_to_align_button_clicked() {
    /* Hiding the Instructions Menu */
    gtk_widget_hide(instructions_window);

    /* Showing the Substrate Alignment Screen */
    gtk_widget_show(alignment_window);
}

void on_instructions_to_rate_button_clicked() {
    /* Hiding the Instructions Menu */
    gtk_widget_hide(instructions_window);

    /* Showing the Saving Rate Window */
    gtk_widget_show(rate_window);
}

void on_instructions_to_save_button_clicked() {
    /* Hiding the Instructions Menu */
    gtk_widget_hide(instructions_window);

    /* Showing the Save Feature Window */
    gtk_widget_show(save_window);
}

/*** Substrate Alignment Screen ***/

void on_alignment_to_instructions_button_clicked() {
    /* Hiding the Substrate Alignment Screen */
    gtk_widget_hide(alignment_window);

    /* Showing the Instructions Menu Screen */
    gtk_widget_show(instructions_window);
}

/*** Substrate Placement Screen ***/

void on_placement_to_instructions_button_clicked() {
    /* Hiding the Substrate Placement Window */
    gtk_widget_hide(placement_window);

    /* Showing the Instructions Menu */
    gtk_widget_show(instructions_window);
}

/*** Save Feature Screen ***/

void on_save_to_instructions_button_clicked() {
    /* Hiding the Save Feature Window */
    gtk_widget_hide(save_window);

    /* Showing the Instructions Menu */
    gtk_widget_show(instructions_window);
}

void on_save_to_sensing_button_clicked() {
    /* Hiding the Save Feature Window */
    gtk_widget_hide(save_window);

    /* Showing the Sensing Mode */
    gtk_widget_show(sensing_window); 
}


/*** Save Rate Screen ***/

void on_rate_to_instructions_button_clicked() {
    /* Hiding the Save Rate Window */
    gtk_widget_hide(rate_window);

    /* Showing the Instructions Menu */
    gtk_widget_show(instructions_window);
}

void on_rate_to_sensing_button_clicked() {
    /* Hiding the Save Rate Window */
    gtk_widget_hide(rate_window);

    /* Showing the Sensing Mode */
    gtk_widget_show(sensing_window); 
}


/*** Report a Bug Window ***/

 
void on_send_report_button_clicked() {
    
}

void on_report_to_start_button_clicked() {
    /* Hiding the Report a Bug Screen */
    gtk_widget_hide(report_window);

    /* Showing the Start Menu */
    gtk_widget_show(start_window);
}


/*** Collimation Window ***/

void on_collimation_to_start_button_clicked() {
    /* Hiding the Test Collimation Window */
    gtk_widget_hide(collimation_window);

    /* Showing the Start Menu */
    gtk_widget_show(start_window);
}

void on_test_collimation_button_toggled() {
    
}

/*** Sensing Mode ***/

void on_sensing_to_start_button_clicked() {
    /* Hiding the Sensing Window */
    gtk_widget_hide(sensing_window);

    /* Showing the Start Menu */
    gtk_widget_show(start_window);    
}

void on_sensing_add_hertz_button_clicked() {

    /* Pausing the process and changing the sleep time */
    sem_wait(&threadLock);
    
    hertz += 0.25;
    
    saveRate = 1000000/hertz;

    /* Showing the display rate */
    sprintf(saveRateText, "%.02f", hertz);
  
    gtk_label_set_text(sensing_rate_number, saveRateText);
    gtk_label_set_text(sensing_current_save_number, saveRateText); 
       
    /* Having the process reactivate */
    sem_post(&threadLock);
}

void on_sensing_subtract_hertz_button_clicked() {
    
    /* Pausing the process and changing the sleep time */
    sem_wait(&threadLock);

    hertz -= 0.25;
    
    saveRate = 1000000/hertz;

    /* Showing the display rate */
    sprintf(saveRateText, "%.02f", hertz);
    
    gtk_label_set_text(sensing_rate_number, saveRateText);
    gtk_label_set_text(sensing_current_save_number, saveRateText); 

    /* Resuming the process */
    sem_post(&threadLock);
}

void on_sensing_saving_toggle_toggled() {
    /* Pausing the process to allow the variable to update */
    sem_wait(&threadLock);

    /* If the save feature is off, turn it on */
    if (saving == 0) {
        saving = 1;
    }

    /* If the saving feature is on, turn it off */
    else {
        saving = 0;
    }

    /* Resuming the process now that the variable has been updated */
    sem_post(&threadLock);
}

void on_sensing_resume_toggle_toggled() {
    
    /* Pausing the process to allow the variable to update */
    sem_wait(&threadLock);
    
    /* If the resume feature is off, turn it on */
    if (capturing == 0) {
        capturing = 1;
        gtk_button_set_label(sensing_resume_toggle, "Stop Sensing");
    }
   
    /* If the resume feature is on, turn it off */
    else {
        capturing = 0;
        gtk_button_set_label(sensing_resume_toggle, "Begin Sensing");
    }

    /* Resuming the process now the that variables have been updated */
    sem_post(&threadLock);
}

/* Activated when the button for the vacuum pump is activated */
void on_sensing_vacuum_toggle_toggled() {
    
    /* Checking if the vacuum is not active */
    if (vacuumActive == 0) {
        /* Changing the text of the button */
        gtk_button_set_label(sensing_vacuum_toggle, "Stop Vacuuming");

        /* Turning the vacuum on */
        pinMode(0, HIGH);

        /* Setting the flag to high */
        vacuumActive = 1;
    }
    /* The vacuum is already on */
    else {
        /* Changing the text of the button */
        gtk_button_set_label(sensing_vacuum_toggle, "Vacuum Substrate");
        
        /* Turning off the vacuum */
        pinMode(0, HIGH);
        
        /* Setting the flag low */
        vacuumActive = 0;
    }

}


/*** Stored Images Mode ***/

void on_stored_to_start_button_clicked() {
    /* Hiding the Stored Images Mode */
    gtk_widget_hide(stored_window);

    /* Showing the Start Menu */
    gtk_widget_show(start_window);
}

void on_stored_previous_button_clicked() {

}

void on_stored_next_button_clicked() {

}

void on_stored_set_button_clicked() {

}

void GrabImage(fc2Context context) {
    fc2Error error;
    fc2Image rawImage;
    fc2Image convertedImage;
    
    // Starting the Capturing Process
    error = fc2StartCapture( context );
    if (error != FC2_ERROR_OK) {
        printf("Error in fc2StartCapture: %d\n", error);
    }

    // Creating the Raw Image
    error = fc2CreateImage( &rawImage );
    if ( error != FC2_ERROR_OK ) {
        printf("Error in fc2CreateImage: %d\n", error);
    }
    
    // Creating the Converted Image
    error = fc2CreateImage( &convertedImage);
    if (error != FC2_ERROR_OK) {
        printf("Error in fc2CreateImage: %d\n", error);
    }

    // Retrieving the Image
    error = fc2RetrieveBuffer( context, &rawImage );
    if (error != FC2_ERROR_OK) {
        printf("Error in retrieveBuffer: %d\n", error);
    }

    // Converting the final image to RGB
    error = fc2ConvertImageTo(FC2_PIXEL_FORMAT_RGB8, &rawImage, &convertedImage);
    if(error != FC2_ERROR_OK) {
        printf("Error in fc2ConvertImageTo: %d\n", error );
    } 

    if (saving == 1) {
        printf("Saving the Image\n");
        /* Creating the file name to store the image */
        sprintf(filename, "Image_%s_%04d.jpeg", diodeWavelengths[laser],count);
        /* Incrementing the count to go to the next image */
        
    
        /* Saving the Image as a JPEG */
        error = fc2SaveImage(&convertedImage, filename, FC2_JPEG);
        if (error != FC2_ERROR_OK) {
            printf("Error in fc2SaveImage\n");
        }

        /* Moving the image to the location of the USB drive */
        /* Getting the system call ready */
        sprintf(saveCommand, "mv Image_%s_%04d.jpeg /media/pi/EXTSTORAGE/Saved_Images", diodeWavelengths[laser], count);

        /* Using system to move the image to the external storage (usb) */
        system(saveCommand);

        /* Incrementing the count for the image being saved*/
        count++;
    }

    // Copying the memory to the imgBuffer
    memcpy((void *)imgBuf, (void*)convertedImage.pData,IMG_SIZE);
    
    GdkPixbuf* updatePixBuf = gdk_pixbuf_new_from_data((const guchar*)imgBuf, GDK_COLORSPACE_RGB, FALSE, 8, convertedImage.cols, convertedImage.rows, convertedImage.stride, NULL, NULL);
    
    printf("After converting the image to GtkImage, before scaling.\n");
    
    // Scaling the image for display
    GdkPixbuf* scaledPixBuf = gdk_pixbuf_scale_simple(updatePixBuf, 480,320, GDK_INTERP_BILINEAR);
    g_object_unref(G_OBJECT(updatePixBuf));

    // Request display update
    g_idle_add(gtkImageFunction, (gpointer)scaledPixBuf);  
    
    // Destroying the raw image
    error = fc2DestroyImage(&rawImage);
    if( error != FC2_ERROR_OK) {
        printf("Error in fc2DestroyImage: %d\n", error);
    } 

    // Destory memory for converted image
    error = fc2DestroyImage(&convertedImage);
    if (error != FC2_ERROR_OK) {
        printf("Error in fc2DestoryImage: %d\n", error);
    }

    error = fc2StopCapture(context);
    if (error != FC2_ERROR_OK) {
        printf("Error in fc2StopCapture: %d\n", error);
    }

}


// Functions for GUI Updates form Imaging thread
gboolean gtkImageFunction(gpointer user_data) {
    gtk_image_set_from_pixbuf(GTK_IMAGE(sensing_image), (GdkPixbuf*)user_data);
    g_object_unref(G_OBJECT(user_data));
    return G_SOURCE_REMOVE;
}

gboolean gtkDiodeDisplayFunction(gpointer user_data) {

    /* Setting the diode number for the sensing mode */
    gtk_label_set_text(sensing_diode_number, (char *)user_data);

    /* Unrefrencing the g_object to make space ofor the data */
    return G_SOURCE_REMOVE;
}
 
/* This is the main loop that the image processing will be take place in.
 * Essentially, all some of the callbacks will make changes to global variables
 * causing this loop to operate differently */
void* imgThreadMain(void* args) {

    /* Motor commands */
    const char* SERVO_0_OPEN = "0,1447";
    const char* SERVO_0_CLOSE = "0,1100";
    const char* SERVO_1_OPEN = "1,1522";
    const char* SERVO_1_CLOSE = "1,1918";
    const char* SERVO_2_OPEN = "2,1470";
    const char* SERVO_2_CLOSE = "2,1865";
    char command[40];
    
    /*Start by closing all laser blockers */ 
    sprintf(command, "./UscCmd --servo %s", SERVO_0_CLOSE);
    system(command);
    sprintf(command, "./UscCmd --servo %s", SERVO_1_CLOSE);                     
    system(command);
    sprintf(command, "./UscCmd --servo %s", SERVO_2_CLOSE);                     
    system(command);

    
    /* Runing while the device is up and going */
    while (operating == 1) {

        /* Capturing the image if the device is sensing */
        if (capturing == 1) {
            
            /* Setting the diode text to the correct diode */
            g_idle_add(gtkDiodeDisplayFunction, (gpointer)diodeWavelengths[laser]);
            
            switch (laser)
            {
                case 0:
                    sprintf(command, "./UscCmd --servo %s", SERVO_0_OPEN);                     
                    break;
                case 1:
                    sprintf(command, "./UscCmd --servo %s", SERVO_1_OPEN);                 
                    break;
                case 2:
                    sprintf(command, "./UscCmd --servo %s", SERVO_2_OPEN);                     
                    break;
            }
            /* Setting the laser blocker up */
            system(command);
            
            // Update the image
            GrabImage(context);
            printf("New Image\n");     

            switch (laser++)
            {
                case 0:
                    sprintf(command, "./UscCmd --servo %s", SERVO_0_CLOSE);                     
                    break;
                case 1:
                    sprintf(command, "./UscCmd --servo %s", SERVO_1_CLOSE);                 
                    break;
                case 2:
                    sprintf(command, "./UscCmd --servo %s", SERVO_2_CLOSE);                     
                    break;
            }
            /* Setting the laser blocker down */
            system(command);

            if (laser > 2) {
                laser = 0;
            }

            printf("Laser: %d\n", laser);
        
        }

        // Sleeping for the specified amount
        usleep(saveRate*(0.5));
    }

    sem_destroy(&threadLock);

    return NULL;
}



/*Sets the target of a maestro laser blocking driver channel*/
int maestroSetTarget(int fd, unsigned char channel, unsigned short target) {
    unsigned char command[] = {0x84, channel, target & 0x7F, target >> 7 & 0x7F};
    if(write(fd, command, sizeof(command)) == -1)
    {        
        perror("error writing");
        return -1;
    }
    return 0;
}    

//Gets the position of a maestro laser blocking driver channel
int maestroGetPosition(int fd, unsigned char channel) {

    unsigned char command[]={0x90, channel};
    
    if(write(fd, command, sizeof(command)) == -1) {
        perror("error writing");
        return -1;
    }

    unsigned char response[2];
    
    if(read(fd,response,2) != 2) {
        perror("error reading");
        return -1;
    }
    
    return response[0] + 256*response[1];
}

