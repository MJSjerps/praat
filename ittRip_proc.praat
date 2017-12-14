#====================================================================
# makes itterated ripple noise from a pointprocess object
# if the period between two pulses is longer than maxper
# a silence will be inserted
#====================================================================

procedure ittRip_proc pointProc$ maxPer

	selectObject: "PointProcess 'pointProc$'"
	ppns_Dur = Get total duration
	ppns_PtNr = Get number of points
	Create Sound from formula: "NewSnd", 1, 0, 1, 44100, "0"
	Create Sound from formula: "Noise", 1, 0, ppns_Dur, 44100, "randomGauss(0,0.1)"

	ppns_PrevInTim = 0
	for i from 1 to ppns_PtNr+1
		selectObject: "Sound NewSnd"
		Rename: "NewSnd_temp"

		selectObject: "PointProcess 'pointProc$'"
		if i > ppns_PtNr
			ppns_InTim = ppns_Dur
			ppns_wind = ppns_InTim - ppns_PrevInTim
			ppns_PrevInTim = ppns_InTim
		else
			ppns_InTim = Get time from index: i
			ppns_wind = ppns_InTim - ppns_PrevInTim
			ppns_PrevInTim = ppns_InTim
    	endif
		selectObject: "Sound Noise"
		Extract part: 0, ppns_wind, "rectangular", 1, "no"
		if (ppns_wind < maxPer)
			plusObject: "Sound NewSnd_temp"
			Concatenate
			Rename... NewSnd
		else
			Create Sound from formula: "tempSil", 1, 0, ppns_wind, 44100, "0"
			plusObject: "Sound NewSnd_temp"
			Concatenate
			Rename... NewSnd
			selectObject: "Sound tempSil"
			Remove
		endif

		selectObject: "Sound NewSnd_temp"
		plusObject: "Sound Noise_part"
		Remove
	
	endfor
	
	selectObject: "Sound NewSnd"
	Extract part: 1, (1+ppns_Dur), "rectangular", 1, "no"
	Rename... NonspTone
	
	selectObject: "Sound Noise"
	plusObject: "Sound NewSnd"
	Remove

endproc