calculate_rel_SI_LL <-
function(LL_plus,LL_minus,LL_null,int_Prozent,value){
  rel_norm_SI <- 0
  for (j in 1:length(LL_null)) { 
    rel_norm_SI[j] <- ((LL_plus[j] - LL_minus[j])/LL_null[j])/(2*int_Prozent/100/value)
  }
  return (mean(rel_norm_SI))
}
