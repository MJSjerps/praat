#====================================================================
# fade a sound in (normal amplitude is reached at "starWind" 
# and fade out again at the end (start fading from "endWind"
#====================================================================


procedure fade_proc sound$ startWind endWind

   select Sound 'sound$'
    endtime = Get total duration
    Formula... if x < startWind then self * (x/startWind) else self fi
    Formula... if x > ('endtime') - endWind then self * (('endtime'-x)/endWind) else self fi      

endproc