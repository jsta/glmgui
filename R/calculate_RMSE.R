calculate_RMSE <-
function(data_frame){
  square_sum<-0
  for (i in 1:nrow(data_frame)) {     square_sum<-data_frame[i,4]*data_frame[i,4]+square_sum  }
  RMSE<-sqrt(square_sum/i)
  return(RMSE)
}
