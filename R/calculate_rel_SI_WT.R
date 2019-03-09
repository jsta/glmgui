calculate_rel_SI_WT <-
function(WT_plus,WT_minus,WT_null,int_Prozent,value){
  rel_norm_SI <- 0
  for (j in 1:length(WT_null)) { 
    rel_norm_SI[j] <- ((WT_plus[j] - WT_minus[j])/WT_null[j])/(2*int_Prozent/100/value)
  }
  return (mean(rel_norm_SI, na.rm=TRUE))
}
