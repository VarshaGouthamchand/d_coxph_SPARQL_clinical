library(survival)
library(survminer)

tb <- read.csv("C:\\Users\\P70070487\\OneDrive - Maastro - Clinic\\Radiomics\\Clipped\\2022_hn1.csv")
#View(tb)
f1 <- coxph(Surv(overall_survival_in_days, event_overall_survival) ~ 1, data = tb)
names(f1)

f <- basehaz(f1,centered=FALSE)
plot(f)

