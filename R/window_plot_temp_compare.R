window_plot_temp_compare <-
function(title,workspace, nc_file, dir_field_temp, datapoints){
  w <- gwindow(title = title, visible=FALSE)
  gg <- ggraphics(container=w)
  ggmain <- dev.cur()
  Sys.sleep(0.2)
  setwd(workspace)
  
  
  ## DIFFERENCE PLOT##
  start_par = par(no.readonly = TRUE)
  mod_temp = get_var(nc_file, 'temp', reference='surface')
  mod_depths = get.offsets(mod_temp) #function from package rLakeAnalyzer
  
  tempdata = resample_to_field(nc_file, dir_field_temp, var_name='temp')
  model_df <- resample_sim(mod_temp, t_out = unique(as.POSIXct(as.numeric(tempdata$DateTime), origin='1970-01-01'   )))
  
  #Pivot observed into table
  x = as.numeric(as.POSIXct(tempdata$DateTime))
  y = tempdata$Depth
  z = tempdata[,paste0('Observed_', 'temp')]
  z2 = tempdata[,paste0('Modeled_', 'temp')]
  x_out = sort(unique(x))
  y_out = sort(unique(c(y, mod_depths)))
  
  #remove any NA values before the 2D interp
  x = x[!is.na(z) & !is.na(z2)]
  y = y[!is.na(z) & !is.na(z2)]
  copyz = z
  z = z[!is.na(z) & !is.na(z2)]
  z2 = z2[!is.na(copyz)& !is.na(z2)]
  
  
  #Added a scaling factor to Y. Interp won't interpolate if X and Y are on vastly different scales.
  # I don't use Y from here later, so it doesn't matter what the mangitude of the values is.
  interped = interp(x, y*1e6, z, x_out, y_out*1e6)
  interped2 = interp(x, y*1e6, z2, x_out, y_out*1e6)
  
  gen_default_fig <- function(filename=FALSE, width = 4, height, ps = 11, res = 200, units = "in",
                              mai = c(0.2,0,0.05,0),
                              omi = c(0.1, 0.5, 0, 0), 
                              mgp = c(1.4,.3,0),
                              num_divs = 1, ...){
    
    if ((is.character(filename))){
      valid_fig_path(filename)
      if (missing(height)){
        height = 2*num_divs
      }
      png(filename, width = width, height = height, units = units, res = res)
    }
    par(mai = mai,omi = omi, ps = ps, mgp = mgp, ...)
  }
  
  .stacked_layout <- function(is_heatmap, num_divs){
    if(num_divs == 1 & !is_heatmap) return()
    
    if(is_heatmap){
      colbar_layout(num_divs)
    } else {
      .simple_layout(num_divs)
    }
    
  }
  
  
  
  colbar_layout <- function(nrow = 2){
    # ensures all colorbar plots use same x scaling for divs
    mx <- matrix(c(rep(1,5),2),nrow=1)
    panels <- mx
    if (nrow > 1){
      for (i in 2:nrow){
        panels <- rbind(panels,mx+(i-1)*2)
      }
    }
    
    layout(panels)
    
  }
  
  # Functions from glmtools, which aren't found. So copy & paste
  
  get_xaxis <- function(dates){
    
    
    start_time = min(dates) #earliest date
    end_time = max(dates) #latest date
    
    vis_time = c(start_time-86400, pretty(dates), end_time+86400) # pretty vector to specify tick mark location 
    sec.end_time = as.numeric(end_time) # show time as seconds
    sec.start_time = as.numeric(start_time) # show time as seconds
    tt = sec.end_time - sec.start_time # time range of data frame; used to specify time axis
    
    # specify x axis format based upon time range of data 
    time_form = c()
    if(tt < 1.1*60) { # if time is less than 1 hr units are seconds
      time_form <- "%S"
    } else if (tt < 1.1*60*60) { # if time is less than 1.1 hours units are min:sec
      time_form <- "%M:%S"
    } else if (tt < 60*60*24*2) {# if time is less than 2 days units are hour:min
      time_form <- "%H:%M"
    } else if (tt < 60*60*24*7*8.9) {# if time is less than 2 months units are ex. Jul 25 10:15
      time_form <- "%d %b %H:%M"
    } else {    
      time_form <- "%b %Y"
    }
    
    # specify x axis labels based upon time range of data 
    x_lab = c()
    if(tt < 1.1*60) { # if time is less than 1 minutes units are seconds
      x_lab  <- "Seconds"
    } else if (tt < 1.1*60*60) { # if time is less than 1.1 hours units are min:sec
      x_lab <- "Minutes"
    } else if (tt < 60*60*24*2) {# if time is less than 2 days units are hour:min
      x_lab <- "Hours"
    } else if (tt < 60*60*24*7) { # if time is less than 7 days units are Jul 25 10:15
      x_lab <- " "
    } else if (tt < 60*60*24*7*8.9) {# if time is less than 2 months units are ex. Jul 25 
      x_lab <- " "
    } else if (tt < 60*60*24*7*4.4*12) { # if time is less than 12 months units are Jun, Jul, Aug  
      x_lab <- " "
    } else if (tt < 60*60*24*7*4.4*12*1.1){ # if time is more than 12.1 years units are Jul 2013
      x_lab <- " "
    }
    
    return(list('time_form' = time_form, 'x_lab' = x_lab, 'lim' = c(start_time, end_time), 'vis_time' = vis_time))
  }
  
  #function to create contourplot
  .plot_df_heatmap <- function(data, bar_title, num_cells, palette, title_prefix=NULL, overlays=NULL, xaxis=NULL, col_lim, col_subs, levels, colorspal){
    
    z_out <- rLakeAnalyzer::get.offsets(data)
    reference = ifelse(substr(names(data)[2],1,3) == 'elv', 'bottom', 'surface')
    
    if (missing(col_lim))
      col_lim = range(data[, -1], na.rm = TRUE)
    if (missing(palette))
      palette <- colorRampPalette(c("violet","blue","cyan", "green3", "yellow", "orange", "red"), 
                                  bias = 1, space = "rgb")
    if (missing(col_subs))
      col_subs <- head(pretty(col_lim, 12), -1) #von 6 auf 12
    if (missing(levels))
      levels <- sort(unique(c(col_subs, pretty(col_lim, 15))))
    if (missing(colorspal))
      colorspal <- palette(n = length(levels)-1)
    dates <- data[, 1]
    matrix_var <- data.matrix(data[, -1])
    if(is.null(xaxis)){
      xaxis <- get_xaxis(dates)
    }
    
    yaxis <- get_yaxis_2D(z_out, reference, prefix=title_prefix)
    plot_layout(xaxis, yaxis, add=TRUE)
    .filled.contour(x = dates, y = z_out, z =matrix_var,
                    levels= levels,
                    col=colorspal)
    overlays # will plot any overlay functions
    axis_layout(xaxis, yaxis) #doing this after heatmap so the axis are on top
    
    color_key(levels, colorspal, subs=col_subs, col_label = bar_title)
  }
  
  #function to create contourplot for the differences of modeled and observed temperatures
  .plot_df_heatmap_diff <- function(data, bar_title, num_cells, palette, title_prefix=NULL, overlays=NULL, xaxis=NULL){
    
    z_out <- rLakeAnalyzer::get.offsets(data)
    reference = ifelse(substr(names(data)[2],1,3) == 'elv', 'bottom', 'surface')
    
    #fake range -40 to +40
    col_lim = range(-40, 40)
    palette <- colorRampPalette(c("blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue4","blue","deepskyblue", "lightblue1", "lightcyan","white", "lightpink","lightcoral","indianred","firebrick","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red"))
    col_subs <- head(pretty(col_lim, 12), -1) 
    levels <- sort(unique(c(col_subs, pretty(col_lim, 80))))
    colorspal <- palette(n = length(levels)-1)
    dates <- data[, 1]
    matrix_var <- data.matrix(data[, -1])
    if(is.null(xaxis)){
      xaxis <- get_xaxis(dates)
    }
    
    yaxis <- get_yaxis_2D(z_out, reference, prefix=title_prefix)
    plot_layout(xaxis, yaxis, add=TRUE)
    .filled.contour(x = dates, y = z_out, z =matrix_var,
                    levels= levels,
                    col=colorspal)
    overlays # will plot any overlay functions
    axis_layout(xaxis, yaxis) #doing this after heatmap so the axis are on top
    
    #fake for colorkey:
    col_lim = range(-5,6)
    col_subs <- head(pretty(col_lim, 12), -1)
    levels <- sort(unique(c(col_subs, pretty(col_lim, 15))))
    palette <- colorRampPalette(c("blue4","blue","deepskyblue", "lightblue1", "lightcyan","white", "lightpink","lightcoral","indianred","firebrick","red"))
    colorspal <- palette(n = length(levels)-1)
    color_key_diff(levels, colorspal, subs=col_subs, col_label = bar_title)
  }
  
  
  
  
  get_yaxis_2D <- function(z_out, reference, prefix=NULL, suffix=NULL){
    
    if (length(z_out) < 2){stop('z_out must be larger than 1 for heatmap plots')}
    
    if (reference == 'surface'){
      lim <- c(max(z_out), 0)
      title <- paste(prefix,' Depth (m) ',suffix, sep='')
    } else {
      lim <- c(0, max(z_out))
      title <- paste(prefix,' Elevation (m) ',suffix, sep='')
    }
    
    yaxis <- get_yaxis(data = z_out, title = title, lim = lim)
    return(yaxis) 
  }
  
  get_yaxis <- function(data, title, lim = NULL){
    if (is.null(lim)){
      mn <- min(data, na.rm = TRUE)
      mx <- max(data, na.rm = TRUE)
      axBuff <- diff(c(mn, mx))*0.1
      lim <- c(mn-axBuff, mx+axBuff)
    }
    
    ticks <- pretty(data)
    yaxis <- list('lim'=lim, 'ticks'=ticks, 'title' = title)
    return(yaxis) 
  }
  
  
  plot_layout <- function(xaxis=NULL, yaxis=NULL, add, data = NA){
    
    if (!add){
      panels <- colbar_layout()
    }
    
    
    plot(data, xlim = xaxis$lim,
         ylim=yaxis$lim,
         xlab=xaxis$x_lab, ylab=' ',
         frame=FALSE,axes=FALSE,xaxs="i",yaxs="i")
    
    
  }
  
  axis_layout <- function(xaxis, yaxis){
    # x axis
    axis(side = 1, labels=format(xaxis$vis_time, xaxis$time_form), at = xaxis$vis_time, tck = -0.01, pos = yaxis$lim[1])
    axis(side = 3, labels=NA, at = xaxis$lim, tck = 0)
    axis(side = 2, at = yaxis$ticks, tck = -0.01, pos = xaxis$lim[1])
    ol_par <- par()$mgp
    par(mgp=c(0,1.5,0))
    axis(side = 2, at = mean(yaxis$lim), tck = 0,  labels=yaxis$title)
    par(mgp=ol_par)
    axis(side = 4, labels=NA, at = yaxis$lim, tck = 0)
  }
  
  color_key <- function(levels, colors, subs, cex = 0.75, col_label){
    # add feau plot
    plot(NA, xlim = c(0,1),
         ylim=c(0,1),
         xlab="", ylab="",
         frame=FALSE,axes=FALSE,xaxs="i",yaxs="i")
    old_mgp <- par()$mgp
    old_mai <- par()$mai
    par(mai=c(old_mai[1],0, old_mai[3], 0), mgp = c(-1,-1,0))
    axis(side = 4, at = 0.5, tck = NA, labels= col_label, lwd = 0.0)#(\xB0 C)
    spc_pol_rat <- 0.2 # ratio between spaces and bars
    
    p_start <- 0.1
    p_wid <- 0.55
    
    # plotting to a 1 x 1 space
    if (!all(subs %in% levels)) stop('selected values must be included in levels')
    
    
    num_poly <- length(subs)
    num_spc <- num_poly - 1
    total_height <- num_poly + spc_pol_rat * num_spc
    
    poly_h <- 1/total_height
    spc_h <- spc_pol_rat * poly_h
    
    for (i in 1:num_poly){
      col <- colors[levels==subs[i]]
      b <- (i-1)*(poly_h+spc_h)
      t <- b+poly_h
      m <- mean(c(b,t))
      polygon(c(p_start,p_wid,p_wid,p_start),c(b,b,t,t),col = col, border = NA)
      text(p_wid+0.025,m,as.character(subs[i]), cex = cex, adj = c(0.5, 1), srt = 90)
    }
    par(mai = old_mai, mgp = old_mgp)
  }
  
  color_key_diff <- function(levels, colors, subs, cex = 0.75, col_label){
    # add feau plot
    plot(NA, xlim = c(0,1),
         ylim=c(0,1),
         xlab="", ylab="",
         frame=FALSE,axes=FALSE,xaxs="i",yaxs="i")
    old_mgp <- par()$mgp
    old_mai <- par()$mai
    par(mai=c(old_mai[1],0, old_mai[3], 0), mgp = c(-1,-1,0))
    axis(side = 4, at = 0.5, tck = NA, labels= col_label, lwd = 0.0)#(\xB0 C)
    spc_pol_rat <- 0.2 # ratio between spaces and bars
    
    p_start <- 0.1
    p_wid <- 0.55
    
    # plotting to a 1 x 1 space
    if (!all(subs %in% levels)) stop('selected values must be included in levels')
    
    
    num_poly <- length(subs)
    num_spc <- num_poly - 1
    total_height <- num_poly + spc_pol_rat * num_spc
    
    poly_h <- 1/total_height
    spc_h <- spc_pol_rat * poly_h
    
    for (i in 1:num_poly){
      col <- colors[levels==subs[i]]
      b <- (i-1)*(poly_h+spc_h)
      t <- b+poly_h
      m <- mean(c(b,t))
      polygon(c(p_start,p_wid,p_wid,p_start),c(b,b,t,t),col = col, border = NA)
      if (i==1)
        text(p_wid+0.025,m,paste0("<= ",as.character(subs[i])), cex = cex, adj = c(0.5, 1), srt = 90)
      else if (i==num_poly)
        text(p_wid+0.025,m,paste0(">= ",as.character(subs[i])), cex = cex, adj = c(0.5, 1), srt = 90)
      else
        text(p_wid+0.025,m,as.character(subs[i]), cex = cex, adj = c(0.5, 1), srt = 90)
    }
    par(mai = old_mai, mgp = old_mgp)
  }
  
  #RMSE
  
  rmse_frame <- compare_to_field(nc_file, dir_field_temp,metric = 'water.temperature', as_value = TRUE) 
  rmse_frame <- calculate_diff_modell_field(data_frame = rmse_frame)
  rmse<- calculate_RMSE(rmse_frame)
  
  #modify par()
  gen_default_fig(filename=FALSE, num_divs=2)
  #.stacked_layout(TRUE, num_divs=1) #only 1 contourplot per page
  colbar_layout(2)
  obs_df <- data.frame(interped$z)
  mod_df <- data.frame(interped2$z)
  difff = interped2$z-interped$z
  diff_df = data.frame(difff) #modeled - obs
  
  names(diff_df) <- paste('diff_', y_out, sep='')
  diff_df <- cbind(data.frame(DateTime=as.POSIXct(x_out, origin='1970-01-01')), diff_df)
  
  names(obs_df) <- paste('var_', y_out, sep='')
  obs_df <- cbind(data.frame(DateTime=as.POSIXct(x_out, origin='1970-01-01')), obs_df)
  
  xaxis <- get_xaxis(model_df[,1])
  y.text = y_out[length(y_out)]-diff(range(y_out))*0.1
  # for Label Position in the upper left corner of the plot
  # y.text = y_out[1]+diff(range(y_out))*0.05
  
  col_lim = range(difff, na.rm = TRUE)
  
  #for contourplot with modeled AND observed data
  xaxis2 <- get_xaxis(model_df[,1])
  col_lim2 = range(range(interped$z, na.rm = TRUE), range(interped2$z, na.rm = TRUE))
 
  if(datapoints==4){
  #pdf('diff_contourplot.pdf')  #doesn't work properly as the legend will be on a new page
  .plot_df_heatmap_diff(diff_df, bar_title = paste('Temperature Difference: Modeled - Observed RMSE_Temp =', round(rmse, 2)), xaxis=xaxis)
  
  dev.copy(pdf,"difference_contourplot.pdf") # copies the "screen" to PDF
  dev.off()
  #reset par()
  par(start_par)}
  
  
  
  ###PLOT WITH BOTH DATA: MODELED AND OBSERVED WITH DATAPOINTS
  
  if(datapoints==2){
  gen_default_fig(filename=FALSE, num_divs=2)#, omi = c(0.1, 0.5, 0, 0))
  .stacked_layout(T, num_divs=2)

  .plot_df_heatmap(obs_df, bar_title = 'Temperature (°C): Observed', overlays=c(points(x=x,y=y, pch = 19, cex = 0.2),text(x_out[1],y=y.text,'observed', pos=4, offset = 1, col = "white", font = 2)), xaxis=xaxis2, col_lim=col_lim2)
  .plot_df_heatmap(model_df, bar_title = paste('Temperature (°C): Modeled RMSE_Temp =', round(rmse, 2), '°C'), overlays=text(x_out[1],y=y.text,'modeled', pos=4, offset = 1, col = "white", font = 2), xaxis=xaxis2, col_lim=col_lim2)
  dev.copy(pdf,"contourplot_with_datapoints.pdf") # copies the "screen" to PDF
  dev.off()
  #reset par()
  par(start_par)}
  
  
  ###PLOT WITH BOTH DATA: MODELED AND OBSERVED WITHOUT DATAPOINTS
  
  if(datapoints==3){
    gen_default_fig(filename=FALSE, num_divs=2)#, omi = c(0.1, 0.5, 0, 0))
    .stacked_layout(T, num_divs=2)
    
    .plot_df_heatmap(obs_df, bar_title = 'Temperature (°C): Observed', overlays=text(x_out[1],y=y.text,'observed', pos=4, offset = 1, col = "white", font = 2), xaxis=xaxis2, col_lim=col_lim2)
    .plot_df_heatmap(model_df, bar_title = paste('Temperature (°C): Modeled RMSE_Temp =', round(rmse, 2), '°C'), overlays=text(x_out[1],y=y.text,'modeled', pos=4, offset = 1, col = "white", font = 2), xaxis=xaxis2, col_lim=col_lim2)
    dev.copy(pdf,"contourplot_without_datapoints.pdf") # copies the "screen" to PDF
    dev.off()
    #reset par()
    par(start_par)}
 
  
}
