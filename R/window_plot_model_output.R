window_plot_model_output <-
function(workspace){

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
  font(sub_label_titel) <- c(weight="bold")
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
