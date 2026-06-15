#-------------------------------------------------------------#
#-------------------------------------------------------------#
#-------   Script to export the validation data set   --------#
#-------------------------------------------------------------#
#-------------------------------------------------------------#

library(tidyverse)
library(readxl)



## Exporting 2024 final validation dataset for Timothee (GFZ) ####

dir_geowiki <- "/Users/xavi_rp/Documents/JRC_D1/AccuracyAssessment_Second/geowiki_2026/"


dir_export <- "/Users/xavi_rp/Documents/JRC_D1/AccuracyAssessment_Second/validation_dataset_exports/"



## All validations file

valid_all <- read.csv(paste0(dir_geowiki, "../AllValidations_2024_2026.csv"))

head(valid_all)
nrow(valid_all)  # 21752. 21612 is the final number available for using in the assessment.
                 # 62 not associated to any strata
                 # 54 outside GAUL
                 # 24 impossible to be assigned et the end of the validatin exercise 2024
21752 - (62 + 54) - 24

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


# Including a column showing if the sample was finally used in the asssessment, or not
dir_1stAssessment <- "/Users/xavi_rp/Documents/JRC_D1/copy_SharePoint_kk/validation/Results/final_v2/"
data_1stAssessment <- read_excel(paste0(dir_1stAssessment, "GFC_v2_accuracy-assessment_gaul.xlsx"), 
                                 sheet = "5_combined")
nrow(data_1stAssessment)  # 21612. Correct, the ones finally used

valid_export <- valid_export %>%
  mutate(
    UsedIn_1stAssessment = if_else(
      location_id %in% data_1stAssessment$location_id,
      "Yes",
      "No"
    )
  )

head(valid_export)
sum(valid_export$UsedIn_1stAssessment == "Yes") # +
sum(valid_export$UsedIn_1stAssessment == "No")



# References
Reference_data_2026_strata <- readxl::read_excel("/Users/xavi_rp/Documents/JRC_D1/copy_SharePoint_kk/validation/Reference_data_2026_strata.xlsx", 
                                                 n_max = 15, sheet = "Main") 

sort(Reference_data_2026_strata$ID2)
sort(unique(valid_export$X2024_1st_groupid))


ref_2024 <- Reference_data_2026_strata %>% 
  filter(!is.na(ID2)) %>% 
  select("ID2", `Region / Countries...3`) %>% 
  rename( "Region" = `Region / Countries...3`)

ref_2024



valid_export <- valid_export %>% 
  left_join(ref_2024, by = c("X2024_1st_groupid" = "ID2")) %>%  #names()
  relocate(Region, .before = location_id) %>% #head()
  select(-X2024_final_groupid) %>% #head()
  select(-X2024_final_sample_id) #%>% head()

names(valid_export)



# saving the file

if(!dir.exists(paste0(dir_export, "export_GFZ/"))) dir.create(paste0(dir_export, "export_GFZ/"))

write.csv(valid_export, 
          paste0(dir_export, "export_GFZ/",
                 format(Sys.Date(), "%Y%m%d"), 
                 "_Validations2024_GFZ.csv"), 
          row.names = FALSE)





