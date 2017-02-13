function answ=lprobit(input1,input2,what)
%LPROBIT Calculates all kinds of things for probit link functions:
%USE:  answ=lprobit(input1, input2, what)
%   where  y  is the observed y vector;
%          input1  is the input1 needed, determined by what you want out!
%          what  returns what is asked:
%             what=='eta' returns the linear predictor, eta; (input1 is mu)
%             what=='mu' returns the mean, mu; (input1 is eta)
%             what=='detadmu' returns the deriv. d(eta)/d(mu) (input1 is mu);
%          answ  is the answer asked for.
%Called by glmfit and irls.

%Copyright 1996 Peter Dunn
%Last revision: 11 November 1996

%  input2 is only used for binomial (logit/complg/probit) cases, when  input2=m.
%  for finding eta,           input1 = mu
%  for finding mu,            input1 = eta
%  for finding d(eta)/d(mu),  input1 = mu

m=input2;
if strcmp(what,'mu'),
   eta=input1;
else
   mu=input1;
end;

if strcmp(what,'eta'),
   answ=sqrt(2)*erfinv(2*(mu./m)-1);
elseif strcmp(what,'mu'),
   answ=m.*(1+erf(eta/sqrt(2)))/2;
else
   answ=(sqrt(2*pi)./m).*exp((erfinv((2*mu./m)-1)).^2);
end;
