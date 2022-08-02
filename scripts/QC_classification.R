# @D-Harouni
# Classify QC status of the INFORM drug screening platform

library(openxlsx)

# read input 
dfQC <- openxlsx::read.xlsx("~/data/QC_param.xlsx")

# QC classification
dfQC$QCstatus <- ifelse(dfQC$screen_zprimer >= 0.5, "high", "intermediate") # setting robust zprime higher or equal to 0.5 as "high"
dfQC$QCstatus <- ifelse(dfQC$screen_zprimer <= -0.5, "fail", dfQC$QCstatus) # setting robust zprime lower or equal to -0.5 as "fail"
dfQC$QCstatus <- ifelse(c(dfQC$screen_zprimer > -0.5 & dfQC$screen_zprimer < 0.5 & dfQC$Reader == "new" &
                            dfQC$mean_cor < 0.7 & dfQC$mean_DMSO < 5000),
                        "borderline", dfQC$QCstatus) # "borderline" classification (new plate reader threshold)
dfQC$QCstatus <- ifelse(c(dfQC$screen_zprimer > -0.5 & dfQC$screen_zprimer < 0.5 & dfQC$Reader == "old" &
                            dfQC$mean_cor < 0.7 & dfQC$mean_DMSO < 600),
                        "borderline", dfQC$QCstatus) # "borderline" classification (old plate reader threshold), 
                                                     # "intermediate" is set by default to teh remaining conditions

# save output
openxlsx::write.xlsx(dfQC, "~data/QC_classification.xlsx")
