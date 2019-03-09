set_parameter <-
function(workspace) {
  win_set_parameter <- gwindow("Enter a parameter", width = 50, height= 50,visible = TRUE)
  group_set_g1 <- ggroup(horizontal = FALSE,container = win_set_parameter)
  group_set_g1_g <- ggroup(horizontal = TRUE,container = group_set_g1)
  

  cb <<- gcombobox(l, selected = 0, editable=TRUE, container=group_set_g1_g,handler=function(h,...){
    nml_file = file.path(workspace,"glm2.nml")
    print(length(List_parameter))
    eg_nml <-read_nml(nml_file)
    gewaehlterwert<<- get_nml_value(eg_nml,arg_name = svalue(h$obj))
    if(length(List_parameter)!=0){
     if(List_parameter[[1]]==svalue(cb)) {
       svalue(value)<<-paste(List_parameter[[3]],";",List_parameter[[4]],";",List_parameter[[5]],sep ="")
     }
      else if(length(gewaehlterwert)>1){
        for (k in 1:length(gewaehlterwert)) {
          if(k==1){
            textarg<-gewaehlterwert[k]
          }
          else{textarg<-paste(textarg,gewaehlterwert[k], sep =",")}
          
        }
        svalue(value)<<-textarg
      }
      else{
        if(is.numeric(gewaehlterwert)){print("numeric")}
        else if ( is.character(gewaehlterwert)){print("character")}
        svalue(value)<-gewaehlterwert
        gewaehlt<<- svalue(h$obj)
      }
      
    }
    else if(length(gewaehlterwert)>1){
      for (k in 1:length(gewaehlterwert)) {
        if(k==1){
          textarg<-gewaehlterwert[k]
        }
        else{textarg<-paste(textarg,gewaehlterwert[k], sep =",")}
        
      }
      svalue(value)<<-textarg
      if(is.numeric(gewaehlterwert)){print("numeric (multiple)")} 
      else if ( is.character(gewaehlterwert)){print("character")}
      gewaehlt<<- svalue(h$obj) #ENDNEW
    }
    else{
      if(is.numeric(gewaehlterwert)){print("numeric")}
      else if ( is.character(gewaehlterwert)){print("character")}
      svalue(value)<-gewaehlterwert
      gewaehlt<<- svalue(h$obj)
    }

  })
  
  #parameter <- gedit("Parameter", container = group_set_g1_g )
  value <- gedit("...", container = group_set_g1_g)
  
  group_set_g2 <- ggroup(horizontal = FALSE,container = win_set_parameter)
  group_set_g2_g <- ggroup(horizontal = TRUE,container = group_set_g2)
  
  button_set_parameter<<-gbutton("Set", container = group_set_g2_g,handler = function(h, ...) {
    nml_file = file.path(workspace,"glm2.nml")
    if(svalue(value)!=""){
      #check for split character 
      if(grepl(";",svalue(value)) && length(List_parameter)==0){
        print("set Intervall")
        
        b<-unlist(strsplit(svalue(value),";"))
        if(length(b)==3){
          if(as.numeric(b[1])>as.numeric(b[2])){
            show_message("Start value > End value")
            
          }
          else {
            List_parameter_temp <<- list()
            nml_file = file.path(workspace,"glm2.nml")
            eg_nml <-read_nml(nml_file)
            ###1 Parameter
            ###2 Default Value
            ###3 Start Value
            ###4 End Value
            ###5 Step
            
            List_parameter_temp[[1]]<<- svalue(cb)
            List_parameter_temp[[2]]<<- get_nml_value(eg_nml,arg_name = svalue(cb))
            List_parameter_temp[[3]]<<- as.numeric(b[1])
            List_parameter_temp[[4]]<<- as.numeric(b[2])
            List_parameter_temp[[5]]<<- as.numeric(b[3])
            List_parameter <<- List_parameter_temp
 
            List_values_temp <<- list()
            dCounter <-List_parameter[[3]]
            i <- 1
            while(dCounter<=List_parameter[[4]]){
              List_values_temp[[i]] <- dCounter
              i <- i + 1
              dCounter<-dCounter + List_parameter[[5]]
            }
            List_values<<-List_values_temp
            svalue(label_nml_range)<<-paste(List_parameter[[1]]," : ",List_parameter[[3]]," - ",List_parameter[[4]]," /",List_parameter[[5]])
            remove(List_parameter_temp,List_values_temp)
          }

        }
        else{
          show_message("Wrong format")
        }
        
      }
      else if(grepl(";",svalue(value))==FALSE && length(List_parameter)!=0 && List_parameter[[1]] ==svalue(cb)){
        print("delete Intervall and set value")
        ### Delets Intervall for single value
        List_parameter <<- list()
        List_values <<- list()
        svalue(label_nml_range)<<-""

        
        if(is.numeric(gewaehlterwert)){
          gewaehlterwert <- as.numeric(svalue(value))
          print(gewaehlterwert)
          
          eg_nml <- set_nml(eg_nml,arg_name =  gewaehlt ,arg_val = gewaehlterwert)
          nml_file = file.path(workspace , "glm2.nml")
          write_nml(eg_nml, file = nml_file)
          
        }
        else if(is.character(gewaehlterwert)){
          gewaehlterwert <- as.character(svalue(value))
          print(gewaehlterwert)
          
          eg_nml <- set_nml(eg_nml,arg_name =  gewaehlt ,arg_val = gewaehlterwert)
          nml_file = file.path(workspace , "glm2.nml")
          write_nml(eg_nml, file = nml_file)
          
        }
        
      }
      else if(grepl(";",svalue(value))==TRUE && length(List_parameter)!=0 && List_parameter[[1]] ==svalue(cb)){
        b<-unlist(strsplit(svalue(value),";"))
        if(length(b)==3){
          if(as.numeric(b[1])>as.numeric(b[2])){
            show_message("Start value > End value")
            
          }
          else {
            List_parameter_temp <<- list()
            nml_file = file.path(workspace,"glm2.nml")
            eg_nml <-read_nml(nml_file)
            ###1 Parameter
            ###2 Default Value
            ###3 Start Value
            ###4 End Value
            ###5 Step
            
            List_parameter_temp[[1]]<<- svalue(cb)
            List_parameter_temp[[2]]<<- get_nml_value(eg_nml,arg_name = svalue(cb))
            List_parameter_temp[[3]]<<- as.numeric(b[1])
            List_parameter_temp[[4]]<<- as.numeric(b[2])
            List_parameter_temp[[5]]<<- as.numeric(b[3])
            List_parameter <<- List_parameter_temp
            
            List_values_temp <<- list()
            dCounter <-List_parameter[[3]]
            i <- 1
            while(dCounter<=List_parameter[[4]]){
              List_values_temp[[i]] <- dCounter
              i <- i + 1
              dCounter<-dCounter + List_parameter[[5]]
            }
            List_values<<-List_values_temp
            svalue(label_nml_range)<<-paste(List_parameter[[1]]," : ",List_parameter[[3]]," - ",List_parameter[[4]]," /",List_parameter[[5]])
            remove(List_parameter_temp,List_values_temp)
          }
          
        }
        else if(grepl(";",svalue(value))==TRUE && length(List_parameter)!=0 && List_parameter[[1]] !=svalue(cb)){
          show_message(paste("Another interval is already set : ",List_parameter[[1]]))
        }
        else{
          show_message("Wrong format")
        }
      }
      else if((grepl(";",svalue(value))==FALSE) && (grepl(",",svalue(value))==FALSE)){
        print("single value")
        
        
        
        if(is.numeric(gewaehlterwert)){
          gewaehlterwert <- as.numeric(svalue(value))
          eg_nml <-read_nml(nml_file)
          eg_nml <- set_nml(eg_nml,arg_name =  gewaehlt ,arg_val = gewaehlterwert)
          nml_file = file.path(workspace , "glm2.nml")
          write_nml(eg_nml, file = nml_file)
          check_data_connection(workspace)

        }
        else if(is.character(gewaehlterwert)){
          gewaehlterwert <- as.character(svalue(value))
          eg_nml <-read_nml(nml_file)
          eg_nml <- set_nml(eg_nml,arg_name =  gewaehlt ,arg_val = gewaehlterwert)
          nml_file = file.path(workspace , "glm2.nml")
          write_nml(eg_nml, file = nml_file)
          check_data_connection(workspace)
          
          
          
        }
        
        
      }
      
      else if(grepl(",",svalue(value))==TRUE){
        print("multiple values")
        
        if(is.numeric(gewaehlterwert)){
          gewaehlterwert <- as.numeric(strsplit(svalue(value), ',')[[1]])
          eg_nml <-read_nml(nml_file)
          eg_nml <- set_nml(eg_nml,arg_name =  gewaehlt ,arg_val = gewaehlterwert)
          nml_file = file.path(workspace , "glm2.nml")
          write_nml(eg_nml, file = nml_file)
          check_data_connection(workspace)
          
        }
     
      }

    }
  })
  
  but_hauptm_cancel <- gbutton("Close", container = group_set_g2_g, handler=function(h,...) dispose((h$obj)))
}
