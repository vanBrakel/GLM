function [ fitted, fittedEta ] = fit( obj, xvar )
% Fits values to an estimated GLM model.

% Number of observations
N = size(xvar,1);

% Transform fit back to original.
if ischar(obj.Link),
   linkinfo=['l',obj.Link];                     %the file containing link info
else
   linkinfo='lpower';                           %link info if a power link
end;

% X variables names
if strcmp(obj.Intercept,'on') && ~any(sum(xvar) == N)
   x = [ones(N,1),xvar];
else
   x = xvar;
end;

% Set m to ones.
m = ones(size(x));

% Calculate linear predictions.
if isempty(obj.O)
    o = zeros(N,1);
else
    o = obj.O;
end
       
% Find linear predictors.
linpred = x*obj.Beta + o;

% Fit values.
fitted = feval(linkinfo,linpred,m,'mu');
fittedEta = linpred;

end

