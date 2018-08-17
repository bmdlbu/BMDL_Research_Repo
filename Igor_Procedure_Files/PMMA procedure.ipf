#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function LoadFile(dataPoints, PDMS, GW)
	variable dataPoints, GW,PDMS
	wave wave0

	Make/N=(dataPoints+1)/D/O timeStamp1
	Make/N=(dataPoints+1)/D/O efficiency1, efficiency2,efficiency3
	Make/N=(dataPoints+1)/D/O g10w780,  g15w780, g20w780, g25w780 , g30w780, g35w780,  g40w780, g45w780, g50w780, g10w850,  g15w850, g20w850, g25w850 , g30w850, g35w850,  g40w850, g45w850, g50w850
	
	//string CWString
	//sprintf CWString "%.2f" CW
	
	variable i, CW
	
	string wavename780, wavename850, wavename904
	
	
	for( CW = 2.51; CW < 2.57; CW += 0.01)
		
		//wavename780 = "g"+num2str(PDMS*1000)+"w780"
		wavename780 = "g"+num2str(CW*100)+"w780f" + num2str(PDMS*1000) + "h" +num2str(GW*1000)
		LoadWave/J/M/D/N=wave/O/K=0/V={"\t, "," $",0,0} "F:\Fimmwave Fimmprop files\FIMMWAVE:New:SL and GW Scan "+ num2str(GW*1000) + " nm GL 784 nm SL 0.0-0.5 um "+ num2str(CW)+" CW "+ num2str(PDMS) + " um PDMS "+ num2str(dataPoints)+" pts New PMMA RIb.txt"
		print "F:\Fimmwave Fimmprop files\FIMMWAVE:New:SL and GW Scan "+ num2str(GW*1000) + " nm GL 784 nm SL 0.0-0.5 um "+ num2str(CW)+" CW "+ num2str(PDMS) + " um PDMS "+ num2str(dataPoints)+" pts New PMMA RIb.txt"
		
		for(i=0; i <= dataPoints+1; i += 1)
			timeStamp1[i] = wave0[i][0]
			efficiency1[i] = wave0[i][1]
		endfor
		Duplicate/O efficiency1 $wavename780
		
		//wavename850 = "g"+num2str(PDMS*1000)+"w850"
		wavename850 = "g"+num2str(CW*100)+"w850f" + num2str(PDMS*1000) + "h" +num2str(GW*1000)
		LoadWave/J/M/D/N=wave/O/K=0/V={"\t, "," $",0,0} "F:\Fimmwave Fimmprop files\FIMMWAVE\New\SL and GW Scan "+ num2str(GW*1000) + " nm GL 863 nm SL 0.0-0.5 um "+ num2str(CW)+" CW "+ num2str(PDMS) + " um PDMS " + num2str(dataPoints)+" pts New PMMA RIb.txt"
		print "F:\Fimmwave Fimmprop files\FIMMWAVE\New\SL and GW Scan "+ num2str(GW*1000) + " nm GL 863 nm SL 0.0-0.5 um "+ num2str(CW)+" CW "+ num2str(PDMS) + " um PDMS " + num2str(dataPoints)+" pts New PMMA RIb.txt"

		for(i=0; i <= dataPoints+1; i += 1)
			efficiency2[i] = wave0[i][1]
		endfor
		Duplicate/O efficiency2 $wavename850
		
		//wavename904 = "g"+num2str(CW*100)+"w904"	
		
		//LoadWave/J/M/D/N=wave/O/K=0/V={"\t, "," $",0,0} "F:\Fimmwave Fimmprop files\FIMMWAVE\New\SL and GW Scan "+ num2str(GW*1000) + " nm GL 904 nm SL 0.0-0.02 um "+ num2str(CW)+" CW "+ num2str(PDMS) + " um PDMS " + num2str(dataPoints)+" pts.txt"
		//print  "F:\Fimmwave Fimmprop files\FIMMWAVE\New\SL and GW Scan "+ num2str(GW*1000) + " nm GL 904 nm SL 0.0-0.02 um "+ num2str(CW)+" CW "+ num2str(PDMS) + " um PDMS " + num2str(dataPoints)+" pts.txt"
		
		//for(i=0; i <= dataPoints+1; i += 1)
		//	efficiency3[i] = wave0[i][1]
		//endfor
		//Duplicate/O efficiency3 $wavename904
		
	endfor
	
	
End

Function Test(dataPoints,wave1,timeStamp1)
variable dataPoints
wave wave1, timeStamp1
Make/N=(dataPoints+1)/D/O findmin
variable i
for(i=10; i <= dataPoints; i += 1)
CurveFit/M=2/W=0 line, wave1[0,i]/X=timeStamp1[0,i]/D
WAVE W_sigma
findmin[i] = w_sigma[1]
print w_sigma[1]
endfor


End




Function Scaledifferential(dataPoints, P1, P2,timeStamp, PDMS)
	
	variable dataPoints, PDMS
	wave P1, P2, timeStamp
	variable P1_0, P2_0
	
	Make/N=(dataPoints)/D/O ScaledDiffValue
	
	
	variable i
	P1_0 = P1[0]
	P2_0 = P2[0]
	
	for(i=0; i < dataPoints; i += 1)
		ScaledDiffValue[i] = (P1[i] - P1_0/P2_0*P2[i]) / (P1[i] + P1_0/P2_0*P2[i])
	endfor
	
	
	display ScaledDiffValue vs timeStamp
	ModifyGraph nticks(bottom)=10,minor(bottom)=1,sep(bottom)=1
	ModifyGraph nticks=10,sep=10
	ModifyGraph minor=1,sep(left)=5
	ModifyGraph mirror(left)=3,fSize=14,axThick=3;
	TextBox/C/N=text0/F=0/A=MT/E "\\Z20" + num2str(PDMS) + " um PMMA "
	Label left "\\Z20 Scaled Differential Value"
	Label bottom "\\Z20 Sensing Layer Thickness (um)"
	ModifyGraph lsize=2,rgb=(0,65280,0)

End

//naming Scaled differential calculated wave
Function ScaledifferentialWavename(dataPoints, P1, P2,timeStamp,diffWaveName)
	
	variable dataPoints
	string diffWaveName
	wave P1, P2, timeStamp
	variable P1_0, P2_0,test,test1
	
	Make/N=(dataPoints+1)/D/O ScaledDiffValue
	Make/N=(dataPoints+1)/D/O ScaledDiffValues
	wave wave1,wave99
	
	variable i
	P1_0 = P1[0]
	P2_0 = P2[0]
	
	for(i=0; i < dataPoints+1; i += 1)
		//ScaledDiffValue[i] = (P1[i] - P2[i]) / (P1[i] + P2[i])
		ScaledDiffValue[i] = (P1[i] - P1_0/P2_0*P2[i]) / (P1[i] + P1_0/P2_0*P2[i])
	endfor
	
	Duplicate/O ScaledDiffValue $diffWaveName
	Duplicate/O $diffWaveName wave1
	CurveFit/M=2/W=0 line, wave1[0,4]/X=timeStamp[0,4]/D
	WAVE W_coef
	test1 = W_coef[1]
	//Duplicate/O ScaledDiffValues $diffWaveName
	//Duplicate/O $diffWaveName wave99
	//CurveFit/M=2/W=0 line, wave99[0,100]/X=timeStamp[0,100]/D
	Wavestats P2
	test =  V_max
	Wavestats P1
	
	print test1
	//print V_max
	//print test
	//WAVE W_coef
	//print W_coef[1]
	//WAVE W_sigma
	//print w_sigma[1]
	
	
End


//8 waves
Function Scaledifferential8waves(dataPoints, wave1, wave2, wave3, wave4, wave5, wave6, wave7, wave8, timeStamp)
	
	variable dataPoints
	wave wave1, wave2, wave3, wave4, wave5, wave6, wave7, wave8, timeStamp
	variable P1_0, P2_0
	Make/N=(dataPoints)/D/O P1, P2
	Make/N=(dataPoints)/D/O ScaledDiffValue
	Make/N=(dataPoints)/D/O sdiff1,sdiff2,sdiff3,sdiff4
	
	
	variable i,k
	string wavename1, wavename2
	string diffwave
	
	
	for( k = 1; k < 2; k += 1)
		wavename1 = "wave"+num2str(1+k)
		wavename2 = "wave"+num2str(5+k)
		diffwave = "sdiff"+num2str(1+k)
		print wavename1 + " " + wavename2 + " diffwave " + diffwave

		Duplicate/O $nameofwave($wavename1) P1
		Duplicate/O $wavename2 P2
		
		P1_0 = P1[0]
		P2_0 = P2[0]
	
		for(i=0; i < dataPoints; i += 1)
			ScaledDiffValue[i] = (P1[i] - P1_0/P2_0*P2[i]) / (P1[i] + P1_0/P2_0*P2[i])
		endfor
		
		Duplicate/O ScaledDiffValue $diffwave
	endfor
	
	
	
	display sdiff1,sdiff2,sdiff3,sdiff4 vs timeStamp
	if(0)
	ModifyGraph nticks(bottom)=10,minor(bottom)=1,sep(bottom)=1
	ModifyGraph nticks=10,sep=10
	ModifyGraph minor=1,sep(left)=5
	ModifyGraph axThick=2
	ModifyGraph lsize=2
	TextBox/C/N=text0/F=0/A=MT/E "\\Z12 Scaled Differential Values vs. Sensing Layer Thickness for 4um Cavity with 12nm Gold Film Thickness"
	Label left "\\Z12 Scaled Differential Value"
	Label bottom "\\Z12 Sensing Layer Thickness (um)"
	endif
	//ModifyGraph rgb=(0,65280,0)

End


Function displayRange(L,H, ywave, xwave)
	variable L, H
	wave ywave, xwave
	
	display ywave[L,H] vs xwave[L,H]
	ModifyGraph nticks(bottom)=10,minor(bottom)=1,sep(bottom)=1
	ModifyGraph nticks=10,sep=10
	ModifyGraph minor=1,sep(left)=5
	ModifyGraph axThick=2
	ModifyGraph lsize=2
	TextBox/C/N=text0/F=0/A=MT/E "\\Z12 Scaled Differential Values vs. Sensing Layer Thickness for 4um Cavity with 12nm Gold Film Thickness"
	Label left "\\Z12 Scaled Differential Value"
	Label bottom "\\Z12 Sensing Layer Thickness (um)"
	ModifyGraph lsize=1,rgb=(0,65280,0) 

End

Function display4waves(wave1, wave2, wave3, wave4, timeStamp)
	
	wave wave1, wave2, wave3, wave4, timeStamp
	
	display wave1, wave2, wave3, wave4 vs timeStamp
	ModifyGraph nticks(bottom)=10,minor(bottom)=1,sep(bottom)=1
	ModifyGraph nticks=10,sep=10
	ModifyGraph minor=1,sep(left)=5
	ModifyGraph axThick=2
	ModifyGraph lsize=1
	TextBox/C/N=text0/F=0/A=MT/E "\\Z18 Scaled Differential Values vs. Sensing Layer Thickness for 4um Cavity"
	Label left "\\Z16 Scaled Differential Value"
	Label bottom "\\Z16 Sensing Layer Thickness (um)"
	Legend/C/N=text1/J/F=2/A=MT/E=2 "\\s(diff_g12) gold 12nm\r\\s(diff_g13) gold 13nm\r\\s(diff_g14) gold 14nm\r\\s(diff_g15) gold 15nm"
	ModifyGraph rgb(diff_g13)=(65280,0,52224),rgb(diff_g14)=(65280,21760,0), rgb(diff_g15)=(65280,43520,0)
	ModifyGraph fStyle=1

End


Window eff() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(261.75,52.25,1017,487.25) g10w780,  g15w780, g20w780, g25w780 , g10w850, g15w850, g20w850, g25w850 vs timeStamp1
	ModifyGraph frameStyle=1
	ModifyGraph lSize=1.5
	ModifyGraph lStyle(g11w780)=8,lStyle(g13w780)=8
	ModifyGraph rgb(g11w780)=(65280,43520,0),rgb(g13w780)=(32768,65280,0)
	ModifyGraph rgb(g11w850)=(65280,43520,0),rgb(g13w850)=(32768,65280,0)
	ModifyGraph mirror(left)=3
	ModifyGraph nticks=10
	ModifyGraph minor=1
	ModifyGraph sep(bottom)=10
	ModifyGraph fSize=15
	ModifyGraph axThick=2
	Label left "\\Z20 Efficiency"
	Label bottom "\\Z20 Sensing Layer Thickness (um)"
	TextBox/C/N=text0/F=0/A=MT/X=2.79/Y=7.52/E "\\Z20Efficiency vs. Sensing Layer Thickness with 12nm Silver Film"
EndMacro

Window diff() : Graph
	Display /W=(261.75,52.25,1017,487.25) diff_g10, diff_g15, diff_g20, diff_g25 vs timeStamp1
	ModifyGraph nticks(bottom)=10,minor(bottom)=1,sep(bottom)=1
	ModifyGraph nticks=10,sep=10
	ModifyGraph minor=1,sep(left)=5
	ModifyGraph mirror(left)=3,fSize=14,axThick=3;
	TextBox/C/N=text0/F=0/A=MT/E "\\Z20" + num2str(PDMS) + " um PMMA "
	Label left "\\Z20 Scaled Differential Value"
	Label bottom "\\Z20 Sensing Layer Thickness (um)"
	ModifyGraph lsize=2,rgb=(0,65280,0)
	 
EndMacro

Function Responsivity(diffwave)
	wave diffwave
	Return wavemax(diffwave) - wavemin(diffwave)
End

Function Res_wave(wave0, wave1, wave2, wave3, wave4)
	wave wave0, wave1, wave2, wave3, wave4
	
	Make/N=(5)/D/O res, cavity_width
		
	string nnwave = "wave0"
	edit $nnwave
	print nameofwave($nnwave)
	//print nameofwave(wave0)
	res[0] = -wavemin(wave0)
	res[1] = -wavemin(wave1)
	res[2] = -wavemin(wave2)
	res[3] = -wavemin(wave3)
	res[4] = -wavemin(wave4)
	
		
	variable i
	if(0)
	for(i = 0; i <0; i += 1)
	
		string nwave = "wave"+num2str(i)
		print nameofwave($nwave)
		
		duplicate/O $nameofwave($nwave) temp
		print wavemin(temp)
		
		res[i] = Responsivity(temp)
		
		print Responsivity(temp)
		
		cavity_width[i] = (398+i)/100
	
	endfor
	endif
End


Function eff_waves(wave1, wave2, timeStamp1,PDMS) 
	wave wave1, wave2, timeStamp1
	variable PDMS

	Display /W=(261.75,52.25,1017,487.25) wave1,  wave2 vs timeStamp1
	ModifyGraph lstyle($nameofwave(wave2))=8,rgb($nameofwave(wave2))=(0,15872,65280)
	ModifyGraph nticks(bottom)=10,minor(bottom)=1,sep(bottom)=1
	ModifyGraph nticks=10,sep=10
	ModifyGraph minor=1,sep(left)=5
	ModifyGraph mirror(left)=3,fSize=14,axThick=3;
	ModifyGraph lsize=2
	Legend/C/N=text1/J "\\Z14\\s("+nameofwave(wave1)+") 780nm\r\\s("+nameofwave(wave2)+") 850nm"
	Label left "\\Z20 Efficiency"
	Label bottom "\\Z20 Sensing Layer Thickness (um)"
	TextBox/C/N=text0/F=0/A=MT/X=2.79/Y=7.52/E "\\Z20Efficiency vs. Sensing Layer Thickness with PMMA " + num2str(PDMS) + " um"
End

Function diff_waves(wave1, timeStamp1,PDMS) 
	wave wave1, timeStamp1
	variable PDMS

	Display /W=(261.75,52.25,1017,487.25) wave1 vs timeStamp1
	
	ModifyGraph nticks(bottom)=10,minor(bottom)=1,sep(bottom)=1
	ModifyGraph nticks=10,sep=10
	ModifyGraph minor=1,sep(left)=5
	ModifyGraph mirror(left)=3,fSize=14,axThick=3;
	Label left "\\Z20 Scaled Differential Value"
	Label bottom "\\Z20 Sensing Layer Thickness (um)"
	ModifyGraph lsize=2,rgb=(0,65280,0)
	TextBox/C/N=text0/F=0/A=MT/X=2.79/Y=7.52/E "\\Z20 Diffierential value vs. Sensing Layer Thickness with PMMA " + num2str(PDMS) + " um"
	 
End
