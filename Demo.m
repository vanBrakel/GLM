% ========== GENERALIZED LINEAR MODEL estimation for Matlab ==============
% [JPvB, 13/02/2017]
%
% Fits Generalized Linear models with one of the following distributions:
%  > 'normal'/'gamma'/'inv_gsn'/'poisson'/'binomial'
%
% And one of the following (if compatible) link functions:
%  > 'id'/'log'/'sqroot'/'power'/'logit'/'probit'/'recip'/'complog'
%
% Estimation procedure has been copied and modified from the package:
% ================ [GLMLAB by Peter Dunn (08 Mar 1999)] ==================
% Original files: www.mathworks.com/matlabcentral/fileexchange/195-glmlab
% This GLM package is essentially the same as Peter Dunn's, but does not
% recquire the usage of the GLMLAB GUI and outputs results like in R.
% This package also calculates some additional measure-of-fit statistics.
% ------------------------------------------------------------------------
% Some key notes for usage:
% - Supply the X and Y variables in structs, with one variable per element.
%
%   For example: 
%         Y.Distance = ...
%         X.Speed = ...
%         X.Time = ...
%
% - Every supplied variable should be a N x 1 column vector where the rows
%   are the observations.
% - It is also possible to supply weights (in struct W) and an offset
%   (in struct O) to be taken into account in the estimation procedure.
%   As with X and Y, the variables inside the struct should be N x 1.
% - When using the binomial distribution, Y should contain a variable
%   with two columns: (column 1) the responses, (column 2) the sample size
%   per response. If you don't have sample sizes, simply make columns 2
%   a vector of only ones.
% ------------------------------------------------------------------------
% Options:
%  - GLM.Distribution   'normal'/'gamma'/'inv_gsn'/'poisson'/'binomial'
%  - GLM.Link           'id'/'log'/'sqroot'/'power'/'logit'/'probit'/'recip'/'complog'
%  - GLM.Residual       type of residuals, 'deviance'(default)/'pearson'
%  - GLM.Scale          'mean deviance'(default),'fixed',[positive number]
%  - GLM.Intercept      use intercept, 'on'(default)/'off'
%  - GLM.ShowEquation   display equation, 'on'(default)/'off'
%  - GLM.Display        display output, 'on'(default)/'off'
%  - GLM.Recycle        use fit as starting values, 'on'/'off'(default)
%  - GLM.illctol        ill-conditioned threshold. default = 1e-10
%  - GLM.toler          tolerance. default = 1e-10
%  - GLM.maxit          max iterations. default = 30
% ------------------------------------------------------------------------
% Estimating a GLM model involves three steps:
%  (1) Create a GLM model object:                    mdl = GLM;
%  (2) Specifying the needed link and distribution:  mdl.Distribution = ..
%                                                    mdl.Link = ..
%  (3) Estimate parameters with the data:            mdl.Estimate(Y,X);
%
% After estimation, it is also possible to fit ..
% .. new values to the estimated model as follows:   fit = mdl.Fit(Xnew);
%
% The results are almost completely identical with the estimation in R.
% For comparison, try the Demo.R file (as included in folder) that
% gives the same output as the demo examples below. See for yourself.
% ========================================================================
%        NEVERTHELESS: this code is still relatively unstable.
% ========================================================================
% This code has not been peer-reviewed and may give wrong outputs.
% The internal estimation of GLM has been directly copied from Peter Dunn.
% There is no guarantee that this code is correct. Do not rely on it.
% Check with other applications (e.g. R) to verify the correctness.
% ========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               SPECIFY WHICH DEMO's TO RUN (1 to 5)
                        DEMO = [1,2,5];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add GLM package to workspace
addpath(genpath('GLM'));

% Make sample data variables:
clear X Y Xnew Ybin W O;
Y.MilesPerGallon = [38,26,22,32,36,27,27,44,32,28,31]';
X.Horsepower = [85,92,112,96,84,90,86,52,84,79,82]';
X.Acceleration = [17,14.5,14.7,13.9,13,17.3,15.6,24.6,11.6,18.6,19.4]';
X.Cylinders = [6,4,6,4,4,4,4,4,4,4,4]';

% Make weights.
W.Importance = [1,2,2,2,3,2,2,2,1,1,1]';

% Make offset (e.g. measurement error: MilesPerGallon overestimated by 5).
O.MeasurementError = 5.*ones(11,1);

% Make new data to fit after estimation (out-of-sample).
Xnew.Horsepower = [70,67,67,67,110]';
Xnew.Acceleration = [16.9,15,15.7,16.2,16.4]';
Xnew.Cylinders = [4,4,4,4,6]';

% Make new variable for binomial model.
% Column 1 is response, column 2 is sample size.
Ybin.SecondHand(:,1) = [0,1,1,1,0,0,1,0,0,1,1]';
Ybin.SecondHand(:,2) = [1,1,1,1,1,1,1,1,1,1,1]'; % (sample sizes just 1)

% ------------------------------------------------------------------------
% Demo 1: fitting a GLM with normal distribution and identity link.
if ismember(1,DEMO)
fprintf('\n\n');
fprintf(' ================================================\n');
fprintf('  DEMO 1: normal distribution with identity link\n');
fprintf(' ================================================');

mdl = GLM;
mdl.Distribution = 'normal';
mdl.Link = 'id';
mdl.Estimate(Y,X);

% Fit new data (out-of-sample)
fit = mdl.Fit(Xnew);
fprintf('Fitted out-of-sample values:\n');
disp(fit);
end
% ------------------------------------------------------------------------
% Demo 2: fitting a GLM with gamma distribution and log link.
if ismember(2,DEMO)
fprintf('\n\n');
fprintf(' ================================================\n');
fprintf('  DEMO 2: gamma distribution with log link\n');
fprintf(' ================================================');

mdl = GLM;
mdl.Distribution = 'gamma';
mdl.Link = 'log';
mdl.Estimate(Y,X);
end
% ------------------------------------------------------------------------
% Demo 3: fitting a GLM with gamma distribution and log link.
% Where the observations are weighted by another variable.
if ismember(3,DEMO)
fprintf('\n\n');
fprintf(' ======================================================\n');
fprintf('  DEMO 3: gamma distribution with log link and weights\n');
fprintf(' ======================================================');

mdl = GLM;
mdl.Distribution = 'gamma';
mdl.Link = 'log';
mdl.Estimate(Y,X,W);        % Note: now includes weights 'W'.
end
% ------------------------------------------------------------------------
% Demo 4: fitting a GLM with binomial distribution and probit link.
if ismember(4,DEMO)
fprintf('\n\n');
fprintf(' ================================================\n');
fprintf('  DEMO 4: binomial distribution with probit link\n');
fprintf(' ================================================');

mdl = GLM;
mdl.Distribution = 'binomial';
mdl.Link = 'probit';
mdl.Estimate(Ybin,X);
end
% ------------------------------------------------------------------------
% Demo 5: GLM with binomial distibution, probit link, weight and offset.
if ismember(5,DEMO)
fprintf('\n\n');
fprintf(' ============================================================\n');
fprintf('  DEMO 5: binomial dist. with probit link, weight and offset\n');
fprintf(' ============================================================');

mdl = GLM;
mdl.Distribution = 'binomial';
mdl.Link = 'probit';
mdl.Estimate(Ybin,X,W,O);   % Note: now includes weights 'W' and offset 'O'
end


% ========================================================================
% This is free and unencumbered software released into the public domain.
% 
% Anyone is free to copy, modify, publish, use, compile, sell, or
% distribute this software, either in source code form or as a compiled
% binary, for any purpose, commercial or non-commercial, and by any
% means.
% 
% In jurisdictions that recognize copyright laws, the author or authors
% of this software dedicate any and all copyright interest in the
% software to the public domain. We make this dedication for the benefit
% of the public at large and to the detriment of our heirs and
% successors. We intend this dedication to be an overt act of
% relinquishment in perpetuity of all present and future rights to this
% software under copyright law.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
% IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
% OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
% OTHER DEALINGS IN THE SOFTWARE.
% 
% For more information, please refer to <http://unlicense.org>
% ========================================================================