calculate_rel_SI_RMSE <-
function(Q_plus,Q_minus,Q_null){
  rel_norm_SI <- 0
  rel_norm_SI <- abs(Q_plus - Q_minus)/Q_null
  return (rel_norm_SI)
}
