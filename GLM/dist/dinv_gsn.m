function answ=dinv_gsn(what,y,mu,m,weights)
%DINV_GSN The distribution information for the inverse Gaussian distribution.
%USE:  answ=dinv_gsn(what,y,mu,m,weights)
%   where  y,  mu,  m and  weights  are the obvious;
%          what  returns what is asked:
%             what== 1 returns the variance function;
%             what== 2 returns the deviance/scaled deviance;
%          answ  is the answer asked for.
%Called by  irls, glmfit.

%Copyright 1996, 1997 Peter Dunn
%15/05/1997

if what==1,
   answ=mu.^3;
elseif what==2;
   answ=sum( (weights.*(y-mu).^2)./(mu.^2 .*y));
end;
