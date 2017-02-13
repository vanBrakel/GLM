function answ=dpoisson(what,y,mu,m,weights)
%DPOISSON Calculates all kinds of things for poisson distributions.
%USE:  answ=dpoisson(what,y,mu,m,weights)
%   where  y,  mu,  m and  weights  are the obvious;
%          what  returns what is asked:
%             what== 1 returns the variance function;
%             what== 2 returns the deviance/scaled deviance;
%          answ  is the answer asked for.
%Called by  irls, glmfit.

%Copyright 1996, 1997 Peter Dunn
%15/05/1997

if what==1,
   mu=mu+0.00001*(mu==0);
   answ=mu;
elseif what==2,
   %Things looks messy as lim(x->0) x*ln(x) =0, but MATLAB gives NaN.
   yy=y+0.5*(y==0);mu=mu+0.5.*(mu==0);
   answ=2*sum( weights.*(y.*log(yy./mu) - (y-mu))) ;
end;
