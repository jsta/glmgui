### glmGUI ###


# starting point +  check lib
glmGUI <- function(...){
  version <- 1.0
  libs = c("gWidgets","tcltk", "gWidgetsRGtk2", "ncdf4", "rLakeAnalyzer", "digest", "graphics", "testit" ,"treemap","akima", "imputeTS")
  for (i in libs){
    if( !is.element(i, .packages(all.available = TRUE)) ) {
      install.packages(i)
    }
    if(require(i,character.only = TRUE)){
      print(paste(i," found"))
    }
  }
  if (require("glmtools")){
    print("glmtools found")
    if (require("GLMr")){
      print("GLMr found")
      windows_main_menu(version)
    }
    else{
      install.packages("GLMr", repos="http://owi.usgs.gov/R") 
      if(require("glmtools")){windows_main_menu(version)}
      }
  }
  else {
    install.packages("glmtools", repos="http://owi.usgs.gov/R")
    if(require("glmtools")){windows_main_menu(version)}
    }
}

#Create main window
windows_main_menu <- function(version){
  win_main <- gwindow("General Lake Model Toolbox", width = 300, visible = FALSE)
  content_project <- ggroup(horizontal = FALSE, container=win_main, fill=TRUE )
  #Define Variables
  workspace<<-""
  arg_meteo<<-""           #Filename meteo
  multi_inflow<<-""        #List Multiple Filename Inflow
  multi_outflow<<-""       #List Multiple Filename Outflow
  arg_inflow<<-""
  arg_outflow<<-""
  dir_field_temp<<-""
  dir_field_level<<-""
  
  List_parameter <<- list()
  List_values <<- list()
  dfList_Temp<<-list()
  dfList_Level<<-list()
    
  ####  Workspace
  content_project_workspace <- ggroup(horizontal = TRUE ,container = content_project)
  sub_label <-glabel("1. Workspace",container = content_project_workspace)
  font(sub_label) <- c(size=10,weight="bold")
  content_project_workspace2 <- ggroup(horizontal = TRUE ,container = content_project)
  glabel("Path: ",container = content_project_workspace2,fg="red")
  label_workspace <<-glabel("",container = content_project_workspace2,fg="red")
  content_project_workspace4 <- ggroup(horizontal = TRUE ,container = content_project)
  glabel("Project: ",container = content_project_workspace4,fg="red")
  label_workspace_project <<-glabel("",container = content_project_workspace4,fg="red")
  content_project_workspace_1 <- ggroup(horizontal = TRUE ,container = content_project)
  button_new_workspace <<- gbutton("Create New Control File", container = content_project_workspace_1, handler = function(h,...){
    dir<-""
    dir <- tk_choose.dir()  #instead of tclvalue(tkchooseDirectory())
    if(dir!=""){
      svalue(label_workspace)<- dir
      workspace<<- dir
      dir <- paste (dir,"/glm2.nml", sep = "")
      if(file.exists(dir)){
        show_message("Found existing Project\nCould not build new project.")
      }
      else{
        
        glm_nml <- read_nml()
        write_nml(glm_nml, file = dir)
        check_data_connection(workspace = workspace)
  
        
      }
    }
    
    
  })
  button_workspace <<- gbutton("Open Project", container = content_project_workspace_1, handler = function(h, ...) {
    dir<-""
    dir <- tk_choose.dir()  #instead of tclvalue(tkchooseDirectory())
    if(dir!=""){
      workspace<<- dir
      dir <- paste (dir,"/glm2.nml", sep = "")
      svalue(label_workspace)<- dir
      if(file.exists(dir)){
        show_message("Found glm2.nml file. \nCreating project.")
        ### existing project found
        check_data_connection(workspace = workspace)
        
      }
      else{
        #### no existing project found - create New
        window <- gwindow("Confirm", width = 250, height = 100)
        group <- ggroup(container = window)
        gimage("info", dirname="stock", size="dialog", container=group)
        
        ## A group for the message and buttons
        innergroup <- ggroup(horizontal=FALSE, container = group)
        glabel("No control file found. \n\nCreate Default?", container=innergroup, expand=TRUE)
        
        ## A group to organize the buttons
        buttongroup <- ggroup(container = innergroup)
        ## Push buttons to right
        #addSpring(button.group)
        gbutton("Ok",  container=buttongroup, handler = function(h,...){
          glm_nml <- read_nml()
          write_nml(glm_nml, file = dir)
          check_data_connection(workspace = workspace)
          dispose(window)
        })
        gbutton("Cancel",container=buttongroup,handler = function(h,...) {
          dispose(window)})
      }
      
      
    }

  })
  gseparator(horizontal=TRUE, container=content_project, expand=TRUE)  
  
  ####   Data connection
  content_project_data <- ggroup(horizontal = TRUE ,container = content_project)
  
  sub_label<-glabel("2. Data Connection", container = content_project_data)
  font(sub_label) <- c(size=10,weight="bold")
  content_project_meteo <- ggroup(horizontal = TRUE ,container = content_project)
  glabel("Meteo Data:  ", container = content_project_meteo)
  label_met_data <<-glabel("Data not found. Please select!",container = content_project_meteo)
  button_met_draw <<-gbutton("Show  Data" , container = content_project_meteo, handler = function(h,..){
    window_input_csv_to_plot(dir_meteo,arg_meteo,workspace)
  })
  enabled(button_met_draw)<-FALSE
  content_project_inflow <- ggroup(horizontal = TRUE ,container = content_project)
  glabel("Inflow Data:  ", container = content_project_inflow)
  label_inflow_data <<-glabel("Data not found. Please select!",container = content_project_inflow)
  button_inflow_draw <<-gbutton("Show  Data" , container = content_project_inflow, handler = function(h,..){
    if(length(multi_inflow)>1){
      for (i in 1:length(multi_inflow)) {
        dir_inflow_multiple <- paste (workspace,multi_inflow[i], sep = "/")
        window_input_csv_to_plot(dir_inflow_multiple,multi_inflow[i],workspace)
        
      }
    }
    else{
      window_input_csv_to_plot(dir_inflow,arg_inflow,workspace)
    }
  })
  enabled(button_inflow_draw)<-FALSE
  content_project_outflow <- ggroup(horizontal = TRUE ,container = content_project)
  glabel("Outflow Data:", container = content_project_outflow)
  label_outflow_data <<-glabel("Data not found. Please select!",container = content_project_outflow)
  button_outflow_draw <<-gbutton("Show  Data" , container = content_project_outflow, handler = function(h,..){
    if(length(multi_outflow)>1){
      for (i in 1:length(multi_outflow)) {
        dir_outflow_multiple <- paste (workspace,multi_outflow[i], sep = "/")
        window_input_csv_to_plot(dir_outflow_multiple,multi_outflow,workspace)
        
      }
    }
    else{
      window_input_csv_to_plot(dir_outflow,arg_outflow,workspace)
    }
  })
  enabled(button_outflow_draw)<-FALSE
  gseparator(horizontal=TRUE, container=content_project, expand=TRUE)  
  
  #### Config
  content_project_nml <- ggroup(horizontal = TRUE ,container = content_project)
  sub_label <-glabel("3. Control File",container = content_project_nml)
  font(sub_label) <- c(size=10,weight="bold")
  content_project_nml2 <- ggroup(horizontal = TRUE ,container = content_project)
  glabel("Status: ",container = content_project_nml2,fg="red")
  label_nml_status <<-glabel("",container = content_project_nml2,fg="red")
  content_project_nml3 <- ggroup(horizontal = TRUE ,container = content_project)
  button_confi<<-gbutton("Show All Settings" , container = content_project_nml3, handler = function(h,..){get_parameter(workspace)})
  button_set_parameter<<-gbutton("Change Specific Parameter" , container = content_project_nml3, handler = function(h,..){set_parameter(workspace)})
  enabled(button_confi)<-FALSE
  enabled(button_set_parameter)<-FALSE
  content_project_nml4 <- ggroup(horizontal = TRUE ,container = content_project)
  glabel("Range detected: ",container = content_project_nml4,fg="red")
  label_nml_range <<-glabel("",container = content_project_nml4,fg="red")
  gseparator(horizontal=TRUE, container=content_project, expand=TRUE)  
  

  
  #### Field Data 
  content_project_survey <- ggroup(horizontal = TRUE ,container = content_project)
  sub_label<-glabel("4. Field Data", container = content_project_survey)
  font(sub_label) <- c(size=10,weight="bold")
  ### FD- Temp
  content_project_survey1 <- ggroup(horizontal = TRUE ,container = content_project)
  glabel("Temperature : ",container = content_project_survey1,fg="red")
  label_field_temp <-glabel("Please select file...",container = content_project_survey1,fg="red")
  
  content_project_survey2 <- ggroup(horizontal = TRUE ,container = content_project)
  button_field_temp<<-gbutton("Select File" , container = content_project_survey2, handler = function(h,..){
    dir <-  tk_choose.files(default = workspace, caption = "Select temperature data file", multi = FALSE, filters = NULL, index = 1)    #statt file.choose(new=FALSE)
    if(dir!=""){
      dir_field_temp <<- dir
      svalue(label_field_temp)<-dir_field_temp
      enabled(button_field_temp_show)<<-TRUE
      enabled(checkbox_Temp_plot)<<-TRUE
      enabled(checkbox_Temp_plot2)<<-TRUE
      enabled(checkbox_Temp_plot3)<<-TRUE
      enabled(checkbox_Temp_plot4)<<-TRUE
      enabled(checkbox_Temp_rmse)<<-TRUE
      #enabled(button_field_combine_adjust)<<- FALSE 
      }
    })
  enabled(button_field_temp)<<-FALSE 
  button_field_temp_show<-gbutton("Show Data" , container = content_project_survey2, handler = function(h,..){window_input_csv_to_plot2(dir_field_temp,strsplit(dir_field_temp, "/")[[1]][max(length(strsplit(dir_field_temp, "/")[[1]]))],workspace)}) #AENDERUNG: korrekter Funktionsaufruf
  enabled(button_field_temp_show)<-FALSE

  
  content_project_build_check1_sub <- ggroup(horizontal = TRUE ,container = content_project)
  checkbox_Temp_rmse <<-gcheckbox(text = "Analyze Temperature Differences (RMSE)",container=content_project_build_check1_sub,checked=FALSE)
  enabled(checkbox_Temp_rmse)<-FALSE
  checkbox_Temp_plot <<-gcheckbox(text = "Plot Temperature Differences",container=content_project_build_check1_sub,checked=FALSE)
  enabled(checkbox_Temp_plot)<-FALSE
  content_project_build_check1_sub2 <- ggroup(horizontal = TRUE ,container = content_project)
  checkbox_Temp_plot2 <<-gcheckbox(text = "Save Contourplots of observed and modeled Temperature with measured datapoints as PDF to your workspace",container=content_project_build_check1_sub2,checked=FALSE)
  enabled(checkbox_Temp_plot2)<-FALSE
  content_project_build_check1_sub3 <- ggroup(horizontal = TRUE ,container = content_project)
  checkbox_Temp_plot3 <<-gcheckbox(text = "Save Contourplots of observed and modeled Temperature without measured datapoints as PDF to your workspace",container=content_project_build_check1_sub3,checked=FALSE)
  enabled(checkbox_Temp_plot3)<-FALSE
  content_project_build_check1_sub4 <- ggroup(horizontal = TRUE ,container = content_project)
  checkbox_Temp_plot4 <<-gcheckbox(text = "Save Contourplots of Temperature Differences as PDF to your workspace",container=content_project_build_check1_sub4,checked=FALSE)
  enabled(checkbox_Temp_plot4)<-FALSE
  
  
  
  
  #Seperator Temp - Level
  content_project_survey3 <- ggroup(horizontal = TRUE ,container = content_project)
  glabel("Lake Level : ",container = content_project_survey3,fg="red")
  label_field_level <<-glabel("Please select file...",container = content_project_survey3,fg="red")
  content_project_survey4 <- ggroup(horizontal = TRUE ,container = content_project)
  button_field_level<<-gbutton("Select File" , container = content_project_survey4, handler = function(h,..){
    dir <-  tk_choose.files(default = dir_field_temp, caption = "Select lake level data file", multi = FALSE, filters = NULL, index = 1)    #statt file.choose(new=FALSE)
    #print(dir)
    if(dir!=""){
      dir_field_level <<- dir
      svalue(label_field_level)<-dir_field_level
      enabled(button_field_level_show)<<-TRUE
      enabled(checkbox_Level_plot)<<-TRUE
      enabled(checkbox_Level_rmse)<<-TRUE
      #enabled(button_field_combine_adjust)<<- TRUE
    }
  })
  enabled(button_field_level)<<-FALSE
  button_field_level_show<-gbutton("Show Data" , container = content_project_survey4, handler = function(h,..){window_input_csv_to_plot2(dir_field_level,strsplit(dir_field_level, "/")[[1]][max(length(strsplit(dir_field_level, "/")[[1]]))],workspace)})  #AENDERUNG: korrekter Funktionsaufruf
  enabled(button_field_level_show)<-FALSE
  content_project_build_check1_sub2 <- ggroup(horizontal = TRUE ,container = content_project)

  checkbox_Level_rmse <<-gcheckbox(text = "Analyze Level Differences (RMSE, MBE)",container=content_project_build_check1_sub2,checked=FALSE)
  enabled(checkbox_Level_rmse)<-FALSE
  checkbox_Level_plot <<-gcheckbox(text = "Plot Level",container=content_project_build_check1_sub2,checked=FALSE)
  enabled(checkbox_Level_plot)<-FALSE
  
  gseparator(horizontal=TRUE, container=content_project, expand=TRUE)  
  
  #### Build
  
  content_project_build <- ggroup(horizontal = TRUE ,container = content_project)
  sub_label<-glabel("5. Build Model", container = content_project_build)
  font(sub_label) <- c(size=10,weight="bold")
  content_project_build1 <- ggroup(horizontal = TRUE ,container = content_project)
  glabel("Status: ",container = content_project_build1,fg="red")
  label_status_build <<-glabel("",container = content_project_build1,fg="red")

  content_project_build2 <- ggroup(horizontal = TRUE ,container = content_project)
  button_cal_SI_value<<-gbutton("Calculate SI-Value" , container = content_project_build2, handler = function(h,..){
    window_select_SI_calculation(workspace)
    })
  button_autocalib<<-gbutton("Autocalibrate Model" , container = content_project_build2, handler = function(h,..){
    window_select_auto_kalib(workspace)
  })
  enabled(button_cal_SI_value)<-FALSE
  enabled(button_autocalib)<-FALSE
  button_build <<- gbutton("Build", container = content_project_build2,handler = function(h, ...){
    ###Start Modelling
    if(svalue(h$obj) == "Build"){
      svalue(h$obj) <- "Stop"
      build_model(workspace = workspace)
    }
    else{
      svalue(h$obj) <- "Build"
    }

    enabled(button_output)<- TRUE

  })
  enabled(button_build)<-FALSE
  button_output<<- gbutton("Output", container = content_project_build2,handler = function(h, ...){
    ###Start Modelling
    dir_output <<-paste (workspace,"/output/", sep = "")
    #print(dir_output)
    nml_file = file.path(workspace,"glm2.nml")
    eg_nml <-read_nml(nml_file)
    dir_output<-paste(dir_output,get_nml_value(eg_nml,arg_name = "csv_lake_fname"), sep = "")  #AENDERUNG: csv wird beim model build als csv mit Namen des Sees erzeugt, nicht des Projekts
    #print(get_nml_value(eg_nml,arg_name = "sim_name"))
    #print(dir_output)
    dir_output<-paste(dir_output,".csv", sep = "")
    #print(dir_output)
    if(file.exists(dir_output)){
      window_output_csv_to_plot(dir_output)
      window_plot_model_output(workspace)
    }
  })
  #button_field_combine_adjust<-gbutton("Auto Adjusting" , container = content_project_build2, handler = function(h,..){autoadjust_temp_level(workspace)})
  #enabled(button_field_combine_adjust)<- FALSE 
  enabled(button_output)<-FALSE
  glabel(text=paste("Toolbox Version: ",version), container = content_project_build2)
   
  
  #Button for reading the GLM Version of package GLMr; GLMr::glm_version() only runs run_glm(), so that the version is printed to the console, but can't be saved as char or even copied to file via sink()
  gbutton("GLM Version", container = content_project_build2, handler=function(h,...) {
    libpath = .libPaths()[1]
    glmrpath = list.files(path = libpath, pattern='RELEASE',recursive = T)[1]
    if (is.na(glmrpath)){gmessage('Cannot find the version. You can run glm_version() in the R console to find out.', title = 'GLM Version')}
    else {completepath = paste(libpath,glmrpath, sep = '/')
    glmversion = readChar(completepath, nchars = 10)
    gmessage(glmversion, title = 'GLM Version')}})
  
  gseparator(horizontal=TRUE, container=content_project, expand=TRUE) 
  #### Button Bar
  win_main_group_buttons <- ggroup(horizontal = TRUE, container = content_project)
  gbutton("Close", container = win_main_group_buttons, handler=function(h,...) {
    svalue(button_build)<- "Stop"
    dispose((h$obj)) })

  
  visible(win_main) <- TRUE
  
}
build_model <- function(workspace,...){
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
      run_glm(workspace)
      
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
    run_glm(workspace)
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
      plot(data_frame_temp_raw[,1],data_frame_temp_raw[,4],ylab = "Temperature difference [°C]", xlab = "Years",cex = 0.5, col = "blue",pch = 5)
    
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
      show_message(paste("Temperature RMSE: ",temp_rmse, " °C"))
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
check_data_connection <- function(workspace,...){
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
        #füllen der Liste für die Combobox
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
get_parameter <- function(workspace, ...) {#start function

  #get glm2.nml
  nml_file = file.path(workspace,"glm2.nml")
  #run_glm(eg_folder)
  #suppressWarnings(eg_nml <-read_nml(nml_file))
  eg_nml <-read_nml(nml_file)
  #start window
  win <- gwindow("nml - configuration file",visible = FALSE, name = "configuration file")
  main<- ggroup(horizontal = FALSE, spacing = 1, container = win, use.scrollwindow = FALSE)
  for ( i in 1:length(names(eg_nml)) ) {
    #start groups
    main_sub<- ggroup(container = main,horizontal = FALSE, spacing = 5)
    main_sub_text <- ggroup(container = main_sub,horizontal = TRUE)
    sub_label <-glabel(names(eg_nml)[i],container = main_sub_text, fg="red")
    font(sub_label) <- c(size=12,weight="bold")
    
   
    main_sub_value <- ggroup(container = main_sub,horizontal = TRUE)
    zaehler<- 1
    gsetup<- ggroup(container = main_sub_value,horizontal = TRUE)
    gcolumn<- ggroup(container = gsetup,horizontal = FALSE)
    
    for(j in 1:length(eg_nml[[i]])){
      
      #get name and value
      name <- names(eg_nml[[i]][j])
      arg <- get_nml_value(eg_nml,arg_name = name)
      print(name)
      print(length(arg))
      if(length(arg)>1){
        
        for (k in 1:length(arg)) {
          if(k==1){
            textarg<-as.character(arg[k])
            }
          else{textarg<-paste(textarg,arg[k], sep =",")}
          
        }
        
        #arg<<-paste(unlist(arg),collapse=",")
      }
      else{textarg<-as.character(arg)}
      print(textarg)
      gContainer<- ggroup(container = gcolumn,horizontal = TRUE)
      glabel(name,container = gContainer)
      txt_data_frame_name <- gedit(textarg, container = gContainer, width = nchar(textarg))
      
        
      
        #create columns
      zaehler<- zaehler +1 
      if (zaehler>2){gcolumn<- ggroup(container = gsetup,horizontal = FALSE)
        zaehler <-1
      }
    }
    if(i!=length(names(eg_nml))){gseparator(horizontal=TRUE, container=main_sub, expand=TRUE)}
  }#End groups
  visible(win) <- TRUE
  #End function
}
set_parameter <- function(workspace) {
  win_set_parameter <- gwindow("Enter a parameter", width = 50, height= 50,visible = TRUE)
  group_set_g1 <- ggroup(horizontal = FALSE,container = win_set_parameter)
  group_set_g1_g <- ggroup(horizontal = TRUE,container = group_set_g1)
  

  cb <<- gcombobox(l, selected = 0, editable=TRUE, container=group_set_g1_g,handler=function(h,...){
    nml_file = file.path(workspace,"glm2.nml")
    print(length(List_parameter))
    eg_nml <-read_nml(nml_file)
    gewaehlterwert<<- get_nml_value(eg_nml,arg_name = svalue(h$obj))
    if(length(List_parameter)!=0){
     if(List_parameter[[1]]==svalue(cb)) {
       svalue(value)<<-paste(List_parameter[[3]],";",List_parameter[[4]],";",List_parameter[[5]],sep ="")
     }
      else if(length(gewaehlterwert)>1){
        for (k in 1:length(gewaehlterwert)) {
          if(k==1){
            textarg<-gewaehlterwert[k]
          }
          else{textarg<-paste(textarg,gewaehlterwert[k], sep =",")}
          
        }
        svalue(value)<<-textarg
      }
      else{
        if(is.numeric(gewaehlterwert)){print("numeric")}
        else if ( is.character(gewaehlterwert)){print("character")}
        svalue(value)<-gewaehlterwert
        gewaehlt<<- svalue(h$obj)
      }
      
    }
    else if(length(gewaehlterwert)>1){
      for (k in 1:length(gewaehlterwert)) {
        if(k==1){
          textarg<-gewaehlterwert[k]
        }
        else{textarg<-paste(textarg,gewaehlterwert[k], sep =",")}
        
      }
      svalue(value)<<-textarg
      if(is.numeric(gewaehlterwert)){print("numeric (multiple)")} 
      else if ( is.character(gewaehlterwert)){print("character")}
      gewaehlt<<- svalue(h$obj) #ENDNEW
    }
    else{
      if(is.numeric(gewaehlterwert)){print("numeric")}
      else if ( is.character(gewaehlterwert)){print("character")}
      svalue(value)<-gewaehlterwert
      gewaehlt<<- svalue(h$obj)
    }

  })
  
  #parameter <- gedit("Parameter", container = group_set_g1_g )
  value <- gedit("...", container = group_set_g1_g)
  
  group_set_g2 <- ggroup(horizontal = FALSE,container = win_set_parameter)
  group_set_g2_g <- ggroup(horizontal = TRUE,container = group_set_g2)
  
  button_set_parameter<<-gbutton("Set", container = group_set_g2_g,handler = function(h, ...) {
    nml_file = file.path(workspace,"glm2.nml")
    if(svalue(value)!=""){
      #check for split character 
      if(grepl(";",svalue(value)) && length(List_parameter)==0){
        print("set Intervall")
        
        b<-unlist(strsplit(svalue(value),";"))
        if(length(b)==3){
          if(as.numeric(b[1])>as.numeric(b[2])){
            show_message("Start value > End value")
            
          }
          else {
            List_parameter_temp <<- list()
            nml_file = file.path(workspace,"glm2.nml")
            eg_nml <-read_nml(nml_file)
            ###1 Parameter
            ###2 Default Value
            ###3 Start Value
            ###4 End Value
            ###5 Step
            
            List_parameter_temp[[1]]<<- svalue(cb)
            List_parameter_temp[[2]]<<- get_nml_value(eg_nml,arg_name = svalue(cb))
            List_parameter_temp[[3]]<<- as.numeric(b[1])
            List_parameter_temp[[4]]<<- as.numeric(b[2])
            List_parameter_temp[[5]]<<- as.numeric(b[3])
            List_parameter <<- List_parameter_temp
 
            List_values_temp <<- list()
            dCounter <-List_parameter[[3]]
            i <- 1
            while(dCounter<=List_parameter[[4]]){
              List_values_temp[[i]] <- dCounter
              i <- i + 1
              dCounter<-dCounter + List_parameter[[5]]
            }
            List_values<<-List_values_temp
            svalue(label_nml_range)<<-paste(List_parameter[[1]]," : ",List_parameter[[3]]," - ",List_parameter[[4]]," /",List_parameter[[5]])
            remove(List_parameter_temp,List_values_temp)
          }

        }
        else{
          show_message("Wrong format")
        }
        
      }
      else if(grepl(";",svalue(value))==FALSE && length(List_parameter)!=0 && List_parameter[[1]] ==svalue(cb)){
        print("delete Intervall and set value")
        ### Delets Intervall for single value
        List_parameter <<- list()
        List_values <<- list()
        svalue(label_nml_range)<<-""

        
        if(is.numeric(gewaehlterwert)){
          gewaehlterwert <- as.numeric(svalue(value))
          print(gewaehlterwert)
          
          eg_nml <- set_nml(eg_nml,arg_name =  gewaehlt ,arg_val = gewaehlterwert)
          nml_file = file.path(workspace , "glm2.nml")
          write_nml(eg_nml, file = nml_file)
          
        }
        else if(is.character(gewaehlterwert)){
          gewaehlterwert <- as.character(svalue(value))
          print(gewaehlterwert)
          
          eg_nml <- set_nml(eg_nml,arg_name =  gewaehlt ,arg_val = gewaehlterwert)
          nml_file = file.path(workspace , "glm2.nml")
          write_nml(eg_nml, file = nml_file)
          
        }
        
      }
      else if(grepl(";",svalue(value))==TRUE && length(List_parameter)!=0 && List_parameter[[1]] ==svalue(cb)){
        b<-unlist(strsplit(svalue(value),";"))
        if(length(b)==3){
          if(as.numeric(b[1])>as.numeric(b[2])){
            show_message("Start value > End value")
            
          }
          else {
            List_parameter_temp <<- list()
            nml_file = file.path(workspace,"glm2.nml")
            eg_nml <-read_nml(nml_file)
            ###1 Parameter
            ###2 Default Value
            ###3 Start Value
            ###4 End Value
            ###5 Step
            
            List_parameter_temp[[1]]<<- svalue(cb)
            List_parameter_temp[[2]]<<- get_nml_value(eg_nml,arg_name = svalue(cb))
            List_parameter_temp[[3]]<<- as.numeric(b[1])
            List_parameter_temp[[4]]<<- as.numeric(b[2])
            List_parameter_temp[[5]]<<- as.numeric(b[3])
            List_parameter <<- List_parameter_temp
            
            List_values_temp <<- list()
            dCounter <-List_parameter[[3]]
            i <- 1
            while(dCounter<=List_parameter[[4]]){
              List_values_temp[[i]] <- dCounter
              i <- i + 1
              dCounter<-dCounter + List_parameter[[5]]
            }
            List_values<<-List_values_temp
            svalue(label_nml_range)<<-paste(List_parameter[[1]]," : ",List_parameter[[3]]," - ",List_parameter[[4]]," /",List_parameter[[5]])
            remove(List_parameter_temp,List_values_temp)
          }
          
        }
        else if(grepl(";",svalue(value))==TRUE && length(List_parameter)!=0 && List_parameter[[1]] !=svalue(cb)){
          show_message(paste("Another interval is already set : ",List_parameter[[1]]))
        }
        else{
          show_message("Wrong format")
        }
      }
      else if((grepl(";",svalue(value))==FALSE) && (grepl(",",svalue(value))==FALSE)){
        print("single value")
        
        
        
        if(is.numeric(gewaehlterwert)){
          gewaehlterwert <- as.numeric(svalue(value))
          eg_nml <-read_nml(nml_file)
          eg_nml <- set_nml(eg_nml,arg_name =  gewaehlt ,arg_val = gewaehlterwert)
          nml_file = file.path(workspace , "glm2.nml")
          write_nml(eg_nml, file = nml_file)
          check_data_connection(workspace)

        }
        else if(is.character(gewaehlterwert)){
          gewaehlterwert <- as.character(svalue(value))
          eg_nml <-read_nml(nml_file)
          eg_nml <- set_nml(eg_nml,arg_name =  gewaehlt ,arg_val = gewaehlterwert)
          nml_file = file.path(workspace , "glm2.nml")
          write_nml(eg_nml, file = nml_file)
          check_data_connection(workspace)
          
          
          
        }
        
        
      }
      
      else if(grepl(",",svalue(value))==TRUE){
        print("multiple values")
        
        if(is.numeric(gewaehlterwert)){
          gewaehlterwert <- as.numeric(strsplit(svalue(value), ',')[[1]])
          eg_nml <-read_nml(nml_file)
          eg_nml <- set_nml(eg_nml,arg_name =  gewaehlt ,arg_val = gewaehlterwert)
          nml_file = file.path(workspace , "glm2.nml")
          write_nml(eg_nml, file = nml_file)
          check_data_connection(workspace)
          
        }
     
      }

    }
  })
  
  but_hauptm_cancel <- gbutton("Close", container = group_set_g2_g, handler=function(h,...) dispose((h$obj)))
}

# Create data frame to compare observed and modelled lake levels
get_dataframe_Level_Lake<-function(workspace,dir_field_level,dir_output_model){
  
  data_level_field <- read.csv(dir_field_level, header=T)
  
  data_level <- read.csv(dir_output_model, header=T)
  
  ######
  #search for Level Name in ModelOutput -> Return extracted Level lake data and Time Data
  for (i in 1:length(names(data_level))) {
    if(length(grep("Level", names(data_level)[i]))>0){
      model_level_data<-data_level[,c(1,i)]  
    }
  }
  
  ### Define Data Frame to save Values for printing
  df_compare_height <- data.frame(Date=character(),Level_Model=double(), Level_Field=double(),Difference = double(),stringsAsFactors=FALSE) 
  
  value_date_model = character(nrow(model_level_data))
  ### Search for Values of the same Date
  for (j in 1:nrow(model_level_data)) {
    value_date_model[j] <- gsub(x=model_level_data[j,1],pattern=" 24:00:00",replacement="",fixed=T)}
    #### Search for same Date in Field Data
  
  #workaround: use the match() function to avoid nested for-loop!!
  matchingnumbers = na.omit(match(data_level_field[,1], value_date_model))
  model_level_data_n = model_level_data
  for (j in 1:nrow(model_level_data)) {model_level_data_n[j,2] = NA}
  for (k in matchingnumbers) {model_level_data_n[k,2] = model_level_data[k,2]}
  model_level_data_n = na.omit(model_level_data_n)
  
  value_date_model_n = value_date_model
  for (j in 1:length(value_date_model)) {value_date_model_n[j] = NA}
  for (k in matchingnumbers) {value_date_model_n[k] = value_date_model[k]}
  value_date_model_n = na.omit(value_date_model_n)
  
  matchingnumbers2 = na.omit(match(value_date_model, data_level_field[,1]))
  data_level_field_n = data_level_field
  for (j in 1:nrow(data_level_field)) {data_level_field_n[j,2] = NA}
  for (k in matchingnumbers2) {data_level_field_n[k,2] = data_level_field[k,2]}
  data_level_field_n = na.omit(data_level_field_n)
  
  for (j in 1:nrow(data_level_field_n)) {
  df_compare_height[j,1] = value_date_model_n[j] 
  df_compare_height[j,2] = model_level_data_n[j,2]
  df_compare_height[j,3] = data_level_field_n[j,2]
  df_compare_height[j,4] = model_level_data_n[j,2]-data_level_field_n[j,2]}
    
  
  ###Deletes Variables in RAM
  remove(j,k,i,value_date_model,data_level,data_level_field)
  
  return(df_compare_height)
}
calculate_diff_modell_field <- function(data_frame){
  vektor<- 0
  for(element in 1:nrow(data_frame)){
    diff<- data_frame[,3][element]-data_frame[,2][element]
    vektor[element]<-as.double(diff)
  }
  data_frame[["diff"]] <- vektor
  return(data_frame)
}
calculate_aov<- function(List_data_frame){
  count<-0
  for(element in 1:length(List_data_frame)){
    count[[element]]<- length(List_data_frame[[element]][,4])
    print(length(List_data_frame[[element]][,4]))
  }
  print(count)
  print(min(count))
  
  for(element in 1:length(List_data_frame)){
    if(element ==1){
      df_group <- data.frame(cbind(sample(unlist(List_data_frame[[element]][,4]), min(count), replace=FALSE)))
    }
    else{
      df_group[[element]] <- sample(unlist(List_data_frame[[element]][,4]), min(count), replace=FALSE)
    }

  }
  vecktor_group<-stack(df_group)
  remove(df_group)
  v<- aov(values ~ ind, data = vecktor_group,qr = TRUE)
  p<-summary(v)[[1]][["Pr(>F)"]][[1]]
  print(p)
  print(summary(v))
  return(p)
}

#window plot output csv: implement smoothing and trend analysis of all data
window_output_csv_to_plot <- function(directory_csv,...){
  import_csv <- read.csv(directory_csv, header=TRUE,fill = TRUE) # 1 column
  #INIT Variable 
  auswahl_plot<-2
  auswahl_glaettungskooef<-"20"
  
  window_import <- gwindow("Output Model (CSV)")
  windows_import_2views <- ggroup(container=window_import,horizontal = TRUE)
  #####left - selection
  windows_import_firstView <- ggroup(container = windows_import_2views, horizontal = FALSE)
  radio_button_value <- gradio(names(import_csv)[2:length(names(import_csv))], container=windows_import_firstView, selected=1)
  windows_import_firstView_glaettung <- ggroup(container = windows_import_firstView, horizontal = TRUE)
  glabel("Filter", container = windows_import_firstView_glaettung )
  combo_glaettung <- gcombobox(c("1","2","3","5","10","20","30","50","100"), selected = 6, editable = TRUE,  handler = function(h,...){print(svalue(h$obj));auswahl_glaettungskooef<<-svalue(h$obj);updatePlots(auswahl_plot)},  container = windows_import_firstView_glaettung)
  glabel("",container = windows_import_firstView)
  windows_import_firstView_smooth <- ggroup(container = windows_import_firstView, horizontal = TRUE)
  
  checkbox_smooth <-gcheckbox(container=windows_import_firstView_smooth,checked=TRUE, handler=function(h,...) {
    updatePlots(auswahl_plot)
  })
  sub_label <-glabel("smooth  ",container = windows_import_firstView_smooth)
  font(sub_label) <- c(color="orange")
  windows_import_firstView_trend <- ggroup(container = windows_import_firstView, horizontal = TRUE)
  checkbox_trend <-gcheckbox(container=windows_import_firstView_trend,checked=TRUE,  handler=function(h,...) {
    updatePlots(auswahl_plot)
  })
  sub_label <-glabel("trend",container = windows_import_firstView_trend)
  font(sub_label) <- c(color="green")
  ##### right - plot      EXPAND = TRUE
  windows_import_secoundView <- ggroup(container = windows_import_2views, horizontal = FALSE,expand = TRUE)
  sub_label_titel <-glabel(names(import_csv)[2],container = windows_import_secoundView)
  font(sub_label_titel) <- c(size=10,weight="bold")
  add(windows_import_secoundView, ggraphics(width=1600, height = 900)); ggmain <- dev.cur()
  
  
  addHandlerClicked(radio_button_value, handler=function(h,gg..) {
    tmp_check <- svalue(h$obj)
    svalue(sub_label_titel) <- tmp_check
    cat(sprintf("You picked %s\n",tmp_check))
    for ( i in 2:length(names(import_csv))) {
      if(names(import_csv)[i]==svalue(h$obj)){
        auswahl_plot <<-as.numeric(i)
        #print(auswahl_plot)
      }
    }
    updatePlots(auswahl_plot)
  })
  #####Update Plot
  updatePlots <- function(auswahl_plot) {
    auswahl <-import_csv[, auswahl_plot]
    zeit <-import_csv[, 1]
    dev.set(ggmain);     plot(zeit,auswahl, type = "h");  if(svalue(checkbox_smooth))  lines(lowess(auswahl ,f =1/as.numeric(auswahl_glaettungskooef)),col="orange"); if(svalue(checkbox_trend))  lines(lowess(auswahl, f=1 ),col="green");
  }
  updatePlots(auswahl_plot)
  visible(window_import) <- TRUE
  #########################
  
  
}


window_input_csv_to_plot <- function(directory_csv,filename,workspace,...){
  import_csv <- read.csv(directory_csv, header=TRUE,fill = TRUE) # 1 column
  #INIT Variable 
  auswahl_plot<-2
  #auswahl_glaettungskooef<-"20"
  list_missing_data<<- c("")
  list_repair<-c("")
  
  window_import <- gwindow(paste("Import",filename,sep=" "))
  windows_import_2views <- ggroup(container=window_import,horizontal = TRUE)
  #####left - selection
  windows_import_firstView <- ggroup(container = windows_import_2views, horizontal = FALSE)
  radio_button_value <- gradio(names(import_csv)[2:length(names(import_csv))], container=windows_import_firstView, selected=1)
  button_analyse <- gbutton("Analyze Data", container=windows_import_firstView, handler = function(h, ...) check_null(auswahl_plot))
  windows_import_firstView_glaettung <- ggroup(container = windows_import_firstView, horizontal = TRUE)
  
    
  button_repair <- gbutton("Repair", container=windows_import_firstView, handler = function(h, ...) repair_input(auswahl_plot))
    
  
  #AENDERUNG: REPAIR AS FUNCTION
  
  repair_input = function(auswahl_plot){
    auswahl <-import_csv[, auswahl_plot]
    list_repair = na.kalman(auswahl) #kalman interpolation as non-parametric method: package imputeTS
    
    updatePlots_repair(auswahl_plot, list_repair)
    print(workspace)
    print(filename)
    show_write_dialog(workspace,auswahl_plot,import_csv,list_repair,list_missing_data,filename)
  }
  
  updatePlots_repair <- function(auswahl_plot, list_repair) {
    auswahl <-import_csv[, auswahl_plot]
    zeit <-import_csv[, 1]
    #print(list)
    dev.set(ggmain);     plot(as.Date(zeit) ,auswahl, type = "h", xlab = "Year", ylab = "", ylim = c(min(na.omit(auswahl)),max(na.omit(auswahl))*1.1)) #;  if(svalue(checkbox_smooth))  lines(lowess(auswahl ,f =1/as.numeric(auswahl_glaettungskooef)),col="orange"); if(svalue(checkbox_trend))  lines(lowess(auswahl ,f =1),col="green"); #AENDERUNG Achsenbeschriftung
    if(list_missing_data[1]!=""){
      
      points(as.Date(zeit), list_repair, col = "red", pch = 15)
      points(as.Date(zeit), auswahl, col = "green", pch = 20, cex = 0.5)
      
      legend('topleft','groups',c("Measured", "Repaired"), col = c("green", "red"), pch = c(20,15), bg = "grey90")
    }
  }
    
  
  glabel("",container = windows_import_firstView)
  windows_import_firstView_smooth <- ggroup(container = windows_import_firstView, horizontal = TRUE)
  
  
  windows_import_firstView_trend <- ggroup(container = windows_import_firstView, horizontal = TRUE)
  
  windows_import_secoundView <- ggroup(container = windows_import_2views, horizontal = FALSE,expand = TRUE)
  sub_label_titel <-glabel(names(import_csv)[2],container = windows_import_secoundView)
  font(sub_label_titel) <- c(size=10,weight="bold")
  add(windows_import_secoundView, ggraphics(width=1200)); ggmain <- dev.cur()
  Sys.sleep(0.2)
  
  
  addHandlerClicked(radio_button_value, handler=function(h,gg..) {
    tmp_check <- svalue(h$obj)
    list_missing_data<<- c("")
    enabled(button_repair)<-FALSE
    svalue(sub_label_titel) <- tmp_check
    cat(sprintf("You picked %s\n",tmp_check))
    for ( i in 2:length(names(import_csv))) {
      if(names(import_csv)[i]==svalue(h$obj)){
        auswahl_plot <<-as.numeric(i)
        #print(auswahl_plot)
      }
    }
    updatePlots(auswahl_plot)
  })
  #####Update Plot
  updatePlots <- function(auswahl_plot) {
    auswahl <-import_csv[, auswahl_plot]
    zeit <-import_csv[, 1]
    #print(list)
    dev.set(ggmain);     plot(as.Date(zeit) ,auswahl, type = "h",ylab="value", xlab="Year", ylim = c(min(na.omit(auswahl)),max(na.omit(auswahl))*1.1))#;  if(svalue(checkbox_smooth))  lines(lowess(auswahl ,f =1/as.numeric(auswahl_glaettungskooef)),col="orange"); if(svalue(checkbox_trend))  lines(lowess(auswahl ,f =1),col="green");
    if(list_missing_data!=""){
      k<-1
      while(k<= length(list_missing_data)) {
        #print(k)
        points(list_missing_data[k], 0, col = "dark red")
        if(list_repair!=""){
          #print(list_repair[as.numeric(list_missing_data[k])])
          points(list_missing_data[k],list_repair[as.numeric(list_missing_data[k])],col="red")
        }
        k<-k+1
        
      }
    }
  }
  ######## Init Plot - auswahl_plot=2
  check_null <- function(auswahl_plot) {
    #CHECK NA 
    list_missing_data<<- c("")
    k<-1
    i<-1
    while(k<=length(import_csv[, auswahl_plot])) {
      #print(zahl_zeile)
      if(is.na(as.numeric(import_csv[, auswahl_plot][k]))){
        list_missing_data[[i]] <<- k
        i<-i+1
        #print("null found")
      }
      k<-k+1
    }
    if(list_missing_data==""){
      gmessage("No Null-Values")
    }
    else if(length(list_missing_data)==length(import_csv[, auswahl_plot])){
      gmessage("All Values Null")
    }
    else
    {
      gmessage(paste("Number of Null Values",length(list_missing_data)))
      enabled(button_repair)<-TRUE
      updatePlots(auswahl_plot)
      
    }
    #CHECK IF ALL VALUES EQUAL 0
    list_0_data<<- c("")
    k<-1
    i<-1
    while(k<=length(import_csv[, auswahl_plot])) {
      
      if(as.numeric(na.omit(import_csv[, auswahl_plot][k]))== 0){
        list_0_data[[i]] <<- k
        i<-i+1
        
      }
      k<-k+1
    }
    
    if(length(list_0_data)==length(import_csv[, auswahl_plot])){
      gmessage("All Values equal to 0! Please check if NA is meant instead of 0.")
    }
    
  
  }
  
  
  
  
  ###################
  
  ################
  enabled(button_repair)<-FALSE
  updatePlots(auswahl_plot)
  visible(window_import) <- TRUE
  #########################
  
  
}


###second csv input function for Field Data: no repair should be possible


window_input_csv_to_plot2 <- function(directory_csv,filename,workspace,...){
  import_csv <- read.csv(directory_csv, header=TRUE,fill = TRUE) # 1 column
  #INIT Variable 
  #AENDERUNG: in field_temp values are in column 3
  if(directory_csv == dir_field_temp){auswahl_plot=3; selectnr = 2}
  else{auswahl_plot<-2; selectnr = 1}
  
  list_missing_data<<- c("")
  list_repair<-numeric()
  
  
  check_null <- function(auswahl_plot) {
    list_missing_data<<- c("")
    k<-1
    i<-1
    while(k<=length(import_csv[, auswahl_plot])) {
      #print(zahl_zeile)
      
      #AENDERUNG: is.na fuer NA values; 0 ist die Zahl 0
      if(is.na(as.numeric(import_csv[, auswahl_plot][k]))){
        list_missing_data[[i]] <<- k
        i<-i+1
        #print("null found")
      }
      k<-k+1
    }
    if(list_missing_data[1]==""){
      gmessage("No Null-Values")
    }
    else if(length(list_missing_data)==length(import_csv[, auswahl_plot])){
      gmessage("All Values Null")
    }
    else
    {
      gmessage(paste("Number of Null Values",length(list_missing_data)))
      enabled(button_repair)<-FALSE
      updatePlots(auswahl_plot)
    }
  }
  
  
  window_import <- gwindow("Import")
  windows_import_2views <- ggroup(container=window_import,horizontal = TRUE)
  #####left - selection
  windows_import_firstView <- ggroup(container = windows_import_2views, horizontal = FALSE)
  radio_button_value <- gradio(names(import_csv)[2:length(names(import_csv))], container=windows_import_firstView, selected=selectnr)
  button_analyse <- gbutton("Analyze Data", container=windows_import_firstView, handler = function(h, ...) check_null(auswahl_plot))
  windows_import_firstView_glaettung <- ggroup(container = windows_import_firstView, horizontal = TRUE)
  
  if(directory_csv == dir_field_temp){
    button_repair <- gbutton("Repair", container=windows_import_firstView, handler = function(h, ...) show_message('You cannot repair field data' ))
  }
  
  if(directory_csv == dir_field_level){
    button_repair <- gbutton("Repair", container=windows_import_firstView, handler = function(h, ...) show_message('You cannot repair field data' ) )
    
  }
  
    print(workspace)
    print(filename)
    #show_write_dialog(workspace,auswahl_plot,import_csv,list_repair,list_missing_data,filename)
  
  glabel("",container = windows_import_firstView)
  
  
  ##### right - plot      EXPAND = TRUE
  windows_import_secoundView <- ggroup(container = windows_import_2views, horizontal = FALSE,expand = TRUE)
  sub_label_titel <-glabel(names(import_csv)[2],container = windows_import_secoundView)
  font(sub_label_titel) <- c(size=10,weight="bold")
  add(windows_import_secoundView, ggraphics(width=800, height = 450)); ggmain <- dev.cur()
  Sys.sleep(0.2)
  
  
  addHandlerClicked(radio_button_value, handler=function(h,gg..) {
    tmp_check <- svalue(h$obj)
    list_missing_data<<- c("")
    enabled(button_repair)<-FALSE
    svalue(sub_label_titel) <- tmp_check
    cat(sprintf("You picked %s\n",tmp_check))
    for ( i in 2:length(names(import_csv))) {
      if(names(import_csv)[i]==svalue(h$obj)){
        auswahl_plot <<-as.numeric(i)
        #print(auswahl_plot)
      }
    }
    updatePlots(auswahl_plot)
  })
  #####Update Plot
  updatePlots <- function(auswahl_plot) {
    auswahl <-import_csv[, auswahl_plot]
    zeit <-import_csv[, 1]
    #print(list)
    dev.set(ggmain);     plot(as.Date(zeit) ,auswahl, type = "h", xlab = "Year", ylab = "", ylim = c(min(na.omit(auswahl)),max(na.omit(auswahl))*1.1)) 
  }
  
  ################
  enabled(button_repair)<-FALSE #No repair should be possible for field data
  updatePlots(auswahl_plot)
  visible(window_import) <- TRUE
  #########################
}


window_plot_multi_histo <- function(title,list_data_frame){
  for(element in 1:length(list_data_frame)){
    if(element ==1 || element  == 21 || element ==41|| element ==61|| element ==81 || element ==101|| element ==121|| element ==141|| element ==161 || element ==181){
      #Minimum Displaysize EVGA
      window_histo <- gwindow(title = title,width = 1024, height = 768)
      gg_histo<-ggraphics(container = window_histo)
      ###Wait 0.5sek for ggraphic to be build
      par(mfrow=c(5,4))
      Sys.sleep(1)
    }
    else if (element >200){
      break
    }
    data_frame <- list_data_frame[[element]]
    if(length(data_frame[,4])>5000){
      wert<- shapiro.test(sample(data_frame[,4], 1000, replace=FALSE))
    }
    else{
      wert<- shapiro.test(data_frame[,4])
    }
    if(wert$p.value>=0.05){
      norm<- "normal distribution"
    }
    else{
      norm<- "no normal distribution"
    }
    hist(data_frame[,4],main = norm , xlab = List_values[[element]])
  }
  
}
window_plot_RMSE <- function(title , List_data_frame){
  #Minimum Displaysize EVGA
  window_plot_RMSE <- gwindow(title = title,width = 1024, height = 768,visible= FALSE)
  ggmain<-ggraphics(container = window_plot_RMSE)
  visible(window_plot_RMSE)<-TRUE
  ###Wait 0.5sek for ggraphic to be build
  Sys.sleep(1)
  vektor <- 0
  for(element in 1:length(List_data_frame)){
    vektor[[element]] <- calculate_RMSE( List_data_frame[[element]] ) 
  }
  print(vektor)
  print(unlist(List_values))
  p_varianzanalyse <- calculate_aov(List_data_frame)
  if(p_varianzanalyse>0.05){
    p_varianzanalyse<-"No significant Difference"
  }
  else{
    p_varianzanalyse<-"Significant Difference"
  }
  main_text <-paste (List_parameter[[1]]," Minimum: ", List_values[match(min(vektor),vektor)], "\n ", p_varianzanalyse)
  plot(unlist(List_values),vektor, main = main_text )
  lines(unlist(List_values),vektor,col="red")
  for(element in 1:length(List_values)){
    data_frame <- List_data_frame[[element]]
    if(length(data_frame[,4])>5000){
      wert<- shapiro.test(sample(data_frame[,4], 1000, replace=FALSE))
    }
    else{
      wert<- shapiro.test(data_frame[,4])
    }
    if(wert$p.value>=0.05){
      points(unlist(List_values)[element],vektor[[element]],col="green")
    }
    else{
      points(unlist(List_values)[element],vektor[[element]],col="red")
      
    }
  }
}
window_plot_dataframe_Level_Lake <- function(data_frame,workspace){
  #Minimum Displaysize EVGA
  window_import <- gwindow(title = names(data_frame)[2] ,width = 1024, height = 768)
  ggmain<-ggraphics(container = window_import)
  dir_output <<-paste (workspace,"/output", sep = "")
  nml_file <- file.path(workspace, 'glm2.nml')
  eg_nml <-read_nml(nml_file)
  dir_output_model<- paste(dir_output,"/",get_nml_value(eg_nml,arg_name = "csv_lake_fname"),".csv",sep = "")
  
  ###Wait 0.5sek for ggraphic to be build
  Sys.sleep(0.5)
  
  data_h <- read.csv(dir_output_model)
  
  plot (as.Date(data_h[,1]),data_h[,12], type = "l", col="red", xlab ="Date", ylab = "Level [m]")
  
  lines(as.Date(data_frame[,1]),data_frame[,3],col="blue" )
  legend("topright", legend = c("Field", "Model"),col = c(4, 2),text.width = strwidth("1,000,000"),lty = 1:2, xjust = 1, yjust = 1) 
  
}
window_plot_list_graph <- function(title,list_data_frame,List_values, List_parameter){
  window_import2 <- gwindow(title = title ,width = 1024, height = 768,visible = FALSE)
  ggmain<-ggraphics(container = window_import2)
  visible(window_import2)<-TRUE
  par(mfrow=n2mfrow(length(list_data_frame)))
  
  ###Wait 0.5sek for ggraphic to be build
  Sys.sleep(1)
  #Minimum Displaysize EVGA
  for(element in 1:length(list_data_frame)){
    data_frame<- list_data_frame[[element]]
    plot(data_frame[,1],data_frame[,2], main = paste(List_parameter[[1]], List_values[[element]]))
    points(data_frame[,1],data_frame[,2],type = "p")
    points(data_frame[,1],data_frame[,3],type = "p")
    lines(data_frame[,1],data_frame[,3],col="red")
    lines(data_frame[,1],data_frame[,2],col="blue")
  }
}

###TEST###
window_plot_list_temp <- function(title,list_data_frame){
  window_import2 <- gwindow(title = title ,width = 1024, height = 768,visible = FALSE)
  ggmain<-ggraphics(container = window_import2)
  visible(window_import2)<-TRUE
  par(mfrow=n2mfrow(length(list_data_frame)))
  
  ###Wait 0.5sek for ggraphic to be build
  Sys.sleep(1)
  #Minimum Displaysize EVGA
  for(element in 1:length(list_data_frame)){
    data_frame<- list_data_frame[[element]]
    plot(data_frame[,1],data_frame[,2], main = title)
    points(data_frame[,1],data_frame[,2],type = "p")
    points(data_frame[,1],data_frame[,3],type = "p")
    lines(data_frame[,1],data_frame[,3],col="red")
    lines(data_frame[,1],data_frame[,2],col="blue")
  }
}


#plot model output (netcdf file)

window_plot_model_output <- function(workspace){
  
  nc_file <- file.path(workspace,".//output//output.nc")
  auswahl_plot<- sim_vars(nc_file)[,1][1]
  window_import <- gwindow("Output Model (netCDF)")
  windows_import_2views <- ggroup(container=window_import,horizontal = TRUE)
  #####left - selection
  windows_import_firstView <- ggroup(container = windows_import_2views, horizontal = FALSE)
  radio_button_value <- gradio(sim_vars(nc_file)[,1], container=windows_import_firstView, selected=1)
  ##### right - plot      EXPAND = TRUE
  windows_import_secoundView <- ggroup(container = windows_import_2views, horizontal = FALSE,expand = TRUE)
  sub_label_titel <-glabel("wert",container = windows_import_secoundView)
  font(sub_label_titel) <- c(size=10,weight="bold")
  add(windows_import_secoundView, ggraphics(width=1200)); ggmain <- dev.cur()
  
  
  addHandlerClicked(radio_button_value, handler=function(h,gg..) {
    tmp_check <- svalue(h$obj)
    print(tmp_check)
    svalue(sub_label_titel)<- tmp_check
    auswahl_plot<<-tmp_check
    updatePlots(auswahl_plot)
  })
  #####Update Plot
  updatePlots <- function(auswahl_plot) {
    
    dev.set(ggmain);     plot_var(file = nc_file,var_name = auswahl_plot);
  }
  updatePlots(auswahl_plot)
  visible(window_import) <- TRUE
  #########################
  
  
  
  
}

#AENDERUNG: showing the plot via plot() sometimes crashes the system: workaround: saving as pdf in workspace
window_plot_temp_compare<-function(title,workspace, nc_file, dir_field_temp, datapoints){
  w <- gwindow(title = title, visible=FALSE)
  gg <- ggraphics(container=w)
  ggmain <- dev.cur()
  Sys.sleep(0.2)
  setwd(workspace)
  
  
  ## DIFFERENCE PLOT##
  start_par = par(no.readonly = TRUE)
  mod_temp = get_var(nc_file, 'temp', reference='surface')
  mod_depths = get.offsets(mod_temp) #function from package rLakeAnalyzer
  
  tempdata = resample_to_field(nc_file, dir_field_temp, var_name='temp')
  model_df <- resample_sim(mod_temp, t_out = unique(as.POSIXct(as.numeric(tempdata$DateTime), origin='1970-01-01'   )))
  
  #Pivot observed into table
  x = as.numeric(as.POSIXct(tempdata$DateTime))
  y = tempdata$Depth
  z = tempdata[,paste0('Observed_', 'temp')]
  z2 = tempdata[,paste0('Modeled_', 'temp')]
  x_out = sort(unique(x))
  y_out = sort(unique(c(y, mod_depths)))
  
  #remove any NA values before the 2D interp
  x = x[!is.na(z) & !is.na(z2)]
  y = y[!is.na(z) & !is.na(z2)]
  copyz = z
  z = z[!is.na(z) & !is.na(z2)]
  z2 = z2[!is.na(copyz)& !is.na(z2)]
  
  
  #Added a scaling factor to Y. Interp won't interpolate if X and Y are on vastly different scales.
  # I don't use Y from here later, so it doesn't matter what the mangitude of the values is.
  interped = interp(x, y*1e6, z, x_out, y_out*1e6)
  interped2 = interp(x, y*1e6, z2, x_out, y_out*1e6)
  
  gen_default_fig <- function(filename=FALSE, width = 4, height, ps = 11, res = 200, units = "in",
                              mai = c(0.2,0,0.05,0),
                              omi = c(0.1, 0.5, 0, 0), 
                              mgp = c(1.4,.3,0),
                              num_divs = 1, ...){
    
    if ((is.character(filename))){
      valid_fig_path(filename)
      if (missing(height)){
        height = 2*num_divs
      }
      png(filename, width = width, height = height, units = units, res = res)
    }
    par(mai = mai,omi = omi, ps = ps, mgp = mgp, ...)
  }
  
  .stacked_layout <- function(is_heatmap, num_divs){
    if(num_divs == 1 & !is_heatmap) return()
    
    if(is_heatmap){
      colbar_layout(num_divs)
    } else {
      .simple_layout(num_divs)
    }
    
  }
  
  
  
  colbar_layout <- function(nrow = 2){
    # ensures all colorbar plots use same x scaling for divs
    mx <- matrix(c(rep(1,5),2),nrow=1)
    panels <- mx
    if (nrow > 1){
      for (i in 2:nrow){
        panels <- rbind(panels,mx+(i-1)*2)
      }
    }
    
    layout(panels)
    
  }
  
  # Functions from glmtools, which aren't found. So copy & paste
  
  get_xaxis <- function(dates){
    
    
    start_time = min(dates) #earliest date
    end_time = max(dates) #latest date
    
    vis_time = c(start_time-86400, pretty(dates), end_time+86400) # pretty vector to specify tick mark location 
    sec.end_time = as.numeric(end_time) # show time as seconds
    sec.start_time = as.numeric(start_time) # show time as seconds
    tt = sec.end_time - sec.start_time # time range of data frame; used to specify time axis
    
    # specify x axis format based upon time range of data 
    time_form = c()
    if(tt < 1.1*60) { # if time is less than 1 hr units are seconds
      time_form <- "%S"
    } else if (tt < 1.1*60*60) { # if time is less than 1.1 hours units are min:sec
      time_form <- "%M:%S"
    } else if (tt < 60*60*24*2) {# if time is less than 2 days units are hour:min
      time_form <- "%H:%M"
    } else if (tt < 60*60*24*7*8.9) {# if time is less than 2 months units are ex. Jul 25 10:15
      time_form <- "%d %b %H:%M"
    } else {    
      time_form <- "%b %Y"
    }
    
    # specify x axis labels based upon time range of data 
    x_lab = c()
    if(tt < 1.1*60) { # if time is less than 1 minutes units are seconds
      x_lab  <- "Seconds"
    } else if (tt < 1.1*60*60) { # if time is less than 1.1 hours units are min:sec
      x_lab <- "Minutes"
    } else if (tt < 60*60*24*2) {# if time is less than 2 days units are hour:min
      x_lab <- "Hours"
    } else if (tt < 60*60*24*7) { # if time is less than 7 days units are Jul 25 10:15
      x_lab <- " "
    } else if (tt < 60*60*24*7*8.9) {# if time is less than 2 months units are ex. Jul 25 
      x_lab <- " "
    } else if (tt < 60*60*24*7*4.4*12) { # if time is less than 12 months units are Jun, Jul, Aug  
      x_lab <- " "
    } else if (tt < 60*60*24*7*4.4*12*1.1){ # if time is more than 12.1 years units are Jul 2013
      x_lab <- " "
    }
    
    return(list('time_form' = time_form, 'x_lab' = x_lab, 'lim' = c(start_time, end_time), 'vis_time' = vis_time))
  }
  
  #function to create contourplot
  .plot_df_heatmap <- function(data, bar_title, num_cells, palette, title_prefix=NULL, overlays=NULL, xaxis=NULL, col_lim, col_subs, levels, colorspal){
    
    z_out <- rLakeAnalyzer::get.offsets(data)
    reference = ifelse(substr(names(data)[2],1,3) == 'elv', 'bottom', 'surface')
    
    if (missing(col_lim))
      col_lim = range(data[, -1], na.rm = TRUE)
    if (missing(palette))
      palette <- colorRampPalette(c("violet","blue","cyan", "green3", "yellow", "orange", "red"), 
                                  bias = 1, space = "rgb")
    if (missing(col_subs))
      col_subs <- head(pretty(col_lim, 12), -1) #von 6 auf 12
    if (missing(levels))
      levels <- sort(unique(c(col_subs, pretty(col_lim, 15))))
    if (missing(colorspal))
      colorspal <- palette(n = length(levels)-1)
    dates <- data[, 1]
    matrix_var <- data.matrix(data[, -1])
    if(is.null(xaxis)){
      xaxis <- get_xaxis(dates)
    }
    
    yaxis <- get_yaxis_2D(z_out, reference, prefix=title_prefix)
    plot_layout(xaxis, yaxis, add=TRUE)
    .filled.contour(x = dates, y = z_out, z =matrix_var,
                    levels= levels,
                    col=colorspal)
    overlays # will plot any overlay functions
    axis_layout(xaxis, yaxis) #doing this after heatmap so the axis are on top
    
    color_key(levels, colorspal, subs=col_subs, col_label = bar_title)
  }
  
  #function to create contourplot for the differences of modeled and observed temperatures
  .plot_df_heatmap_diff <- function(data, bar_title, num_cells, palette, title_prefix=NULL, overlays=NULL, xaxis=NULL){
    
    z_out <- rLakeAnalyzer::get.offsets(data)
    reference = ifelse(substr(names(data)[2],1,3) == 'elv', 'bottom', 'surface')
    
    #fake range -40 to +40
    col_lim = range(-40, 40)
    palette <- colorRampPalette(c("blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue","deepskyblue", "lightblue1", "lightcyan","white", "lightpink","lightcoral","indianred","firebrick","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red"))
    col_subs <- head(pretty(col_lim, 12), -1) 
    levels <- sort(unique(c(col_subs, pretty(col_lim, 80))))
    colorspal <- palette(n = length(levels)-1)
    dates <- data[, 1]
    matrix_var <- data.matrix(data[, -1])
    if(is.null(xaxis)){
      xaxis <- get_xaxis(dates)
    }
    
    yaxis <- get_yaxis_2D(z_out, reference, prefix=title_prefix)
    plot_layout(xaxis, yaxis, add=TRUE)
    .filled.contour(x = dates, y = z_out, z =matrix_var,
                    levels= levels,
                    col=colorspal)
    overlays # will plot any overlay functions
    axis_layout(xaxis, yaxis) #doing this after heatmap so the axis are on top
    
    #fake for colorkey:
    col_lim = range(-5,6)
    col_subs <- head(pretty(col_lim, 12), -1)
    levels <- sort(unique(c(col_subs, pretty(col_lim, 15))))
    palette <- colorRampPalette(c("blue4","blue","deepskyblue", "lightblue1", "lightcyan","white", "lightpink","lightcoral","indianred","firebrick","red"))
    colorspal <- palette(n = length(levels)-1)
    color_key_diff(levels, colorspal, subs=col_subs, col_label = bar_title)
  }
  
  
  
  
  get_yaxis_2D <- function(z_out, reference, prefix=NULL, suffix=NULL){
    
    if (length(z_out) < 2){stop('z_out must be larger than 1 for heatmap plots')}
    
    if (reference == 'surface'){
      lim <- c(max(z_out), 0)
      title <- paste(prefix,' Depth (m) ',suffix, sep='')
    } else {
      lim <- c(0, max(z_out))
      title <- paste(prefix,' Elevation (m) ',suffix, sep='')
    }
    
    yaxis <- get_yaxis(data = z_out, title = title, lim = lim)
    return(yaxis) 
  }
  
  get_yaxis <- function(data, title, lim = NULL){
    if (is.null(lim)){
      mn <- min(data, na.rm = TRUE)
      mx <- max(data, na.rm = TRUE)
      axBuff <- diff(c(mn, mx))*0.1
      lim <- c(mn-axBuff, mx+axBuff)
    }
    
    ticks <- pretty(data)
    yaxis <- list('lim'=lim, 'ticks'=ticks, 'title' = title)
    return(yaxis) 
  }
  
  
  plot_layout <- function(xaxis=NULL, yaxis=NULL, add, data = NA){
    
    if (!add){
      panels <- colbar_layout()
    }
    
    
    plot(data, xlim = xaxis$lim,
         ylim=yaxis$lim,
         xlab=xaxis$x_lab, ylab=' ',
         frame=FALSE,axes=FALSE,xaxs="i",yaxs="i")
    
    
  }
  
  axis_layout <- function(xaxis, yaxis){
    # x axis
    axis(side = 1, labels=format(xaxis$vis_time, xaxis$time_form), at = xaxis$vis_time, tck = -0.01, pos = yaxis$lim[1])
    axis(side = 3, labels=NA, at = xaxis$lim, tck = 0)
    axis(side = 2, at = yaxis$ticks, tck = -0.01, pos = xaxis$lim[1])
    ol_par <- par()$mgp
    par(mgp=c(0,1.5,0))
    axis(side = 2, at = mean(yaxis$lim), tck = 0,  labels=yaxis$title)
    par(mgp=ol_par)
    axis(side = 4, labels=NA, at = yaxis$lim, tck = 0)
  }
  
  color_key <- function(levels, colors, subs, cex = 0.75, col_label){
    # add feau plot
    plot(NA, xlim = c(0,1),
         ylim=c(0,1),
         xlab="", ylab="",
         frame=FALSE,axes=FALSE,xaxs="i",yaxs="i")
    old_mgp <- par()$mgp
    old_mai <- par()$mai
    par(mai=c(old_mai[1],0, old_mai[3], 0), mgp = c(-1,-1,0))
    axis(side = 4, at = 0.5, tck = NA, labels= col_label, lwd = 0.0)#(\xB0 C)
    spc_pol_rat <- 0.2 # ratio between spaces and bars
    
    p_start <- 0.1
    p_wid <- 0.55
    
    # plotting to a 1 x 1 space
    if (!all(subs %in% levels)) stop('selected values must be included in levels')
    
    
    num_poly <- length(subs)
    num_spc <- num_poly - 1
    total_height <- num_poly + spc_pol_rat * num_spc
    
    poly_h <- 1/total_height
    spc_h <- spc_pol_rat * poly_h
    
    for (i in 1:num_poly){
      col <- colors[levels==subs[i]]
      b <- (i-1)*(poly_h+spc_h)
      t <- b+poly_h
      m <- mean(c(b,t))
      polygon(c(p_start,p_wid,p_wid,p_start),c(b,b,t,t),col = col, border = NA)
      text(p_wid+0.025,m,as.character(subs[i]), cex = cex, adj = c(0.5, 1), srt = 90)
    }
    par(mai = old_mai, mgp = old_mgp)
  }
  
  color_key_diff <- function(levels, colors, subs, cex = 0.75, col_label){
    # add feau plot
    plot(NA, xlim = c(0,1),
         ylim=c(0,1),
         xlab="", ylab="",
         frame=FALSE,axes=FALSE,xaxs="i",yaxs="i")
    old_mgp <- par()$mgp
    old_mai <- par()$mai
    par(mai=c(old_mai[1],0, old_mai[3], 0), mgp = c(-1,-1,0))
    axis(side = 4, at = 0.5, tck = NA, labels= col_label, lwd = 0.0)#(\xB0 C)
    spc_pol_rat <- 0.2 # ratio between spaces and bars
    
    p_start <- 0.1
    p_wid <- 0.55
    
    # plotting to a 1 x 1 space
    if (!all(subs %in% levels)) stop('selected values must be included in levels')
    
    
    num_poly <- length(subs)
    num_spc <- num_poly - 1
    total_height <- num_poly + spc_pol_rat * num_spc
    
    poly_h <- 1/total_height
    spc_h <- spc_pol_rat * poly_h
    
    for (i in 1:num_poly){
      col <- colors[levels==subs[i]]
      b <- (i-1)*(poly_h+spc_h)
      t <- b+poly_h
      m <- mean(c(b,t))
      polygon(c(p_start,p_wid,p_wid,p_start),c(b,b,t,t),col = col, border = NA)
      if (i==1)
        text(p_wid+0.025,m,paste0("<= ",as.character(subs[i])), cex = cex, adj = c(0.5, 1), srt = 90)
      else if (i==num_poly)
        text(p_wid+0.025,m,paste0(">= ",as.character(subs[i])), cex = cex, adj = c(0.5, 1), srt = 90)
      else
        text(p_wid+0.025,m,as.character(subs[i]), cex = cex, adj = c(0.5, 1), srt = 90)
    }
    par(mai = old_mai, mgp = old_mgp)
  }
  
  #RMSE
  
  rmse_frame <- compare_to_field(nc_file, dir_field_temp,metric = 'water.temperature', as_value = TRUE) 
  rmse_frame <- calculate_diff_modell_field(data_frame = rmse_frame)
  rmse<- calculate_RMSE(rmse_frame)
  
  #modify par()
  gen_default_fig(filename=FALSE, num_divs=2)
  #.stacked_layout(TRUE, num_divs=1) #only 1 contourplot per page
  colbar_layout(2)
  obs_df <- data.frame(interped$z)
  mod_df <- data.frame(interped2$z)
  difff = interped2$z-interped$z
  diff_df = data.frame(difff) #modeled - obs
  
  names(diff_df) <- paste('diff_', y_out, sep='')
  diff_df <- cbind(data.frame(DateTime=as.POSIXct(x_out, origin='1970-01-01')), diff_df)
  
  names(obs_df) <- paste('var_', y_out, sep='')
  obs_df <- cbind(data.frame(DateTime=as.POSIXct(x_out, origin='1970-01-01')), obs_df)
  
  xaxis <- get_xaxis(model_df[,1])
  y.text = y_out[length(y_out)]-diff(range(y_out))*0.1
  # for Label Position in the upper left corner of the plot
  # y.text = y_out[1]+diff(range(y_out))*0.05
  
  col_lim = range(difff, na.rm = TRUE)
  
  #for contourplot with modeled AND observed data
  xaxis2 <- get_xaxis(model_df[,1])
  col_lim2 = range(range(interped$z, na.rm = TRUE), range(interped2$z, na.rm = TRUE))
 
  if(datapoints==4){
  #pdf('diff_contourplot.pdf')  #doesn't work properly as the legend will be on a new page
  .plot_df_heatmap_diff(diff_df, bar_title = paste('Temperature Difference (°C): Modeled - Observed RMSE_Temp =', round(rmse, 2), '°C'), xaxis=xaxis)
  
  dev.copy(pdf,"difference_contourplot.pdf") # copies the "screen" to PDF
  dev.off()
  #reset par()
  par(start_par)}
  
  
  
  ###PLOT WITH BOTH DATA: MODELED AND OBSERVED WITH DATAPOINTS
  
  if(datapoints==2){
  gen_default_fig(filename=FALSE, num_divs=2)#, omi = c(0.1, 0.5, 0, 0))
  .stacked_layout(T, num_divs=2)

  .plot_df_heatmap(obs_df, bar_title = 'Temperature (°C): Observed', overlays=c(points(x=x,y=y, pch = 19, cex = 0.2),text(x_out[1],y=y.text,'observed', pos=4, offset = 1, col = "white", font = 2)), xaxis=xaxis2, col_lim=col_lim2)
  .plot_df_heatmap(model_df, bar_title = paste('Temperature (°C): Modeled RMSE_Temp =', round(rmse, 2), '°C'), overlays=text(x_out[1],y=y.text,'modeled', pos=4, offset = 1, col = "white", font = 2), xaxis=xaxis2, col_lim=col_lim2)
  dev.copy(pdf,"contourplot_with_datapoints.pdf") # copies the "screen" to PDF
  dev.off()
  #reset par()
  par(start_par)}
  
  
  ###PLOT WITH BOTH DATA: MODELED AND OBSERVED WITHOUT DATAPOINTS
  
  if(datapoints==3){
    gen_default_fig(filename=FALSE, num_divs=2)#, omi = c(0.1, 0.5, 0, 0))
    .stacked_layout(T, num_divs=2)
    
    .plot_df_heatmap(obs_df, bar_title = 'Temperature (°C): Observed', overlays=text(x_out[1],y=y.text,'observed', pos=4, offset = 1, col = "white", font = 2), xaxis=xaxis2, col_lim=col_lim2)
    .plot_df_heatmap(model_df, bar_title = paste('Temperature (°C): Modeled RMSE_Temp =', round(rmse, 2), '°C'), overlays=text(x_out[1],y=y.text,'modeled', pos=4, offset = 1, col = "white", font = 2), xaxis=xaxis2, col_lim=col_lim2)
    dev.copy(pdf,"contourplot_without_datapoints.pdf") # copies the "screen" to PDF
    dev.off()
    #reset par()
    par(start_par)}
 
  
}


#calculate Quality Management 
calculate_RMSE <- function(data_frame){
  square_sum<-0
  for (i in 1:nrow(data_frame)) {     square_sum<-data_frame[i,4]*data_frame[i,4]+square_sum  }
  RMSE<-sqrt(square_sum/i)
  return(RMSE)
}

#SI Value
window_select_SI_calculation <- function(workspace){
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
calculate_SI_value <- function(List_parameter, int_Prozent,int_guete_verfahren,int_field_data,workspace,label_status_SI_calculation,but_cal_si){
  #initial run to create output directory
  run_glm(workspace)
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
    run_glm(workspace)
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
    run_glm(workspace)
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
    run_glm(workspace)
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

calculate_rel_SI_LL <- function(LL_plus,LL_minus,LL_null,int_Prozent,value){
  rel_norm_SI <- 0
  for (j in 1:length(LL_null)) { 
    rel_norm_SI[j] <- ((LL_plus[j] - LL_minus[j])/LL_null[j])/(2*int_Prozent/100/value)
  }
  return (mean(rel_norm_SI))
}

calculate_rel_SI_WT <- function(WT_plus,WT_minus,WT_null,int_Prozent,value){
  rel_norm_SI <- 0
  for (j in 1:length(WT_null)) { 
    rel_norm_SI[j] <- ((WT_plus[j] - WT_minus[j])/WT_null[j])/(2*int_Prozent/100/value)
  }
  return (mean(rel_norm_SI, na.rm=TRUE))
}

calculate_rel_SI_RMSE <- function(Q_plus,Q_minus,Q_null){
  rel_norm_SI <- 0
  rel_norm_SI <- abs(Q_plus - Q_minus)/Q_null
  return (rel_norm_SI)
}

###Autoadjust Model


### INFLOW AND OUTFLOW, RAIN ARE MEASURED. Therefore default calibration range is set to +/- 10% for flows and 20% for rain.
### SEEPAGE must be handled isolated as it isnt changable in glm2.2 on default
### OTHER PARAMETERS: Default calibration range set on +/- 50% of default value.

boundary.env=new.env() #new environment for the calibration range boundaries: vec_boundaries
assign("vec_boundary",c(50,50,50,50,50,50,50,50,50,50,50,10,10,20,50), env=boundary.env) #default vector of calibration range

window_select_auto_kalib <- function(workspace){
  
  win_SI_auto <- gwindow("Autocalibrate Lake Model", width = 400, visible = FALSE)
  win_SI_1 <- ggroup(horizontal = FALSE ,container = win_SI_auto)
  
  sub_label <-glabel("1. Select Parameter (based on SI-Values)",container = win_SI_1)
  font(sub_label) <- c(size=10,weight="bold")
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
  font(sub_label) <- c(size=10,weight="bold")
  
  radio_button_field_auto <- gradio(c("Temperature","Lake Level"), container=win_SI_1,horizontal =TRUE, selected=2)
  gseparator(horizontal=TRUE, container=win_SI_1, expand=TRUE) 

  sub_label <-glabel("3. Select Interval Density",container = win_SI_1)
  font(sub_label) <- c(size=10,weight="bold")
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


calculate_auto_kalib <- function(workspace,List_parameter,vec_boundary, int_field_data,int_intervall, label_status_CAL_calculation){ 
  #initial run to create output directory
  run_glm(workspace)
  svalue(label_status_CAL_calculation) <-"building..."
  dir_output <<-paste (workspace,"/output/", sep = "")
  nml_file <- file.path(workspace, 'glm2.nml')
  nc_file <- file.path(dir_output, 'output.nc')
  ### Save Default Parameter
  eg_nml_old <-read_nml(nml_file)
  eg_nml <-read_nml(nml_file)
  
  
  
  dir_output_model<- paste(dir_output,"/",get_nml_value(eg_nml,arg_name = "csv_lake_fname"),".csv",sep = "")
  start_time<-Sys.time()
  
  vektor <- 0
  
  matrix <- get_pre_list_of_default_values(List_parameter,but_cal_si_auto,int_intervall,vec_boundary)
  
  
  print("Number of combinations:")
  print(nrow(matrix))
  print(ncol(matrix))
  
  #get number of parameters: inflow and outflow factors can have more than 1 parameter depending on the number of inflows/outflows
  number_of_parameters = length(List_parameter)
  if('inflow_factor' %in% List_parameter){number_of_parameters = number_of_parameters -1 + length(get_nml_value(eg_nml ,'inflow_factor'))}
  if('outflow_factor' %in% List_parameter){number_of_parameters = number_of_parameters -1 + length(get_nml_value(eg_nml ,'outflow_factor'))}
  
  num_inflow = length(get_nml_value(eg_nml ,'inflow_factor'))
  num_outflow = length(get_nml_value(eg_nml ,'outflow_factor'))
  
  
  #modify list_parameter and append as many in/outflow_factors as needed
  if('inflow_factor' %in% List_parameter && num_inflow > 1){
    index = 0
    index = match('inflow_factor', List_parameter) - 1
    for (i in 2:num_inflow){List_parameter = append(List_parameter, 'inflow_factor', index)}
  }
  
  if('outflow_factor' %in% List_parameter && num_outflow > 1){
    index = 0
    index = match('outflow_factor', List_parameter) - 1
    for (i in 2:num_outflow){List_parameter = append(List_parameter, 'outflow_factor', index)}
  }
  
  if(ncol(matrix)==length(List_parameter)){
    print("Starting conditions met.")
    start_time = Sys.time()
    for(i in 1:nrow(matrix)){
      for(j in 1:length(List_parameter)){
        print(paste(List_parameter[j]))
        print(matrix[i,j])
        
        arg_val_infl = numeric(0)  #length of 0
        arg_val_outfl = numeric(0)  #length of 0
        if(num_inflow < 2 && num_outflow < 2){
          eg_nml <- set_nml(eg_nml,arg_name =  paste(List_parameter[j]) ,arg_val =  as.numeric(matrix[,j][i])) }
        
        else{
          if('inflow_factor' %in% List_parameter && num_inflow > 1){arg_val_infl = as.numeric(matrix[i, min(which(List_parameter %in% 'inflow_factor')):max(which(List_parameter %in% 'inflow_factor'))]) 
          eg_nml <- set_nml(eg_nml,arg_name =  'inflow_factor' ,arg_val =  arg_val_infl)}
          if('outflow_factor' %in% List_parameter && num_outflow > 1){arg_val_outfl = as.numeric(matrix[i, min(which(List_parameter %in% 'outflow_factor')):max(which(List_parameter %in% 'outflow_factor'))]) 
          eg_nml <- set_nml(eg_nml,arg_name =  'outflow_factor' ,arg_val =  arg_val_outfl)}
          j=j+length(arg_val_infl)+length(arg_val_outfl)
          if(j<=length(List_parameter)){
            eg_nml <- set_nml(eg_nml,arg_name =  paste(List_parameter[j]) ,arg_val =  as.numeric(matrix[,j][i])) }
        }
        calculate_needed_time2(i,label_status_CAL_calculation,start_time,nrow(matrix))
      }
      write_nml(eg_nml, file = nml_file)
      #Wait until writing process stopped
      Sys.sleep(1)
      #Run model building
      
      run_glm(workspace)
      nc_file <- file.path(dir_output, 'output.nc')
      
      if(int_field_data=="Temperature"){
        print("calculating temperature differences")
        data_frame <- compare_to_field(nc_file, dir_field_temp,metric = 'water.temperature', as_value = TRUE) 
        data_frame <- calculate_diff_modell_field(data_frame = data_frame)
        vektor [i]   <-  calculate_RMSE(data_frame)
      }
      else if(int_field_data=="Lake Level"){
        print("calculating lake level differences")
        data_frame <- get_dataframe_Level_Lake(workspace,dir_field_level,dir_output_model)
        vektor [i]   <-  calculate_RMSE(data_frame)
      }
      
    }
    
    df_frame <- data.frame(matrix,vektor)
    
    if (int_field_data=="Temperature") {
      write.table(x = df_frame,file = paste(workspace, "/AutoCal_WT.csv", sep = "") ,quote = FALSE,row.names=FALSE, col.names= c(List_parameter,"RMSE"))  }
    else if(int_field_data=="Lake Level") {
      write.table(x = df_frame,file = paste(workspace, "/AutoCal_LL.csv", sep = "") ,quote = FALSE,row.names=FALSE, col.names= c(List_parameter,"RMSE"))  }
    
    
    print(List_parameter)
    print(df_frame)
    
    print(paste("Minimum : ",min(vektor)))
    zeile<- match(min(vektor),vektor)
    
    print(paste("Row: ",zeile+0)) #row number of console dialog. In the written CSV its row+1 as there's a header
    
    
    svalue(label_status_CAL_calculation)<<-"DONE"
    
    
    write_nml(eg_nml_old, file = nml_file)
    
  }
  else{
    print("Error: Number of columns in the matrix does not match the length of the parameter list.")
  }
  
}


get_Vektor_of_all_values <- function (parameter,int_intervall,prozent,default_value){

  print(parameter)
  print (int_intervall)
  print(prozent)
  print(default_value)
  dezimal = 100/prozent
  startwert <- default_value - (default_value/dezimal)
  teil <- (default_value/dezimal)/(int_intervall/2)
  vektor <- c(startwert)
  for(i in 1:int_intervall){
    startwert <- startwert + teil
    vektor <- c(vektor,startwert)
  }
  
  print(vektor)
  return(list(vektor))
}



get_pre_list_of_default_values <- function(List_parameter,but_cal_si_auto,int_intervall,vec_boundary){
  
  nml_file = file.path(workspace, 'glm2.nml')
  eg_nml <-read_nml(nml_file)
  ### go through all parameters
  
  for(i in 1:length(List_parameter)){
    parameter <-paste(List_parameter[i])
    
    if(      svalue(but_cal_si_auto) != "Cancel Calculation"){
      svalue(but_cal_si_auto) <-"cancelled"
      break
    }
    if(i == 1){
      
      ### INFLOW AND OUTFLOW, RAIN ARE MEASURED. Therefore default calibration range is set to +/- 10% for flows and 20% for rain.
      
      ### OTHER PARAMETERS: Default calibration range set on +/- 50% of default value.
      #b_Kw=50;b_ce=50;b_cd=50;b_ch=50;b_coef_mix_conv=50;b_coef_wind_stir=50;b_coef_mix_shear=50;b_coef_mix_turb=50;b_coef_mix_KH=50;b_coef_mix_hyp=50;b_seepage_rate=50;b_inflow_factor=10; b_outflow_factor=10; b_rain_factor=20; b_wind_factor=50
      
      
      if(parameter == "inflow_factor"){  vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[12],get_nml_value(eg_nml, parameter)[1]))  
      
      #If in/outflow_factor has more than 1 number // more in/outflows
      if(length(get_nml_value(eg_nml , parameter)) > 1){
        for( i in 2:length(get_nml_value(eg_nml , parameter))){
          
          vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[12],get_nml_value(eg_nml, parameter)[i]))
        }
        
      }    
      }
      
      else if(parameter == "outflow_factor"){  vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[13],get_nml_value(eg_nml, parameter)[1]))  
      
      #If in/outflow_factor has more than 1 number // more in/outflows
      if(length(get_nml_value(eg_nml , parameter)) > 1){
        for( i in 2:length(get_nml_value(eg_nml , parameter))){
          
          vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[13],get_nml_value(eg_nml, parameter)[i]))
        }
        
      }    
      }
      
      else if(parameter == "rain_factor"){vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[14],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "seepage_rate"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[11],get_nml_value(eg_nml, parameter)))}
      
      else if(parameter == "ce"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[2],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "cd"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[3],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "ch"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[4],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "Kw"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[1],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "wind_factor"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[15],get_nml_value(eg_nml, parameter)))}
      
      else if(parameter == "coef_mix_conv"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[5],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_wind_stir"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[6],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_shear"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[7],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_turb"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[8],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_KH"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[9],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_hyp"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[10],get_nml_value(eg_nml, parameter)))}
      
    }
    else{
      if(parameter == "inflow_factor"){    vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[12],get_nml_value(eg_nml, parameter)[1]) )     
      
      #If outflow_factor has more than 1 number // more outflows
      if(length(get_nml_value(eg_nml , parameter)) > 1){
        for( i in 2:length(get_nml_value(eg_nml , parameter))){
          
          vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[12],get_nml_value(eg_nml, parameter)[i]))
        }
        
      } 
      }
      
      else if(parameter == "outflow_factor"){    vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[13],get_nml_value(eg_nml, parameter)[1]) )     
      
      #If outflow_factor has more than 1 number // more outflows
      if(length(get_nml_value(eg_nml , parameter)) > 1){
        for( i in 2:length(get_nml_value(eg_nml , parameter))){
          
          vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[13],get_nml_value(eg_nml, parameter)[i]))
        }
        
      } 
      }
      
      else if(parameter == "rain_factor"){vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[14],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "seepage_rate"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[11],get_nml_value(eg_nml, parameter)))}
      
      else if(parameter == "ce"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[2],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "cd"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[3],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "ch"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[4],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "Kw"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[1],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "wind_factor"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[15],get_nml_value(eg_nml, parameter)))}
      
      else if(parameter == "coef_mix_conv"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[5],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_wind_stir"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[6],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_shear"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[7],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_turb"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[8],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_KH"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[9],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_hyp"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[10],get_nml_value(eg_nml, parameter)))}
      
    }
  }
  ### all combinations to grid
  
  grid<-expand.grid(vektor_def)
  print(grid)
  return(grid)
}

#additional functionality
calculate_needed_time <- function(i,label_status_SI_calculation,start_time,length_List_parameter){
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
calculate_needed_time2 <- function(i,label_status_CAL_calculation,start_time,length_List_parameter){
  percent<- (round(i*100/length_List_parameter,digits = 2))
  EstimSec<-round( as.numeric(     difftime( Sys.time(),start_time,units = c("secs")))*(100-percent)/percent , digits = 0)
  if(EstimSec>90 & EstimSec<3600){
    EstimSec<-round( as.numeric(     difftime( Sys.time(),start_time,units = c("mins")))*(100-percent)/percent , digits = 0)
    svalue(label_status_CAL_calculation)<<-paste("",   paste(  percent   ,"% "),paste("Estimated time:",EstimSec)," Mins"    )
  }
  else if(EstimSec>3600){
    EstimSec<-round( as.numeric(     difftime( Sys.time(),start_time,units = c("hours")))*(100-percent)/percent , digits = 0)
    svalue(label_status_CAL_calculation)<<-paste("",   paste(  percent   ,"% "),paste("Estimated time:",EstimSec)," Hours"    )
  }
  else{
    svalue(label_status_CAL_calculation)<<-paste("",   paste(  percent   ,"% "),paste("Estimated time:",EstimSec)," Sec"    )
  }
}
show_message <- function(message){
  ###Msg existing Project
  window <- gwindow("Message", width = 250, height = 100)
  group <- ggroup(container = window)
  gimage("info", dirname="stock", size="dialog", container=group)
  innergroup <- ggroup(horizontal=FALSE, container = group)
  glabel(message, container=innergroup, expand=TRUE)
  gbutton("ok",  container=group, handler = function(h,...)dispose(window))
}
show_write_dialog <- function(workspace,auswahl_plot,import_csv,list_repair,list_missing_data,filename) {
  window <- gwindow("Write File",width = 200,height = 150)
  group <- ggroup(container = window)
  gimage("info", dirname="stock", size="dialog", container=group)
  inner.group <- ggroup(horizontal=FALSE, container = group)
  glabel("Save to file? \nKeep in mind that interpolation only makes sense for individual missing values.\nOtherwise the field data will be changed too much and the model calibration will be negatively affected.", container=inner.group, expand=TRUE)
  button.group <- ggroup(container = inner.group)
  addSpring(button.group)
  gbutton("ok", handler=function(h,...){
    
    #AENDERUNG: Field Data could be saved anywhere else; workaround:
    dir_write_csv<-paste(workspace,filename,sep = "/")
    if(dir_field_temp !=""){
      if(filename == strsplit(dir_field_temp, "/")[[1]][max(length(strsplit(dir_field_temp, "/")[[1]]))])
      {dir_write_csv = dir_field_temp}}
    if(dir_field_level !=""){
      if(filename == strsplit(dir_field_level, "/")[[1]][max(length(strsplit(dir_field_level, "/")[[1]]))])
      {dir_write_csv = dir_field_level}}
    
    
    
    if(file.exists(dir_write_csv)){
      i<-1
      while(i<=length(list_missing_data)){
        zahl<-as.integer(list_missing_data[i])
        #print(zahl)
        #list_repair[zahl]
        import_csv[[auswahl_plot]][zahl]<<-list_repair[zahl]
        i<-i+1
      }
      
      
      write.csv(x = import_csv,file = dir_write_csv,quote = FALSE,row.names=FALSE)
      dispose(window)
    }
    else{
      galert("file not found")
    }
    
    
  }, container=button.group)
  gbutton("cancel", handler = function(h,...) dispose(window),container=button.group)
  
}



#function to open window at auto calibration to set the ranges for every parameter
set_cali_boundary = function(boundary){
  
  window_boundary <- gwindow("Set calibration range", visible = F)
  
  window_boundary2 <- gframe(container=window_boundary, text = "Set the percentage range that will be the upper and lower limits \nfor automatic calibration for each parameter\n")
  
  windows_b_group1 <- ggroup(container=window_boundary2,horizontal = FALSE)
  windows_b_group1a <- ggroup(container=window_boundary2,horizontal = FALSE)
  windows_b_group2 <- ggroup(container=window_boundary2,horizontal = FALSE)
  windows_b_group2a <- ggroup(container=window_boundary2,horizontal = FALSE)
  windows_b_group3 <- ggroup(container=window_boundary2,horizontal = FALSE)
  
  range = c(5,10,20,30,40,50,70,90)
  
  
  glabel("Kw", container = windows_b_group1)
  combo_kw <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[1], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[1]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group1)
  
  glabel("Ce", container = windows_b_group1)
  combo_ce <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[2], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[2]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group1)
  
  glabel("Cd", container = windows_b_group1)
  combo_cd <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[3], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[3]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group1)
  
  glabel("Ch", container = windows_b_group1)
  combo_ch <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[4], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[4]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group1)
  
  gseparator(container = windows_b_group1a, horizontal = F)
  
  glabel("coef_mix_conv", container = windows_b_group2)
  combo_cmc <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[5], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[5]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group2)
  
  glabel("coef_wind_stir", container = windows_b_group2)
  combo_cws <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[6], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[6]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group2)
  
  glabel("coef_mix_shear", container = windows_b_group2)
  combo_cms <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[7], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[7]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group2)
  
  glabel("coef_mix_turb", container = windows_b_group2)
  combo_cmt <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[8], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[8]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group2)
  
  glabel("coef_mix_KH", container = windows_b_group2)
  combo_cmk <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[9], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[9]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group2)
  
  glabel("coef_mix_hyp", container = windows_b_group2)
  combo_gcmh <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[10], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[10]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group2)
  
  gseparator(container = windows_b_group2a, horizontal = F)
  
  
  glabel("Seepage rate", container = windows_b_group3)
  combo_sr <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[11], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[11]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group3)
  
  glabel("Inflow factor", container = windows_b_group3)
  combo_if <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[12], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[12]<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group3)
  
  glabel("Outflow factor", container = windows_b_group3)
  combo_of <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[13], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[13]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group3)
  
  glabel("Rain factor", container = windows_b_group3)
  combo_rf <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[14], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[14]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group3)
  
  glabel("Wind factor", container = windows_b_group3)
  combo_wf <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[15], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[15]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group3)
  
  range_close = gbutton("Ok", container = window_boundary2, handler = function(h,...){dispose((window_boundary))}, anchor=c(-1,-1))
  visible(window_boundary) = T
  
}
