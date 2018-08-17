#pragma rtGlobals=3		// Use modern global access method and strict wave access.

// Make sure to create waves to pass to function!
Make/O/N=256/D lambda1means,lambda3means,lambda2means


Function LoadAndFindMeans(points,separate, together,secondspersample)

Variable points, separate, together, secondspersample
//Wave lambda1means, lambda2means, lambda3means
Variable lambda1mean, lambda2mean, lambda3mean,scaledpoints

KillGraphs(0,3)

Make/O/N=(points)/D lambda1means,lambda2means,lambda3means,Times

variable i,n,x

variable graphyscalingfactor = 1.1

string datestamp = "1-18-14"
string testnumber = "1"

//string pathName = "C:Users:joshbrake.LETNET:Dropbox:LETU:LETU M.S.E. Stuff:Experimental:Initial Cavity Test with Fluid:" + datestamp + ":Test #" + testnumber + ":" // Windows Version
string pathName = "C:Josh LETU M.S.E. Data:Experimental:Initial Biological Cavity Test:" + datestamp + ":Test #" + testnumber + ":" //C Drive Option
//String pathName = "MacBook SSD:Users:joshbrake:Dropbox:LETU:LETU MSE Stuff:Experimental:Initial Cavity Test:4-22-13 Data:Raw Data:"	// Mac Version

string combinedfilename = pathName + datestamp + " T" + testnumber + " Avg Intensity for Spectrum 780 808 830 P vs t.jpg"
string P1name = pathName + datestamp + " T" + testnumber + " Avg Intensity for Spectrum 780 P vs t.jpg"
string P2name =  pathName + datestamp + " T" + testnumber + " Avg Intensity for Spectrum 808 P vs t.jpg"
string P3name =  pathName + datestamp + " T" + testnumber + "Avg Intensity for Spectrum 830 P vs t.jpg"



for (i = 1; i <= points; i += 1)

	lambda1mean = 0
	lambda2mean = 0
	lambda3mean = 0
	
	String fileName = pathName + "Raw Data:" +num2str(i) + ".txt"
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
	lambda2mean = mean(w1,1840,1920)
	lambda3mean = mean(w1,1570,1630)
	
	lambda1means[x]= lambda1mean
	lambda2means[x]= lambda2mean
	lambda3means[x]= lambda3mean
	
	x = x + 1
	
	Print lambda1mean
	Print lambda2mean
	Print lambda3mean
	
endfor

Times = Samples2Seconds(points,secondspersample)

if(separate==1)
display/K=1 lambda1means vs Times
Label left "Absolute Irradiance (µW•cm\\S-1\\M•nm\\S-1\\M)"
Label bottom "Time (s)"
//SetAxis bottom WaveMin(CavityWidth),mean(CavityWidth) 
SetAxis left 0,Wavemax(lambda1means)*graphyscalingfactor
Legend/C/N=text0/J/A=MC/X=45/Y=45 "\\s(lambda1means) 780 nm"
Textbox/A=MC/F=0/X=0/Y=50 "780 nm Optical Intensity vs. Time"
ModifyGraph nticks(left)=10,nticks(bottom)=20,minor=1;DelayUpdate
ModifyGraph frameStyle=1,mode(lambda1means)=4,marker=19,msize=2
RenameWindow # P1

display/K=1 lambda2means vs Times
Label left "Absolute Irradiance (µW•cm\\S-1\\M•nm\\S-1\\M)"
Label bottom "Time (s)"
ModifyGraph rgb=(1,4,52428)
//SetAxis bottom WaveMin(CavityWidth),mean(CavityWidth)
SetAxis left 0,Wavemax(lambda2means)*graphyscalingfactor
Legend/C/N=text0/J/A=MC/X=45/Y=45 "\\s(lambda2means) 808 nm"
Textbox/A=MC/F=0/X=0/Y=50 "808 nm Optical Intensity vs. Time"
ModifyGraph nticks(left)=10,nticks(bottom)=20,minor=1;DelayUpdate
ModifyGraph frameStyle= 1,mode(lambda2means)=4,marker=19,msize=2
RenameWindow # P2

display/K=1 lambda3means vs Times
Label left "Absolute Irradiance (µW•cm\\S-1\\M•nm\\S-1\\M)"
Label bottom "Time (s)"
ModifyGraph rgb=(0,65535,0)
//SetAxis bottom WaveMin(CavityWidth),mean(CavityWidth) 
SetAxis left 0,Wavemax(lambda3means)*graphyscalingfactor
Legend/C/N=text0/J/A=MC/X=45/Y=45 "\\s(lambda3means) 830 nm"
Textbox/A=MC/F=0/X=0/Y=50 "830 nm Optical Intensity vs. Time"
ModifyGraph nticks(left)=10,nticks(bottom)=20,minor=1;DelayUpdate
ModifyGraph frameStyle=1,mode(lambda3means)=4,marker=19,msize=2
RenameWindow # P3
endif

if(together==1)
display/K=1 lambda1means,lambda2means,lambda3means vs Times
Label left "Absolute Irradiance (µW•cm\\S-1\\M•nm\\S-1\\M)"
Label bottom "Time (s)"
Legend/C/N=text0/J/A=MC/X=45/Y=45 "\\s(lambda1means) 780 nm\r\\s(lambda2means) 808 nm\r\\s(lambda3means) 830 nm"
Textbox/A=MC/F=0/X=0/Y=50 "780 nm, 808 nm, and 830 nm Optical Intensity vs. Time"
ModifyGraph rgb(lambda3means)=(0,65535,0),rgb(lambda2means)=(1,4,52428)
ModifyGraph mode=0
//SetAxis bottom WaveMin(CavityWidth),mean(CavityWidth)
variable axisset
axisset = max(Wavemax(lambda1means),Wavemax(lambda2means))
SetAxis left 0,max(axisset,Wavemax(lambda3means))*graphyscalingfactor
ModifyGraph frameStyle=1,nticks(left)=10,nticks(bottom)=20,minor=1;DelayUpdate
RenameWindow # P0
endif


SavePICT/O/E=-6/B=144/I/W=(0,0,12,9)/WIN=P0 as combinedfilename
SavePICT/O/E=-6/B=144/I/W=(0,0,12,9)/WIN=P1 as P1name
SavePICT/O/E=-6/B=144/I/W=(0,0,12,9)/WIN=P2 as P2name
SavePICT/O/E=-6/B=144/I/W=(0,0,12,9)/WIN=P3 as P3name
	Return 0

End

