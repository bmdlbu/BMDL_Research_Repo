#pragma rtGlobals=3		// Use modern global access method and strict wave access.

// Make sure to create waves to pass to function!
Make/O/N=256/D lambda1maximums,lambda3maximums,lambda2maximums


Function LoadAndFindMax(points,separate, together, datapointsperwindow)

Variable points, separate, together,datapointsperwindow
//Wave lambda1maximums, lambda2maximums, lambda3maximums
Variable lambda1max, lambda2max, lambda3max,scaledpoints

scaledpoints = points/datapointsperwindow

Make/O/N=(scaledpoints)/D lambda1maximums,lambda2maximums,lambda3maximums,CavityWidth

variable i,n,x

for (i = 1; i < points; i += 5)

	String pathName = "C:Users:joshbrake:Dropbox:LETU M.S.E. Stuff:Experimental:Initial Cavity Test:5-12-13 Data:5-12-13 Experiment 1 2.00 min:Raw Data:" // Windows Version
	//String pathName = "MacBook SSD:Users:joshbrake:Dropbox:LETU:LETU MSE Stuff:Experimental:Initial Cavity Test:4-22-13 Data:Raw Data:"	// Mac Version
	
	for(n=0; n < 5; n +=1)
	String fileName = pathName +num2str(i+n) + ".txt"
	Print fileName
	
	// Load the waves and set the local variables
	LoadWave/A/O/J/D/W/K=0/V={"\t"," $",0,0}/L={4,5,0,1,0} fileName
	
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

	lambda1max = lambda1max + WaveMax(w1,1944,2066)
	lambda2max = lambda2max +WaveMax(w1,1780,1944)
	lambda3max = lambda3max + WaveMax(w1,1573,1780)
	
	endfor
	
	lambda1max = lambda1max/5
	lambda2max = lambda2max/5
	lambda3max = lambda3max/5

	lambda1maximums[x]= lambda1max
	lambda2maximums[x]= lambda2max
	lambda3maximums[x]= lambda3max
	
	x = x + 1
	
	Print lambda1max
	Print lambda2max
	Print lambda3max
	
Endfor

CavityWidth = Turns2CW(scaledpoints)

if(separate==1)
display/K=1 lambda1maximums vs CavityWidth
Label left "Absolute Irradiance (µW•cm\\S-1\\M•nm\\S-1\\M)"
Label bottom "Cavity Width (µm)"
//SetAxis bottom WaveMin(CavityWidth),WaveMax(CavityWidth) 
SetAxis left 0,WaveMax(lambda1maximums)+50
Legend/C/N=text0/J/A=MC/X=45/Y=45 "\\s(lambda1maximums) 780 nm"
Textbox/A=MC/F=0/X=0/Y=50 "780 nm Optical Intensity vs. Cavity Width"
ModifyGraph nticks(left)=10,nticks(bottom)=20,minor=1;DelayUpdate
ModifyGraph mode(lambda1maximums)=4
ModifyGraph marker=19,msize=2

display/K=1 lambda2maximums vs CavityWidth
Label left "Absolute Irradiance (µW•cm\\S-1\\M•nm\\S-1\\M)"
Label bottom "Cavity Width (µm)"
ModifyGraph rgb=(1,4,52428)
//SetAxis bottom WaveMin(CavityWidth),WaveMax(CavityWidth)
SetAxis left 0,WaveMax(lambda2maximums)+50
Legend/C/N=text0/J/A=MC/X=45/Y=45 "\\s(lambda2maximums) 808 nm"
Textbox/A=MC/F=0/X=0/Y=50 "808 nm Optical Intensity vs. Cavity Width"
ModifyGraph nticks(left)=10,nticks(bottom)=20,minor=1;DelayUpdate
ModifyGraph mode(lambda2maximums)=4
ModifyGraph marker=19,msize=2

display/K=1 lambda3maximums vs CavityWidth
Label left "Absolute Irradiance (µW•cm\\S-1\\M•nm\\S-1\\M)"
Label bottom "Cavity Width (µm)"
ModifyGraph rgb=(0,65535,0)
//SetAxis bottom WaveMin(CavityWidth),WaveMax(CavityWidth) 
SetAxis left 0,WaveMax(lambda3maximums)+50
Legend/C/N=text0/J/A=MC/X=45/Y=45 "\\s(lambda3maximums) 830 nm"
Textbox/A=MC/F=0/X=0/Y=50 "830 nm Optical Intensity vs. Cavity Width"
ModifyGraph nticks(left)=10,nticks(bottom)=20,minor=1;DelayUpdate
ModifyGraph mode(lambda3maximums)=4
ModifyGraph marker=19,msize=2
endif

if(together==1)
display/K=1 lambda1maximums,lambda2maximums,lambda3maximums vs CavityWidth
Label left "Absolute Irradiance (µW•cm\\S-1\\M•nm\\S-1\\M)"
Label bottom "Cavity Width (µm)"
Legend/C/N=text0/J/A=MC/X=45/Y=45 "\\s(lambda1maximums) 780 nm\r\\s(lambda2maximums) 808 nm\r\\s(lambda3maximums) 830 nm"
Textbox/A=MC/F=0/X=0/Y=50 "780 nm, 808 nm, and 830 nm Optical Intensity vs. Cavity Width"
ModifyGraph rgb(lambda3maximums)=(0,65535,0),rgb(lambda2maximums)=(1,4,52428)
ModifyGraph mode=0
//SetAxis bottom WaveMin(CavityWidth),WaveMax(CavityWidth)
variable axisset
axisset = Max(WaveMax(lambda1maximums),WaveMax(lambda2maximums))
SetAxis left 0,Max(axisset,WaveMax(lambda3maximums))+50
ModifyGraph nticks(left)=10,nticks(bottom)=20,minor=1;DelayUpdate
endif



	Return 0

End

Function GraphLaserSpectrum()

LoadWave/A/J/O/D/W/K=0/L={17,18,0,0,0} "MacBook SSD:Users:joshbrake:Dropbox:LETU:LETU MSE Stuff:Experimental:Initial Cavity Test:5-9-13 Experiment 3 1.30 min:Laser Spectrum.csv"

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



Function Turns2CW(scaledpoints)
variable scaledpoints

Make/O/N=(scaledpoints)/D CavityWidth

variable i


for(i=0; i < scaledpoints; i+=1)
CavityWidth[i]=i*4.5/scaledpoints+2.5
endfor

return CavityWidth

End