#
# GLM models in R to compare with demo in Matlab package "Generalized Linear Models".
#
# ====================================================================================
# Construct some data for the demo's
MilesPerGallon <- c(38,26,22,32,36,27,27,44,32,28,31)
Horsepower <- c(85,92,112,96,84,90,86,52,84,79,82)
Acceleration <- c(17,14.5,14.7,13.9,13,17.3,15.6,24.6,11.6,18.6,19.4)
Cylinders <- c(6,4,6,4,4,4,4,4,4,4,4)
Importance <- c(1,2,2,2,3,2,2,2,1,1,1)
Offset <- c(5,5,5,5,5,5,5,5,5,5,5)
SecondHand <- c(0,1,1,1,0,0,1,0,0,1,1)

# Construct data frames:
data <- data.frame(MilesPerGallon,Horsepower,Acceleration,Cylinders,
                   Importance,Offset,SecondHand)

# Create some new data:
Horsepower <- c(70,67,67,67,110)
Acceleration <- c(16.9,15,15.7,16.2,16.4)
Cylinders <- c(4,4,4,4,6)
dataNew <- data.frame(Horsepower,Acceleration,Cylinders)

# ====================================================================================
# DEMO 1: GLM with normal distribution and identity link.
mdl <- glm(MilesPerGallon~Horsepower+Acceleration+Cylinders,data=data,
           family=gaussian(link=identity))
R2 <- 1-(mdl$deviance/mdl$null.deviance)
pMSE <- mean(residuals(mdl,"pearson")^2)
dMSE <- mean(residuals(mdl,"deviance")^2)
summary(mdl,dispersion=12.2692) # dispersion parameter as calculated in Matlab.
cat("\nPearson MSE: ",pMSE,"\n\nDeviance MSE: ",dMSE,"\n\nMcFadden R^2: ",R2,"\n")

cat("Predict new values:")
predict(mdl, dataNew)

# DEMO 2: GLM with gamma distribution and log link.
mdl <- glm(MilesPerGallon~Horsepower+Acceleration+Cylinders,data=data,
           family=Gamma(link=log))
R2 <- 1-(mdl$deviance/mdl$null.deviance)
pMSE <- mean(residuals(mdl,"pearson")^2)
dMSE <- mean(residuals(mdl,"deviance")^2)
summary(mdl,dispersion=0.0133) # dispersion parameter as calculated in Matlab.
cat("\nPearson MSE: ",pMSE,"\n\nDeviance MSE: ",dMSE,"\n\nMcFadden R^2: ",R2,"\n")

# DEMO 3: GLM with gamma distribution and log link and weights.
mdl <- glm(MilesPerGallon~Horsepower+Acceleration+Cylinders,data=data,
           family=Gamma(link=log),weight=Importance)
R2 <- 1-(mdl$deviance/mdl$null.deviance)
pMSE <- mean(residuals(mdl,"pearson")^2)
dMSE <- mean(residuals(mdl,"deviance")^2)
summary(mdl,dispersion=0.0226) # dispersion parameter as calculated in Matlab.
cat("\nPearson MSE: ",pMSE,"\n\nDeviance MSE: ",dMSE,"\n\nMcFadden R^2: ",R2,"\n")

# DEMO 4: GLM with binomial distribution and probit link.
mdl <- glm(SecondHand~Horsepower+Acceleration+Cylinders,data=data,
           family=binomial(link=probit))
R2 <- 1-(mdl$deviance/mdl$null.deviance)
pMSE <- mean(residuals(mdl,"pearson")^2)
dMSE <- mean(residuals(mdl,"deviance")^2)
summary(mdl,dispersion=1.3067) # dispersion parameter as calculated in Matlab.
cat("\nPearson MSE: ",pMSE,"\n\nDeviance MSE: ",dMSE,"\n\nMcFadden R^2: ",R2,"\n")

# DEMO 5: GLM with binomial distribution, probit link, weight and offset.
mdl <- glm(SecondHand~Horsepower+Acceleration+Cylinders,data=data,
           family=binomial(link=probit),weight=Importance,offset=Offset)
R2 <- 1-(mdl$deviance/mdl$null.deviance)
pMSE <- mean(residuals(mdl,"pearson")^2)
dMSE <- mean(residuals(mdl,"deviance")^2)
summary(mdl,dispersion=2.3473) # dispersion parameter as calculated in Matlab.
cat("\nPearson MSE: ",pMSE,"\n\nDeviance MSE: ",dMSE,"\n\nMcFadden R^2: ",R2,"\n")


# ========================================================================
# This is free and unencumbered software released into the public domain.
# 
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
# 
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# For more information, please refer to <http://unlicense.org>
# ========================================================================
