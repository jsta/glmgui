window_select_auto_kalib <-
function(workspace){

  win_SI_auto <- gwindow("Autocalibrate Lake Model", width = 400, visible = FALSE)
  win_SI_1 <- ggroup(horizontal = FALSE ,container = win_SI_auto)

  sub_label <-glabel("1. Select Parameter (based on SI-Values)",container = win_SI_1)
  font(sub_label) <- c(weight="bold")
  win_SI_para <- ggroup(horizontal = TRUE, container=win_SI_1, fill=TRUE )


  win_SI_para_1 <- ggroup(horizontal = FALSE, container=win_SI_para, fill=TRUE )
  cb_kw_auto <- gcheckbox ("Kw",container = win_SI_para_1,checked =FALSE)
  cb_ce_auto <- gcheckbox ("ce",container = win_SI_para_1,checked =TRUE)
  cb_cd_auto <- gcheckbox ("cd",container = win_SI_para_1,checked =FALSE)
  cb_ch_auto <- gcheckbox ("ch",container = win_SI_para_1,checked =FALSE)

  win_SI_para_2 <- ggroup(horizontal = FALSE, container=win_SI_para, fill=TRUE )
  cb_coef_mix_conv_auto <- gcheckbox ("coef_mix_conv",container = win_SI_para_2,checked =FALSE)
  cb_coef_wind_stir_auto <- gcheckbox ("coef_wind_stir",container = win_SI_para_2,checked =FALSE)
  cb_coef_mix_shear_auto <- gcheckbox ("coef_mix_shear",container = win_SI_para_2,checked =FALSE)
  cb_coef_mix_turb_auto <- gcheckbox ("coef_mix_turb",container = win_SI_para_2,checked =FALSE)
  cb_coef_mix_KH_auto <- gcheckbox ("coef_mix_KH",container = win_SI_para_2,checked =FALSE)
  cb_coef_mix_hyp_auto <- gcheckbox ("coef_mix_hyp",container = win_SI_para_2,checked =FALSE)

  win_SI_para_3 <- ggroup(horizontal = FALSE, container=win_SI_para, fill=TRUE )
  cb_seepage_rate_auto <- gcheckbox ("seepage_rate",container = win_SI_para_3,checked =TRUE)
  cb_inflow_factor_auto <- gcheckbox ("inflow_factor",container = win_SI_para_3,checked =TRUE)
  cb_outflow_factor_auto <- gcheckbox ("outflow_factor",container = win_SI_para_3,checked =TRUE) #AENDERUNG outflow dazu
  cb_rain_factor_auto <- gcheckbox ("rain_factor",container = win_SI_para_3,checked =TRUE)
  cb_wind_factor_auto <- gcheckbox ("wind_factor",container = win_SI_para_3,checked =TRUE)
  gseparator(horizontal=TRUE, container=win_SI_1, expand=TRUE)

  sub_label <-glabel("2. Select Field Data",container = win_SI_1)
  font(sub_label) <- c(weight="bold")

  radio_button_field_auto <- gradio(c("Temperature","Lake Level"), container=win_SI_1,horizontal =TRUE, selected=2)
  gseparator(horizontal=TRUE, container=win_SI_1, expand=TRUE)

  sub_label <-glabel("3. Select Interval Density",container = win_SI_1)
  font(sub_label) <- c(weight="bold")
  gslider_intervall <- gslider(from = 4, to = 20, by = 2, container=win_SI_1) #only even numbers possible: use default value and number/2 parts above and below default value
  svalue(gslider_intervall, index=TRUE)
  svalue(gslider_intervall) <- "4"

  gseparator(horizontal=TRUE, container=win_SI_1, expand=TRUE)
  win_SI_3 <- ggroup(horizontal = TRUE, container=win_SI_1, fill=TRUE )

  but_set_cali_range = gbutton("Set calibration range", container = win_SI_3, handler = function(h,...){ set_cali_boundary(boundary.env$vec_boundary)})
  but_cal_si_auto <<- gbutton("Calibrate", container = win_SI_3, handler=function(h,...) {

    if((dir_field_temp!= "" &&svalue(radio_button_field_auto) =="Temperature")|| (dir_field_level!= "" &&svalue(radio_button_field_auto) =="Lake Level")){
      print("Field data found")


      if(svalue(but_cal_si_auto) == "Calibrate"){


        List_parameter <- list()

        if(svalue(cb_inflow_factor_auto)){List_parameter[length(List_parameter)+1]<- "inflow_factor"}
        if(svalue(cb_outflow_factor_auto)){List_parameter[length(List_parameter)+1]<- "outflow_factor"}

        if(svalue(cb_kw_auto)){List_parameter[length(List_parameter)+1]<- "Kw"}
        if(svalue(cb_ch_auto)){List_parameter[length(List_parameter)+1]<- "ch"}
        if(svalue(cb_ce_auto)){List_parameter[length(List_parameter)+1]<- "ce"}
        if(svalue(cb_cd_auto)){List_parameter[length(List_parameter)+1]<- "cd"}

        if(svalue(cb_coef_mix_conv_auto)){List_parameter[length(List_parameter)+1]<- "coef_mix_conv"}
        if(svalue(cb_coef_wind_stir_auto)){List_parameter[length(List_parameter)+1]<- "coef_wind_stir"}
        if(svalue(cb_coef_mix_shear_auto)){List_parameter[length(List_parameter)+1]<- "coef_mix_shear"}
        if(svalue(cb_coef_mix_turb_auto)){List_parameter[length(List_parameter)+1]<- "coef_mix_turb"}
        if(svalue(cb_coef_mix_KH_auto)){List_parameter[length(List_parameter)+1]<- "coef_mix_KH"}
        if(svalue(cb_coef_mix_hyp_auto)){List_parameter[length(List_parameter)+1]<- "coef_mix_hyp"}

        if(svalue(cb_seepage_rate_auto)){List_parameter[length(List_parameter)+1]<- "seepage_rate"}
        if(svalue(cb_rain_factor_auto)){List_parameter[length(List_parameter)+1]<- "rain_factor"}
        if(svalue(cb_wind_factor_auto)){List_parameter[length(List_parameter)+1]<- "wind_factor"}


        enabled(cb_kw_auto)<- FALSE
        enabled(cb_ce_auto) <- FALSE
        enabled(cb_cd_auto) <- FALSE
        enabled(cb_ch_auto) <- FALSE
        enabled(cb_coef_mix_conv_auto)<-FALSE
        enabled(cb_coef_wind_stir_auto)<-FALSE
        enabled(cb_coef_mix_shear_auto)<-FALSE
        enabled(cb_coef_mix_turb_auto) <-FALSE
        enabled(cb_coef_mix_KH_auto) <-FALSE
        enabled(cb_coef_mix_hyp_auto) <- FALSE
        enabled(cb_seepage_rate_auto) <-FALSE
        enabled(cb_inflow_factor_auto) <-FALSE
        enabled(cb_outflow_factor_auto) <-FALSE
        enabled(cb_rain_factor_auto) <-FALSE
        enabled(cb_wind_factor_auto) <-FALSE

        svalue(but_cal_si_auto)<-"Cancel Calculation"

        calculate_auto_kalib(workspace,List_parameter,boundary.env$vec_boundary,svalue(radio_button_field_auto),svalue(gslider_intervall), label_status_CAL_calculation)
          #calculation start

        #calculation finished or canceled:
        svalue(but_cal_si_auto)<-"Calibrate"


        enabled(cb_kw_auto)<- TRUE
        enabled(cb_ce_auto) <- TRUE
        enabled(cb_cd_auto) <- TRUE
        enabled(cb_ch_auto) <- TRUE
        enabled(cb_coef_mix_conv_auto)<-TRUE
        enabled(cb_coef_wind_stir_auto)<-TRUE
        enabled(cb_coef_mix_shear_auto)<-TRUE
        enabled(cb_coef_mix_turb_auto) <-TRUE
        enabled(cb_coef_mix_KH_auto) <-TRUE
        enabled(cb_coef_mix_hyp_auto) <- TRUE
        enabled(cb_seepage_rate_auto) <-TRUE
        enabled(cb_inflow_factor_auto) <-TRUE
        enabled(cb_outflow_factor_auto) <-TRUE
        enabled(cb_rain_factor_auto) <-TRUE
        enabled(cb_wind_factor_auto) <-TRUE
      }
      else{
        svalue(but_cal_si_auto)<-"canceling..."
      }}


    else{
      show_message("Missing Field Data.")
    }})


  but_cal_close <- gbutton("Close", container = win_SI_3, handler=function(h,...) {dispose((h$obj)) })
  glabel("status:",container = win_SI_3,fg="red")

  label_status_CAL_calculation <<-glabel("",container = win_SI_3,fg="red")

  visible(win_SI_auto) <- TRUE
}
