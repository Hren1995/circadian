function [ydata,betas,P,Q] = tsne_d(D, labels, no_dims, perplexity, relTol,...
                                    lie_multiplier,max_iter,stop_lying_iter,...
                                    mom_switch_iter,readout,outputFile)
%TSNE_D Performs symmetric t-SNE on the pairwise Euclidean distance matrix D
%
%   mappedX = tsne_d(D, labels, no_dims, perplexity)
%   mappedX = tsne_d(D, labels, initial_solution, perplexity)
%
% The function performs symmetric t-SNE on the NxN pairwise Euclidean 
% distance matrix D to construct an embedding with no_dims dimensions 
% (default = 2). An initial solution obtained from an other dimensionality 
% reduction technique may be specified in initial_solution. 
% The perplexity of the Gaussian kernel that is employed can be specified 
% through perplexity (default = 30). The labels of the data are not used 
% by t-SNE itself, however, they are used to color intermediate plots. 
% Please provide an empty labels matrix [] if you don't want to plot 
% results during the optimization.
% The data embedding is returned in mappedX.
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
    
    if nargin < 4 || isempty(perplexity)
        perplexity = 30;
    end
    
    if nargin < 5 || isempty(relTol)
        relTol = 1e-4;
    end
    
    if nargin < 6 || isempty(lie_multiplier)
        lie_multiplier = 10;
    end
    
    if nargin < 7 || isempty(max_iter)
        max_iter = 1000;
    end
    
    if nargin < 8 || isempty(stop_lying_iter)
        stop_lying_iter = 100;
    end
    
    if nargin < 9 || isempty(mom_switch_iter)
        mom_switch_iter = 150;
    end
    
    if nargin < 10 || isempty(readout)
        readout = 1;
    end
    
    if nargin < 11 || isempty(outputFile)
        outputFile = [];
    end
    
    
    
    % First check whether we already have an initial solution
    if numel(no_dims) > 1
        initial_solution = true;
        ydata = no_dims;
        no_dims = size(ydata, 2);
    else
        initial_solution = false;
    end
    
    % Compute joint probabilities
    D = D / max(D(:));                                     % normalize distances
    [P,betas] = d2p_sparse(D .^ 2, perplexity, 1e-5);      % compute affinities using fixed perplexity
    
    unix('purge');
    
    
    % Run t-SNE
    if initial_solution
        [ydata,Q] = tsne_p_sparse(P, labels, ydata,relTol,lie_multiplier,...
            max_iter,stop_lying_iter,mom_switch_iter,readout,outputFile);
    else
        [ydata,Q] = tsne_p_sparse(P, labels, no_dims,relTol,lie_multiplier,...
            max_iter,stop_lying_iter,mom_switch_iter,readout,outputFile);
        
    end
    