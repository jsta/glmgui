window_input_csv_to_plot2 <-
function(directory_csv,filename,workspace,...){
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
