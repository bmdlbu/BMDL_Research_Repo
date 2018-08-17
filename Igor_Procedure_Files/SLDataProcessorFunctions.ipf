#pragma rtGlobals=1		// Use modern global access method and strict wave access.

function setup(CW,GW)

	variable CW,GW
	
	Make/O l; l = {780,788,808, 830, 850}
	
	WaveStats/Q l
	variable/G sizel = V_npnts-1
	
	variable/G numpoints = 2000
	
	variable/G CWPrecision = 2,GWPrecision=1
	String/G CWString,GWString

	CWString=convertNum2Str(CW,CWPrecision)
	GWString=convertNum2Str(GW,GWPrecision)

	String/G P780String,P788String,P808String,P830String,P850String,diff780788,diff780808,diff780830,diff780850,diff788780,diff788808,diff788830,diff788850,diff808780,diff808788,diff808830,diff808850,diff830780,diff830788,diff830808,diff830850,diff850780,diff850788,diff850808,diff850830,SL_Thickness
	
	P780String = "P780" + "CW" + CWString + "GW" + GWString
	P788String = "P788" + "CW" + CWString + "GW" + GWString
	P808String = "P808" + "CW" + CWString + "GW" + GWString
	P830String = "P830" + "CW" + CWString + "GW" + GWString
	P850String = "P850" + "CW" + CWString + "GW" + GWString
	SL_Thickness = "SL_Thickness"
	
//	diff780788 = "diff780788CW" + CWString + "GW" + GWString
//	diff780808 = "diff780808CW" + CWString + "GW" + GWString
//	diff780830 = "diff780830CW" + CWString + "GW" + GWString
//	diff780850 = "diff780850CW" + CWString + "GW" + GWString
//	
//	diff788780 = "diff788780CW" + CWString + "GW" + GWString
//	diff788808 = "diff788808CW" + CWString + "GW" + GWString
//	diff788830 = "diff788830CW" + CWString + "GW" + GWString
//	diff788850 = "diff788850CW" + CWString + "GW" + GWString
//	
//	diff808780 = "diff808780CW" + CWString + "GW" + GWString
//	diff808788 = "diff808788CW" + CWString + "GW" + GWString
//	diff808830 = "diff808830CW" + CWString + "GW" + GWString
//	diff808850 = "diff808850CW" + CWString + "GW" + GWString
//	
//	diff830780 = "diff830780CW" + CWString + "GW" + GWString	
//	diff830788 = "diff830788CW" + CWString + "GW" + GWString	
//	diff830808 = "diff830808CW" + CWString + "GW" + GWString
//	diff830850 = "diff830850CW" + CWString + "GW" + GWString	
//	
//	diff850780 = "diff850780CW" + CWString + "GW" + GWString
//	diff850788 = "diff850788CW" + CWString + "GW" + GWString
//	diff850808 = "diff850808CW" + CWString + "GW" + GWString
//	diff850830 = "diff850830CW" + CWString + "GW" + GWString

end


function loadSLData(CW,GW)
	variable CW,GW

	variable/G numpoints
	variable i,n,k
	
	Wave l
	
	variable/G CWPrecision,GWPrecision,sizel
	
	String/G lString,PlString,CWString,GWString
	
	for (i = 0; i <= sizel; i += 1)

	CWString=convertNum2Str(CW,CWPrecision)
	GWString=convertNum2Str(GW,GWPrecision)
	sprintf lString "%.1f" l[i]
	
	PlString = "P" + num2str(l[i]) + "CW" + CWString + "GW" + GWString
	

	//String pathName = "C:Users:joshbrake.LETNET:Dropbox:LETU:LETU M.S.E. Stuff:FIMMWAVE-FIMMPROP Biosensors Stuff:Scripts:Simulation Data:FIMMPROP SL Scanner:Cavity Redesign for Different Wavelengths:Raw Data:" // Windows Version
	String pathName = "MacBook Pro HDD:Dropbox:LETU:LETU M.S.E. Stuff:FIMMWAVE-FIMMPROP Biosensors Stuff:Scripts:Simulation Data:FIMMPROP SL Scanner:SL Scan Raw Data:Select Wavelengths:"//Cavity Redesign for Different Wavelengths:Raw Data:"	// Mac Version	
	String fileName = "SL Scan SL 0.00-1.00 um " +  CWString + " um CW " + GWString + " nm GW " + num2str(numpoints) + " pts " + lString + " nm.txt"

	String fullPathName = pathName + fileName
	Print fullPathName
	
	// Load the waves and set the local variables
	LoadWave/A/J/D/O/E=0/K=0/V={" "," $",0,0} fullPathName
	
	if (V_flag==0)
		return -1
	endif
	
	// Put the names of the waves into string variables
	String s0, s1
	s0 = StringFromList(0, S_waveNames)
	s1 = StringFromList(1, S_waveNames)
	
	Wave w0 = $s0
	Wave w1 = $s1
	
	Duplicate/O w0, SL_Thickness; KillWaves w0
	Duplicate/O w1, $PlString; KillWaves w1
	
	print PlString
	
	endfor
	

	
	//differentialcalculation(780,808,CW,GW)
	
	//differentialcalculation($P788String,$P808String,788,808,CW,GW,CWPrecision,GWPrecision,numpoints)
	//differentialcalculation(P808String,P830String,808,830,CW,GW,CWPrecision,GWPrecision,numpoints)
	//differentialcalculation(P830String,P850String,830,850,CW,GW,CWPrecision,GWPrecision,numpoints)
	//differentialcalculation(P850String,P780String,850,780,CW,GW,CWPrecision,GWPrecision,numpoints)
	//differentialcalculation($P850String,$P788String,850,788,CW,GW,CWPrecision,GWPrecision,numpoints)
	//differentialcalculation(P850String,P808String,850,808,CW,GW,CWPrecision,GWPrecision,numpoints)
	
	//displaySLData(CW,GW)
	
	//displayDifferentialData(CW,GW)
	
	
end

function displaySLData(CW,GW)

	variable CW,GW
	
	variable/G CWPrecision,GWPrecision
	String/G CWString,GWString
	
	CWString=convertNum2Str(CW,CWPrecision)
	GWString=convertNum2Str(GW,GWPrecision)
	
	variable/G sizel,i
	
	String/G SL_Thickness
	
	Wave l
	Wave/T displayStrings,displayColors
	
	pDisplayStrings()
	
	
	Execute "Display/I/W=(2,8,18,12) " + displayStrings[0] + "  vs SL_Thickness"
	
	for(i=1;i<=sizel;i+=1)
	
	Execute "AppendToGraph " + displayStrings[i] + " vs SL_Thickness"
	
	endfor
	
	// General graph modifications
	ModifyGraph frameStyle= 1,nticks=10,minor=1;DelayUpdate
	Label left "\\Z24 Transmission";DelayUpdate
	Label bottom "\\Z24Sensing Layer Thickness (µm)";DelayUpdate
	SetAxis left 0,1
	ModifyGraph fSize=20,axThick=2
	ModifyGraph axisEnab(left)={0,0.95}
	TextBox/C/N=text0/F=0/A=MT/X=0.00/Y=0.00 "\Z20Transmission vs. Sensing Layer Thickness for " + CWString + " µm Cavity with " + GWString + " nm Gold Film Thickness"
	
	ModifyGraph lsize=2
	
	// Set Graph colors
	for(i=0;i<=sizel;i+=1)
	Execute "ModifyGraph rgb(" + displayStrings[i] + ")=" + displayColors[i]
	endfor
	
	// Create Legend
	String/G LegendString = "Legend/C/N=text1/J/X=-5.00/Y=9.00" + "\"\\\Z18"
	
	for(i=0;i<=sizel;i+=1)
	LegendString = LegendString + "\\r\\s(" + displayStrings[i] + ") " + num2str(l[i]) + " nm"
	endfor
	LegendString = LegendString + "\""
	Execute LegendString
	
	String	TPictureName = "T vs SL " + CWString + " um CW " + GWString + " nm GW.jpg"
	
	saveGraphAsPicture(TPictureName)

end


function differentialcalculation(lambda1,lambda2,CW,GW)

	variable  lambda1,lambda2,CW, GW
	
	variable/G CWPrecision,GWPrecision,numpoints
	
	String/G CWString, GWString,P1String,P2String
	
	P1String = "P" + num2str(lambda1) + "CW" + CWString + "GW" + GWString
	P2String = "P" + num2str(lambda2) + "CW" + CWString + "GW" + GWString
	
	Wave P1=$P1String,P2=$P2String
	
	String DifferentialName = "diff"+num2str(lambda1) + num2str(lambda2) + "CW" + CWString + "GW" + GWString
	Make/O/N=(numpoints)/D $DifferentialName
	
	Wave w0 = $DifferentialName
	variable n
	
	for(n=0;n < numpoints;n=n+1)
	w0[n]=(P1[n]-P2[n])/(P1[n]+P2[n])
	endfor
	
end


function displayDifferentialData(CW,GW)

	variable CW,GW
	variable/G CWPrecision,GWPrecision

	String/G CWString,GWString,lString,diff780808,diff788808,diff808830,diff830850,diff830780,diff850780,diff850788,diff850808,SL_Thickness
	CWString=convertNum2Str(CW,CWPrecision)
	GWString=convertNum2Str(GW,GWPrecision)
	
	

	SL_Thickness = "SL_Thickness"
	
	display/I/W=(2,0,18,7)  $diff780808,$diff850780,$diff808830,$diff830850,$diff850808,$diff830780 vs $SL_Thickness //,$diff850788,$diff788808,
	ModifyGraph lsize=2, rgb($diff808830)=(0,65535,0), rgb($diff830850)=(26411,1,52428),  rgb($diff850808)=(0,0,0), rgb($diff850780)=(0,0,0)// rgb($diff850788)=(39321,1,31457) ,rgb($diff788808)=(0,0,65535)
	ModifyGraph frameStyle= 1,nticks=10,minor=1;DelayUpdate
	Label left "\\Z24 Differential Value";DelayUpdate
	Label bottom "\\Z24Sensing Layer Thickness (µm)";DelayUpdate
	SetAxis left -1,1
	ModifyGraph fSize=20,axThick=2
	TextBox/C/N=text0/F=0/A=MT/X=0.00/Y=0.00 "\Z20Differential Value vs. Sensing Layer Thickness for " + CWString + " µm Cavity with "+ GWString + " nm Gold Film Thickness" 
	ModifyGraph axisEnab(left)={0,0.95}
	Legend/C/N=text1/J/F=2
	Legend/C/N=text1/J/X=-5.00/Y=9.00 "\\Z18\r\\s('" + diff808830 + "') 808 nm & 830 nm\r\\s('" + diff830850 + "') 830 nm & 850 nm\r\\s('" + diff850808 + "') 850 nm & 808 nm\r\\s('" + diff780808 + "') 780 nm & 808 nm\r\\s('" + diff850780 + "') 850 nm & 780 nm"//\r\\s('" + diff850788 + "') 850 nm & 788 nm\r\\s('" + diff788808 + "') 788 nm & 808 nm

	String	DVPictureName = "DV vs SL " + CWString + " um CW " + GWString + " nm GW.jpg"
	
	//saveGraphAsPicture(DVPictureName)
	
end


function/S convertNum2Str(num,precision)
	variable num,precision
	
	String numString
	sprintf numString "%." + num2str(precision) + "f" num
	
	return numString
end

function saveGraphAsPicture(graphName)
string graphName

SavePICT/O/P=SLScanGraphs/C=1/E=-6/B=288/I/W=(0,0,16,9) as graphName

KillTopVisibleGraph()

end


function loadMultiple()

	Make/O CavityWidths; CavityWidths = {3.91,3.92,3.93,3.94,3.95,3.96,3.97,3.98,3.99,4.01,4.02,4.03,4.04,4.05,4.06,4.07,4.08,4.09,4.10,3.90,4.00}
	Make/O GoldWidths; GoldWidths = {12}
	
	WaveStats/Q CavityWidths
	variable numCW = V_npnts-1
	
	WaveStats/Q GoldWidths
	variable numGW = V_npnts-1
	
	variable i,n
	
	for(i=0; i<=numCW; i +=1)
	
		for(n=0; n<=numGW; n +=1)
		
		setup(CavityWidths[i],Goldwidths[n])
		
		loadSLData(CavityWidths[i],GoldWidths[n])
		
		endfor
	endfor
end

function multipleDifferential()

	Make/O CavityWidths; CavityWidths = {3.90,3.91,3.92,3.93,3.94,3.95,3.96,3.97,3.98,3.99,4.00,4.01,4.02,4.03,4.04,4.05,4.06,4.07,4.08,4.09,4.10}
	Make/O GoldWidths; GoldWidths = {12}
	
	WaveStats/Q CavityWidths
	variable numCW = V_npnts-1
	
	WaveStats/Q GoldWidths
	variable numGW = V_npnts-1
	
	String GWString=convertNum2Str(12,1)
	
	variable i,n
	
	for(i=0; i<=numCW; i +=1)
	
		for(n=0; n<=numGW; n +=1)
		
		endfor
	endfor
	
end

Function KillTopVisibleGraph()
	String topGraph = WinName(0, 1, 1)
	if (strlen(topGraph) == 0)
		return 0
	endif
 
	DoWindow /K $topGraph
	return 1
End



function pDisplayStrings()

	variable i
	variable/G sizel
	Wave l
	String/G CWString,GWString
	
	Make/O/T/N=(sizel+1) displayStrings
	
	for(i = 0;i <= sizel;i +=1)
	
	displayStrings[i] = "'P" + num2str(l[i]) +  "CW" + CWString + "GW" + GWString + "'"

	endfor
	
end