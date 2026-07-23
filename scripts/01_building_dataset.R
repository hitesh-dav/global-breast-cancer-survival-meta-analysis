#This script houses the code I made to build the breast cancer survival meta-analysis dataset
#Found 9 studies with data for different countries across 4 World Bank income tiers

study_id <- c(1,2,3,4,5,6,7,8,9)

study_author_year <- c("Tiruneh_2021","Ugandan_cohort_2015","Rasul_2026","Sathishkumar_2024","Goiania_2026","Taizhou_2022","SEER_2021","Holleczek_2013","Osaka_2023")

country <- c("Ethiopia","Uganda","Pakistan","India", "Brazil","China", "United States", "Germany","Japan")

income_tier <- c("Low income","Low income","Lower-middle income","Lower-middle income","Upper-middle income","Upper-middle income","High income","High income","High income")

n_total <- c(482,262,160,17331,7395,6159,188052,8571,4006)

n_survived_5yr <- c(124,136,106,11508,6145,5469,149165,7114,3437)

survival_pct <- c(25.8, 51.8, 66.3, 66.4, 83.1, 88.8, 79.3, 83.0, 85.8)

#OS is overall survival rate and RS is relative survival rate. The papers I found showed different methods of getting this data, and I could not find papers that consistently used one method
metric_type <- c("OS", "OS", "OS", "RS", "OS", "RS", "OS", "RS", "RS")

diagnosis_period <- c("2015-2020", "2004-2012", "2020", "2012-2015", "1988-2015", "2004-2018", "2007-2010", "2005-2009", "2001-2002")



breast_cancer_data <- data.frame(study_id, study_author_year, country, income_tier, n_total, n_survived_5yr, survival_pct, metric_type, diagnosis_period)



write.csv(breast_cancer_data, "data/breast_cancer_survival_data.csv", row.names = FALSE)