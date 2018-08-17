#pragma rtGlobals=3		// Use modern global access method and strict wave access.

// Make sure to create waves to pass to function!
Make/O/N=256/D lambda1maximums,lambda3maximums,lambda2maximums


Function LoadAndFindSums(points,separate, together,secondspersample)

Variable points, separate, together, secondspersample
//Wave lambda1maximums, lambda2maximums, lambda3maximums
Variable lambda1max, lambda2max, lambda3max,lambda1sum,lambda2sum,lambda3sum,scaledpoints

KillGraphs(0,3)

Make/O/N=(points)/D lambda1maximums,lambda2maximums,lambda3maximums,lambda1sums,lambda2sums,lambda3sums,Times

variable i,n,x

variable graphyscalingfactor = 1.1

string datestamp = "1-18-14"
string testnumber = "1"

string pathName = "C:Josh LETU M.S.E. Data:Experimental:Initial Biological Cavity Test:" + datestamp + ":Test #" + testnumber + ":" // Windows Version
//String pathName = "MacBook SSD:Users:joshbrake:Dropbox:LETU:LETU MSE Stuff:Experimental:Initial Cavity Test:4-22-13 Data:Raw Data:"	// Mac Version

string combinedfilename = pathName + datestamp + " T" + testnumber + " Intensity Sum for Spectrum 780 808 830 P vs t.jpg"
string P1name = pathName + datestamp + " T" + testnumber + " Intensity Sum for Spectrum 780 P vs t.jpg"
string P2name =  pathName + datestamp + " T" + testnumber + " Intensity Sum for Spectrum 808 P vs t.jpg"
string P3name =  pathName + datestamp + " T" + testnumber + " Intensity Sum for Spectrum 830 P vs t.jpg"

for (i = 1; i <= points; i += 1)

	lambda1sum = 0
	lambda2sum = 0
	lambda3sum = 0

	String fileName = pathName + "Raw Data:" + num2str(i) + ".txt"
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
	
	// Find and save max intensity values
	lambda1sum = Sum(w1,2000,2060)
	lambda2sum = Sum(w1,1840,1920)
	lambda3sum = Sum(w1,1570,1630)

	lambda1sums[x]= lambda1sum
	lambda2sums[x]= lambda2sum
	lambda3sums[x]= lambda3sum
	
	x = x + 1
	
	Print lambda1sum
	Print lambda2sum
	Print lambda3sum
	
endfor

Times = Samples2Seconds(points,secondspersample)

if(separate==1)
display/K=1 lambda1sums vs Times
Label left "Average Absolute Irradiance (µW•cm\\S-1\\M•nm\\S-1\\M)"
Label bottom "Time (s)"
//SetAxis bottom WaveMin(CavityWidth),WaveMax(CavityWidth) 
SetAxis left 0,WaveMax(lambda1sums)*graphyscalingfactor
Legend/C/N=text0/J/A=MC/X=45/Y=45 "\\s(lambda1sums) 780 nm"
Textbox/A=MC/F=0/X=0/Y=50 "780 nm Optical Intensity vs. Time"
ModifyGraph nticks(left)=10,nticks(bottom)=20,minor=1;DelayUpdate
ModifyGraph mode(lambda1sums)=4
ModifyGraph marker=19,msize=2
ModifyGraph frameStyle=1
RenameWindow # P1

display/K=1 lambda2sums vs Times
Label left "Average Absolute Irradiance (µW•cm\\S-1\\M•nm\\S-1\\M)"
Label bottom "Time (s)"
ModifyGraph rgb=(1,4,52428)
//SetAxis bottom WaveMin(CavityWidth),WaveMax(CavityWidth)
SetAxis left 0,WaveMax(lambda2sums)*graphyscalingfactor
Legend/C/N=text0/J/A=MC/X=45/Y=45 "\\s(lambda2sums) 808 nm"
Textbox/A=MC/F=0/X=0/Y=50 "808 nm Optical Intensity vs. Time"
ModifyGraph nticks(left)=10,nticks(bottom)=20,minor=1;DelayUpdate
ModifyGraph mode(lambda2sums)=4
ModifyGraph marker=19,msize=2
ModifyGraph frameStyle=1
RenameWindow # P2

display/K=1 lambda3sums vs Times
Label left "Average Absolute Irradiance (µW•cm\\S-1\\M•nm\\S-1\\M)"
Label bottom "Time (s)"
ModifyGraph rgb=(0,65535,0)
//SetAxis bottom WaveMin(CavityWidth),WaveMax(CavityWidth) 
SetAxis left 0,WaveMax(lambda3sums)*graphyscalingfactor
Legend/C/N=text0/J/A=MC/X=45/Y=45 "\\s(lambda3sums) 830 nm"
Textbox/A=MC/F=0/X=0/Y=50 "830 nm Optical Intensity vs. Time"
ModifyGraph nticks(left)=10,nticks(bottom)=20,minor=1;DelayUpdate
ModifyGraph mode(lambda3sums)=4
ModifyGraph marker=19,msize=2
ModifyGraph frameStyle=1
RenameWindow # P3
endif

if(together==1)
display/K=1 lambda1sums,lambda2sums,lambda3sums vs Times
Label left "Average Absolute Irradiance (µW•cm\\S-1\\M•nm\\S-1\\M)"
Label bottom "Time (s)"
Legend/C/N=text0/J/A=MC/X=45/Y=45 "\\s(lambda1sums) 780 nm\r\\s(lambda2sums) 808 nm\r\\s(lambda3sums) 830 nm"
Textbox/A=MC/F=0/X=0/Y=50 "780 nm, 808 nm, and 830 nm Optical Intensity vs. Time"
ModifyGraph rgb(lambda3sums)=(0,65535,0),rgb(lambda2sums)=(1,4,52428)
ModifyGraph mode=0
//SetAxis bottom WaveMin(CavityWidth),WaveMax(CavityWidth)
variable axisset
axisset = Max(WaveMax(lambda1sums),WaveMax(lambda2sums))
SetAxis left 0,Max(axisset,WaveMax(lambda3sums))*graphyscalingfactor
ModifyGraph nticks(left)=10,nticks(bottom)=20,minor=1;DelayUpdate
ModifyGraph frameStyle=1
RenameWindow # P0
endif

SavePICT/O/E=-6/B=144/I/W=(0,0,16,9)/WIN=P0 as combinedfilename
SavePICT/O/E=-6/B=144/I/W=(0,0,16,9)/WIN=P1 as P1name
SavePICT/O/E=-6/B=144/I/W=(0,0,16,9)/WIN=P2 as P2name
SavePICT/O/E=-6/B=144/I/W=(0,0,16,9)/WIN=P3 as P3name

	Return 0

End

Function GraphLaserSpectrum()

LoadWave/A/J/O/D/W/K=0/L={17,18,0,0,0} "C:Users:joshbrake:Dropbox:LETU M.S.E. Stuff:Experimental:Initial Cavity Test:5-9-13 Data:5-9-13 Experiment 1 1.30 min:Laser Spectrum.csv"

String s0, s1, s2, s3
	s0 = StringFromList(1, S_waveNames)
	s1 = StringFromList(19, S_waveNames)
	s2 = StringFromList(20, S_waveNames)
	s3 = StringFromList(21, S_waveNames)
	
	Wave w0 = $s0
	Wave w1 = $s1

display w1 vs w0
ModifyGraph nticks(bottom)=10,minor(bottom)=1,sep(bottom)=1;DelayUpdate
ModifyGraph nticks(left)=10,minor(left)=1,sep(left)=1;DelayUpdate
SetAxis bottom 750,850
SetAxis left 0,WaveMax(w1)+50
Label left "Absolute Irradiance (µW•µm\\S-1\\M•nm\\S-1\\M)";DelayUpdate
Label bottom "Wavelength (nm)"
Textbox/A=MC/F=0/X=0/Y=50 "780 nm, 808 nm, and 830 nm Spectrum"

End



Function Samples2Seconds(points,secondspersample)
variable points, secondspersample

Make/O/N=(points)/D Times

variable i


for(i=0; i < points; i+=1)
Times[i]=secondspersample*i
endfor

return Times

End

Function KillGraphs(startnum, endnum)
	Variable startnum, endnum
 
	Variable i
        String WindowName
 
	for(i=startnum; i<=(endnum); i+=1)
		WindowName="P"+num2str(i)
                if (WinType(WindowName) == 1)
		       KillWindow $WindowName
                endif
	endfor
 
End