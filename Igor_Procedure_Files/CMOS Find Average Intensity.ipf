#pragma rtGlobals=1		// Use modern global access method.



//Load Images
Function LoadImageFiles1spot(numpoints)

	variable numpoints
	
	string filename, path
	
	variable i
	variable col1, col2, row1, row2
	
	Make/O/N=(numpoints)/D tempwave1
	
	Make/O/N=(numpoints)/D temp1
	Make/O/N=(numpoints)/D temp2
	
	for(i =0; i< numpoints; i += 3)
		//file name
		filename = "1-"+num2str(i)+".tif"
		//folder path/name
		path ="E:Cody:4-13-18_Refractive_Index:Point1:"+ filename
		//path ="C:Users:codyjoy:Desktop:Glue Test:No Glue- 850 nm laser:"+ filename
		
		ImageLoad/O/T=tiff path
		
		Duplicate/O/R=(row1,row2)(col1,col2) $filename tempwave1
		
		killwaves $filename
	endfor

End

//Making a New Array for the area next to the Center points
Function TotalCenterAvg(numpoints, row, col, newWaveName)
	variable numpoints
	variable col, row	
	string newWaveName
	
	
	string filename
	variable i
	variable j=0, k = 0
		
	//col1 = 200 row1 = 350 col2 = 300 row2 = 450
	variable col1, col2, row1, row2
	
	col1 = col-25 ;	row1 = row-25 ;	col2 = col+25 ;	row2 = row + 25
		
	Make/O/N=(40000)/D tempwave
	Make/O/N=(numpoints)/D meanvalues

	for(i =0; i< numpoints; i += 3)
		//file name; ex) T40_2_0.bmp
		
		filename = "1-"+num2str(i)+".tif"
		
		//new Array for Frame Averages							
		Duplicate/O/R=(row1,row2)(col1,col2) $filename tempwave
		meanvalues[i] = mean(tempwave)
	endfor
	
	Duplicate/O meanvalues $newWaveName
	
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
		//ScaledDiffValues[i] = (P1[i] - P2[i]) / (P1[i] + P2[i])
		ScaledDiffValue[i] = (P1[i] - 4243.38/11476.6*P2[i]) / (P1[i] + 4243.38/11476.6*P2[i])
	endfor
	
	Duplicate/O ScaledDiffValue $diffWaveName
	Duplicate/O $diffWaveName wave1
	CurveFit/M=2/W=0 line, wave1[0,100]/X=timeStamp[0,100]/D
	WAVE W_coef
	test1 = W_coef[1]
	//Duplicate/O ScaledDiffValues $diffWaveName
	//Duplicate/O $diffWaveName wave99
	//CurveFit/M=2/W=0 line, wave99[0,100]/X=timeStamp[0,100]/D
	//Wavestats P2
	//test =  V_max
	//Wavestats P1
	
	print test1
	//print V_max
	//print test
	//WAVE W_coef
	//print W_coef[1]
	//WAVE W_sigma
	//print w_sigma[1]
	
	
End

Function LoadImageAndSave3(numpoints, diodeNum, row, col, arraysize1, arraysize2, arraysize3, wave_name1, wave_name2, wave_name3)

	variable numpoints, diodeNum, row, col, arraysize1, arraysize2, arraysize3
	string wave_name1, wave_name2, wave_name3
	
	String/G pathname
	string filename, path
	variable i
	variable col1, col2, row1, row2, areaPixels1
	variable col21, col22, row21, row22, areaPixels2
	variable col31, col32, row31, row32, areaPixels3
	
	col1 = col-arraysize1/2 ;	row1 = row-arraysize1/2 ;	col2 = col+arraysize1/2-0.1 ;	row2 = row+arraysize1/2-0.1
	col21 = col-arraysize2/2 ;	row21 = row-arraysize2/2 ;	col22 = col+arraysize2/2-0.1 ;	row22 = row+arraysize2/2-0.1
	col31 = col-arraysize3/2 ;	row31 = row-arraysize3/2 ;	col32 = col+arraysize3/2-0.1 ;	row32 = row+arraysize3/2-0.1
	
	areaPixels1 = (row2-row1+1)*(col2-col1+1)
	areaPixels2 = (row22-row21+1)*(col22-col21+1)
	areaPixels3 = (row32-row31+1)*(col32-col31+1)	
	
	Make/O/N=(areaPixels1)/D tempwave1
	Make/O/N=(areaPixels2)/D tempwave2
	Make/O/N=(areaPixels3)/D tempwave3
	
	Make/O/N=(numpoints)/D temp1
	Make/O/N=(numpoints)/D temp2
	Make/O/N=(numpoints)/D temp3

	for(i =0; i< numpoints; i += 1)		
		filename = num2str(diodeNum)+"-"+ num2str(i)+".tif"
		path ="C:Donggee:2.21.18 2nd test C:"+ filename
		ImageLoad/O/T=tiff path

		Duplicate/O/R=(row1,row2)(col1,col2) $filename tempwave1
		Duplicate/O/R=(row21,row22)(col21,col22) $filename tempwave2
		Duplicate/O/R=(row31,row32)(col31,col32) $filename tempwave3
		
		temp1[i] = mean(tempwave1)
		temp2[i] = mean(tempwave2)
		temp3[i] = mean(tempwave3)
		
		killwaves $filename
		
	endfor
	Duplicate/O temp1 $wave_name1
	Duplicate/O temp2 $wave_name2
	Duplicate/O temp3 $wave_name3
	
End

Function LoadImageAndSave(numpoints, diodeNum, row, col, arraysize, wave_name)

	variable numpoints, diodeNum, row, col, arraysize
	string wave_name
	
	String/G pathname
	string filename, path
	variable i
	variable col1, col2, row1, row2, areaPixels
	
	col1 = col-arraysize/2 ;	row1 = row-arraysize/2 ;	col2 = col+arraysize/2-0.1 ;	row2 = row+arraysize/2-0.1
	
	areaPixels = (row2-row1+1)*(col2-col1+1)

	Make/O/N=(areaPixels)/D tempwave
	Make/O/N=(numpoints)/D temp

	for(i =0; i< numpoints; i += 1)		
		filename = num2str(diodeNum)+"-"+ num2str(i)+".tif"
		path ="C:Donggee:2.21.18 2nd test C:"+ filename
		ImageLoad/O/T=tiff path

		Duplicate/O/R=(row1,row2)(col1,col2) $filename tempwave
		
		temp[i] = mean(tempwave)
		
		killwaves $filename
		
	endfor
	Duplicate/O temp $wave_name

End


Function appendImagestoWave(wave1, row, col, arraysize, numpts, init_frame, wave_frame)

	wave wave1

	variable init_frame, numpts, wave_frame, row, col, arraysize
	
	variable col1, col2, row1, row2, areaPixels
	
	col1 = col-arraysize/2 ;	row1 = row-arraysize/2 ;	col2 = col+arraysize/2-0.1 ;	row2 = row+arraysize/2-0.1
	
	areaPixels = (row2-row1+1)*(col2-col1+1)

	Make/O/N=(areaPixels)/D tempwave
//	InsertPoints wave_frame, numpts*10, wave1 //10s
	InsertPoints wave_frame, numpts, wave1
	
	variable i
	String filename, path
	variable n = 0

	for(i = init_frame; i < init_frame+numpts; i += 1)		
		filename = "1_2018-04-16-142029-0" + num2str(i)+".tif"
		path ="E:Cody:4-13-18_Refractive_Index:Fluid 1:"+filename
		ImageLoad/O/T=tiff path

		Duplicate/O/R=(row1,row2)(col1,col2) $filename tempwave
		
		wave1[i-init_frame+wave_frame+n] = mean(tempwave)
		
//		n = n + 9                 // 10s
		
		killwaves $filename
		
	endfor

End

Function appendImagestoWave1(wave1, row, col, arraysize, numpts, init_frame, wave_frame)

	wave wave1

	variable init_frame, numpts, wave_frame, row, col, arraysize
	
	variable col1, col2, row1, row2, areaPixels
	
	col1 = col-arraysize/2 ;	row1 = row-arraysize/2 ;	col2 = col+arraysize/2 ;	row2 = row+arraysize/2
	
	areaPixels = (row2-row1+1)*(col2-col1+1)

	Make/O/N=(areaPixels)/D tempwave
//	InsertPoints wave_frame, numpts*10, wave1 //10s
	InsertPoints wave_frame, numpts, wave1
	
	variable i
	String filename, path
	variable n = 0

	for(i = init_frame; i < init_frame+numpts; i += 1)		
		if(0<=i<10)
			filename = "1_2018-04-13-191316-000" + num2str(i)+".tif"
			path ="E:Cody:4-13-18_Refractive_Index:Point1:"+filename
			ImageLoad/O/T=tiff path

			Duplicate/O/R=(row1,row2)(col1,col2) $filename tempwave
		
			wave1[i-init_frame+wave_frame+n] = mean(tempwave)
		elseif(10<=i<100)
			filename = "1_2018-04-13-191316-00" + num2str(i)+".tif"
			path ="E:Cody:4-13-18_Refractive_Index:Point1:"+filename
			ImageLoad/O/T=tiff path

			Duplicate/O/R=(row1,row2)(col1,col2) $filename tempwave
		
			wave1[i-init_frame+wave_frame+n] = mean(tempwave)
		elseif(100<=i<1000)
			filename = "1_2018-04-13-191316-0" + num2str(i)+".tif"
			path ="E:Cody:4-13-18_Refractive_Index:Point1:"+filename
			ImageLoad/O/T=tiff path
	
			Duplicate/O/R=(row1,row2)(col1,col2) $filename tempwave
		
			wave1[i-init_frame+wave_frame+n] = mean(tempwave)
	
		elseif(1000<=i)
			filename = "1_2018-04-13-191316-" + num2str(i)+".tif"
			path ="E:Cody:4-13-18_Refractive_Index:Point1:"+filename
			ImageLoad/O/T=tiff path
		
			Duplicate/O/R=(row1,row2)(col1,col2) $filename tempwave
		
			wave1[i-init_frame+wave_frame+n] = mean(tempwave)

		endif
		
//		n = n + 9                 // 10s
		
		killwaves $filename
		
	endfor

End


Function appendImagestoWaveatDiffpts(wave1, wave2, wave3, row1, col1, row2, col2, row3, col3, arraysize, numpts, init_frame, wave_frame)

	string wave1, wave2, wave3

	variable init_frame, numpts, wave_frame, row1, col1, arraysize, row2, col2, row3, col3
	
	
	variable col11, col12, row11, row12, areaPixels1, areaPixels2, areaPixels3
	variable col21, col22, row21, row22
	variable col31, col32, row31, row32
	
	col11 = col1-arraysize/2 ;	row11 = row1-arraysize/2 ;	col12 = col1+arraysize/2-0.1 ;	row12 = row1+arraysize/2-0.1
	col21 = col2-arraysize/2 ;	row21 = row2-arraysize/2 ;	col22 = col2+arraysize/2-0.1 ;	row22 = row2+arraysize/2-0.1
	col31 = col3-arraysize/2 ;	row31 = row3-arraysize/2 ;	col32 = col3+arraysize/2-0.1 ;	row32 = row3+arraysize/2-0.1
	
	areaPixels1 = (row12-row11+1)*(col12-col11+1)
	areaPixels2 = (row22-row21+1)*(col22-col21+1)
	areaPixels3 = (row32-row31+1)*(col32-col31+1)

	Make/O/N=(areaPixels1)/D tempwave1
	Make/O/N=(areaPixels2)/D tempwave2
	Make/O/N=(areaPixels3)/D tempwave3
	Make/O/N=(numpts)/D Temp
	Make/O/N=(numpts)/D Temp1
	Make/O/N=(numpts)/D Temp2
	Make/O/N=(numpts/3)/D Temp3
	Make/O/N=(numpts/3)/D Temp4
	Make/O/N=(numpts/3)/D Temp5
	
	//InsertPoints wave_frame, numpts, wave_name1
	//InsertPoints wave_frame, numpts, wave2
	//InsertPoints wave_frame, numpts, wave3
	
	variable i
	String filename, path
	variable n = 0

	for(i = init_frame; i < init_frame+numpts; i += 1)		
		filename = "1_2018-04-16-184848-" + num2str(i)+".tif"
		path ="E:Cody:4-13-18_Refractive_Index:Fluid 1:"+filename
		ImageLoad/O/T=tiff path

		Duplicate/O/R=(row11,row12)(col11,col12) $filename tempwave1
		Duplicate/O/R=(row21,row22)(col21,col22) $filename tempwave2
		Duplicate/O/R=(row31,row32)(col31,col32) $filename tempwave3
						
		Temp[i-init_frame+wave_frame+n] = mean(tempwave1)
		Temp1[i-init_frame+wave_frame+n] = mean(tempwave2)
		Temp2[i-init_frame+wave_frame+n] = mean(tempwave3)
		
		killwaves $filename
		
	endfor
				
	for(i=0; i<numpts/3 ; i+=1)
		Temp3[i] = Temp[wave_frame+i*3]
		Temp4[i] = Temp1[wave_frame+i*3+1]
		Temp5[i] = Temp2[wave_frame+i*3+2]
	endfor

	Duplicate/O Temp3 $wave1
	Duplicate/O Temp4 $wave2
	Duplicate/O Temp5 $wave3

	wavestats Temp3
	print V_avg
	print V_sdev
	print V_sdev/V_avg*100

	wavestats Temp4
	print V_avg
	print V_sdev
	print V_sdev/V_avg*100
	
	wavestats Temp5
	print V_avg
	print V_sdev
	print V_sdev/V_avg*100


End



function createTime(frame, totalTime, wave_name)
	
	variable frame, totalTime
	string wave_name
	variable i
	
	Make/O/N=(frame)/D sampleTime
	
	for(i=0;i<frame;i+=1)
		sampleTime[i]=i*totalTime/ frame
	endfor
	
	Duplicate sampleTime $wave_name

end


Function ImprovedDifferentialWavename(dataPoints, P1, P2, diffWaveName)
	
	variable dataPoints
	string diffWaveName
	wave P1, P2
	variable P1_0, P2_0
	
	Make/N=(dataPoints)/D/O ScaledDiffValue
	
	
	variable i
	P1_0 = P1[0]
	P2_0 = P2[0]
	
	for(i=0; i < dataPoints; i += 1)
		ScaledDiffValue[i] = (P1[i] - P1_0)/P1_0 - (P2[i] - P2_0)/P2_0
	endfor
	Duplicate/O ScaledDiffValue $diffWaveName
	
End

Function referenceMode(numpoints, wave1, wave2, newWaveName)
	variable numpoints
	wave wave1, wave2
	string newWaveName
	
	variable i, avg1, avg2
	
	avg1 = wave1[0] // Initial data
	avg2 = wave2[0] // Initial ref
	
	Make/O/N=(numpoints)/D testwave
	for(i =0; i < numpoints; i += 1)
		testwave[i] = wave1[i] - wave2[i] * avg1/avg2 + avg1
	endfor
	Duplicate/O testwave $newWaveName
	
End

function DivideInt(wave1, init_frame, end_frame, wave_name1, wave_name2, wave_name3)

	variable init_frame, end_frame
	string wave_name1, wave_name2, wave_name3
	wave wave1
	variable i, numframe

	numframe = end_frame - init_frame

	Make/O/N=(numframe/3)/D Temp
	Make/O/N=(numframe/3)/D Temp1
	Make/O/N=(numframe/3)/D Temp2


	for(i=0; i<numframe/3 ; i+=1)
		Temp[i] = wave1[init_frame+i*3]
		Temp1[i] = wave1[init_frame+i*3+1]
		Temp2[i] = wave1[init_frame+i*3+2]
	endfor

	Duplicate/O Temp $wave_name1
	Duplicate/O Temp1 $wave_name2
	Duplicate/O Temp2 $wave_name3

	wavestats Temp
	print V_avg
	print V_sdev
	print V_sdev/V_avg*100

	wavestats Temp1
	print V_avg
	print V_sdev
	print V_sdev/V_avg*100
	
	wavestats Temp2
	print V_avg
	print V_sdev
	print V_sdev/V_avg*100

end

Function findMean(wave1, wave2, wave3)
	wave wave1, wave2, wave3
	
	variable avg1, avg2, avg3
	avg1 = mean(wave1)
	avg2 = mean(wave2)
	avg3 = mean(wave3)
	
	return (avg1 + avg2 + avg3) / 3
End


Function Run(numpoints,timepersample)
	variable numpoints, timepersample
	
	
	
	Make/O/N=(numpoints)/D test, test1, test2, test3, test4, test5, test6, test7, test8, test9, test10, test11
	
	Make/O/N=(3)/D trans_avg, ref_avg, sputtertime1
	
	//LoadImageFiles1spot(numpoints, spotNum, sputterTime)
	variable i
	
	for( i = 1 ; i < 500; i += 1 ) //number of spots
		//LoadImageFiles1spot(500)
	endfor

	


	
	
	//TotalCenterAvg
	TotalCenterAvg(500, 378, 215, "test")
	TotalCenterAvg(500, 378, 215, "test1")
	TotalCenterAvg(500, 378, 215, "test2")
	TotalCenterAvg(500, 378, 215, "test3")
	TotalCenterAvg(500, 378, 215, "test4")
	TotalCenterAvg(500, 378, 215, "test5")
	TotalCenterAvg(500, 378, 215, "test6")
	TotalCenterAvg(500, 378, 215, "test7")
	TotalCenterAvg(500, 378, 215, "test8")
	TotalCenterAvg(500, 378, 215, "test9")
	TotalCenterAvg(500, 378, 215, "test10")
	TotalCenterAvg(500, 378, 215, "test11")

	
	
	
	
	
	
	
	
	
	
	
	if(1)
	variable tavg, ravg
	string wave_name1, wave_name2, wave_name3
	Make/O/N=(3)/D transmission, reflection, sputtertime
	
	sputtertime = {30,40,50}
	
	for(i = 0; i < 3; i += 1)
		//transmission
		wave_name1 = "t"+num2str(30+10*i) +"s1" ; wave_name2 = "t"+num2str(30+10*i) +"s2" ;	wave_name3 = "t"+num2str(30+10*i) +"s3"
		transmission[i] = findMean($wave_name1, $wave_name2, $wave_name3) / findMean(ns1, ns2, ns3)
		//reflection
		wave_name1 = "r"+num2str(30+10*i) +"s1" ; wave_name2 = "r"+num2str(30+10*i) +"s2"; wave_name3 = "r"+num2str(30+10*i) +"s3"
		reflection[i] = findMean($wave_name1, $wave_name2, $wave_name3) / findMean(ns1, ns2, ns3)
	endfor
	
	display transmission, reflection vs sputtertime
	
	endif

END






Window AverageofFrame788nmfilter() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(156,69.5,590.25,324.5) test,test1,test2
	ModifyGraph margin(top)=72
	ModifyGraph lSize=2
	ModifyGraph rgb(test1)=(0,12800,52224),rgb(test2)=(0,52224,0)
	Label left "\\F'Arial'\\Z18Average Pixel Intensity"
	Label bottom "\\Z18Image Number"
	TextBox/C/N=text0/A=MC/X=-20.63/Y=73.02 "Average of Frame\\Z18"
	Legend/C/N=text1/J/A=MC/X=49.25/Y=29.11 "\\s(test) 780 nm \r\\s(test1) 830 nm\r\\s(test2) 850 nm"
	TextBox/C/N=text2/F=0/Z=1/A=MT/X=5.26/Y=-13.73 "\\Z36Average of Frame"
EndMacro

Window Laser850nmFilter788nm() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(264.75,239,659.25,447.5) test2,test2
EndMacro

Window Laser780nmFilter788nm() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(567.75,77.75,962.25,286.25) test
EndMacro

Window Laser830nmFilter788nm() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(680.25,82.25,1074.75,290.75) test1
EndMacro
