build_model <-
function(workspace,...){
  svalue(label_status_build)<<-"building..."

  if(length(List_values)>0){
    ###multiple models build
    start_time<-Sys.time()
    #### LOOP
    for(element in 1:length(List_values)){
      if(svalue(button_build)=="Build"){break}


      dir_output <<-paste (workspace,"/output/", sep = "")
      nml_file <- file.path(workspace, 'glm2.nml')
      nc_file <- file.path(dir_output, 'output.nc')
      eg_nml <-read_nml(nml_file)
      #get_nml_value(read_nml(file.path(workspace, 'glm2.nml')),arg_name = "csv_lake_fname")
      dir_output_model<- paste(dir_output,"",get_nml_value(eg_nml,arg_name = "csv_lake_fname"),".csv",sep = "") #fuer Ammersee "" statt "/"

      eg_nml <- set_nml(eg_nml,arg_name =  List_parameter[[1]] ,arg_val = List_values[[element]])
      write_nml(eg_nml, file = nml_file)
      #Wait until writing prozess Stoped
      Sys.sleep(1)
      #Run model building
      GLMr::run_glm(workspace)

      ### Creates Data Framework for analysis
      ####compare level lake data
      if(svalue(checkbox_Level_plot)||svalue(checkbox_Level_rmse)){
        #### Calculate Data
        data_frame_level_raw <- get_dataframe_Level_Lake(workspace,dir_field_level,dir_output_model)
        ###Create List to Store Data Frame and List to Store Looped Parameter
        if(element ==1 ){                   dfList_Level <<- list()                }
        ####save Framework to List
        numb_elements<-as.numeric(length(dfList_Level))+1
        dfList_Level[[numb_elements]] <-data_frame_level_raw
        remove(numb_elements,data_frame_level_raw)
      }
      ####Compare Temp data
      if(svalue(checkbox_Temp_plot)||svalue(checkbox_Temp_rmse)){
        data_frame_temp_raw <- compare_to_field(nc_file, dir_field_temp,metric = 'water.temperature', as_value = TRUE)
        data_frame_temp_raw <- calculate_diff_modell_field(data_frame = data_frame_temp_raw)
        #if(svalue(checkbox_Temp_plot)){window_plot_temp_compare(paste("Value = ",List_values[[element]]),workspace, nc_file, dir_field_temp)}
        if(element ==1){                   dfList_Temp <<- list()                }
        numb_elements<-as.numeric(length(dfList_Temp))+1
        dfList_Temp[[numb_elements]] <-data_frame_temp_raw

        remove(numb_elements,data_frame_temp_raw)
      }


      #### Calculate Estimated Time

      percent<-round((element/length(List_values)*100),digits =0)
      EstimSec<-round( as.numeric(     difftime( Sys.time(),start_time,units = c("secs")))*(100-percent)/percent , digits = 0)
      if(EstimSec>90 & EstimSec<3600){
        EstimSec<-round( as.numeric(     difftime( Sys.time(),start_time,units = c("mins")))*(100-percent)/percent , digits = 0)
        svalue(label_status_build)<<-paste("building...",   paste(  percent   ,"% "),paste("Estimated time:",EstimSec)," Mins"    )
      }
      else if(EstimSec>3600){
        EstimSec<-round( as.numeric(     difftime( Sys.time(),start_time,units = c("hours")))*(100-percent)/percent , digits = 0)
        svalue(label_status_build)<<-paste("building...",   paste(  percent   ,"% "),paste("Estimated time:",EstimSec)," Hours"    )
      }
      else{
        svalue(label_status_build)<<-paste("building...",   paste(  percent   ,"% "),paste("Estimated time:",EstimSec)," Sec"    )
      }
    #### End Loop
    }
    if(svalue(button_build)=="Stop"){
      #### Plot
      if(svalue(checkbox_Level_plot) ){
        window_plot_list_graph("Compare Level",dfList_Level, List_values, List_parameter)
      }
      #### Calculation
      if(svalue(checkbox_Level_rmse)){
        ### Display histogram of each loop
        #1
        window_plot_multi_histo("Histogram Lake Level",dfList_Level)
        window_plot_RMSE("RMSE Lake Level" , dfList_Level)

      }
      if(svalue(checkbox_Temp_rmse)){


        window_plot_multi_histo("Histogram Temperature",dfList_Temp)
        window_plot_RMSE("RMSE Temperature" , dfList_Temp)

      }
    }

  }
  else{####single model build
    print("jupp") #equivalent to "yeah"
    GLMr::run_glm(workspace)
    dir_output <<-paste (workspace,"/output/", sep = "")
    nml_file <- file.path(workspace, 'glm2.nml')
    nc_file <- file.path(dir_output, 'output.nc')
    eg_nml <-read_nml(nml_file)
    dir_output_model<- paste(dir_output,"",get_nml_value(eg_nml,arg_name = "csv_lake_fname"),".csv",sep = "")


    ###TEMP changed:
    if(svalue(checkbox_Temp_plot)){
      #window_plot_temp_compare("Temperature",workspace, nc_file, dir_field_temp)  DOESNT WORK
      data_frame_temp_raw <- calculate_diff_modell_field(data_frame = compare_to_field(nc_file, dir_field_temp,metric = 'water.temperature', as_value = TRUE))
      w <- gwindow(title = "Temperature differences", visible=TRUE)
      gg <- ggraphics(container=w)
      ggmain <- dev.cur()
      Sys.sleep(0.2)
      plot(data_frame_temp_raw[,1],data_frame_temp_raw[,4],ylab = "Temperature difference", xlab = "Years",cex = 0.5, col = "blue",pch = 5)

    }

    if(svalue(checkbox_Temp_plot2)){
      window_plot_temp_compare("Temperature",workspace, nc_file, dir_field_temp, datapoints = 2)

    }
    if(svalue(checkbox_Temp_plot3)){
      window_plot_temp_compare("Temperature",workspace, nc_file, dir_field_temp, datapoints = 3)

    }
    if(svalue(checkbox_Temp_plot4)){
      window_plot_temp_compare("Temperature",workspace, nc_file, dir_field_temp, datapoints = 4)

    }

    if(svalue(checkbox_Temp_rmse)){
      temp_rmse <- compare_to_field(nc_file, dir_field_temp,metric = 'water.temperature', as_value = FALSE)
      show_message(paste("Temperature RMSE: ",temp_rmse, " "))
    }
    ###LEVEL
    if(svalue(checkbox_Level_plot) ||svalue(checkbox_Level_rmse)){
      df_level <-     get_dataframe_Level_Lake(workspace,dir_field_level,dir_output_model)
    }
    if(svalue(checkbox_Level_plot)){
      window_plot_dataframe_Level_Lake(df_level, workspace)
    }
    if(svalue(checkbox_Level_rmse)){
      RMSE_level <- calculate_RMSE( data_frame = df_level)

      show_message(paste("Level RMSE: ",RMSE_level, " m"))
      show_message(paste("Level MBE (Mean Bias Error: Model Data - Field Data): ",mean(df_level[,4]), " m"))
    }

  }






  svalue(button_build) <<- "Build"
  ####Finished
  svalue(label_status_build)<<-"building...complete"
}
