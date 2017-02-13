function answ=lpower(input1,input2,what)
%LPOWER Calculates all kinds of things for power link functions:
%USE:  answ=lpower(input1, input2, what)
%   where  y  is the observed y vector;
%          input1  is the input1 needed, determined by what you want out!
%          what  returns what is asked:
%             what=='eta' returns the linear predictor, eta; (input1 is mu)
%             what=='mu' returns the mean, mu; (input1 is eta)
%             what=='detadmu' returns the derivative d(eta)/d(mu) (input1 is mu);
%          answ  is the answer asked for.
%Called by glmfit and irls.

%Copyright 1996, 1997 Peter Dunn
%01 August 1997

%  input2 is only used for binomial (logit/complg) cases, when  input2=m.
%  for finding eta,           input1 = mu
%  for finding mu,            input1 = eta
%  for finding d(eta)/d(mu),  input1 = mu

extrctgl;
if ~isstr(link), pw=link; link='power';end;

m=input2;
if strcmp(what,'mu'),
   eta=input1;
else
   mu=input1;
end;

if strcmp(what,'eta'),
   answ=mu.^pw;
elseif strcmp(what,'mu'),
   eta=eta.*(eta>0)+(eta<=0);
   answ=exp(1/pw * log(eta));%pw'th root of eta
else
   mu=mu.*(mu>0)+(mu<=0);
   answ=pw.*mu.^(pw-1);
end;
