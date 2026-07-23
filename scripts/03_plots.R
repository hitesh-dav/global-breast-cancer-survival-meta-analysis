library(metafor)
breast_cancer_data <- read.csv("data/breast_cancer_survival_data.csv")

escalc_data <-escalc(measure="PLO", xi = n_survived_5yr, ni = n_total, data = breast_cancer_data)

overall_model <- rma(yi, vi, data = escalc_data)



#Forest plot shows each study as a dot with a confidence interval line, stacked with the pooled estimate as a diamond at the bottom
#transf = transf.ilogit which converts back from the logit scale to interpretable percentages
#slab = country labels each row with the country name
forest(overall_model, transf = transf.ilogit, slab = breast_cancer_data$country)


#Saving the forest plot as an actual image file for the repo instead of just viewing it in RStudio
#png() opens a file connection so the plot gets written to disk instead of just displayed
#dev.off() closes it and forgetting dev.off() leaves the file broken or bleeds into the next plot
png("figures/forest_plot.png", width = 1200, height = 800, res = 150)
forest(overall_model,transf = transf.ilogit, slab = breast_cancer_data$country)
dev.off()


#Funnel plot checks for publication bias, which is different from heterogeneity.
#It plots each study's effect size against its precision - small/imprecise studies should scatter more widely just by chance, while big studies should cluster tightly near the pooled estimate. If the funnel looks lopsided, that can mean certain results were less likely to get published or found in my search.
#Caveat: I only have 9 studies here, so this has pretty limited power - formal publication bias tests usually want at least 10 studies.
funnel(overall_model)

#saving the plot
png("figures/funnel_plot.png", width = 1200, height = 800, res = 150)
funnel(overall_model)
dev.off()