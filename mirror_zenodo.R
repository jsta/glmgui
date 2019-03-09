# zenodo::install_github("jsta/jsta")
library(jsta)

download_zenodo("2025865")
tar_file <- list.files(pattern = "tar.gz")

untar(tar_file, exdir = "../")
