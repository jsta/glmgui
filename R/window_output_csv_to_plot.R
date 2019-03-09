window_output_csv_to_plot <-
function(directory_csv,...){
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
