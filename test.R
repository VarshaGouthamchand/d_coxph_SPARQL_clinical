library(reticulate)
library(Rcpp)
os <- import("os")
os$listdir(".")

# Set the path to the Python executable file
use_python("C:/Users/P70070487/Anaconda3/bin/python", required=TRUE)

# Check the version of Python.
py_config()

print(df)
fileName <- 'C:\\Users\\P70070487\\Documents\\d_coxph\\hi.txt'
data <- readChar(fileName, file.info(fileName)$size)
print(data)
string <- readChar("C:\\Users\\P70070487\\Documents\\d_coxph\\hi.txt",nchars=1e6)
string <- trimws(string)
print(string)

df <- system(paste("python C:\\Users\\P70070487\\Documents\\d_coxph\\run_sparql_for_cox.py", string, sep=" "))
df

source_python("C:\\Users\\P70070487\\Documents\\d_coxph\\run_sparql_for_cox.py")
run_sparql_for_cox("localhost")
typeof(df)
df = read.csv('df.csv')
print(df)


library("survival")
library("survminer")
res.cox <- coxph(Surv(Survivaldays, Survival) ~ Gender, data = df)
res.cox
res.cox <- coxph(Surv(Survivaldays, Survival) ~ Gender + Tstage + HPV + Nstage, data =  df)
summary(res.cox)
