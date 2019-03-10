
<!-- README.md is generated from README.Rmd. Please edit that file -->

# glmgui

Mirror of the `glmgui` package: <https://doi.org/10.5281/zenodo.2025865>

## Installation

``` r
devtools::install_github("jsta/glmgui")
```

## Usage

``` r
library(glmgui)

glmGUI()
```

<details>

<summary>devtools::check() output</summary>

    #> Updating glmgui documentation
    #> Warning: roxygen2 requires Encoding: UTF-8
    #> Writing NAMESPACE
    #> Loading glmgui
    #> Writing NAMESPACE
    #> ── Building ───────────────────────────────────────────────────────────────────────── glmgui ──
    #> Setting env vars:
    #> ● CFLAGS    : -Wall -pedantic
    #> ● CXXFLAGS  : -Wall -pedantic
    #> ● CXX11FLAGS: -Wall -pedantic
    #> ───────────────────────────────────────────────────────────────────────────────────────────────
    #>   
       checking for file ‘/home/jose/R/scripts/glmgui/DESCRIPTION’ ...
      
    ✔  checking for file ‘/home/jose/R/scripts/glmgui/DESCRIPTION’
    #> 
      
    ─  preparing ‘glmgui’:
    #> 
      
       checking DESCRIPTION meta-information ...
      
    ✔  checking DESCRIPTION meta-information
    #> 
      
    ─  checking for LF line-endings in source and make files and shell scripts
    #> 
      
    ─  checking for empty or unneeded directories
    #> ─  looking to see if a ‘data/datalist’ file should be added
    #> 
      
    ─  building ‘glmgui_1.0.tar.gz’
    #> 
      
       
    #> 
    ── Checking ───────────────────────────────────────────────────────────────────────── glmgui ──
    #> Setting env vars:
    #> ● _R_CHECK_CRAN_INCOMING_USE_ASPELL_: TRUE
    #> ● _R_CHECK_CRAN_INCOMING_REMOTE_    : FALSE
    #> ● _R_CHECK_CRAN_INCOMING_           : FALSE
    #> ● _R_CHECK_FORCE_SUGGESTS_          : FALSE
    #> ── R CMD check ────────────────────────────────────────────────────────────
    #>   
    ─  using log directory ‘/tmp/RtmpgPTdav/glmgui.Rcheck’
    #> 
      
    ─  using R version 3.5.2 (2018-12-20)
    #> ─  using platform: x86_64-pc-linux-gnu (64-bit)
    #> ─  using session charset: UTF-8
    #> 
      
    ─  using options ‘--no-manual --as-cran’ (688ms)
    #> 
      
    ✔  checking for file ‘glmgui/DESCRIPTION’
    #> ─  this is package ‘glmgui’ version ‘1.0’
    #> ✔  checking package namespace information
    #>    checking package dependencies ...
      
    ✔  checking package dependencies (1.4s)
    #> 
      
    ✔  checking if this is a source package
    #> ✔  checking if there is a namespace
    #> 
      
       checking for executable files ...
      
    ✔  checking for executable files (371ms)
    #> 
      
    ✔  checking for hidden files and directories
    #> ✔  checking for portable file names
    #> ✔  checking for sufficient/correct file permissions
    #> 
      
    ✔  checking serialization versions
    #>    checking whether package ‘glmgui’ can be installed ...
      
    ✔  checking whether package ‘glmgui’ can be installed (3.7s)
    #> 
      
       checking installed package size ...
      
    N  checking installed package size
    #> 
      
         installed size is 21.6Mb
    #>      sub-directories of 1Mb or more:
    #> 
      
           extdata  21.3Mb
    #> 
      
       checking package directory ...
      
    ✔  checking package directory
    #>    checking DESCRIPTION meta-information ...
      
    ✔  checking DESCRIPTION meta-information
    #> 
      
    ✔  checking top-level files
    #> ✔  checking for left-over files
    #> ✔  checking index information
    #>    checking package subdirectories ...
      
    ✔  checking package subdirectories
    #> 
      
       checking R files for non-ASCII characters ...
      
    ✔  checking R files for non-ASCII characters
    #> 
      
       checking R files for syntax errors ...
      
    ✔  checking R files for syntax errors
    #> 
      
       checking whether the package can be loaded ...
      
    ✔  checking whether the package can be loaded (470ms)
    #> 
      
       checking whether the package can be loaded with stated dependencies ...
      
    ✔  checking whether the package can be loaded with stated dependencies (456ms)
    #> 
      
       checking whether the package can be unloaded cleanly ...
      
    ✔  checking whether the package can be unloaded cleanly (448ms)
    #> 
      
       checking whether the namespace can be loaded with stated dependencies ...
      
    ✔  checking whether the namespace can be loaded with stated dependencies (457ms)
    #> 
      
       checking whether the namespace can be unloaded cleanly ...
      
    ✔  checking whether the namespace can be unloaded cleanly (467ms)
    #>    checking loading without being on the library search path ...
      
    ✔  checking loading without being on the library search path (521ms)
    #> 
      
       checking dependencies in R code ...
      
    W  checking dependencies in R code (847ms)
    #>    'library' or 'require' calls not declared from:
    #>      ‘GLMr’ ‘glmtools’
    #>    'library' or 'require' calls in package code:
    #>      ‘GLMr’ ‘glmtools’
    #>      Please use :: or requireNamespace() instead.
    #>      See section 'Suggested packages' in the 'Writing R Extensions' manual.
    #> 
      
       checking S3 generic/method consistency ...
      
    ✔  checking S3 generic/method consistency (1s)
    #> 
      
       checking replacement functions ...
      
    ✔  checking replacement functions (582ms)
    #> 
      
       checking foreign function calls ...
      
    ✔  checking foreign function calls (777ms)
    #> 
      
       checking R code for possible problems ...
      
    N  checking R code for possible problems (7.8s)
    #> 
      
       build_model: no visible binding for '<<-' assignment to
    #>      ‘label_status_build’
    #>    build_model: no visible binding for global variable
    #>      ‘label_status_build’
    #>    build_model: no visible binding for global variable ‘List_values’
    #>    build_model: no visible binding for global variable ‘button_build’
    #>    build_model: no visible binding for '<<-' assignment to ‘dir_output’
    #>    build_model: no visible binding for global variable ‘dir_output’
    #>    build_model: no visible global function definition for ‘read_nml’
    #>    build_model: no visible global function definition for ‘get_nml_value’
    #>    build_model: no visible global function definition for ‘set_nml’
    #>    build_model: no visible binding for global variable ‘List_parameter’
    #>    build_model: no visible global function definition for ‘write_nml’
    #>    build_model: no visible binding for global variable
    #>      ‘checkbox_Level_plot’
    #>    build_model: no visible binding for global variable
    #>      ‘checkbox_Level_rmse’
    #>    build_model: no visible binding for global variable ‘dir_field_level’
    #>    build_model: no visible binding for global variable
    #>      ‘checkbox_Temp_plot’
    #>    build_model: no visible binding for global variable
    #>      ‘checkbox_Temp_rmse’
    #>    build_model: no visible global function definition for
    #>      ‘compare_to_field’
    #>    build_model: no visible binding for global variable ‘dir_field_temp’
    #>    build_model: no visible global function definition for ‘dev.cur’
    #>    build_model: no visible global function definition for ‘plot’
    #>    build_model: no visible binding for global variable
    #>      ‘checkbox_Temp_plot2’
    #>    build_model: no visible binding for global variable
    #>      ‘checkbox_Temp_plot3’
    #>    build_model: no visible binding for global variable
    #>      ‘checkbox_Temp_plot4’
    #>    build_model: no visible binding for '<<-' assignment to ‘button_build’
    #>    calculate_SI_value: no visible binding for '<<-' assignment to
    #>      ‘dir_output’
    #>    calculate_SI_value: no visible binding for global variable ‘dir_output’
    #>    calculate_SI_value: no visible global function definition for
    #>      ‘read_nml’
    #>    calculate_SI_value: no visible global function definition for
    #>    ‘get_nml_
      
         ‘get_nml_value’
    #>    calculate_SI_value: no visible global function definition for ‘set_nml’
    #>    calculate_SI_value: no visible global function definition for
    #>      ‘write_nml’
    #>    calculate_SI_value: no visible global function definition for
    #>      ‘compare_to_field’
    #>    calculate_SI_value: no visible binding for global variable
    #>      ‘dir_field_temp’
    #>    calculate_SI_value: no visible binding for global variable
    #>      ‘dir_field_level’
    #>    calculate_SI_value: no visible global function definition for
    #>      ‘write.csv’
    #>    calculate_SI_value: no visible global function definition for ‘dev.cur’
    #>    calculate_SI_value: no visible global function definition for ‘par’
    #>    calculate_SI_value: no visible global function definition for ‘barplot’
    #>    calculate_aov: no visible global function definition for ‘stack’
    #>    calculate_aov: no visible global function definition for ‘aov’
    #>    calculate_auto_kalib: no visible binding for '<<-' assignment to
    #>      ‘dir_output’
    #>    calculate_auto_kalib: no visible binding for global variable
    #>      ‘dir_output’
    #>    calculate_auto_kalib: no visible global function definition for
    #>      ‘read_nml’
    #>    calculate_auto_kalib: no visible global function definition for
    #>      ‘get_nml_value’
    #>    calculate_auto_kalib: no visible binding for global variable
    #>      ‘but_cal_si_auto’
    #>    calculate_auto_kalib: no visible global function definition for
    #>      ‘set_nml’
    #>    calculate_auto_kalib: no visible global function definition for
    #>      ‘write_nml’
    #>    calculate_auto_kalib: no visible global function definition for
    #>      ‘compare_to_field’
    #>    calculate_auto_kalib: no visible binding for global variable
    #>      ‘dir_field_temp’
    #>    calculate_auto_kalib: no visible binding for global variable
    #>      ‘dir_field_level’
    #>    calculate_auto_kalib: no visible global function definition for
    #>      ‘write.table’
    #>    check_data_connection: no visible global function definition for
    #>      ‘read_nml’
    #>    check_data_connection: no visible global function definition for
    #>      ‘get_nml_value’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘button_confi’
    #>    check_data_connection: no visible binding for global variable
    #>    ‘butt
      
         ‘button_confi’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘button_set_parameter’
    #>    check_data_connection: no visible binding for global variable
    #>      ‘button_set_parameter’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘button_build’
    #>    check_data_connection: no visible binding for global variable
    #>      ‘button_build’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘button_cal_SI_value’
    #>    check_data_connection: no visible binding for global variable
    #>      ‘button_cal_SI_value’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘button_field_level’
    #>    check_data_connection: no visible binding for global variable
    #>      ‘button_field_level’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘button_field_temp’
    #>    check_data_connection: no visible binding for global variable
    #>      ‘button_field_temp’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘button_autocalib’
    #>    check_data_connection: no visible binding for global variable
    #>      ‘button_autocalib’
    #>    check_data_connection: no visible binding for '<<-' assignment to ‘l’
    #>    check_data_connection: no visible binding for '<<-' assignment to ‘k’
    #>    check_data_connection: no visible binding for global variable ‘l’
    #>    check_data_connection: no visible binding for global variable ‘k’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘dir_meteo’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘arg_meteo’
    #>    check_data_connection: no visible binding for global variable
    #>      ‘dir_meteo’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘label_met_data’
    #>    check_data_connection: no visible binding for global variable
    #>      ‘label_met_data’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘multi_inflow’
    #>    check_data_connection: no visible binding for global variable
    #>      ‘multi_inflow’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘label_inflow_data’
    #> check_data_connection: no visible 
      
       check_data_connection: no visible binding for global variable
    #>      ‘label_inflow_data’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘arg_inflow’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘dir_inflow’
    #>    check_data_connection: no visible binding for global variable
    #>      ‘dir_inflow’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘multi_outflow’
    #>    check_data_connection: no visible binding for global variable
    #>      ‘multi_outflow’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘label_outflow_data’
    #>    check_data_connection: no visible binding for global variable
    #>      ‘label_outflow_data’
    #>    check_data_connection: no visible binding for '<<-' assignment to
    #>      ‘dir_outflow’
    #>    check_data_connection: no visible binding for global variable
    #>      ‘dir_outflow’
    #>    get_dataframe_Level_Lake: no visible global function definition for
    #>      ‘read.csv’
    #>    get_dataframe_Level_Lake: no visible global function definition for
    #>      ‘na.omit’
    #>    get_parameter: no visible global function definition for ‘read_nml’
    #>    get_parameter: no visible global function definition for
    #>      ‘get_nml_value’
    #>    get_pre_list_of_default_values: no visible binding for global variable
    #>      ‘workspace’
    #>    get_pre_list_of_default_values: no visible global function definition
    #>      for ‘read_nml’
    #>    get_pre_list_of_default_values: no visible global function definition
    #>      for ‘get_nml_value’
    #>    glmGUI: no visible global function definition for ‘install.packages’
    #>    set_cali_boundary : <anonymous>: no visible binding for '<<-'
    #>      assignment to ‘boundary.env’
    #>    set_cali_boundary : <anonymous>: no visible binding for global variable
    #>      ‘boundary.env’
    #>    set_parameter: no visible binding for '<<-' assignment to ‘cb’
    #>    set_parameter: no visible binding for global variable ‘l’
    #>    set_parameter : <anonymous>: no visible binding for global variable
    #>      ‘List_parameter’
    #>    set_parameter : <anonymous>: no visible global function definition for
    #>      ‘read_nml’
    #>    set_parameter : <anonymous>: no visible binding for '<<-' assignment to
    #>      ‘gewaehlterwert’
    #> set_paramet
      
       set_parameter : <anonymous>: no visible global function definition for
    #>      ‘get_nml_value’
    #>    set_parameter : <anonymous>: no visible binding for global variable
    #>      ‘cb’
    #>    set_parameter : <anonymous>: no visible binding for global variable
    #>      ‘gewaehlterwert’
    #>    set_parameter : <anonymous>: no visible binding for '<<-' assignment to
    #>      ‘gewaehlt’
    #>    set_parameter: no visible binding for '<<-' assignment to
    #>      ‘button_set_parameter’
    #>    set_parameter : <anonymous>: no visible binding for '<<-' assignment to
    #>      ‘List_parameter_temp’
    #>    set_parameter : <anonymous>: no visible binding for global variable
    #>      ‘List_parameter_temp’
    #>    set_parameter : <anonymous>: no visible binding for '<<-' assignment to
    #>      ‘List_parameter’
    #>    set_parameter : <anonymous>: no visible binding for '<<-' assignment to
    #>      ‘List_values’
    #>    set_parameter : <anonymous>: no visible binding for '<<-' assignment to
    #>      ‘label_nml_range’
    #>    set_parameter : <anonymous>: no visible binding for global variable
    #>      ‘label_nml_range’
    #>    set_parameter : <anonymous>: no visible global function definition for
    #>      ‘set_nml’
    #>    set_parameter : <anonymous>: no visible binding for global variable
    #>      ‘gewaehlt’
    #>    set_parameter : <anonymous>: no visible global function definition for
    #>      ‘write_nml’
    #>    show_write_dialog : <anonymous>: no visible binding for global variable
    #>      ‘dir_field_temp’
    #>    show_write_dialog : <anonymous>: no visible binding for global variable
    #>      ‘dir_field_level’
    #>    show_write_dialog : <anonymous>: no visible global function definition
    #>      for ‘write.csv’
    #>    window_input_csv_to_plot: no visible global function definition for
    #>      ‘read.csv’
    #>    window_input_csv_to_plot: no visible binding for '<<-' assignment to
    #>      ‘list_missing_data’
    #>    window_input_csv_to_plot : repair_input: no visible global function
    #>      definition for ‘na.kalman’
    #>    window_input_csv_to_plot : repair_input: no visible binding for global
    #>      variable ‘list_missing_data’
    #>    window_input_csv_to_plot : updatePlots_repair: no visible global
    #>      function definition for ‘dev.set’
    #> window_input_csv_to_plot : updatePlots_repair: no vi
      
       window_input_csv_to_plot : updatePlots_repair: no visible global
    #>      function definition for ‘plot’
    #>    window_input_csv_to_plot : updatePlots_repair: no visible global
    #>      function definition for ‘na.omit’
    #>    window_input_csv_to_plot : updatePlots_repair: no visible binding for
    #>      global variable ‘list_missing_data’
    #>    window_input_csv_to_plot : updatePlots_repair: no visible global
    #>      function definition for ‘points’
    #>    window_input_csv_to_plot : updatePlots_repair: no visible global
    #>      function definition for ‘legend’
    #>    window_input_csv_to_plot: no visible global function definition for
    #>      ‘dev.cur’
    #>    window_input_csv_to_plot : <anonymous>: no visible binding for '<<-'
    #>      assignment to ‘list_missing_data’
    #>    window_input_csv_to_plot : updatePlots: no visible global function
    #>      definition for ‘dev.set’
    #>    window_input_csv_to_plot : updatePlots: no visible global function
    #>      definition for ‘plot’
    #>    window_input_csv_to_plot : updatePlots: no visible global function
    #>      definition for ‘na.omit’
    #>    window_input_csv_to_plot : updatePlots: no visible binding for global
    #>      variable ‘list_missing_data’
    #>    window_input_csv_to_plot : updatePlots: no visible global function
    #>      definition for ‘points’
    #>    window_input_csv_to_plot : check_null: no visible binding for '<<-'
    #>      assignment to ‘list_missing_data’
    #>    window_input_csv_to_plot : check_null: no visible binding for global
    #>      variable ‘list_missing_data’
    #>    window_input_csv_to_plot : check_null: no visible binding for '<<-'
    #>      assignment to ‘list_0_data’
    #>    window_input_csv_to_plot : check_null: no visible global function
    #>      definition for ‘na.omit’
    #>    window_input_csv_to_plot : check_null: no visible binding for global
    #>      variable ‘list_0_data’
    #>    window_input_csv_to_plot2: no visible global function definition for
    #>      ‘read.csv’
    #>    window_input_csv_to_plot2: no visible binding for global variable
    #>      ‘dir_field_temp’
    #>    window_input_csv_to_plot2: no visible binding for '<<-' assignment to
    #>      ‘list_missing_data’
    #>    window_input_csv_to_plot2 : check_null: no visible binding for '<<-'
    #>      assignment to ‘list_missing_data’
    #> window_input_csv_to_plot2 : check_
      
       window_input_csv_to_plot2 : check_null: no visible binding for global
    #>      variable ‘list_missing_data’
    #>    window_input_csv_to_plot2: no visible binding for global variable
    #>      ‘dir_field_level’
    #>    window_input_csv_to_plot2: no visible global function definition for
    #>      ‘dev.cur’
    #>    window_input_csv_to_plot2 : <anonymous>: no visible binding for '<<-'
    #>      assignment to ‘list_missing_data’
    #>    window_input_csv_to_plot2 : updatePlots: no visible global function
    #>      definition for ‘dev.set’
    #>    window_input_csv_to_plot2 : updatePlots: no visible global function
    #>      definition for ‘plot’
    #>    window_input_csv_to_plot2 : updatePlots: no visible global function
    #>      definition for ‘na.omit’
    #>    window_output_csv_to_plot: no visible global function definition for
    #>      ‘read.csv’
    #>    window_output_csv_to_plot: no visible global function definition for
    #>      ‘dev.cur’
    #>    window_output_csv_to_plot : updatePlots: no visible global function
    #>      definition for ‘dev.set’
    #>    window_output_csv_to_plot : updatePlots: no visible global function
    #>      definition for ‘plot’
    #>    window_output_csv_to_plot : updatePlots: no visible global function
    #>      definition for ‘lines’
    #>    window_output_csv_to_plot : updatePlots: no visible global function
    #>      definition for ‘lowess’
    #>    window_plot_RMSE: no visible binding for global variable ‘List_values’
    #>    window_plot_RMSE: no visible binding for global variable
    #>      ‘List_parameter’
    #>    window_plot_RMSE: no visible global function definition for ‘plot’
    #>    window_plot_RMSE: no visible global function definition for ‘lines’
    #>    window_plot_RMSE: no visible global function definition for
    #>      ‘shapiro.test’
    #>    window_plot_RMSE: no visible global function definition for ‘points’
    #>    window_plot_dataframe_Level_Lake: no visible binding for '<<-'
    #>      assignment to ‘dir_output’
    #>    window_plot_dataframe_Level_Lake: no visible global function definition
    #>      for ‘read_nml’
    #>    window_plot_dataframe_Level_Lake: no visible binding for global
    #>      variable ‘dir_output’
    #>    window_plot_dataframe_Level_Lake: no visible global function definition
    #>      for ‘get_nml_value’
    #> window_plot_dataframe_Level_Lake: no visible globa
      
       window_plot_dataframe_Level_Lake: no visible global function definition
    #>      for ‘read.csv’
    #>    window_plot_dataframe_Level_Lake: no visible global function definition
    #>      for ‘plot’
    #>    window_plot_dataframe_Level_Lake: no visible global function definition
    #>      for ‘lines’
    #>    window_plot_dataframe_Level_Lake: no visible global function definition
    #>      for ‘legend’
    #>    window_plot_dataframe_Level_Lake: no visible global function definition
    #>      for ‘strwidth’
    #>    window_plot_list_graph: no visible global function definition for ‘par’
    #>    window_plot_list_graph: no visible global function definition for
    #>      ‘n2mfrow’
    #>    window_plot_list_graph: no visible global function definition for
    #>      ‘plot’
    #>    window_plot_list_graph: no visible global function definition for
    #>      ‘points’
    #>    window_plot_list_graph: no visible global function definition for
    #>      ‘lines’
    #>    window_plot_list_temp: no visible global function definition for ‘par’
    #>    window_plot_list_temp: no visible global function definition for
    #>      ‘n2mfrow’
    #>    window_plot_list_temp: no visible global function definition for ‘plot’
    #>    window_plot_list_temp: no visible global function definition for
    #>      ‘points’
    #>    window_plot_list_temp: no visible global function definition for
    #>      ‘lines’
    #>    window_plot_model_output: no visible global function definition for
    #>      ‘sim_vars’
    #>    window_plot_model_output: no visible global function definition for
    #>      ‘dev.cur’
    #>    window_plot_model_output : updatePlots: no visible global function
    #>      definition for ‘dev.set’
    #>    window_plot_model_output : updatePlots: no visible global function
    #>      definition for ‘plot_var’
    #>    window_plot_multi_histo: no visible global function definition for
    #>      ‘par’
    #>    window_plot_multi_histo: no visible global function definition for
    #>      ‘shapiro.test’
    #>    window_plot_multi_histo: no visible global function definition for
    #>      ‘hist’
    #>    window_plot_multi_histo: no visible binding for global variable
    #>      ‘List_values’
    #>    window_plot_temp_compare: no visible global function definition for
    #>      ‘dev.cur’
    #>    window_plot_temp_compare: no visible global function definition for
    #>      ‘par’
    #> window_plot_temp_compare: no visible global 
      
       window_plot_temp_compare: no visible global function definition for
    #>      ‘get_var’
    #>    window_plot_temp_compare: no visible global function definition for
    #>      ‘get.offsets’
    #>    window_plot_temp_compare: no visible global function definition for
    #>      ‘resample_to_field’
    #>    window_plot_temp_compare: no visible global function definition for
    #>      ‘resample_sim’
    #>    window_plot_temp_compare: no visible global function definition for
    #>      ‘interp’
    #>    window_plot_temp_compare : gen_default_fig: no visible global function
    #>      definition for ‘valid_fig_path’
    #>    window_plot_temp_compare : gen_default_fig: no visible global function
    #>      definition for ‘png’
    #>    window_plot_temp_compare : gen_default_fig: no visible global function
    #>      definition for ‘par’
    #>    window_plot_temp_compare : .stacked_layout: no visible global function
    #>      definition for ‘.simple_layout’
    #>    window_plot_temp_compare : colbar_layout: no visible global function
    #>      definition for ‘layout’
    #>    window_plot_temp_compare : .plot_df_heatmap: no visible global function
    #>      definition for ‘colorRampPalette’
    #>    window_plot_temp_compare : .plot_df_heatmap: no visible global function
    #>      definition for ‘head’
    #>    window_plot_temp_compare : .plot_df_heatmap: no visible global function
    #>      definition for ‘.filled.contour’
    #>    window_plot_temp_compare : .plot_df_heatmap_diff: no visible global
    #>      function definition for ‘colorRampPalette’
    #>    window_plot_temp_compare : .plot_df_heatmap_diff: no visible global
    #>      function definition for ‘head’
    #>    window_plot_temp_compare : .plot_df_heatmap_diff: no visible global
    #>      function definition for ‘.filled.contour’
    #>    window_plot_temp_compare : plot_layout: no visible global function
    #>      definition for ‘plot’
    #>    window_plot_temp_compare : axis_layout: no visible global function
    #>      definition for ‘axis’
    #>    window_plot_temp_compare : axis_layout: no visible global function
    #>      definition for ‘par’
    #>    window_plot_temp_compare : color_key: no visible global function
    #>      definition for ‘plot’
    #>    window_plot_temp_compare : color_key: no visible global function
    #>      definition for ‘par’
    #> window_plot_temp_compare : color_key: no visibl
      
       window_plot_temp_compare : color_key: no visible global function
    #>      definition for ‘axis’
    #>    window_plot_temp_compare : color_key: no visible global function
    #>      definition for ‘polygon’
    #>    window_plot_temp_compare : color_key: no visible global function
    #>      definition for ‘text’
    #>    window_plot_temp_compare : color_key_diff: no visible global function
    #>      definition for ‘plot’
    #>    window_plot_temp_compare : color_key_diff: no visible global function
    #>      definition for ‘par’
    #>    window_plot_temp_compare : color_key_diff: no visible global function
    #>      definition for ‘axis’
    #>    window_plot_temp_compare : color_key_diff: no visible global function
    #>      definition for ‘polygon’
    #>    window_plot_temp_compare : color_key_diff: no visible global function
    #>      definition for ‘text’
    #>    window_plot_temp_compare: no visible global function definition for
    #>      ‘compare_to_field’
    #>    window_plot_temp_compare: no visible global function definition for
    #>      ‘dev.copy’
    #>    window_plot_temp_compare: no visible binding for global variable ‘pdf’
    #>    window_plot_temp_compare: no visible global function definition for
    #>      ‘dev.off’
    #>    window_plot_temp_compare: no visible global function definition for
    #>      ‘points’
    #>    window_plot_temp_compare: no visible global function definition for
    #>      ‘text’
    #>    window_select_SI_calculation : <anonymous>: no visible binding for
    #>      global variable ‘dir_field_temp’
    #>    window_select_SI_calculation : <anonymous>: no visible binding for
    #>      global variable ‘dir_field_level’
    #>    window_select_SI_calculation : <anonymous>: no visible binding for
    #>      global variable ‘label_status_SI_calculation’
    #>    window_select_SI_calculation: no visible binding for '<<-' assignment
    #>      to ‘label_status_SI_calculation’
    #>    window_select_auto_kalib : <anonymous>: no visible binding for global
    #>      variable ‘boundary.env’
    #>    window_select_auto_kalib: no visible binding for '<<-' assignment to
    #>      ‘but_cal_si_auto’
    #>    window_select_auto_kalib : <anonymous>: no visible binding for global
    #>      variable ‘dir_field_temp’
    #>    window_select_auto_kalib : <anonymous>: no visible binding for global
    #>      variable ‘dir_field_level’
    #> window_select_auto_ka
      
       window_select_auto_kalib : <anonymous>: no visible binding for global
    #>      variable ‘label_status_CAL_calculation’
    #>    window_select_auto_kalib: no visible binding for '<<-' assignment to
    #>      ‘label_status_CAL_calculation’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘workspace’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘arg_meteo’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘multi_inflow’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘multi_outflow’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘arg_inflow’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘arg_outflow’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘dir_field_temp’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘dir_field_level’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘List_parameter’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘List_values’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘dfList_Temp’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘dfList_Level’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘label_workspace’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘label_workspace_project’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘button_new_workspace’
    #>    windows_main_menu : <anonymous>: no visible binding for '<<-'
    #>      assignment to ‘workspace’
    #>    windows_main_menu : <anonymous>: no visible global function definition
    #>      for ‘read_nml’
    #>    windows_main_menu : <anonymous>: no visible global function definition
    #>      for ‘write_nml’
    #>    windows_main_menu : <anonymous>: no visible binding for global variable
    #>      ‘workspace’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘button_workspace’
    #>    windows_main_menu : <anonymous> : <anonymous>: no visible global
    #>      function definition for ‘read_nml’
    #>    windows_main_menu : <anonymous> : <anonymous>: no visible global
    #> 
      
         function definition for ‘write_nml’
    #>    windows_main_menu : <anonymous> : <anonymous>: no visible binding for
    #>      global variable ‘workspace’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘label_met_data’
    #>    windows_main_menu : <anonymous>: no visible binding for global variable
    #>      ‘dir_meteo’
    #>    windows_main_menu : <anonymous>: no visible binding for global variable
    #>      ‘arg_meteo’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘label_inflow_data’
    #>    windows_main_menu : <anonymous>: no visible binding for global variable
    #>      ‘multi_inflow’
    #>    windows_main_menu : <anonymous>: no visible binding for global variable
    #>      ‘dir_inflow’
    #>    windows_main_menu : <anonymous>: no visible binding for global variable
    #>      ‘arg_inflow’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘label_outflow_data’
    #>    windows_main_menu : <anonymous>: no visible binding for global variable
    #>      ‘multi_outflow’
    #>    windows_main_menu : <anonymous>: no visible binding for global variable
    #>      ‘dir_outflow’
    #>    windows_main_menu : <anonymous>: no visible binding for global variable
    #>      ‘arg_outflow’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘label_nml_status’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘label_nml_range’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘button_field_temp’
    #>    windows_main_menu : <anonymous>: no visible binding for '<<-'
    #>      assignment to ‘dir_field_temp’
    #>    windows_main_menu : <anonymous>: no visible binding for global variable
    #>      ‘dir_field_temp’
    #>    windows_main_menu: no visible binding for global variable
    #>      ‘button_field_temp’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘label_field_level’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘button_field_level’
    #>    windows_main_menu : <anonymous>: no visible binding for '<<-'
    #>      assignment to ‘dir_field_level’
    #>    windows_main_menu : <anonymous>: no visible binding for global variable
    #>      ‘dir_field_level’
    #> windows_main_menu: no visible binding f
      
       windows_main_menu: no visible binding for global variable
    #>      ‘button_field_level’
    #>    windows_main_menu: no visible binding for '<<-' assignment to
    #>      ‘label_status_build’
    #>    windows_main_menu : <anonymous>: no visible global function definition
    #>      for ‘get_nml_value’
    #>    Undefined global functions or variables:
    #>      .filled.contour .simple_layout List_parameter List_parameter_temp
    #>      List_values aov arg_inflow arg_meteo arg_outflow axis barplot
    #>      boundary.env but_cal_si_auto button_autocalib button_build
    #>      button_cal_SI_value button_confi button_field_level button_field_temp
    #>      button_set_parameter cb checkbox_Level_plot checkbox_Level_rmse
    #>      checkbox_Temp_plot checkbox_Temp_plot2 checkbox_Temp_plot3
    #>      checkbox_Temp_plot4 checkbox_Temp_rmse colorRampPalette
    #>      compare_to_field dev.copy dev.cur dev.off dev.set dir_field_level
    #>      dir_field_temp dir_inflow dir_meteo dir_outflow dir_output
    #>      get.offsets get_nml_value get_var gewaehlt gewaehlterwert head hist
    #>      install.packages interp k l label_inflow_data label_met_data
    #>      label_nml_range label_outflow_data label_status_CAL_calculation
    #>      label_status_SI_calculation label_status_build layout legend lines
    #>      list_0_data list_missing_data lowess multi_inflow multi_outflow
    #>      n2mfrow na.kalman na.omit par pdf plot plot_var png points polygon
    #>      read.csv read_nml resample_sim resample_to_field set_nml shapiro.test
    #>      sim_vars stack strwidth text valid_fig_path workspace write.csv
    #>      write.table write_nml
    #>    Consider adding
    #>      importFrom("grDevices", "colorRampPalette", "dev.copy", "dev.cur",
    #>                 "dev.off", "dev.set", "n2mfrow", "pdf", "png")
    #>      importFrom("graphics", ".filled.contour", "axis", "barplot", "hist",
    #>                 "layout", "legend", "lines", "par", "plot", "points",
    #>                 "polygon", "strwidth", "text")
    #>      importFrom("stats", "aov", "lowess", "na.omit", "shapiro.test")
    #>      importFrom("utils", "head", "install.packages", "read.csv", "stack",
    #>                 "write.csv", "write.table")
    #>    to your NAMESPACE file.
    #>    checking Rd files ...
      
    ✔  checking Rd files
    #> 
      
       checking Rd metadata ...
      
    ✔  checking Rd metadata
    #> 
      
       checking Rd line widths ...
      
    ✔  checking Rd line widths
    #> 
      
       checking Rd cross-references ...
      
    ✔  checking Rd cross-references
    #> 
      
       checking for missing documentation entries ...
      
    W  checking for missing documentation entries (531ms)
    #>    Undocumented code objects:
    #>      ‘glmGUI’
    #>    Undocumented data sets:
    #>      ‘boundary.env’
    #> 
      
       All user-level objects in a package should have documentation entries.
    #>    See chapter ‘Writing R documentation files’ in the ‘Writing R
    #>    Extensions’ manual.
    #>    checking for code/documentation mismatches ...
      
    ✔  checking for code/documentation mismatches (1.6s)
    #> 
      
       checking Rd \usage sections ...
      
    W  checking Rd \usage sections
    #>    Undocumented arguments in documentation object 'windows_main_menu'
    #>      ‘version’
    #>    
    #> 
      
       Functions with \usage entries need to have the appropriate \alias
    #>    entries, and all their arguments documented.
    #>    The \usage entries must correspond to syntactically valid R code.
    #>    See chapter ‘Writing R documentation files’ in the ‘Writing R
    #>    Extensions’ manual.
    #> 
      
       checking Rd contents ...
      
    ✔  checking Rd contents (1s)
    #> 
      
       checking for unstated dependencies in examples ...
      
    ✔  checking for unstated dependencies in examples
    #> 
      
    ✔  checking contents of ‘data’ directory
    #>    checking data for non-ASCII characters ...
      
    ✔  checking data for non-ASCII characters
    #> 
      
       checking data for ASCII and uncompressed saves ...
      
    ✔  checking data for ASCII and uncompressed saves
    #> 
      
       checking examples ...
      
    ─  checking examples ... NONE
    #> 
      
       
    #>    See
    #>      ‘/tmp/RtmpgPTdav/glmgui.Rcheck/00check.log’
    #>    for details.
    #>    
    #>    
    #> 
      
    
    ── R CMD check results ──────────────────────────────────── glmgui 1.0 ────
    #> Duration: 25.7s
    #> 
    #> ❯ checking dependencies in R code ... WARNING
    #>   'library' or 'require' calls not declared from:
    #>     ‘GLMr’ ‘glmtools’
    #>   'library' or 'require' calls in package code:
    #>     ‘GLMr’ ‘glmtools’
    #>     Please use :: or requireNamespace() instead.
    #>     See section 'Suggested packages' in the 'Writing R Extensions' manual.
    #> 
    #> ❯ checking for missing documentation entries ... WARNING
    #>   Undocumented code objects:
    #>     ‘glmGUI’
    #>   Undocumented data sets:
    #>     ‘boundary.env’
    #>   All user-level objects in a package should have documentation entries.
    #>   See chapter ‘Writing R documentation files’ in the ‘Writing R
    #>   Extensions’ manual.
    #> 
    #> ❯ checking Rd \usage sections ... WARNING
    #>   Undocumented arguments in documentation object 'windows_main_menu'
    #>     ‘version’
    #>   
    #>   Functions with \usage entries need to have the appropriate \alias
    #>   entries, and all their arguments documented.
    #>   The \usage entries must correspond to syntactically valid R code.
    #>   See chapter ‘Writing R documentation files’ in the ‘Writing R
    #>   Extensions’ manual.
    #> 
    #> ❯ checking installed package size ... NOTE
    #>     installed size is 21.6Mb
    #>     sub-directories of 1Mb or more:
    #>       extdata  21.3Mb
    #> 
    #> ❯ checking R code for possible problems ... NOTE
    #>   build_model: no visible binding for '<<-' assignment to
    #>     ‘label_status_build’
    #>   build_model: no visible binding for global variable
    #>     ‘label_status_build’
    #>   build_model: no visible binding for global variable ‘List_values’
    #>   build_model: no visible binding for global variable ‘button_build’
    #>   build_model: no visible binding for '<<-' assignment to ‘dir_output’
    #>   build_model: no visible binding for global variable ‘dir_output’
    #>   build_model: no visible global function definition for ‘read_nml’
    #>   build_model: no visible global function definition for ‘get_nml_value’
    #>   build_model: no visible global function definition for ‘set_nml’
    #>   build_model: no visible binding for global variable ‘List_parameter’
    #>   build_model: no visible global function definition for ‘write_nml’
    #>   build_model: no visible binding for global variable
    #>     ‘checkbox_Level_plot’
    #>   build_model: no visible binding for global variable
    #>     ‘checkbox_Level_rmse’
    #>   build_model: no visible binding for global variable ‘dir_field_level’
    #>   build_model: no visible binding for global variable
    #>     ‘checkbox_Temp_plot’
    #>   build_model: no visible binding for global variable
    #>     ‘checkbox_Temp_rmse’
    #>   build_model: no visible global function definition for
    #>     ‘compare_to_field’
    #>   build_model: no visible binding for global variable ‘dir_field_temp’
    #>   build_model: no visible global function definition for ‘dev.cur’
    #>   build_model: no visible global function definition for ‘plot’
    #>   build_model: no visible binding for global variable
    #>     ‘checkbox_Temp_plot2’
    #>   build_model: no visible binding for global variable
    #>     ‘checkbox_Temp_plot3’
    #>   build_model: no visible binding for global variable
    #>     ‘checkbox_Temp_plot4’
    #>   build_model: no visible binding for '<<-' assignment to ‘button_build’
    #>   calculate_SI_value: no visible binding for '<<-' assignment to
    #>     ‘dir_output’
    #>   calculate_SI_value: no visible binding for global variable ‘dir_output’
    #>   calculate_SI_value: no visible global function definition for
    #>     ‘read_nml’
    #>   calculate_SI_value: no visible global function definition for
    #>     ‘get_nml_value’
    #>   calculate_SI_value: no visible global function definition for ‘set_nml’
    #>   calculate_SI_value: no visible global function definition for
    #>     ‘write_nml’
    #>   calculate_SI_value: no visible global function definition for
    #>     ‘compare_to_field’
    #>   calculate_SI_value: no visible binding for global variable
    #>     ‘dir_field_temp’
    #>   calculate_SI_value: no visible binding for global variable
    #>     ‘dir_field_level’
    #>   calculate_SI_value: no visible global function definition for
    #>     ‘write.csv’
    #>   calculate_SI_value: no visible global function definition for ‘dev.cur’
    #>   calculate_SI_value: no visible global function definition for ‘par’
    #>   calculate_SI_value: no visible global function definition for ‘barplot’
    #>   calculate_aov: no visible global function definition for ‘stack’
    #>   calculate_aov: no visible global function definition for ‘aov’
    #>   calculate_auto_kalib: no visible binding for '<<-' assignment to
    #>     ‘dir_output’
    #>   calculate_auto_kalib: no visible binding for global variable
    #>     ‘dir_output’
    #>   calculate_auto_kalib: no visible global function definition for
    #>     ‘read_nml’
    #>   calculate_auto_kalib: no visible global function definition for
    #>     ‘get_nml_value’
    #>   calculate_auto_kalib: no visible binding for global variable
    #>     ‘but_cal_si_auto’
    #>   calculate_auto_kalib: no visible global function definition for
    #>     ‘set_nml’
    #>   calculate_auto_kalib: no visible global function definition for
    #>     ‘write_nml’
    #>   calculate_auto_kalib: no visible global function definition for
    #>     ‘compare_to_field’
    #>   calculate_auto_kalib: no visible binding for global variable
    #>     ‘dir_field_temp’
    #>   calculate_auto_kalib: no visible binding for global variable
    #>     ‘dir_field_level’
    #>   calculate_auto_kalib: no visible global function definition for
    #>     ‘write.table’
    #>   check_data_connection: no visible global function definition for
    #>     ‘read_nml’
    #>   check_data_connection: no visible global function definition for
    #>     ‘get_nml_value’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘button_confi’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘button_confi’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘button_set_parameter’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘button_set_parameter’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘button_build’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘button_build’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘button_cal_SI_value’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘button_cal_SI_value’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘button_field_level’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘button_field_level’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘button_field_temp’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘button_field_temp’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘button_autocalib’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘button_autocalib’
    #>   check_data_connection: no visible binding for '<<-' assignment to ‘l’
    #>   check_data_connection: no visible binding for '<<-' assignment to ‘k’
    #>   check_data_connection: no visible binding for global variable ‘l’
    #>   check_data_connection: no visible binding for global variable ‘k’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘dir_meteo’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘arg_meteo’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘dir_meteo’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘label_met_data’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘label_met_data’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘multi_inflow’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘multi_inflow’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘label_inflow_data’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘label_inflow_data’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘arg_inflow’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘dir_inflow’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘dir_inflow’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘multi_outflow’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘multi_outflow’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘label_outflow_data’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘label_outflow_data’
    #>   check_data_connection: no visible binding for '<<-' assignment to
    #>     ‘dir_outflow’
    #>   check_data_connection: no visible binding for global variable
    #>     ‘dir_outflow’
    #>   get_dataframe_Level_Lake: no visible global function definition for
    #>     ‘read.csv’
    #>   get_dataframe_Level_Lake: no visible global function definition for
    #>     ‘na.omit’
    #>   get_parameter: no visible global function definition for ‘read_nml’
    #>   get_parameter: no visible global function definition for
    #>     ‘get_nml_value’
    #>   get_pre_list_of_default_values: no visible binding for global variable
    #>     ‘workspace’
    #>   get_pre_list_of_default_values: no visible global function definition
    #>     for ‘read_nml’
    #>   get_pre_list_of_default_values: no visible global function definition
    #>     for ‘get_nml_value’
    #>   glmGUI: no visible global function definition for ‘install.packages’
    #>   set_cali_boundary : <anonymous>: no visible binding for '<<-'
    #>     assignment to ‘boundary.env’
    #>   set_cali_boundary : <anonymous>: no visible binding for global variable
    #>     ‘boundary.env’
    #>   set_parameter: no visible binding for '<<-' assignment to ‘cb’
    #>   set_parameter: no visible binding for global variable ‘l’
    #>   set_parameter : <anonymous>: no visible binding for global variable
    #>     ‘List_parameter’
    #>   set_parameter : <anonymous>: no visible global function definition for
    #>     ‘read_nml’
    #>   set_parameter : <anonymous>: no visible binding for '<<-' assignment to
    #>     ‘gewaehlterwert’
    #>   set_parameter : <anonymous>: no visible global function definition for
    #>     ‘get_nml_value’
    #>   set_parameter : <anonymous>: no visible binding for global variable
    #>     ‘cb’
    #>   set_parameter : <anonymous>: no visible binding for global variable
    #>     ‘gewaehlterwert’
    #>   set_parameter : <anonymous>: no visible binding for '<<-' assignment to
    #>     ‘gewaehlt’
    #>   set_parameter: no visible binding for '<<-' assignment to
    #>     ‘button_set_parameter’
    #>   set_parameter : <anonymous>: no visible binding for '<<-' assignment to
    #>     ‘List_parameter_temp’
    #>   set_parameter : <anonymous>: no visible binding for global variable
    #>     ‘List_parameter_temp’
    #>   set_parameter : <anonymous>: no visible binding for '<<-' assignment to
    #>     ‘List_parameter’
    #>   set_parameter : <anonymous>: no visible binding for '<<-' assignment to
    #>     ‘List_values’
    #>   set_parameter : <anonymous>: no visible binding for '<<-' assignment to
    #>     ‘label_nml_range’
    #>   set_parameter : <anonymous>: no visible binding for global variable
    #>     ‘label_nml_range’
    #>   set_parameter : <anonymous>: no visible global function definition for
    #>     ‘set_nml’
    #>   set_parameter : <anonymous>: no visible binding for global variable
    #>     ‘gewaehlt’
    #>   set_parameter : <anonymous>: no visible global function definition for
    #>     ‘write_nml’
    #>   show_write_dialog : <anonymous>: no visible binding for global variable
    #>     ‘dir_field_temp’
    #>   show_write_dialog : <anonymous>: no visible binding for global variable
    #>     ‘dir_field_level’
    #>   show_write_dialog : <anonymous>: no visible global function definition
    #>     for ‘write.csv’
    #>   window_input_csv_to_plot: no visible global function definition for
    #>     ‘read.csv’
    #>   window_input_csv_to_plot: no visible binding for '<<-' assignment to
    #>     ‘list_missing_data’
    #>   window_input_csv_to_plot : repair_input: no visible global function
    #>     definition for ‘na.kalman’
    #>   window_input_csv_to_plot : repair_input: no visible binding for global
    #>     variable ‘list_missing_data’
    #>   window_input_csv_to_plot : updatePlots_repair: no visible global
    #>     function definition for ‘dev.set’
    #>   window_input_csv_to_plot : updatePlots_repair: no visible global
    #>     function definition for ‘plot’
    #>   window_input_csv_to_plot : updatePlots_repair: no visible global
    #>     function definition for ‘na.omit’
    #>   window_input_csv_to_plot : updatePlots_repair: no visible binding for
    #>     global variable ‘list_missing_data’
    #>   window_input_csv_to_plot : updatePlots_repair: no visible global
    #>     function definition for ‘points’
    #>   window_input_csv_to_plot : updatePlots_repair: no visible global
    #>     function definition for ‘legend’
    #>   window_input_csv_to_plot: no visible global function definition for
    #>     ‘dev.cur’
    #>   window_input_csv_to_plot : <anonymous>: no visible binding for '<<-'
    #>     assignment to ‘list_missing_data’
    #>   window_input_csv_to_plot : updatePlots: no visible global function
    #>     definition for ‘dev.set’
    #>   window_input_csv_to_plot : updatePlots: no visible global function
    #>     definition for ‘plot’
    #>   window_input_csv_to_plot : updatePlots: no visible global function
    #>     definition for ‘na.omit’
    #>   window_input_csv_to_plot : updatePlots: no visible binding for global
    #>     variable ‘list_missing_data’
    #>   window_input_csv_to_plot : updatePlots: no visible global function
    #>     definition for ‘points’
    #>   window_input_csv_to_plot : check_null: no visible binding for '<<-'
    #>     assignment to ‘list_missing_data’
    #>   window_input_csv_to_plot : check_null: no visible binding for global
    #>     variable ‘list_missing_data’
    #>   window_input_csv_to_plot : check_null: no visible binding for '<<-'
    #>     assignment to ‘list_0_data’
    #>   window_input_csv_to_plot : check_null: no visible global function
    #>     definition for ‘na.omit’
    #>   window_input_csv_to_plot : check_null: no visible binding for global
    #>     variable ‘list_0_data’
    #>   window_input_csv_to_plot2: no visible global function definition for
    #>     ‘read.csv’
    #>   window_input_csv_to_plot2: no visible binding for global variable
    #>     ‘dir_field_temp’
    #>   window_input_csv_to_plot2: no visible binding for '<<-' assignment to
    #>     ‘list_missing_data’
    #>   window_input_csv_to_plot2 : check_null: no visible binding for '<<-'
    #>     assignment to ‘list_missing_data’
    #>   window_input_csv_to_plot2 : check_null: no visible binding for global
    #>     variable ‘list_missing_data’
    #>   window_input_csv_to_plot2: no visible binding for global variable
    #>     ‘dir_field_level’
    #>   window_input_csv_to_plot2: no visible global function definition for
    #>     ‘dev.cur’
    #>   window_input_csv_to_plot2 : <anonymous>: no visible binding for '<<-'
    #>     assignment to ‘list_missing_data’
    #>   window_input_csv_to_plot2 : updatePlots: no visible global function
    #>     definition for ‘dev.set’
    #>   window_input_csv_to_plot2 : updatePlots: no visible global function
    #>     definition for ‘plot’
    #>   window_input_csv_to_plot2 : updatePlots: no visible global function
    #>     definition for ‘na.omit’
    #>   window_output_csv_to_plot: no visible global function definition for
    #>     ‘read.csv’
    #>   window_output_csv_to_plot: no visible global function definition for
    #>     ‘dev.cur’
    #>   window_output_csv_to_plot : updatePlots: no visible global function
    #>     definition for ‘dev.set’
    #>   window_output_csv_to_plot : updatePlots: no visible global function
    #>     definition for ‘plot’
    #>   window_output_csv_to_plot : updatePlots: no visible global function
    #>     definition for ‘lines’
    #>   window_output_csv_to_plot : updatePlots: no visible global function
    #>     definition for ‘lowess’
    #>   window_plot_RMSE: no visible binding for global variable ‘List_values’
    #>   window_plot_RMSE: no visible binding for global variable
    #>     ‘List_parameter’
    #>   window_plot_RMSE: no visible global function definition for ‘plot’
    #>   window_plot_RMSE: no visible global function definition for ‘lines’
    #>   window_plot_RMSE: no visible global function definition for
    #>     ‘shapiro.test’
    #>   window_plot_RMSE: no visible global function definition for ‘points’
    #>   window_plot_dataframe_Level_Lake: no visible binding for '<<-'
    #>     assignment to ‘dir_output’
    #>   window_plot_dataframe_Level_Lake: no visible global function definition
    #>     for ‘read_nml’
    #>   window_plot_dataframe_Level_Lake: no visible binding for global
    #>     variable ‘dir_output’
    #>   window_plot_dataframe_Level_Lake: no visible global function definition
    #>     for ‘get_nml_value’
    #>   window_plot_dataframe_Level_Lake: no visible global function definition
    #>     for ‘read.csv’
    #>   window_plot_dataframe_Level_Lake: no visible global function definition
    #>     for ‘plot’
    #>   window_plot_dataframe_Level_Lake: no visible global function definition
    #>     for ‘lines’
    #>   window_plot_dataframe_Level_Lake: no visible global function definition
    #>     for ‘legend’
    #>   window_plot_dataframe_Level_Lake: no visible global function definition
    #>     for ‘strwidth’
    #>   window_plot_list_graph: no visible global function definition for ‘par’
    #>   window_plot_list_graph: no visible global function definition for
    #>     ‘n2mfrow’
    #>   window_plot_list_graph: no visible global function definition for
    #>     ‘plot’
    #>   window_plot_list_graph: no visible global function definition for
    #>     ‘points’
    #>   window_plot_list_graph: no visible global function definition for
    #>     ‘lines’
    #>   window_plot_list_temp: no visible global function definition for ‘par’
    #>   window_plot_list_temp: no visible global function definition for
    #>     ‘n2mfrow’
    #>   window_plot_list_temp: no visible global function definition for ‘plot’
    #>   window_plot_list_temp: no visible global function definition for
    #>     ‘points’
    #>   window_plot_list_temp: no visible global function definition for
    #>     ‘lines’
    #>   window_plot_model_output: no visible global function definition for
    #>     ‘sim_vars’
    #>   window_plot_model_output: no visible global function definition for
    #>     ‘dev.cur’
    #>   window_plot_model_output : updatePlots: no visible global function
    #>     definition for ‘dev.set’
    #>   window_plot_model_output : updatePlots: no visible global function
    #>     definition for ‘plot_var’
    #>   window_plot_multi_histo: no visible global function definition for
    #>     ‘par’
    #>   window_plot_multi_histo: no visible global function definition for
    #>     ‘shapiro.test’
    #>   window_plot_multi_histo: no visible global function definition for
    #>     ‘hist’
    #>   window_plot_multi_histo: no visible binding for global variable
    #>     ‘List_values’
    #>   window_plot_temp_compare: no visible global function definition for
    #>     ‘dev.cur’
    #>   window_plot_temp_compare: no visible global function definition for
    #>     ‘par’
    #>   window_plot_temp_compare: no visible global function definition for
    #>     ‘get_var’
    #>   window_plot_temp_compare: no visible global function definition for
    #>     ‘get.offsets’
    #>   window_plot_temp_compare: no visible global function definition for
    #>     ‘resample_to_field’
    #>   window_plot_temp_compare: no visible global function definition for
    #>     ‘resample_sim’
    #>   window_plot_temp_compare: no visible global function definition for
    #>     ‘interp’
    #>   window_plot_temp_compare : gen_default_fig: no visible global function
    #>     definition for ‘valid_fig_path’
    #>   window_plot_temp_compare : gen_default_fig: no visible global function
    #>     definition for ‘png’
    #>   window_plot_temp_compare : gen_default_fig: no visible global function
    #>     definition for ‘par’
    #>   window_plot_temp_compare : .stacked_layout: no visible global function
    #>     definition for ‘.simple_layout’
    #>   window_plot_temp_compare : colbar_layout: no visible global function
    #>     definition for ‘layout’
    #>   window_plot_temp_compare : .plot_df_heatmap: no visible global function
    #>     definition for ‘colorRampPalette’
    #>   window_plot_temp_compare : .plot_df_heatmap: no visible global function
    #>     definition for ‘head’
    #>   window_plot_temp_compare : .plot_df_heatmap: no visible global function
    #>     definition for ‘.filled.contour’
    #>   window_plot_temp_compare : .plot_df_heatmap_diff: no visible global
    #>     function definition for ‘colorRampPalette’
    #>   window_plot_temp_compare : .plot_df_heatmap_diff: no visible global
    #>     function definition for ‘head’
    #>   window_plot_temp_compare : .plot_df_heatmap_diff: no visible global
    #>     function definition for ‘.filled.contour’
    #>   window_plot_temp_compare : plot_layout: no visible global function
    #>     definition for ‘plot’
    #>   window_plot_temp_compare : axis_layout: no visible global function
    #>     definition for ‘axis’
    #>   window_plot_temp_compare : axis_layout: no visible global function
    #>     definition for ‘par’
    #>   window_plot_temp_compare : color_key: no visible global function
    #>     definition for ‘plot’
    #>   window_plot_temp_compare : color_key: no visible global function
    #>     definition for ‘par’
    #>   window_plot_temp_compare : color_key: no visible global function
    #>     definition for ‘axis’
    #>   window_plot_temp_compare : color_key: no visible global function
    #>     definition for ‘polygon’
    #>   window_plot_temp_compare : color_key: no visible global function
    #>     definition for ‘text’
    #>   window_plot_temp_compare : color_key_diff: no visible global function
    #>     definition for ‘plot’
    #>   window_plot_temp_compare : color_key_diff: no visible global function
    #>     definition for ‘par’
    #>   window_plot_temp_compare : color_key_diff: no visible global function
    #>     definition for ‘axis’
    #>   window_plot_temp_compare : color_key_diff: no visible global function
    #>     definition for ‘polygon’
    #>   window_plot_temp_compare : color_key_diff: no visible global function
    #>     definition for ‘text’
    #>   window_plot_temp_compare: no visible global function definition for
    #>     ‘compare_to_field’
    #>   window_plot_temp_compare: no visible global function definition for
    #>     ‘dev.copy’
    #>   window_plot_temp_compare: no visible binding for global variable ‘pdf’
    #>   window_plot_temp_compare: no visible global function definition for
    #>     ‘dev.off’
    #>   window_plot_temp_compare: no visible global function definition for
    #>     ‘points’
    #>   window_plot_temp_compare: no visible global function definition for
    #>     ‘text’
    #>   window_select_SI_calculation : <anonymous>: no visible binding for
    #>     global variable ‘dir_field_temp’
    #>   window_select_SI_calculation : <anonymous>: no visible binding for
    #>     global variable ‘dir_field_level’
    #>   window_select_SI_calculation : <anonymous>: no visible binding for
    #>     global variable ‘label_status_SI_calculation’
    #>   window_select_SI_calculation: no visible binding for '<<-' assignment
    #>     to ‘label_status_SI_calculation’
    #>   window_select_auto_kalib : <anonymous>: no visible binding for global
    #>     variable ‘boundary.env’
    #>   window_select_auto_kalib: no visible binding for '<<-' assignment to
    #>     ‘but_cal_si_auto’
    #>   window_select_auto_kalib : <anonymous>: no visible binding for global
    #>     variable ‘dir_field_temp’
    #>   window_select_auto_kalib : <anonymous>: no visible binding for global
    #>     variable ‘dir_field_level’
    #>   window_select_auto_kalib : <anonymous>: no visible binding for global
    #>     variable ‘label_status_CAL_calculation’
    #>   window_select_auto_kalib: no visible binding for '<<-' assignment to
    #>     ‘label_status_CAL_calculation’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘workspace’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘arg_meteo’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘multi_inflow’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘multi_outflow’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘arg_inflow’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘arg_outflow’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘dir_field_temp’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘dir_field_level’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘List_parameter’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘List_values’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘dfList_Temp’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘dfList_Level’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘label_workspace’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘label_workspace_project’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘button_new_workspace’
    #>   windows_main_menu : <anonymous>: no visible binding for '<<-'
    #>     assignment to ‘workspace’
    #>   windows_main_menu : <anonymous>: no visible global function definition
    #>     for ‘read_nml’
    #>   windows_main_menu : <anonymous>: no visible global function definition
    #>     for ‘write_nml’
    #>   windows_main_menu : <anonymous>: no visible binding for global variable
    #>     ‘workspace’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘button_workspace’
    #>   windows_main_menu : <anonymous> : <anonymous>: no visible global
    #>     function definition for ‘read_nml’
    #>   windows_main_menu : <anonymous> : <anonymous>: no visible global
    #>     function definition for ‘write_nml’
    #>   windows_main_menu : <anonymous> : <anonymous>: no visible binding for
    #>     global variable ‘workspace’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘label_met_data’
    #>   windows_main_menu : <anonymous>: no visible binding for global variable
    #>     ‘dir_meteo’
    #>   windows_main_menu : <anonymous>: no visible binding for global variable
    #>     ‘arg_meteo’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘label_inflow_data’
    #>   windows_main_menu : <anonymous>: no visible binding for global variable
    #>     ‘multi_inflow’
    #>   windows_main_menu : <anonymous>: no visible binding for global variable
    #>     ‘dir_inflow’
    #>   windows_main_menu : <anonymous>: no visible binding for global variable
    #>     ‘arg_inflow’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘label_outflow_data’
    #>   windows_main_menu : <anonymous>: no visible binding for global variable
    #>     ‘multi_outflow’
    #>   windows_main_menu : <anonymous>: no visible binding for global variable
    #>     ‘dir_outflow’
    #>   windows_main_menu : <anonymous>: no visible binding for global variable
    #>     ‘arg_outflow’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘label_nml_status’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘label_nml_range’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘button_field_temp’
    #>   windows_main_menu : <anonymous>: no visible binding for '<<-'
    #>     assignment to ‘dir_field_temp’
    #>   windows_main_menu : <anonymous>: no visible binding for global variable
    #>     ‘dir_field_temp’
    #>   windows_main_menu: no visible binding for global variable
    #>     ‘button_field_temp’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘label_field_level’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘button_field_level’
    #>   windows_main_menu : <anonymous>: no visible binding for '<<-'
    #>     assignment to ‘dir_field_level’
    #>   windows_main_menu : <anonymous>: no visible binding for global variable
    #>     ‘dir_field_level’
    #>   windows_main_menu: no visible binding for global variable
    #>     ‘button_field_level’
    #>   windows_main_menu: no visible binding for '<<-' assignment to
    #>     ‘label_status_build’
    #>   windows_main_menu : <anonymous>: no visible global function definition
    #>     for ‘get_nml_value’
    #>   Undefined global functions or variables:
    #>     .filled.contour .simple_layout List_parameter List_parameter_temp
    #>     List_values aov arg_inflow arg_meteo arg_outflow axis barplot
    #>     boundary.env but_cal_si_auto button_autocalib button_build
    #>     button_cal_SI_value button_confi button_field_level button_field_temp
    #>     button_set_parameter cb checkbox_Level_plot checkbox_Level_rmse
    #>     checkbox_Temp_plot checkbox_Temp_plot2 checkbox_Temp_plot3
    #>     checkbox_Temp_plot4 checkbox_Temp_rmse colorRampPalette
    #>     compare_to_field dev.copy dev.cur dev.off dev.set dir_field_level
    #>     dir_field_temp dir_inflow dir_meteo dir_outflow dir_output
    #>     get.offsets get_nml_value get_var gewaehlt gewaehlterwert head hist
    #>     install.packages interp k l label_inflow_data label_met_data
    #>     label_nml_range label_outflow_data label_status_CAL_calculation
    #>     label_status_SI_calculation label_status_build layout legend lines
    #>     list_0_data list_missing_data lowess multi_inflow multi_outflow
    #>     n2mfrow na.kalman na.omit par pdf plot plot_var png points polygon
    #>     read.csv read_nml resample_sim resample_to_field set_nml shapiro.test
    #>     sim_vars stack strwidth text valid_fig_path workspace write.csv
    #>     write.table write_nml
    #>   Consider adding
    #>     importFrom("grDevices", "colorRampPalette", "dev.copy", "dev.cur",
    #>                "dev.off", "dev.set", "n2mfrow", "pdf", "png")
    #>     importFrom("graphics", ".filled.contour", "axis", "barplot", "hist",
    #>                "layout", "legend", "lines", "par", "plot", "points",
    #>                "polygon", "strwidth", "text")
    #>     importFrom("stats", "aov", "lowess", "na.omit", "shapiro.test")
    #>     importFrom("utils", "head", "install.packages", "read.csv", "stack",
    #>                "write.csv", "write.table")
    #>   to your NAMESPACE file.
    #> 
    #> 0 errors ✔ | 3 warnings ✖ | 2 notes ✖
    #> Error: R CMD check found WARNINGs

</details>
