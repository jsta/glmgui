window_plot_dataframe_Level_Lake <-
function(data_frame,workspace){
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
