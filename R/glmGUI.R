
#' @export
#'
glmGUI <-
function(...){
  version <- 1.0
  libs = c("gWidgets2","tcltk", "gWidgets2RGtk2", "ncdf4", "rLakeAnalyzer", "digest", "graphics", "testit" ,"treemap","akima", "imputeTS")
  for (i in libs){
    if( !is.element(i, .packages(all.available = TRUE)) ) {
      install.packages(i)
    }
    if(require(i,character.only = TRUE)){
      print(paste(i," found"))
    }
  }
  if (require("glmtools")){
    print("glmtools found")
    if (require("GLMr")){
      print("GLMr found")
      windows_main_menu(version)
    }
    else{
      install.packages("GLMr", repos="http://owi.usgs.gov/R")
      if(require("glmtools")){windows_main_menu(version)}
      }
  }
  else {
    install.packages("glmtools", repos="http://owi.usgs.gov/R")
    if(require("glmtools")){windows_main_menu(version)}
    }
}
