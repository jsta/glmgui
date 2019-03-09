window_plot_multi_histo <-
function(title,list_data_frame){
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
