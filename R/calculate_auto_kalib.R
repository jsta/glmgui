calculate_auto_kalib <-
function(workspace,List_parameter,vec_boundary, int_field_data,int_intervall, label_status_CAL_calculation){
  #initial run to create output directory
  GLMr::run_glm(workspace)
  svalue(label_status_CAL_calculation) <-"building..."
  dir_output <<-paste (workspace,"/output/", sep = "")
  nml_file <- file.path(workspace, 'glm2.nml')
  nc_file <- file.path(dir_output, 'output.nc')
  ### Save Default Parameter
  eg_nml_old <-read_nml(nml_file)
  eg_nml <-read_nml(nml_file)



  dir_output_model<- paste(dir_output,"/",get_nml_value(eg_nml,arg_name = "csv_lake_fname"),".csv",sep = "")
  start_time<-Sys.time()

  vektor <- 0

  matrix <- get_pre_list_of_default_values(List_parameter,but_cal_si_auto,int_intervall,vec_boundary)


  print("Number of combinations:")
  print(nrow(matrix))
  print(ncol(matrix))

  #get number of parameters: inflow and outflow factors can have more than 1 parameter depending on the number of inflows/outflows
  number_of_parameters = length(List_parameter)
  if('inflow_factor' %in% List_parameter){number_of_parameters = number_of_parameters -1 + length(get_nml_value(eg_nml ,'inflow_factor'))}
  if('outflow_factor' %in% List_parameter){number_of_parameters = number_of_parameters -1 + length(get_nml_value(eg_nml ,'outflow_factor'))}

  num_inflow = length(get_nml_value(eg_nml ,'inflow_factor'))
  num_outflow = length(get_nml_value(eg_nml ,'outflow_factor'))


  #modify list_parameter and append as many in/outflow_factors as needed
  if('inflow_factor' %in% List_parameter && num_inflow > 1){
    index = 0
    index = match('inflow_factor', List_parameter) - 1
    for (i in 2:num_inflow){List_parameter = append(List_parameter, 'inflow_factor', index)}
  }

  if('outflow_factor' %in% List_parameter && num_outflow > 1){
    index = 0
    index = match('outflow_factor', List_parameter) - 1
    for (i in 2:num_outflow){List_parameter = append(List_parameter, 'outflow_factor', index)}
  }

  if(ncol(matrix)==length(List_parameter)){
    print("Starting conditions met.")
    start_time = Sys.time()
    for(i in 1:nrow(matrix)){
      for(j in 1:length(List_parameter)){
        print(paste(List_parameter[j]))
        print(matrix[i,j])

        arg_val_infl = numeric(0)  #length of 0
        arg_val_outfl = numeric(0)  #length of 0
        if(num_inflow < 2 && num_outflow < 2){
          eg_nml <- set_nml(eg_nml,arg_name =  paste(List_parameter[j]) ,arg_val =  as.numeric(matrix[,j][i])) }

        else{
          if('inflow_factor' %in% List_parameter && num_inflow > 1){arg_val_infl = as.numeric(matrix[i, min(which(List_parameter %in% 'inflow_factor')):max(which(List_parameter %in% 'inflow_factor'))])
          eg_nml <- set_nml(eg_nml,arg_name =  'inflow_factor' ,arg_val =  arg_val_infl)}
          if('outflow_factor' %in% List_parameter && num_outflow > 1){arg_val_outfl = as.numeric(matrix[i, min(which(List_parameter %in% 'outflow_factor')):max(which(List_parameter %in% 'outflow_factor'))])
          eg_nml <- set_nml(eg_nml,arg_name =  'outflow_factor' ,arg_val =  arg_val_outfl)}
          j=j+length(arg_val_infl)+length(arg_val_outfl)
          if(j<=length(List_parameter)){
            eg_nml <- set_nml(eg_nml,arg_name =  paste(List_parameter[j]) ,arg_val =  as.numeric(matrix[,j][i])) }
        }
        calculate_needed_time2(i,label_status_CAL_calculation,start_time,nrow(matrix))
      }
      write_nml(eg_nml, file = nml_file)
      #Wait until writing process stopped
      Sys.sleep(1)
      #Run model building

      GLMr::run_glm(workspace)
      nc_file <- file.path(dir_output, 'output.nc')

      if(int_field_data=="Temperature"){
        print("calculating temperature differences")
        data_frame <- compare_to_field(nc_file, dir_field_temp,metric = 'water.temperature', as_value = TRUE)
        data_frame <- calculate_diff_modell_field(data_frame = data_frame)
        vektor [i]   <-  calculate_RMSE(data_frame)
      }
      else if(int_field_data=="Lake Level"){
        print("calculating lake level differences")
        data_frame <- get_dataframe_Level_Lake(workspace,dir_field_level,dir_output_model)
        vektor [i]   <-  calculate_RMSE(data_frame)
      }

    }

    df_frame <- data.frame(matrix,vektor)

    if (int_field_data=="Temperature") {
      write.table(x = df_frame,file = paste(workspace, "/AutoCal_WT.csv", sep = "") ,quote = FALSE,row.names=FALSE, col.names= c(List_parameter,"RMSE"))  }
    else if(int_field_data=="Lake Level") {
      write.table(x = df_frame,file = paste(workspace, "/AutoCal_LL.csv", sep = "") ,quote = FALSE,row.names=FALSE, col.names= c(List_parameter,"RMSE"))  }


    print(List_parameter)
    print(df_frame)

    print(paste("Minimum : ",min(vektor)))
    zeile<- match(min(vektor),vektor)

    print(paste("Row: ",zeile+0)) #row number of console dialog. In the written CSV its row+1 as there's a header


    svalue(label_status_CAL_calculation)<<-"DONE"


    write_nml(eg_nml_old, file = nml_file)

  }
  else{
    print("Error: Number of columns in the matrix does not match the length of the parameter list.")
  }

}
