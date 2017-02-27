classdef GLM < handle
    % GLM model object that fits a Generalized Linear Model
    %
    % Includes 'normal'/'gamma'/'inv_gsn'/'poisson'/'binomial' distributions
    % and 'id'/'log'/'sqroot'/'power'/'logit'/'probit'/'recip'/'complog' link functions.
    %
    % Options:
    %  - GLM.Distribution   'normal'/'gamma'/'inv_gsn'/'poisson'/'binomial'
    %  - GLM.Link           'id'/'log'/'sqroot'/'power'/'logit'/'probit'/'recip'/'complog'
    %  - GLM.Residual       type of residuals, 'deviance'(default)/'pearson'
    %  - GLM.Scale          'mean deviance'(default),'fixed',[positive number]
    %  - GLM.Intercept      use intercept, 'on'(default)/'off'
    %  - GLM.ShowEquation   display equation, 'on'(default)/'off'
    %  - GLM.Display        display output, 'on'(default)/'off'
    %  - GLM.Recycle        use fit as starting values, 'on'/'off'(default)
    %  - GLM.illctol        ill-conditioned threshold. default = 1e-10
    %  - GLM.toler          tolerance. default = 1e-10
    %  - GLM.maxit          max iterations. default = 30
    %
    % Example usage: 
    % 
    %   >> mdl = GLM;
    %   >> disp(mdl);
    %   >> mdl.Distribution = 'gamma';
    %   >> mdl.Link = 'log';
    %   >> disp(mdl);
    %   >> mdl.Estimate(X,Y);
    
    properties
        Distribution    = 'normal';
        Link            = 'id';
        Residual        = 'deviance';
        Scale           = 'mean deviance';
        Intercept       = 'on';
        Y               = [];
        X               = [];
        W               = [];
        O               = [];
        Ylabel          = '';
        Xlabel          = {};
        Wlabel          = '-';
        Olabel          = '-';
        Beta            = [];
        StErrors        = [];
        Fitted          = [];
        FittedEta       = [];
        Residuals       = [];
        ResidDeviance   = [];
        NullDeviance    = [];
        Dispersion      = [];
        McFaddenR2      = [];
        MSE_deviance    = [];
        MSE_pearson     = [];
        DIC             = [];
        BetaCov         = [];
        DiffCov         = [];
        XWX             = [];
        Df              = 0;
        ShowEquation    = 'on';
        Display         = 'on';
        Recycle         = 'off';
        illctol         = 1e-10;
        toler           = 1e-10;
        maxit           = 30;
    end
    
    methods
        % ========================== METHODS =============================
        function Estimate(this,Y,X,W,O)
            % Estimate model using X and Y data.
            
            % Check x variable.
            if ~isstruct(X)
                error('X must be a struct with the variables');
            end
            ocs = 'may only have one column (rows are observations).';
            x = [];
            xfields = fieldnames(X);
            for i = 1:length(xfields)
                if size(X.(xfields{i}),2) ~= 1
                    error('Variables %s',ocs);
                end
              x = [x, X.(xfields{i})];
            end
            this.Xlabel = xfields';
            % Check y variable.
            if ~isstruct(Y)
                error('Y must be a struct with the dependent variable');
            end
            yfields = fieldnames(Y);
            y = Y.(yfields{1});
            if length(yfields) > 1
                error('Y may only contain one variable.');
            end
            if strcmp(this.Distribution,'binomial') == 1 && size(y,2) ~= 2
                error(['When using a binomial distribution, ' ...
                       'Y must have two columns: responses (column 1) ' ...
                       'and sample sizes (column 2).']);
            end
            if strcmp(this.Distribution,'binomial') ~= 1 && size(y,2) ~= 1
                error('Y %s',ocs);
            end
            this.Ylabel = yfields{1};
            % Check w variable.
            if nargin > 3 && ~isempty(W)
                if ~isstruct(W)
                    error('W must be a struct with the weight variable.');
                end
                wfields = fieldnames(W);
                w = W.(wfields{1});
                if length(wfields) > 1
                    error('Weight may only contain one variable.');
                end
                if size(w,2) ~= 1
                    error('Weight %s',ocs);
                end
                this.Wlabel = wfields{1};
            else
                w = [];
            end
            % Check o variable.
            if nargin > 4
                if ~isstruct(O)
                    error('O must be a struct with the offset variable.');
                end
                ofields = fieldnames(O);
                o = O.(ofields{1});
                if length(ofields) > 1
                    error('Offset may only contain one variable.');
                end
                if size(o,2) ~= 1
                    error('Offset %s',ocs);
                end
                this.Olabel = ofields{1};
            else
                o = [];
            end
            
            % Fit data.
            this.glmfit(y,x,w,o);
        end
        
        function [fittedScaled, fittedOriginal] = Fit(this,X)
            % Fit new X values to the estimated model.
            
            % Error msg text.
            ocs = 'may only have one column (rows are observations).';
            % Check if model has been estimated.
            if isempty(this.Beta)
                error('Model has not been estimated yet. Estimate first.');
            end
            
            x = [];
            xfields = fieldnames(X);
            for i = 1:length(xfields)
                if size(X.(xfields{i}),2) ~= 1
                    error('X %s',ocs);
                end
                x = [x, X.(xfields{i})];
            end
            [fittedScaled, fittedOriginal] = fit(this,x);
        end
        
        % ======================= SETTER METHODS =========================
        % [Distribution] setter.
        function set.Distribution(this, val)
            opt = {'normal','gamma','inv_gsn','poisson','binomial'};
            if ismember(val,opt);
                this.Distribution = val;
            else
                error(['Not a valid distribution. Use ' strjoin(opt,'/')])
            end
        end
        % [Link] setter.
        function set.Link(this, val)
            opt = {'id','log','sqroot','power','logit','probit','recip','complog'};
            if ismember(val,opt);
                this.Link = val;
            else
                error(['Not a valid link function. Use ' strjoin(opt,'/')])
            end
        end
        % [Scale] setter.
        function set.Scale(this, val)
            opt = {'mean deviance','fixed'};
            if isnumeric(val) || ismember(val,opt);
                this.Scale = val;
            else
                error(['Not a valid scale. Use ' strjoin(opt,'/')])
            end
        end
        % [Residual] setter.
        function set.Residual(this, val)
            opt = {'pearson','deviance','quantile'};
            if ismember(val,opt);
                this.Residual = val;
            else
                error(['Not a valid residual type. Use ' strjoin(opt,'/')])
            end
        end
        % [Intercept] setter.
        function set.Intercept(this, val)
            opt = {'on','off'};
            if ismember(val,opt);
                this.Intercept = val;
            else
                error(['Can''t change intercept. Use ' strjoin(opt,'/')])
            end
        end
        % [Display] setter.
        function set.Display(this, val)
            opt = {'on','off'};
            if ismember(val,opt);
                this.Display = val;
            else
                error(['Can''t change display. Use ' strjoin(opt,'/')])
            end
        end
        % [ShowEquation] setter.
        function set.ShowEquation(this, val)
            opt = {'on','off'};
            if ismember(val,opt);
                this.ShowEquation = val;
            else
                error(['Can''t change ShowEquation. Use ' strjoin(opt,'/')])
            end
        end
        % [Recycle] setter.
        function set.Recycle(this, val)
            opt = {'on','off'};
            if ismember(val,opt);
                this.Recycle = val;
            else
                error(['Can''t change recycle. Use ' strjoin(opt,'/')])
            end
        end
    end
end

% ========================================================================
% This is free and unencumbered software released into the public domain.
% 
% Anyone is free to copy, modify, publish, use, compile, sell, or
% distribute this software, either in source code form or as a compiled
% binary, for any purpose, commercial or non-commercial, and by any
% means.
% 
% In jurisdictions that recognize copyright laws, the author or authors
% of this software dedicate any and all copyright interest in the
% software to the public domain. We make this dedication for the benefit
% of the public at large and to the detriment of our heirs and
% successors. We intend this dedication to be an overt act of
% relinquishment in perpetuity of all present and future rights to this
% software under copyright law.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
% IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
% OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
% OTHER DEALINGS IN THE SOFTWARE.
% 
% For more information, please refer to <http://unlicense.org>
% ========================================================================