show_write_dialog <-
function(workspace,auswahl_plot,import_csv,list_repair,list_missing_data,filename) {
  window <- gwindow("Write File",width = 200,height = 150)
  group <- ggroup(container = window)
  gimage("info", dirname="stock", size="dialog", container=group)
  inner.group <- ggroup(horizontal=FALSE, container = group)
  glabel("Save to file? \nKeep in mind that interpolation only makes sense for individual missing values.\nOtherwise the field data will be changed too much and the model calibration will be negatively affected.", container=inner.group, expand=TRUE)
  button.group <- ggroup(container = inner.group)
  addSpring(button.group)
  gbutton("ok", handler=function(h,...){
    
    #AENDERUNG: Field Data could be saved anywhere else; workaround:
    dir_write_csv<-paste(workspace,filename,sep = "/")
    if(dir_field_temp !=""){
      if(filename == strsplit(dir_field_temp, "/")[[1]][max(length(strsplit(dir_field_temp, "/")[[1]]))])
      {dir_write_csv = dir_field_temp}}
    if(dir_field_level !=""){
      if(filename == strsplit(dir_field_level, "/")[[1]][max(length(strsplit(dir_field_level, "/")[[1]]))])
      {dir_write_csv = dir_field_level}}
    
    
    
    if(file.exists(dir_write_csv)){
      i<-1
      while(i<=length(list_missing_data)){
        zahl<-as.integer(list_missing_data[i])
        #print(zahl)
        #list_repair[zahl]
        import_csv[[auswahl_plot]][zahl]<<-list_repair[zahl]
        i<-i+1
      }
      
      
      write.csv(x = import_csv,file = dir_write_csv,quote = FALSE,row.names=FALSE)
      dispose(window)
    }
    else{
      galert("file not found")
    }
    
    
  }, container=button.group)
  gbutton("cancel", handler = function(h,...) dispose(window),container=button.group)
  
}
