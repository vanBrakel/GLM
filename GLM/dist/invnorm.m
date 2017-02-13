function x=invnorm(p,mu,sigma)
%INVNORM  Inverse cumulative normal ditsribution
%USE:  x=invnorm(p,mu,sigma)
%  where x  is the inverse of the cumulative normal distribution;
%        p  is the probability;
%        mu  is the mean (default is zero);
%        sigma  is the standard deviation (default is 1);
%

%Copyright 1996 Peter Dunn
%11/11/1996

if nargin<3,
   sigma=1;
end;
if nargin==1,
   mu=0;
end;

%error checks
if ~(sigma>0), 
   error('sigma  must be positive!'); 
end;
if size(p)~=size(mu) | size(p)~=size(sigma),
   error('Inputs arguments must be the same size!');
end;
%end error checks

x = mu + sqrt(2)*sigma.*erfinv(2*p-1);
