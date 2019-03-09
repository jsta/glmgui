calculate_needed_time <-
function(i,label_status_SI_calculation,start_time,length_List_parameter){
  percent<- (round(i*100/length_List_parameter,digits = 2))
  EstimSec<-round( as.numeric(     difftime( Sys.time(),start_time,units = c("secs")))*(100-percent)/percent , digits = 0)
  if(EstimSec>90 & EstimSec<3600){
    EstimSec<-round( as.numeric(     difftime( Sys.time(),start_time,units = c("mins")))*(100-percent)/percent , digits = 0)
    svalue(label_status_SI_calculation)<<-paste("",   paste(  percent   ,"% "),paste("Estimated time:",EstimSec)," Mins"    )
  }
  else if(EstimSec>3600){
    EstimSec<-round( as.numeric(     difftime( Sys.time(),start_time,units = c("hours")))*(100-percent)/percent , digits = 0)
    svalue(label_status_SI_calculation)<<-paste("",   paste(  percent   ,"% "),paste("Estimated time:",EstimSec)," Hours"    )
  }
  else{
    svalue(label_status_SI_calculation)<<-paste("",   paste(  percent   ,"% "),paste("Estimated time:",EstimSec)," Sec"    )
  }
}
