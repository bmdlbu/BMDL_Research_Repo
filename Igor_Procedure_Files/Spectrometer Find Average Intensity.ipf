#pragma rtGlobals=3		// Use modern global access method and strict wave access.

// Make sure to create waves to pass to function!
Make/O/N=256/D lambda1means,lambda3means,lambda2means


Function LoadAndFindMeans(points,separate, secondspersample, wave1, wave2, wave3)

Variable points, separate, secondspersample 
string  wave1, wave2, wave3
//Wave lambda1means, lambda2means, lambda3means
Variable lambda1mean, lambda2mean, lambda3mean,scaledpoints



Make/O/N=(points)/D lambda1means,lambda2means,lambda3means

variable i,n,x

variable graphyscalingfactor = 1.1

//C:\Users\codyjoy\Desktop\Spectrometer_stationary_test\780nm
//C:\Users\codyjoy\Desktop\7-30-2014 Rotating Filter Test Spectrometer\No Filter\All Lasers On
//string pathName = "C:Users:joshbrake.LETNET:Dropbox:LETU:LETU M.S.E. Stuff:Experimental:Initial Cavity Test with Fluid:" + datestamp + ":Test #" + testnumber + ":" // Windows Version
string pathName = "C:Users:codyjoy:Desktop:Spectrometer_stationary_test:All lasers:" //C Drive Option
//String pathName = "MacBook SSD:Users:joshbrake:Dropbox:LETU:LETU MSE Stuff:Experimental:Initial Cavity Test:4-22-13 Data:Raw Data:"	// Mac Version

string combinedfilename = pathName + "Spectrometer Average Intensity All Lasers On.jpg"
string P1name = pathName  + "Spectrometer Average Intensity 780 nm.jpg"
string P2name =  pathName  + "Spectrometer Average Intensity 830 nm.jpg"
string P3name =  pathName  + "Spectrometer Average Intensity 850 nm.jpg"



for (i = 1; i <= points; i += 1)

	lambda1mean = 0
	lambda2mean = 0
	lambda3mean = 0
	
	String fileName = pathName + "data_" +num2str(i) + ".txt"
	Print fileName
	
	// Load the waves and set the local variables
	LoadWave/A/O/J/D/W/K=0/V={"\t"," $",0,0}/L={6,7,0,1,0} fileName
	
	if (V_flag==0)
		return -1
	endif
	
	// Put the names of the waves into string variables
	String s0, s1
	s0 = StringFromList(0, S_waveNames)
	s1 = StringFromList(1, S_waveNames)
	
	Wave w0 = $s0
	Wave w1 = $s1
	
	// Find and save mean intensity values

	lambda1mean = mean(w1,2000,2060)
	lambda2mean = mean(w1,1620,1680)
	lambda3mean = mean(w1,1410,1470)
	
	lambda1means[x]= lambda1mean
	lambda2means[x]= lambda2mean
	lambda3means[x]= lambda3mean
	
	x = x + 1
	
	Print lambda1mean
	Print lambda2mean
	Print lambda3mean
	
endfor

Duplicate/O lambda1means $wave1

Duplicate/O lambda2means $wave2

Duplicate/O lambda3means $wave3





End

