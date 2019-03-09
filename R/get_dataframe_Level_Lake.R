get_dataframe_Level_Lake <-
function(workspace,dir_field_level,dir_output_model){
  
  data_level_field <- read.csv(dir_field_level, header=T)
  
  data_level <- read.csv(dir_output_model, header=T)
  
  ######
  #search for Level Name in ModelOutput -> Return extracted Level lake data and Time Data
  for (i in 1:length(names(data_level))) {
    if(length(grep("Level", names(data_level)[i]))>0){
      model_level_data<-data_level[,c(1,i)]  
    }
  }
  
  ### Define Data Frame to save Values for printing
  df_compare_height <- data.frame(Date=character(),Level_Model=double(), Level_Field=double(),Difference = double(),stringsAsFactors=FALSE) 
  
  value_date_model = character(nrow(model_level_data))
  ### Search for Values of the same Date
  for (j in 1:nrow(model_level_data)) {
    value_date_model[j] <- gsub(x=model_level_data[j,1],pattern=" 24:00:00",replacement="",fixed=T)}
    #### Search for same Date in Field Data
  
  #workaround: use the match() function to avoid nested for-loop!!
  matchingnumbers = na.omit(match(data_level_field[,1], value_date_model))
  model_level_data_n = model_level_data
  for (j in 1:nrow(model_level_data)) {model_level_data_n[j,2] = NA}
  for (k in matchingnumbers) {model_level_data_n[k,2] = model_level_data[k,2]}
  model_level_data_n = na.omit(model_level_data_n)
  
  value_date_model_n = value_date_model
  for (j in 1:length(value_date_model)) {value_date_model_n[j] = NA}
  for (k in matchingnumbers) {value_date_model_n[k] = value_date_model[k]}
  value_date_model_n = na.omit(value_date_model_n)
  
  matchingnumbers2 = na.omit(match(value_date_model, data_level_field[,1]))
  data_level_field_n = data_level_field
  for (j in 1:nrow(data_level_field)) {data_level_field_n[j,2] = NA}
  for (k in matchingnumbers2) {data_level_field_n[k,2] = data_level_field[k,2]}
  data_level_field_n = na.omit(data_level_field_n)
  
  for (j in 1:nrow(data_level_field_n)) {
  df_compare_height[j,1] = value_date_model_n[j] 
  df_compare_height[j,2] = model_level_data_n[j,2]
  df_compare_height[j,3] = data_level_field_n[j,2]
  df_compare_height[j,4] = model_level_data_n[j,2]-data_level_field_n[j,2]}
    
  
  ###Deletes Variables in RAM
  remove(j,k,i,value_date_model,data_level,data_level_field)
  
  return(df_compare_height)
}
