function answ=dstyle(what,y,mu,m,weights)
%DSTYLE A template for user-defined distributions in glmlab.
%USE:  answ=dstyle(what,y,mu,m,weights)
%   where  y,  mu,  m and  weights  are the obvious;
%          what  returns what is asked:
%             what== 1 returns the variance function;
%             what== 2 returns the deviance/scaled deviance;
%          answ  is the answer asked for.
%Called by  irls, glmfit.

%Copyright 1996, 1997 Peter Dunn
%15/05/1997

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%EVERYTHING ABOVE THIS LINE MUST BE INCLUDED%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%BELOW THIS LINE ARE THE MATLAB INSTRUCTION FOR FINDING%%%
%%%THE VARIANCE FUNCTION (varfn), AND THE SCALED DEVIANCE%%%
%%%YOU MAY NEED TO INCLUDE  SOME FANCY  FIDDLING TO ALLOW%%%
%%%FOR SOME ODD SITUATIONS (ie when taking logs to ensure%%%
%%%that you aren't taking the logarithm of a non-positive%%%
%%%quantity).  REMEMBER THE CODE NEEDS TO BE VECTORISED!!%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calculate
if what==1,
   %%%In here, you need lines to find the variance function
   %%%from  mu  and  y.
   %%%The section should return the variance function as  answ
elseif what==2,
   %%%In here, you need lines to find the scaled deviance
   %%%from  mu  and  y.
   %%%The section should return the scaled deviance as  answ
end;
