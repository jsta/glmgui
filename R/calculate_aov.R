calculate_aov <-
function(List_data_frame){
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
