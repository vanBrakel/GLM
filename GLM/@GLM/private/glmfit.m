function [ obj ] = glmfit(obj,yvar,xvar,wvar,ovar)
%GLMFIT Fits a generalised linear model (glm)
% USE: [beta,serrors,fits,res,covarbeta,covdiff,devlist,linpred]=glmfit(y,x)
%   where  y  is the response variable;
%             (For a binomial response, y  has two columns:
%              the first contains  y, the second has the sample sizes)
%          x  is the covariate matrix 
%             (the number of columns of  x  is the number of variables.
%          beta  contains the parameters estimates;
%          serrors   are the standard errors;
%          fits  are the fitted values;
%          covarbeta  covariance matrix of the parameter estimates;
%          res  are the standardised residuals:
%             (y-fits)*sqrt(prior wt / (scale parameter*variance function))
%          covdiff  is the var/covariance matrix of standard error of parameter
%             differences.
%          devlist  is a vector of residual deviance for iterations of the fit.
%          linpred  is the linear predictor.
%          xnames  is a string array of the names of the variables (as in the output).
%
% Both vectors  y,  x,  should be the same length: the number of observations.
%
% Only  y  is needed.  If  x  is not supplied, only the constant term is fitted.
%
%ALSO SEE:  glmlab (fitting glm's using glmfit) where  glmfit  is used.

%Copyright 1996--1998 Peter Dunn
%30 July 1998

%Setup
covarbeta=[];
covdiff=[];
y=yvar;
fprintf('\n');

%Some necessary fiddling
[yrows,ycols]=size(y);

if nargin < 4 || isempty(wvar)
    wvar = ones(yrows,1);
end
if nargin < 5 || isempty(ovar)
    ovar = zeros(yrows,1);
end

%Make each row an observation
%can't use  y=y(:)  since the binomial case has two columns
if yrows<ycols, 
   y=y';
end;

ylen=length(y);

if ycols==2,                %Binomial case: extract responses and sample sizes
   m=y(:,2);
   y=y(:,1);
else
   m=ones(size(y));
end;
m=m(:);

if exist('rownamexv')==1,   %rownamexv = GLMLAB_INFO_{13}
   namelist=rownamexv;
end;

%X variables names
if strcmp(obj.Intercept,'on'),    %if include_constant, tag such on
   x=[ones(yrows,1),xvar];
   if ismember('(Intercept)',obj.Xlabel) == 0
        obj.Xlabel = ['(Intercept)', obj.Xlabel];
   end
else
   x=xvar;
end;
%end of that bit of fiddling

zerowts=sum(wvar==0);			%Number of points with zero wight
effpts=ylen-zerowts;			%Effective number of points

% Weight also to smaller form
w = wvar;
o = ovar;

%%%DO THE NUMBER CRUNCHING:
[beta,mu,xtwx,devlist,~,eta] = irls(obj,y,x,w,m,o,true);
%%%DONE THE NUMBER CRUNCHING

% Calculate other statistics.
if ~isempty(devlist),               %if empty, an error
   curdev = devlist(end);           %deviance for current model
   curdf = effpts-length(beta);     %df for current model
   if (curdf<0), 		    %if more estimates than points
      curdf=0;
   end;
   if (strcmp(obj.Distribution,'normal') || ...
           strcmp(obj.Distribution,'gamma') ) && (curdf==0),
      dispers = Inf;                 %Otherwise gives warning: Divide by zero
   else
      if ~ischar(obj.Scale),
         dispers = obj.Scale;
      else
         dispers = curdev/curdf;
      end;
   end;
   covarbeta = real(pinv(xtwx)*dispers);
   
   % Update deviance list.
   devlist=[devlist;curdev];
   
   %Display results
   if strcmp(obj.Display,'on'), %display the parameter estimates

        line=' ============================================================';
        if strcmp(obj.ShowEquation,'on')
            total = 11;
            total = total + length(obj.Ylabel);
            total = total + length(strjoin(obj.Xlabel));
            total = total + length(obj.Link);
            total = total + 2*length(obj.Xlabel);
            total = total + 3*(length(obj.Xlabel)-1);
            sline = [' ' repmat('-',1,total)];
            disp(sline);
            fprintf('    dependent: %s',obj.Ylabel);
            fprintf('\n  independent: %s',strjoin(obj.Xlabel,','));
            fprintf('\n');
            disp(sline);
            fprintf('  %s(E[%s]) = ',obj.Link,obj.Ylabel);
            for v = 1:length(obj.Xlabel)
                if v > 1
                    fprintf(' + ');
                end
                fprintf('ß%d×%s',v,obj.Xlabel{v});
            end
            fprintf('\n');
            disp(sline);
        else
            fprintf('\n');
        end
        fprintf(' distribution: %s',upper(obj.Distribution));
        fprintf('\n         link: %s',upper(obj.Link));
        fprintf('\n       weight: %s',obj.Wlabel);
        fprintf('\n       offset: %s',obj.Olabel);
        fprintf('\n');
        disp(line);
        disp('     Variable    Estimate     S.E.    z-value    Pr(>|z|)');
        disp(line);

        for k = 1:size(x,2)
            name = obj.Xlabel{1,k};
            se = sqrt(covarbeta(k,k));
            zval = beta(k)/se;
            pval = 2*(1-cdfnorm(abs(zval),0,1));
            fprintf('  %12s   %8.3f   %7.3f   % 3.3f \t %3.5f\n',name,beta(k),se,zval,pval);
        end
        disp(line);
   end

    k = 1; %scale parameter used
    if ~isempty(obj.Scale), 
        if ~ischar(obj.Scale), 
            k=obj.Scale; 
        end; 
    end;

    % Calculate the RESIDUALS
    res = findres(obj,y,m,mu,k,wvar,lower(obj.Residual));

    % Calculate deviance.
    if ischar(obj.Scale), 
       sdev = curdev;
    else 
       sdev = curdev/obj.Scale; 
    end;
    
    % Calculate saturated model.
    xsat = ones(ylen,ylen);
    for d=1:ylen
        xsat(d,d) = 0;
    end
    
    [~,~,~,iclist,~,~] = irls(obj,y,ones(ylen,1),w,m,o,false);
    nullDeviance = iclist(end);
    
    % Calculate other output.
    McFaddenR2 = 1 - curdev/nullDeviance;
    MSE_deviance = mean(findres(obj,y,m,mu,k,wvar,'deviance').^2);
    MSE_pearson  = mean(findres(obj,y,m,mu,k,wvar,'pearson').^2);
    DIC = curdev + var(findres(obj,y,m,mu,k,wvar,'deviance'));
    
    covdiff=zeros(size(covarbeta));
    for ii=1:length(covarbeta),
        for jj=ii+1:length(covarbeta),
            cvd=real(sqrt(covarbeta(ii,ii)+covarbeta(jj,jj)-2*covarbeta(ii,jj)));
            covdiff(ii,jj)=cvd;
            covdiff(jj,ii)=cvd;
        end;
    end;
    
    if strcmp(obj.Display,'on'), %display the parameter estimates
        fprintf('  Residual deviance:  %9.4f     Deviance MSE: %-5.4f\n',sdev,MSE_deviance);
        fprintf('  Null deviance:      %9.4f     Pearson MSE:  %-5.4f\n',nullDeviance,MSE_pearson);

        if ~isfinite(dispers),
          fprintf('  Dispersion parameter cannot be found: 0 degrees of freedom.\n');
        else
          fprintf('  Dispersion:         %9.4f     Deviance IC:  %-5.4f\n',dispers,DIC);
        end;
        fprintf('  McFadden R^2:       %9.4f     Residual df:  %-5.4f\n',McFaddenR2,curdf);
        
        disp(line);
        disp(' ');

        if ~isfinite(dispers)
           disp(' WARNING:  Non-finite dispersion.');
        end
    end
else
    errordlg('The model cannot be fitted sensibily; check the inputs and settings.',...
            'Model not fitted.')
    res = [];
end

% Save output to object.
obj.Y = y;
obj.X = x;
obj.W = w;
obj.Beta = beta;
obj.StErrors = diag(covarbeta);
obj.Fitted = mu;
obj.FittedEta = eta;
obj.XWX = xtwx;
obj.Df = curdf;
obj.ResidDeviance = curdev;
obj.NullDeviance = nullDeviance;
obj.McFaddenR2 = McFaddenR2;
obj.MSE_deviance = MSE_deviance;
obj.MSE_pearson = MSE_pearson;
obj.Dispersion = dispers;
obj.Residuals = res;
obj.BetaCov = covarbeta;
obj.DiffCov = covdiff;
obj.DIC = DIC;

end

