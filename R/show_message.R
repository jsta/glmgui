show_message <-
function(message){
  ###Msg existing Project
  window <- gwindow("Message", width = 250, height = 100)
  group <- ggroup(container = window)
  gimage("info", dirname="stock", size="dialog", container=group)
  innergroup <- ggroup(horizontal=FALSE, container = group)
  glabel(message, container=innergroup, expand=TRUE)
  gbutton("ok",  container=group, handler = function(h,...)dispose(window))
}
