function answ=lrecip(input1,input2,what)
%LRECIP Calculates all kinds of things for reciprocal link functions:
%USE:  answ=lrecip(input1, input2, what)
%   where  y  is the observed y vector;
%          input1  is the input1 needed, determined by what you want out!
%          what  returns what is asked:
%             what=='eta' returns the linear predictor, eta; (input1 is mu)
%             what=='mu' returns the mean, mu; (input1 is eta)
%             what=='detadmu' returns the derivative d(eta)/d(mu) (input1 is mu);
%          answ  is the answer asked for.
%Called by glmfit and irls.

%Copyright 1996 Peter Dunn
%11/11/1996

%  input2 is only used for binomial (logit/complg) cases, when  input2=m.
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
   mu=mu+(mu==0);
   answ=1./mu;
elseif strcmp(what,'mu'),
   eta=eta+(eta==0);
   answ=1./eta;
   answ=answ.*(answ>0)+(answ<=0); %makes sure that mu>0
else
   mu=mu+(mu==0);
   answ=-1./(mu.^2);
end;
