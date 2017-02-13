function p=cdfnorm(x,mu,sigma)
%CDFNORM The cumulative distribution of the normal distribution
%USE: p=cdfnorm(x,mu,sigma)
%   where  p  is the probability;
%          x  is the values at which the cdf is calculated
%          mu  is the mean (default is zero);
%          sigma  is the standard deviation (default is one).

%Copyright 1996 Peter Dunn
%11/11/1996

%Defaults
if nargin<3, 
   sigma=1; 
end;

if nargin==1, 
   mu=0; 
end;

%error checks
if ~(sigma>0), 
   error('sigma must be positive!'); 
end;

if (size(x)~=size(mu)) | (size(x)~=size(sigma)),
   error('Inputs arguments must be the same size!');
end;
%end error checks

p=0.5* (1+erf( (x-mu) ./ (sigma * sqrt(2)) ) );

big=find(p>1);
if any(big), 
   p(big)=ones(size(big)); 
end;
