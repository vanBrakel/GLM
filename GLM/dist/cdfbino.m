function [y] = cdfbino(X, N, P)
% CDFBINO Returns the cumulative bimonial distn always returning a number
%          (unlike MATLAB's BINOCDF which can return NaN)
% USE: [y] = cdfbino(X,N,P)

%Copyright 1996 Peter Dunn
%11/11/1996

zz=find(X<0);
zn=find(X>=N);
ze=[1:length(X)]';
ze([zn;zz])=[];

yy=zeros(size(N));

if zn,
   yy(zn)=ones(size(zn));
end;

if ze,
   yy(ze)=1-betainc(P(ze),X(ze)+1,N(ze)-X(ze));
end;

y=yy;
