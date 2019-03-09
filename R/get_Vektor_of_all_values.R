get_Vektor_of_all_values <-
function (parameter,int_intervall,prozent,default_value){

  print(parameter)
  print (int_intervall)
  print(prozent)
  print(default_value)
  dezimal = 100/prozent
  startwert <- default_value - (default_value/dezimal)
  teil <- (default_value/dezimal)/(int_intervall/2)
  vektor <- c(startwert)
  for(i in 1:int_intervall){
    startwert <- startwert + teil
    vektor <- c(vektor,startwert)
  }
  
  print(vektor)
  return(list(vektor))
}
