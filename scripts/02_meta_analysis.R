library(metafor)
breast_cancer_data <- read.csv("data/breast_cancer_survival_data.csv")


#escalc() : effect size calculator where raw numbers like number of survivors or total sample size are inputted 
#and it converts each study into a standardized "effect size" plus a variance 
#For proportions like ours, it typically transforms the raw percentage using something called a logit transformation 
#this keeps everything mathematically well-behaved since averaging proportions that are close to 0% or 100% can negatively influence the analysis
#regular percentages misbehave statistically at the extremes, the logit transformation fixes that

escalc_data <-escalc(measure="PLO", xi = n_survived_5yr, ni = n_total, data = breast_cancer_data) #PLO for measure means logit of proportions, xi is the number of events, ni is the total sample size, data shows where to pull info from
#outputs yi which is the transformed effect size and vi which is the variance

#rma() : random-effects meta-analysis where it takes the effect sizes and variances from escalc() and computes the actual pooled estimate 
# The 9 studies are each converted into a yi and vi, and rma() combines these 9 numbers into one overall pooled estimate 
#basically answering "if I combine all 9 countries' data properly, what's the single best estimate of breast cancer survival, accounting for how reliable each study is?"
#each study gets weighted by 1/variance so studies like SEER (n=188,052, basically no variance) count a lot more than small studies like Pakistan (n=160, high variance)
#it is random-effects instead of fixed-effects because it assumes there are real differences between countries, not just noise, and it estimates tau^2 to capture that between-study variation
#I^2 shows what % of the variation across studies is real differences vs just random chance - if it is high that means income/country level factors are actually driving the differences, which is what I will test next with the meta-regression

overall_model <- rma(yi, vi, data = escalc_data)
summary(overall_model)

#converting pooled estimate back to a percentage that is actually interpretable
predict(overall_model, transf = transf.ilogit)
#outputs: percentage, confidence interval and prediction interval


#Using income tier as a moderator. Allows us to answer the question: does income tier(moderator) explain why survival rates differ so much across the 9 countries

income_model <- rma(yi, vi, mods = ~income_tier, data = escalc_data)
summary(income_model)
#I found that R picks the reference category alphabetically so "High income" is the baseline that is being compared against everything else 
#R^2 = 83.75% which means income tier explains most of the heterogeneity we saw earlier and that is important 
#but QE is still significant even after adding income tier, so there is still unexplained variation left over


#testing if metric_type, which is the OS and RS, explains some of that leftover heterogeneity to get a better picture
metric_model <- rma(yi, vi, mods = ~ income_tier + metric_type, data = escalc_data)
summary(metric_model)

#metric_type RS is not significant since p = 0.36 after income tier is already in the model
#this means OS vs RS is not actually driving the differences between studies, and income effect is robust.

#Saving model outputs to a text file so results are documented, not just in console history
#sink() must be called again with no arguments at the end or output keeps writing to the file

sink("results/model_results.txt")

cat("Overall Model (no moderators)")
summary(overall_model)

cat("Pooled estimate as a percentage")
predict(overall_model, transf = transf.ilogit)

cat("Income Tier Model")
summary(income_model)

cat("Income Tier + Metric Type Model")
summary(metric_model)

sink()
