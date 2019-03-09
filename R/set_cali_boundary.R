set_cali_boundary <-
function(boundary){
  
  window_boundary <- gwindow("Set calibration range", visible = F)
  
  window_boundary2 <- gframe(container=window_boundary, text = "Set the percentage range that will be the upper and lower limits \nfor automatic calibration for each parameter\n")
  
  windows_b_group1 <- ggroup(container=window_boundary2,horizontal = FALSE)
  windows_b_group1a <- ggroup(container=window_boundary2,horizontal = FALSE)
  windows_b_group2 <- ggroup(container=window_boundary2,horizontal = FALSE)
  windows_b_group2a <- ggroup(container=window_boundary2,horizontal = FALSE)
  windows_b_group3 <- ggroup(container=window_boundary2,horizontal = FALSE)
  
  range = c(5,10,20,30,40,50,70,90)
  
  
  glabel("Kw", container = windows_b_group1)
  combo_kw <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[1], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[1]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group1)
  
  glabel("Ce", container = windows_b_group1)
  combo_ce <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[2], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[2]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group1)
  
  glabel("Cd", container = windows_b_group1)
  combo_cd <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[3], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[3]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group1)
  
  glabel("Ch", container = windows_b_group1)
  combo_ch <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[4], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[4]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group1)
  
  gseparator(container = windows_b_group1a, horizontal = F)
  
  glabel("coef_mix_conv", container = windows_b_group2)
  combo_cmc <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[5], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[5]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group2)
  
  glabel("coef_wind_stir", container = windows_b_group2)
  combo_cws <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[6], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[6]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group2)
  
  glabel("coef_mix_shear", container = windows_b_group2)
  combo_cms <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[7], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[7]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group2)
  
  glabel("coef_mix_turb", container = windows_b_group2)
  combo_cmt <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[8], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[8]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group2)
  
  glabel("coef_mix_KH", container = windows_b_group2)
  combo_cmk <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[9], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[9]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group2)
  
  glabel("coef_mix_hyp", container = windows_b_group2)
  combo_gcmh <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[10], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[10]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group2)
  
  gseparator(container = windows_b_group2a, horizontal = F)
  
  
  glabel("Seepage rate", container = windows_b_group3)
  combo_sr <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[11], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[11]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group3)
  
  glabel("Inflow factor", container = windows_b_group3)
  combo_if <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[12], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[12]<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group3)
  
  glabel("Outflow factor", container = windows_b_group3)
  combo_of <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[13], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[13]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group3)
  
  glabel("Rain factor", container = windows_b_group3)
  combo_rf <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[14], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[14]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group3)
  
  glabel("Wind factor", container = windows_b_group3)
  combo_wf <- gcombobox(c("5 %","10 %","20 %","30 %","40 %","50 %","70 %","90 %"), selected = match(boundary[15], range), editable = TRUE,  handler = function(h,...){print(svalue(h$obj));boundary.env$vec_boundary[15]<<-as.numeric(strsplit(svalue(h$obj), " ")[[1]][1])},  container = windows_b_group3)
  
  range_close = gbutton("Ok", container = window_boundary2, handler = function(h,...){dispose((window_boundary))}, anchor=c(-1,-1))
  visible(window_boundary) = T
  
}
