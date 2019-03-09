get_pre_list_of_default_values <-
function(List_parameter,but_cal_si_auto,int_intervall,vec_boundary){
  
  nml_file = file.path(workspace, 'glm2.nml')
  eg_nml <-read_nml(nml_file)
  ### go through all parameters
  
  for(i in 1:length(List_parameter)){
    parameter <-paste(List_parameter[i])
    
    if(      svalue(but_cal_si_auto) != "Cancel Calculation"){
      svalue(but_cal_si_auto) <-"cancelled"
      break
    }
    if(i == 1){
      
      ### INFLOW AND OUTFLOW, RAIN ARE MEASURED. Therefore default calibration range is set to +/- 10% for flows and 20% for rain.
      
      ### OTHER PARAMETERS: Default calibration range set on +/- 50% of default value.
      #b_Kw=50;b_ce=50;b_cd=50;b_ch=50;b_coef_mix_conv=50;b_coef_wind_stir=50;b_coef_mix_shear=50;b_coef_mix_turb=50;b_coef_mix_KH=50;b_coef_mix_hyp=50;b_seepage_rate=50;b_inflow_factor=10; b_outflow_factor=10; b_rain_factor=20; b_wind_factor=50
      
      
      if(parameter == "inflow_factor"){  vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[12],get_nml_value(eg_nml, parameter)[1]))  
      
      #If in/outflow_factor has more than 1 number // more in/outflows
      if(length(get_nml_value(eg_nml , parameter)) > 1){
        for( i in 2:length(get_nml_value(eg_nml , parameter))){
          
          vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[12],get_nml_value(eg_nml, parameter)[i]))
        }
        
      }    
      }
      
      else if(parameter == "outflow_factor"){  vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[13],get_nml_value(eg_nml, parameter)[1]))  
      
      #If in/outflow_factor has more than 1 number // more in/outflows
      if(length(get_nml_value(eg_nml , parameter)) > 1){
        for( i in 2:length(get_nml_value(eg_nml , parameter))){
          
          vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[13],get_nml_value(eg_nml, parameter)[i]))
        }
        
      }    
      }
      
      else if(parameter == "rain_factor"){vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[14],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "seepage_rate"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[11],get_nml_value(eg_nml, parameter)))}
      
      else if(parameter == "ce"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[2],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "cd"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[3],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "ch"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[4],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "Kw"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[1],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "wind_factor"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[15],get_nml_value(eg_nml, parameter)))}
      
      else if(parameter == "coef_mix_conv"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[5],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_wind_stir"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[6],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_shear"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[7],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_turb"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[8],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_KH"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[9],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_hyp"){ vektor_def <- c(get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[10],get_nml_value(eg_nml, parameter)))}
      
    }
    else{
      if(parameter == "inflow_factor"){    vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[12],get_nml_value(eg_nml, parameter)[1]) )     
      
      #If outflow_factor has more than 1 number // more outflows
      if(length(get_nml_value(eg_nml , parameter)) > 1){
        for( i in 2:length(get_nml_value(eg_nml , parameter))){
          
          vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[12],get_nml_value(eg_nml, parameter)[i]))
        }
        
      } 
      }
      
      else if(parameter == "outflow_factor"){    vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[13],get_nml_value(eg_nml, parameter)[1]) )     
      
      #If outflow_factor has more than 1 number // more outflows
      if(length(get_nml_value(eg_nml , parameter)) > 1){
        for( i in 2:length(get_nml_value(eg_nml , parameter))){
          
          vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[13],get_nml_value(eg_nml, parameter)[i]))
        }
        
      } 
      }
      
      else if(parameter == "rain_factor"){vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[14],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "seepage_rate"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[11],get_nml_value(eg_nml, parameter)))}
      
      else if(parameter == "ce"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[2],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "cd"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[3],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "ch"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[4],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "Kw"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[1],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "wind_factor"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[15],get_nml_value(eg_nml, parameter)))}
      
      else if(parameter == "coef_mix_conv"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[5],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_wind_stir"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[6],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_shear"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[7],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_turb"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[8],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_KH"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[9],get_nml_value(eg_nml, parameter)))}
      else if(parameter == "coef_mix_hyp"){ vektor_def <- c(vektor_def, get_Vektor_of_all_values(parameter,int_intervall,vec_boundary[10],get_nml_value(eg_nml, parameter)))}
      
    }
  }
  ### all combinations to grid
  
  grid<-expand.grid(vektor_def)
  print(grid)
  return(grid)
}
