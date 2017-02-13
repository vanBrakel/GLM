function answ=dbinomial(what,y,mu,m,weights)
%DBINOMIAL Calculates all kinds of things for binomial distributions.
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
   mu=mu+0.0001*(mu<0.0001); mu=mu-0.0001*(mu>m-0.0001);
   answ=mu-(mu.^2 ./ m);
elseif what==2,
   %lim(x->0) x*ln(x)=0 but gives NaN
   mu=mu+(mu==0);yfix=y+(y==0).*mu;
   part1=yfix.*log(yfix./mu);
   mmmu=(m-mu)+(m==mu);
   yy=m-y; yy=yy+(yy==0).*(mmmu);
   part2=yy.*log(yy./mmmu);
   answ=2*sum(weights.*(part1+part2));
end;
