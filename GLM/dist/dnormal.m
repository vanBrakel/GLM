function answ=dnormal(what,y,mu,m,weights)
%DNORMAL Calculates all kinds of things for normal distributions.
%USE:  answ=dnormal(what,y,mu,m,weights)
%   where  y,  mu,  m and  weights  are the obvious;
%          what  returns what is asked:
%             what== 1 returns the variance function;
%             what== 2 returns the deviance/scaled deviance;
%          answ  is the answer asked for.
%Called by  irls, glmfit.

%Copyright 1996, 1997 Peter Dunn
%15/05/1997

if what==1,
   answ=ones(size(mu)); 
elseif what==2,
   answ=sum( weights.*((y-mu).^2) );
end;
