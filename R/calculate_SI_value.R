calculate_SI_value <-
function(List_parameter, int_Prozent,int_guete_verfahren,int_field_data,workspace,label_status_SI_calculation,but_cal_si){
  #initial run to create output directory
  GLMr::run_glm(workspace)
  svalue(label_status_SI_calculation) <-"building..."
  dir_output <<-paste (workspace,"/output/", sep = "")
  nml_file <- file.path(workspace, 'glm2.nml')
  nc_file <- file.path(dir_output, 'output.nc')
  ### Save Default Parameter
  eg_nml_old <-read_nml(nml_file)
  eg_nml <-read_nml(nml_file)
  print("calculate sensitivity index")
  print("---------------------------")
  print(paste("Number of parameters: ",length(List_parameter)))
  dir_output_model<- paste(dir_output,"/",get_nml_value(eg_nml,arg_name = "csv_lake_fname"),".csv",sep = "")
  start_time<-Sys.time()
  vektor_name <- 0
  vektor <- 0
  for(i in 1:length(List_parameter)){
    if(      svalue(but_cal_si) != "Cancel Calculation"){
      svalue(but_cal_si) <-" cancelled"
      break}
    eg_nml = eg_nml_old #overwrite glm2.nml with default values, as values could be changed
    value <- get_nml_value(eg_nml,arg_name =  paste(List_parameter[i]))
    ### Default RMSE
    eg_nml <- set_nml(eg_nml,arg_name =   paste(List_parameter[i]) ,arg_val =  value)
    print("writing new value")
    write_nml(eg_nml, file = nml_file)
    Sys.sleep(1)
    GLMr::run_glm(workspace)
    #Select
    if(int_field_data=="Temperature"){
      print("calculating temperature differences")
      data_frame <- compare_to_field(nc_file, dir_field_temp,metric = 'water.temperature', as_value = TRUE)
      data_frame <- calculate_diff_modell_field(data_frame = data_frame)
      WT_null = data_frame[1:nrow(data_frame),3] #1-dimensional num with water temp in every depth of all time points
    }
    else if(int_field_data=="Lake Level"){
      print("calculating lake level differences")
      data_frame <- get_dataframe_Level_Lake(workspace,dir_field_level,dir_output_model)
      LL_null = data_frame[1:nrow(data_frame),2] #1-dimensional num with lake levels of all time points
    }

    if(int_guete_verfahren == "RMSE"){
      print("Calculating RMSE")
      Q_null<- calculate_RMSE(data_frame)
      print(Q_null)}


    ### RMSE plus 5/10 percent
    eg_nml <- set_nml(eg_nml,arg_name =  paste(List_parameter[i]) ,arg_val =  value*(1+as.integer(int_Prozent)/100))
    write_nml(eg_nml, file = nml_file)
    Sys.sleep(1)
    GLMr::run_glm(workspace)
    if(int_field_data=="Temperature"){
      print("calculating temperature differences")
      data_frame <- compare_to_field(nc_file, dir_field_temp,metric = 'water.temperature', as_value = TRUE)
      data_frame <- calculate_diff_modell_field(data_frame = data_frame)
      WT_plus = data_frame[1:nrow(data_frame),3]
    }
    else if(int_field_data=="Lake Level"){
      print("calculating lake level differences")
      data_frame <- get_dataframe_Level_Lake(workspace,dir_field_level,dir_output_model)
      LL_plus = data_frame[1:nrow(data_frame),2]
    }

    if(int_guete_verfahren == "RMSE" && int_field_data != "Combined (Temp,Lake Level)"){
      print("Calculating RMSE")
      Q_plus<- calculate_RMSE(data_frame)
      print(Q_plus)
    }


    ### RMSE minus 5/10 percent
    eg_nml <- set_nml(eg_nml,arg_name =   paste(List_parameter[i]) ,arg_val =  value*(1-as.integer(int_Prozent)/100))
    write_nml(eg_nml, file = nml_file)
    Sys.sleep(1)
    GLMr::run_glm(workspace)
    if(int_field_data=="Temperature"){
      print("calculating temperature differences")
      data_frame <- compare_to_field(nc_file, dir_field_temp,metric = 'water.temperature', as_value = TRUE)
      data_frame <- calculate_diff_modell_field(data_frame = data_frame)
      WT_minus = data_frame[1:nrow(data_frame),3]
    }
    else if(int_field_data=="Lake Level"){
      print("calculating lake level differences")
      data_frame <- get_dataframe_Level_Lake(workspace,dir_field_level,dir_output_model)
      LL_minus = data_frame[1:nrow(data_frame),2]
    }

    if(int_guete_verfahren == "RMSE"){
      print("Calculating RMSE")
      Q_minus<- calculate_RMSE(data_frame)
      print(Q_minus)
    }

    vektor_name[i]<-paste(List_parameter[i])



    if(int_guete_verfahren == "RMSE"){
      vektor[i] <-calculate_rel_SI_RMSE(Q_plus,Q_minus,Q_null)
    }
    else if(int_guete_verfahren == "Model output"){
    if(int_field_data=="Temperature"){
      vektor[i] <-calculate_rel_SI_WT(WT_plus,WT_minus,WT_null,as.integer(int_Prozent),value)
    }

    else if(int_field_data=="Lake Level"){
      vektor[i] <-calculate_rel_SI_LL(LL_plus,LL_minus,LL_null,as.integer(int_Prozent),value)
    }
    }



    calculate_needed_time(i,label_status_SI_calculation,start_time,length(List_parameter))
  }
  ### Set parameter
  if(   svalue(but_cal_si) == "Cancel Calculation"){

    parameter_name <- "parameter"
    y_name <- "Sens_value"
    d1 <<- data.frame(vektor_name,vektor)
    names(d1) <- c(parameter_name,y_name)

    if(int_field_data=="Temperature"){
      write.csv(x = d1,file = paste(workspace, "/Sensitivity_Temp.csv", sep = ""),quote = FALSE,row.names=FALSE)}

    if(int_field_data=="Lake Level"){
      write.csv(x = d1,file = paste(workspace, "/Sensitivity_Level.csv", sep = ""),quote = FALSE,row.names=FALSE)}
    print(d1)
    w <- gwindow(title = "Sensitivity Index Level", visible=TRUE)
    gg <- ggraphics(container=w)
    ggmain <- dev.cur()
    Sys.sleep(0.5)
    op <- par(mar=c(9,6,4,2)) #make plotting area a bit bigger for long parameter names
    barplot(vektor,names.arg = vektor_name,main="Sensitivity Index", ylab="SI-Value", mgp=c(5,1,0),las=2) #mgp for pushing label to the left
    rm(op) # remove change of par()
  }
  ## Set Default Parameter
  write_nml(eg_nml_old, file = nml_file)
  svalue(label_status_SI_calculation)<<-"DONE"


}
