# Generalized Linear Models in Matlab (same results as in R)

---

Fits Generalized Linear models with one of the following distributions:
 > 'normal' / 'gamma' / 'inv_gsn' / 'poisson' / 'binomial'

And one of the following (if compatible) link functions:
 > 'id' / 'log' / 'sqroot' / 'power' / 'logit' / 'probit' / 'recip' / 'complog'

Estimation procedure has been copied and modified from the package:
[GLMLAB by Peter Dunn (08 Mar 1999)](http://www.mathworks.com/matlabcentral/fileexchange/195-glmlab)

This GLM package is essentially the same as Peter Dunn's, but does not
recquire the usage of the GLMLAB GUI and outputs results like in R.
This package also calculates some additional measure-of-fit statistics.

---

Some key notes for usage:
- Supply the `X` and `Y` variables in `structs`, with one variable per element.

  For example: 
   - `Y.Distance = ...`
   - `X.Speed = ...`
   - `X.Time = ...`

- Every supplied variable should be a `N x 1` column vector where the rows
  are the observations.
- It is also possible to supply weights (in struct `W`) and an offset
  (in struct `O`) to be taken into account in the estimation procedure.
  As with `X` and `Y`, the variables inside the struct should be `N x 1`.
- When using the binomial distribution, `Y` should contain a variable
  with two columns: (column 1) the responses, (column 2) the sample size
  per response. If you don't have sample sizes, simply make columns 2
  a vector of only ones.

---

Options:
 - **GLM.Distribution** =   `'normal'/'gamma'/'inv_gsn'/'poisson'/'binomial'`
 - **GLM.Link**         =    `'id'/'log'/'sqroot'/'power'/'logit'/'probit'/'recip'/'complog'`
 - **GLM.Residual**     =  `type of residuals, 'deviance'(default)/'pearson'`
 - **GLM.Scale**        =  `'mean deviance'(default),'fixed',[positive number]`
 - **GLM.Intercept**    =   `use intercept, 'on'(default)/'off'`
 - **GLM.ShowEquation** =  `display equation, 'on'(default)/'off'`
 - **GLM.Display**      =    `display output, 'on'(default)/'off'`
 - **GLM.Recycle**      =    `use fit as starting values, 'on'/'off'(default)`
 - **GLM.illctol**      =    `ill-conditioned threshold. default = 1e-10`
 - **GLM.toler**        =    `tolerance. default = 1e-10`
 - **GLM.maxit**        =    `max iterations. default = 30`

---

Estimating a GLM model involves three steps:
 1. Create a GLM model object: `mdl = GLM;`
 2. Specifying the needed link and distribution: `mdl.Distribution = ..`, `mdl.Link = ..`
 3. Estimate parameters with the data:            `mdl.Estimate(Y,X);`

After estimation, it is also possible to fit new values to the estimated model as follows: `fit = mdl.Fit(Xnew);`

The results are almost completely identical with the estimation in R.
For comparison, try the Demo.R file (as included in folder) that
gives the same output as the demo examples below. See for yourself.

---
***NEVERTHELESS: this code is still relatively unstable.***
---
**This code has not been peer-reviewed** and may give wrong outputs.
The internal estimation of GLM has been directly copied from Peter Dunn.
There is no guarantee that this code is correct. Do not rely on it.
Check with other applications (e.g. R) to verify the correctness.
---
