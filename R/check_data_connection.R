check_data_connection <-
function(workspace,...){
  nml_file = file.path(workspace,"glm2.nml")
  message_nml<-try(eg_nml <-read_nml(nml_file), TRUE)

  if(length(message_nml) == 1){
    show_message(message_nml)
    svalue(label_nml_status)<-"glm2.nml has Errors"
  }
  else{
    print(length(get_nml_value(eg_nml,arg_name = "H")))
    #eg_nml <-read_nml(nml_file)
    svalue(label_nml_status)<-"glm2.nml found"
    enabled(button_confi)<<-TRUE
    enabled(button_set_parameter)<<-TRUE
    enabled(button_build)<<-TRUE
    enabled(button_cal_SI_value)<<-TRUE
    enabled(button_field_level)<<-TRUE
    enabled(button_field_temp)<<-TRUE
    enabled(button_autocalib)<<-TRUE
    enabled(button_cal_SI_value)<<-TRUE


    svalue(label_workspace_project)<- get_nml_value(eg_nml,arg_name = "sim_name")
    # Prepair List for changing parameter value
    eg_nml <-read_nml(nml_file)
    l<<- c("")
    k <<- 1
    for ( i in 1:length(names(eg_nml)) ) {
      for(j in 1:length(eg_nml[[i]])){
        l[[k]]  <<- names(eg_nml[[i]][j])
        k<<- k+1
      }
    }#End groups

    #Meteo Data
    if(get_nml_value(eg_nml,arg_name = "met_sw")=="TRUE"){
      arg <- get_nml_value(eg_nml,arg_name = "meteo_fl")
      dir_meteo <<- paste (workspace,arg, sep = "/")
      arg_meteo <<- arg
      if(file.exists(dir_meteo)){
        enabled(button_met_draw)<-TRUE
        svalue(label_met_data)<<-get_nml_value(eg_nml,arg_name = "meteo_fl")
      }
      else{
        svalue(label_met_data)<<-paste(get_nml_value(eg_nml,arg_name = "meteo_fl")," - Data not found")
        }

    }
    else{
      svalue(label_met_data)<<-"No Meteo data selected"
    }
    #INFLOW Data
    if(get_nml_value(eg_nml,arg_name = "num_inflows")!="0"){
      arg <- get_nml_value(eg_nml,arg_name = "inflow_fl")
      if(length(grep(",", arg))>0){
        multi_inflow<<-unlist(strsplit(arg,","))
        print(length(multi_inflow))
        for (i in 1:length(multi_inflow)) {
          bool<-TRUE
          dir_inflow_multiple <- paste (workspace,multi_inflow[i], sep = "/")

          if(file.exists(dir_inflow_multiple)){}
          else{bool<-FALSE}
        }
        if(bool==TRUE){
          enabled(button_inflow_draw)<-TRUE
          svalue(label_inflow_data)<<-get_nml_value(eg_nml,arg_name = "inflow_fl")
        }
        else{
          show_message("Missing Inflow data in workspace")
        }

      }
      else{
        arg_inflow<<-arg
        dir_inflow <<- paste (workspace,arg, sep = "/")
        if(file.exists(dir_inflow)){
          enabled(button_inflow_draw)<-TRUE
          svalue(label_inflow_data)<<-get_nml_value(eg_nml,arg_name = "inflow_fl")
        }
        else{
          enabled(button_inflow_draw)<-FALSE
          svalue(label_inflow_data)<<-paste(get_nml_value(eg_nml,arg_name = "inflow_fl")," - Data not found")
        }
      }

    }
    else{
      svalue(label_inflow_data)<<-"No Inflow"
    }
    #OUTFLOW Data
    if(get_nml_value(eg_nml,arg_name = "num_outlet")!="0"){
      arg <- get_nml_value(eg_nml,arg_name = "outflow_fl")
      if(length(grep(",", arg))>0){
        multi_outflow<<-unlist(strsplit(arg,","))
        print(length(multi_outflow))
        for (i in 1:length(multi_outflow)) {
          bool<-TRUE
          dir_outflow_multiple <- paste (workspace,multi_outflow[i], sep = "/")

          if(file.exists(dir_outflow_multiple)){}
          else{bool<-FALSE}
        }
        if(bool==TRUE){
          enabled(button_outflow_draw)<-TRUE
          svalue(label_outflow_data)<<-get_nml_value(eg_nml,arg_name = "outflow_fl")
        }
        else{
          show_message("Missing Outflow data in workspace")
        }

      }
      else{
        dir_outflow <<- paste (workspace,arg, sep = "/")
        if(file.exists(dir_outflow)){
          enabled(button_outflow_draw)<-TRUE
          svalue(label_outflow_data)<<-get_nml_value(eg_nml,arg_name = "outflow_fl")
        }
      }

    }
    else{
      svalue(label_outflow_data)<<-"No Outflow"
    }


    }

 }
