calculate_diff_modell_field <-
function(data_frame){
  vektor<- 0
  for(element in 1:nrow(data_frame)){
    diff<- data_frame[,3][element]-data_frame[,2][element]
    vektor[element]<-as.double(diff)
  }
  data_frame[["diff"]] <- vektor
  return(data_frame)
}
