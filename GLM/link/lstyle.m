function answ=lstyle(input1,input2,what)
%LSTYLE A template for user-defined link functions in glmlab.
%USE:  answ=lstyle(input1,input2,what)
%   where  input1 and input2 are inputs depending on what is wanted (see below);
%          what  returns what is asked:
%             what== 'eta' returns the eta, the linear predictor;
%             what== 'mu' returns mu, the fitted values;
%             what== 'detadmu', returns the derivative d(eta)/d(mu);
%          answ  is the answer asked for.
%Called by  irls, glmfit.

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

%Because of the way glmlab access this file, some things may seem strange,
%but don't monkey with things too much or things will go all crooked.
%REMEMBER TO CHANGE THE FUNCTION NAME IN LINES 1 AND 2, AND DON'T
%OVERWRITE THIS FILE!  THAT WOULD BE SILLY.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%EVERYTHING ABOVE THIS LINE MUST BE INCLUDED%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%BELOW THIS LINE ARE THE MATLAB INSTRUCTION FOR FINDING%%%
%%%THE LINEAR PREDICTOR, ETA (eta), THE FITTED VALUES, MU%%%
%%%(mu) AND THE DERIVATIVE D(ETA)/D(MU) (detadmu).       %%%
%%%YOU MAY NEED TO INCLUDE  SOME FANCY  FIDDLING TO ALLOW%%%
%%%FOR SOME ODD SITUATIONS (ie when taking logs to ensure%%%
%%%that you aren't taking the logarithm of a non-positive%%%
%%%quantity).  REMEMBER THE CODE NEEDS TO BE VECTORISED!!%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(what,'eta'),
   %%%In here, you need lines to find the eta from mu.
   %%%The section should return the eta as  answ
elseif strcmp(what,'mu');
   %%%In here, you need lines to find mu from eta.
   %%%The section should return mu and  answ
else
   %%%In here, you need lines to find detadmu from mu
   %%%The section should return detadmu from mu
end;
