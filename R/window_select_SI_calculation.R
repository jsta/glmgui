window_select_SI_calculation <-
function(workspace){
  parameter<-c("Kw","ce","cd","ch","coef_mix_conv","coef_wind_stir","coef_mix_shear","coef_mix_turb","coef_mix_KH","coef_mix_hyp","seepage_rate","inflow_factor","outflow_factor","rain_factor","wind_factor")
  win_SI <- gwindow("Calculate SI-value", width = 400, visible = FALSE)
  win_SI_1 <- ggroup(horizontal = FALSE ,container = win_SI)
  
  sub_label <-glabel("1. Select Parameter(s)",container = win_SI_1)
  font(sub_label) <- c(size=10,weight="bold")
  win_SI_para <- ggroup(horizontal = TRUE, container=win_SI_1, fill=TRUE )
  win_SI_para_1 <- ggroup(horizontal = FALSE, container=win_SI_para, fill=TRUE )
  cb_kw <- gcheckbox ("Kw",container = win_SI_para_1,checked =TRUE)
  cb_ce <- gcheckbox ("ce",container = win_SI_para_1,checked =TRUE)
  cb_cd <- gcheckbox ("cd",container = win_SI_para_1,checked =TRUE)
  cb_ch <- gcheckbox ("ch",container = win_SI_para_1,checked =TRUE)
  win_SI_para_2 <- ggroup(horizontal = FALSE, container=win_SI_para, fill=TRUE )
  cb_coef_mix_conv <- gcheckbox ("coef_mix_conv",container = win_SI_para_2,checked =FALSE)
  cb_coef_wind_stir <- gcheckbox ("coef_wind_stir",container = win_SI_para_2,checked =FALSE)
  cb_coef_mix_shear <- gcheckbox ("coef_mix_shear",container = win_SI_para_2,checked =FALSE)
  cb_coef_mix_turb <- gcheckbox ("coef_mix_turb",container = win_SI_para_2,checked =FALSE)
  cb_coef_mix_KH <- gcheckbox ("coef_mix_KH",container = win_SI_para_2,checked =FALSE)
  cb_coef_mix_hyp <- gcheckbox ("coef_mix_hyp",container = win_SI_para_2,checked =FALSE)
  win_SI_para_3 <- ggroup(horizontal = FALSE, container=win_SI_para, fill=TRUE )
  cb_seepage_rate <- gcheckbox ("seepage_rate",container = win_SI_para_3,checked =TRUE)
  cb_inflow_factor <- gcheckbox ("inflow_factor",container = win_SI_para_3,checked =TRUE)
  cb_outflow_factor <- gcheckbox ("outflow_factor",container = win_SI_para_3,checked =TRUE) #AENDERUNG outflow dazu
  cb_rain_factor <- gcheckbox ("rain_factor",container = win_SI_para_3,checked =TRUE)
  cb_wind_factor <- gcheckbox ("wind_factor",container = win_SI_para_3,checked =TRUE)
  gseparator(horizontal=TRUE, container=win_SI_1, expand=TRUE)  
  
  
  
  sub_label <-glabel("2. Select Increase %",container = win_SI_1)
  font(sub_label) <- c(size=10,weight="bold")
    
  radio_button_percent <- gradio(c("5","10","20","50"), container=win_SI_1, selected=2, horizontal =  TRUE)
  gseparator(horizontal=TRUE, container=win_SI_1, expand=TRUE) 
  
   
  
  sub_label <-glabel("3. Select Field Data",container = win_SI_1)
  font(sub_label) <- c(size=10,weight="bold")
  radio_button_field <- gradio(c("Temperature","Lake Level"), container=win_SI_1,horizontal =TRUE, selected=1) #AENDERUNG: Combined entfernt
  gseparator(horizontal=TRUE, container=win_SI_1, expand=TRUE) 
  
  sub_label <-glabel("4. Select measure of difference",container = win_SI_1)
  font(sub_label) <- c(size=10,weight="bold")
  radio_button_guete <- gradio(c("RMSE","Model output"), container=win_SI_1,horizontal =TRUE, selected=1)
  gseparator(horizontal=TRUE, container=win_SI_1, expand=TRUE)
  
  #dir_field_temp
  win_SI_3 <- ggroup(horizontal = TRUE, container=win_SI_1, fill=TRUE )
  but_cal_si <- gbutton("Calculate SI-Values", container = win_SI_3, handler=function(h,...) {
    
    if((dir_field_temp!= "" &&svalue(radio_button_field) =="Temperature")|| (dir_field_level!= "" &&svalue(radio_button_field) =="Lake Level")){
      print("1")
    if(svalue(but_cal_si) == "Calculate SI-Values"){
    List_parameter <- list()
    #"Kw","ce","cd","ch"   "coef_mix_conv","coef_wind_stir","coef_mix_shear","coef_mix_turb","coef_mix_KH","coef_mix_hyp","seepage_rate","inflow_factor", "outflow_factor" ,"rain_factor","wind_factor"
    if(svalue(cb_kw)){List_parameter[length(List_parameter)+1]<- "Kw"}    
    if(svalue(cb_ch)){List_parameter[length(List_parameter)+1]<- "ch"} 
    if(svalue(cb_ce)){List_parameter[length(List_parameter)+1]<- "ce"}    
    if(svalue(cb_cd)){List_parameter[length(List_parameter)+1]<- "cd"} 
    
    if(svalue(cb_coef_mix_conv)){List_parameter[length(List_parameter)+1]<- "coef_mix_conv"}    
    if(svalue(cb_coef_wind_stir)){List_parameter[length(List_parameter)+1]<- "coef_wind_stir"}    
    if(svalue(cb_coef_mix_shear)){List_parameter[length(List_parameter)+1]<- "coef_mix_shear"}    
    if(svalue(cb_coef_mix_turb)){List_parameter[length(List_parameter)+1]<- "coef_mix_turb"}    
    if(svalue(cb_coef_mix_KH)){List_parameter[length(List_parameter)+1]<- "coef_mix_KH"}    
    if(svalue(cb_coef_mix_hyp)){List_parameter[length(List_parameter)+1]<- "coef_mix_hyp"}    
    
    if(svalue(cb_seepage_rate)){List_parameter[length(List_parameter)+1]<- "seepage_rate"}    
    if(svalue(cb_inflow_factor)){List_parameter[length(List_parameter)+1]<- "inflow_factor"}   
    if(svalue(cb_outflow_factor)){List_parameter[length(List_parameter)+1]<- "outflow_factor"} #AENDERUNG outflow auch dazu
    if(svalue(cb_rain_factor)){List_parameter[length(List_parameter)+1]<- "rain_factor"}    
    if(svalue(cb_wind_factor)){List_parameter[length(List_parameter)+1]<- "wind_factor"}  
    
    
    
    enabled(cb_kw)<- FALSE
    enabled(cb_ce) <- FALSE
    enabled(cb_cd) <- FALSE
    enabled(cb_ch) <- FALSE
    enabled(cb_coef_mix_conv)<-FALSE
    enabled(cb_coef_wind_stir)<-FALSE
    enabled(cb_coef_mix_shear)<-FALSE
    enabled(cb_coef_mix_turb) <-FALSE
    enabled(cb_coef_mix_KH) <-FALSE
    enabled(cb_coef_mix_hyp) <- FALSE
    enabled(cb_seepage_rate) <-FALSE
    enabled(cb_inflow_factor) <-FALSE
    enabled(cb_outflow_factor) <-FALSE
    enabled(cb_rain_factor) <-FALSE
    enabled(cb_wind_factor) <-FALSE
    svalue(but_cal_si)<-"Cancel Calculation"
    calculate_SI_value(List_parameter,svalue(radio_button_percent),svalue(radio_button_guete),svalue(radio_button_field),workspace,label_status_SI_calculation,but_cal_si)
    #calculation finished or canceled
    svalue(but_cal_si)<-"Calculate SI-Values"
    
    
    enabled(cb_kw)<- TRUE
    enabled(cb_ce) <- TRUE
    enabled(cb_cd) <- TRUE
    enabled(cb_ch) <- TRUE
    enabled(cb_coef_mix_conv)<-TRUE
    enabled(cb_coef_wind_stir)<-TRUE
    enabled(cb_coef_mix_shear)<-TRUE
    enabled(cb_coef_mix_turb) <-TRUE
    enabled(cb_coef_mix_KH) <-TRUE
    enabled(cb_coef_mix_hyp) <- TRUE
    enabled(cb_seepage_rate) <-TRUE
    enabled(cb_inflow_factor) <-TRUE
    enabled(cb_outflow_factor) <-TRUE
    enabled(cb_rain_factor) <-TRUE
    enabled(cb_wind_factor) <-TRUE
    }
    else{
      svalue(but_cal_si)<-"canceling..."
    }}
    else{
      show_message("Missing Field Data.")
    }})
  
  but_cal_close <- gbutton("Close", container = win_SI_3, handler=function(h,...) {dispose((h$obj)) })
  glabel("status:",container = win_SI_3,fg="red")
  
  label_status_SI_calculation <<-glabel("",container = win_SI_3,fg="red")
  
  visible(win_SI) <- TRUE
}
