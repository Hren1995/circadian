function [ydata,Q] = tsne_p_sparse(P, labels, no_dims,relTol,...
                        lie_multiplier,max_iter,stop_lying_iter,...
                        mom_switch_iter,readout,outputFile)
                    
%TSNE_P Performs symmetric t-SNE on affinity matrix P
%
%   mappedX = tsne_p(P, labels, no_dims)
%
% The function performs symmetric t-SNE on pairwise similarity matrix P 
% to create a low-dimensional map of no_dims dimensions (default = 2).
% The matrix P is assumed to be symmetric, sum up to 1, and have zeros
% on the diagonal.
% The labels of the data are not used by t-SNE itself, however, they 
% are used to color intermediate plots. Please provide an empty labels
% matrix [] if you don't want to plot results during the optimization.
% The low-dimensional data representation is returned in mappedX.
%
%
% (C) Laurens van der Maaten, 2010
% University of California, San Diego
    
    if nargin < 2 || isempty(labels)
        labels = [];
    end
    
    if nargin < 3 || isempty(no_dims)
        no_dims = 2;
    end
    
    if nargin < 4 || isempty(relTol)
        relTol = 1e-4;
    end
    
    if nargin < 5 || isempty(lie_multiplier)
        lie_multiplier = 10;
    end
    
    if nargin < 6 || isempty(max_iter)
        max_iter = 1000;
    end
    
    if nargin < 7 || isempty(stop_lying_iter)
        stop_lying_iter = 100;
    end
    
    if nargin < 8 || isempty(mom_switch_iter)
        mom_switch_iter = 100;
    end
    
    if nargin < 9 || isempty(readout)
        readout = 1;
    end
    
    if nargin < 10 || isempty(outputFile)
        outputVal = false;
    else
        outputVal = true;
    end
    
    % First check whether we already have an initial solution
    if numel(no_dims) > 1
        initial_solution = true;
        ydata = no_dims;
        no_dims = size(ydata, 2);
    else
        initial_solution = false;
    end
    
    % Initialize some variables
    n = size(P, 1);                                     % number of instances
    momentum = 0.5;                                     % initial momentum
    final_momentum = 0.8;                               % value to which momentum is changed
    epsilon = 500;                                      % initial learning rate
    min_gain = .01;                                     % minimum gain for delta-bar-delta
    old_cost = 1e10;
    

    % Make sure P-vals are set properly
    P(1:(n + 1):end) = 0;                                 % set diagonal to zero
    P = 0.5 * (P + P');                                 % symmetrize P-values
    idx = find(P > 0);
    
    P(idx) = P(idx) ./ sum(P(idx));                     % make sure P-values sum to one
    const = sum(P(idx) .* log(P(idx)));                     % constant in KL divergence
    if ~initial_solution
        P = P * lie_multiplier;                                      % lie about the P-vals to find better local minima
        lying_stopped = false;
    else
        lying_stopped = true;
    end
    
    % Initialize the solution
    if ~initial_solution
        ydata = .0001 * randn(n, no_dims);
    end

    y_incs  = zeros(size(ydata));
    gains = ones(size(ydata));
    
    
    % Run the iterations
    for iter=1:max_iter

        Q = 1 ./ (1 + findAllDistances(ydata).^2);
        Q(1:n+1:end) = 0;
        Z = sum(Q(:));
        Q = Q./Z;
        
        % Compute the gradients (faster implementation)
        L = Z * (P - Q) .* Q;
        y_grads = 4 * (diag(sum(L, 1)) - L) * ydata;
        
        % Update the solution  
        gains = (gains + .2) .* (sign(y_grads) ~= sign(y_incs)) ...         % note that the y_grads are actually -y_grads
              + (gains * .8) .* (sign(y_grads) == sign(y_incs));
        gains(gains < min_gain) = min_gain;
        y_incs = momentum * y_incs - epsilon * (gains .* y_grads);
        ydata = ydata + y_incs;
        ydata = bsxfun(@minus, ydata, mean(ydata, 1));

        cost = const - sum(P(idx) .* log(Q(idx)));
        diffVal = (old_cost - cost) / old_cost;
        old_cost = cost;
        
        
        % Update the momentum if necessary
        if iter == mom_switch_iter
            momentum = final_momentum;
            lying_stopped = true;
        end
        if iter == stop_lying_iter && ~initial_solution
            P = P ./ lie_multiplier;     
        end
        
        % Print out progress
        if ~rem(iter, readout)
            
            disp(['Iteration ' num2str(iter) ': error is ' num2str(cost) ,', change is ' num2str(diffVal)]);
        end
        
                
        % Display scatter plot (maximally first three dimensions)
        if ~rem(iter, readout) && ~isempty(labels)
            if no_dims == 1
                scatter(ydata, ydata, 9, labels, 'filled');
            elseif no_dims == 2
                scatter(ydata(:,1), ydata(:,2), 19, labels, 'filled');
                q = max(abs(ydata(:)));
                axis equal
                axis([-q q -q q])
            else
                scatter3(ydata(:,1), ydata(:,2), ydata(:,3), 40, labels, 'filled');
                axis equal
            end
            
            if outputVal
                q = 5 - length(num2str(iter));
                save([outputFile 'positions' repmat('0',1,q) num2str(iter) '.txt'],'ydata','-ascii');
            end
            
            drawnow
        end
        
        if abs(diffVal) < relTol && lying_stopped
            break;
        end
        
    end
    