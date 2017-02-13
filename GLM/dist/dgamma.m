function answ=dgamma(what,y,mu,m,weights)
%DGAMMA Calculates all kinds of things for gamma distributions.
%USE:  answ=dgamma(what,y,mu,m,weights)
%   where  y,  mu,  m and  weights  are the obvious;
%          what  returns what is asked:
%             what== 1 returns the variance function;
%             what== 2 returns the deviance/scaled deviance;
%          answ  is the answer asked for.
%Called by  irls, glmfit.

%Copyright 1996, 1997 Peter Dunn
%Last revision: 15 May 1997

if what==1,
   answ=(mu.^2)+0.00000001*(mu==0);      %in case  mu=0
   answ=answ.*(answ>0)+(answ<=0);        %removes negative mu's
elseif what==2,
   mu=mu+0.00000001*(mu==0);             %in case  mu=0
   yy=y+(y==0).*mu;                      %in case  y=0
   answ=2*sum( weights.*(-log(yy./mu) + (y-mu)./mu ) );
end
