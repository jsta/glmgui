window_input_csv_to_plot <-
function(directory_csv,filename,workspace,...){
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
  font(sub_label_titel) <- c(weight="bold")
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
