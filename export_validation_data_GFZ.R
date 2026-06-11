#-------------------------------------------------------------#
#-------------------------------------------------------------#
#-------   Script to export the validation data set   --------#
#-------------------------------------------------------------#
#-------------------------------------------------------------#

library(tidyverse)



## Exporting 2024 final validation dataset for Timothee (GFZ) ####

dir_geowiki <- "/Users/xavi_rp/Documents/JRC_D1/AccuracyAssessment_Second/geowiki_2026/"


dir_export <- "/Users/xavi_rp/Documents/JRC_D1/AccuracyAssessment_Second/validation_dataset_exports/"



## All validations file

valid_all <- read.csv(paste0(dir_geowiki, "../AllValidations_2024_2026.csv"))

head(valid_all)
nrow(valid_all)  # 21752

apply(valid_all, 2, function(x) sum(is.na(x)))


valid_export <- valid_all %>% 
  select(location_id,
         X2024_1st_sample_id,
         X2024_1st_groupid,
         X2024_final_userid, 
         X2024_final_groupid, 
         X2024_final_sample_id,
         X2024_final_forest_class,
         X2024_final_confidence_level,
         X2024_final_type_class, 
         X2024_final_class_issues, 
         X2024_final_comment 
         ) 

valid_export %>% nrow()  # 21752
apply(valid_export, 2, function(x) sum(is.na(x)))  # 24 samples unassigned in 2024


if(!dir.exists(paste0(dir_export, "export_GFZ/")))
  dir.create(paste0(dir_export, "export_GFZ/"))

write.csv(valid_export, 
          paste0(dir_export, "export_GFZ/",
                 format(Sys.Date(), "%Y%m%d"), 
                 "_Validations2024_GFZ.csv"), 
          row.names = FALSE)





