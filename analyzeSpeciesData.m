function [speciesDensities,crossSpeciesJS,crossSpeciesJSDivs] = analyzeSpeciesData(data,speciesIdx,xx,sigma,plotsOn,titles)


    if length(data(:,1)) ~= length(speciesIdx)
        cVals = speciesIdx;
        speciesIdx = zeros(length(data(:,1)),1);
        for i=1:6
            speciesIdx(cVals(4*i-3)+1:cVals(4*i+1)) = i;
        end
    end
    
    species = unique(speciesIdx);
    
    L = length(species);
    minVal = min(xx);
    maxVal = max(xx);
    numPoints = length(xx);
    
    speciesDensities = cell(L,1);
    for i=1:L
        [~,speciesDensities{i}] = findPointDensity(data(speciesIdx==species(i),:),sigma,numPoints,[minVal maxVal]);
    end
    
    
    crossSpeciesJS = cell(L,L);
    for i=1:L
        for j=(i+1):L
            crossSpeciesJS{i,j} = findMatrixJSDivergence(speciesDensities{i},speciesDensities{j},true);
            crossSpeciesJS{j,i} = -crossSpeciesJS{i,j};
        end
    end
    
    
    crossSpeciesJSDivs = zeros(L);
    for i=1:L
        for j=(i+1):L
            crossSpeciesJSDivs(i,j) = sum(abs(crossSpeciesJS{i,j}(:)))*(xx(2)-xx(1))^2;
            crossSpeciesJSDivs(j,i) = crossSpeciesJSDivs(i,j);
        end
    end
    
    if plotsOn
        
        figure
        dim1 = ceil(sqrt(L));
        dim2 = ceil(L/dim1);
        
        for i=1:L
            subplot(dim2,dim1,i)
            imagesc(xx,xx,speciesDensities{i})
            set(gca,'ydir','normal');axis equal tight off;
            caxis([0 .8e-3]);
            title(titles{i},'FontSize',16,'FontWeight','Bold');
        end
        
        
        figure
        for i=1:L
            
            if i == 1
                subplot(L,L,1)
                title(titles{1},'FontSize',16,'FontWeight','Bold');
                axis off
            end
            
            for j=(i+1):L
                subplot(L,L,(i-1)*L+j)
                imagesc(xx,xx,crossSpeciesJS{i,j})
                set(gca,'ydir','normal');axis equal tight off;
                caxis([-3e-4 3e-4])
                if i == 1
                    title(titles{j},'FontSize',16,'FontWeight','Bold');
                end
                subplot(L,L,(j-1)*L+i)
                imagesc(xx,xx,crossSpeciesJS{j,i})
                set(gca,'ydir','normal');axis equal tight off;
                caxis([-3e-4 3e-4])
            end
        end
        
        
        figure
        imagesc(1:L,1:L,crossSpeciesJSDivs)
        set(gca,'yTickLabel',titles)
        set(gca,'xTickLabel',titles,'FontSize',16,'FontWeight','Bold')
        axis equal tight
       
        figure
        DD = makePdistForm(crossSpeciesJSDivs);
        Z = linkage(DD,'single');
        dendrogram(Z,'Orientation','left','Labels',titles);
        
        
        
    end

    
    
    
    