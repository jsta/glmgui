get_parameter <-
function(workspace, ...) {#start function

  #get glm2.nml
  nml_file = file.path(workspace,"glm2.nml")
  #run_glm(eg_folder)
  #suppressWarnings(eg_nml <-read_nml(nml_file))
  eg_nml <-read_nml(nml_file)
  #start window
  win <- gwindow("nml - configuration file",visible = FALSE, name = "configuration file")
  main<- ggroup(horizontal = FALSE, spacing = 1, container = win, use.scrollwindow = FALSE)
  for ( i in 1:length(names(eg_nml)) ) {
    #start groups
    main_sub<- ggroup(container = main,horizontal = FALSE, spacing = 5)
    main_sub_text <- ggroup(container = main_sub,horizontal = TRUE)
    sub_label <-glabel(names(eg_nml)[i],container = main_sub_text, fg="red")
    font(sub_label) <- c(weight="bold")


    main_sub_value <- ggroup(container = main_sub,horizontal = TRUE)
    zaehler<- 1
    gsetup<- ggroup(container = main_sub_value,horizontal = TRUE)
    gcolumn<- ggroup(container = gsetup,horizontal = FALSE)

    for(j in 1:length(eg_nml[[i]])){

      #get name and value
      name <- names(eg_nml[[i]][j])
      arg <- get_nml_value(eg_nml,arg_name = name)
      print(name)
      print(length(arg))
      if(length(arg)>1){

        for (k in 1:length(arg)) {
          if(k==1){
            textarg<-as.character(arg[k])
            }
          else{textarg<-paste(textarg,arg[k], sep =",")}

        }

        #arg<<-paste(unlist(arg),collapse=",")
      }
      else{textarg<-as.character(arg)}
      print(textarg)
      gContainer<- ggroup(container = gcolumn,horizontal = TRUE)
      glabel(name,container = gContainer)
      txt_data_frame_name <- gedit(textarg, container = gContainer, width = nchar(textarg))



        #create columns
      zaehler<- zaehler +1
      if (zaehler>2){gcolumn<- ggroup(container = gsetup,horizontal = FALSE)
        zaehler <-1
      }
    }
    if(i!=length(names(eg_nml))){gseparator(horizontal=TRUE, container=main_sub, expand=TRUE)}
  }#End groups
  visible(win) <- TRUE
  #End function
}
