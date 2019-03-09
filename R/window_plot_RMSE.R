window_plot_RMSE <-
function(title , List_data_frame){
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
