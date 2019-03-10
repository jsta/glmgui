#' Windows main menu
#'
#' @import gWidgets
#'
windows_main_menu <-
function(version){
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
