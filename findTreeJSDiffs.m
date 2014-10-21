function JSs = findTreeJSDiffs(crossSpeciesJS,crossSpeciesJSDivs,tree)

    L = length(tree(:,1));
    N = length(crossSpeciesJS(:,1));
    JSs = cell(L,1);
    
    
    for i=1:L
        
        a = tree(i,1:2);
        
        if max(a) <= N
            
            JSs{i} = crossSpeciesJS{a(1),a(2)};
            
        else
            
            idx1 = findTreeIndicesFromRoot(tree,a(1));
            idx2 = findTreeIndicesFromRoot(tree,a(2));
            
            D = crossSpeciesJSDivs(idx1,idx2);
            [ii,jj] = find(D == min(D(:)));
            
            JSs{i} = crossSpeciesJS{ii(1),jj(1)};
            
            
        end
        
        
    end