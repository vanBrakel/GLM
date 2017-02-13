function res=findres(obj,y,m,mu,k,pwvar,type)
%FINDRES Finds residuals in glmlab

%Peter Dunn
%30 July 1998

%Set up
reps=1;
[yrows,ycols]=size(y);
ylen=length(y);
distinfo=['d',obj.Distribution];

%For discrete distns and quantile residuals, replications
%are useful (as there is a random element).  See if the
%user would like replications (and how many).
if strcmp(lower(type),'quantile')&&(strcmp(type,'poisson')||strcmp(type,'binomial')),

   bell;
   reply=-1;					%Set an invalid reply to enter loop

   while reply<0				%While an invalid reply...
      reply=inputdlg([errdis,' quantile residuals contain random elements.  ',...
         'How many sets of residuals would you like calculated?'],...
         'Replication of Residuals',1,{'1'});   %Default n just one rep
      if sum(size(reply))==0, 			%CANCEL or empty
         reply{1}='1'; 
      end; 
      reply=str2num(reply{1});			%Convert reply to a number
   end;

   reps=reply;

   if length(reps)==0,				%If blank reply
      reps=1;
   end;

   tag='s';					%For plurals
   if reps==1, 
      tag='';
   end;

   %Message
   disp([' * Finding ',num2str(reps),' set',tag,...
         ' of ',errdis,' quantile residuals.']);
end;

%Set up  res  matrix
res=zeros(length(y),reps);

for ii=1:reps,				%For each replication...
   if strcmp(type,'deviance'),       %deviance residuals
      rescol=zeros(yrows,1);		%Set this column as zeroes
      for jj=1:ylen,			%For each data point...
         yy=y(jj);
         mmu=mu(jj);
         rescol(jj)=sign(yy-mmu)*...
            sqrt(feval(distinfo,2,yy,mmu,m(jj),pwvar(jj)));
      end;

   elseif strcmp(type,'pearson'),    %pearson residuals
      rescol=zeros(yrows,1);
      for jj=1:ylen,
         yy=y(jj);
         mmu=mu(jj);
         rescol(jj)=(yy-mmu)* sqrt(pwvar(jj)/...
                   (k*feval(distinfo,1,m(jj),mmu,m(jj),pwvar(jj))) );
      end;

   else                 		%quantile residuals

      if strcmp(obj.Distribution,'normal'),
         rescol=(y-mu)./sqrt(k) .*sqrt(pwvar);
      elseif strcmp(obj.Distribution,'gamma'),
         rescol=invnorm(cdfgam(y,mu,k)).*sqrt(pwvar);
      elseif strcmp(obj.Distribution,'inv_gsn'),
         kk=k;
         if length(k)==1, 
            kk=k*ones(size(y)); 
         end;
         rescol=zeros(length(y),1);
         hwbar = waitbar(0,'Computing Residuals...');		%Can be a long process
         for i=1:length(y)
            cdfinv_gsn=quad8('pdf_ig',0,y(i),[],[],mu(i),1/kk(i));
            rescol(i)=invnorm(cdfinv_gsn).*sqrt(pwvar(i));
            waitbar(i/length(y));		%Update waitbar
         end;
         close(hwbar);				%Delete waitbar
      else 					%discrete distns

         ok=1;
         if strcmp(obj.Distribution,'binomial'),
            phat=mu./m;
            p0=cdfbino(y-1,m,phat);
            p1=cdfbino(y,m,phat);
            p0=p0-p0.*(y==0);
         elseif strcmp(obj.Distribution,'poisson'),
            p0=cdfpoiss(y-1,mu);
            p1=cdfpoiss(y,mu);
         end;

         if ok,
            r=p0+(p1-p0).*rand(length(p0),1);
            rescol=invnorm(r);
         end;
      end;
   end;
   res(:,ii)=rescol;
end;

return;
