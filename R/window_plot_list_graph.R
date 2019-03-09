window_plot_list_graph <-
function(title,list_data_frame,List_values, List_parameter){
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
