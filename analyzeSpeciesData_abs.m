function [speciesDensities,crossSpeciesDiffs,crossSpeciesDs] = analyzeSpeciesData_abs(data,speciesIdx,xx,sigma,plotsOn,titles)

    species = unique(speciesIdx);
    L = length(species);
    minVal = min(xx);
    maxVal = max(xx);
    numPoints = length(xx);
    
    speciesDensities = cell(L,1);
    for i=1:L
        [~,speciesDensities{i}] = findPointDensity(data(speciesIdx==species(i),:),sigma,numPoints,[minVal maxVal]);
    end
    
    
    crossSpeciesDiffs = cell(6,6);
    for i=1:6
        for j=(i+1):6
            crossSpeciesDiffs{i,j} = speciesDensities{i}-speciesDensities{j};
            crossSpeciesDiffs{j,i} = -crossSpeciesDiffs{i,j};
        end
    end
    
    
    crossSpeciesDs = zeros(6);
    for i=1:6
        for j=(i+1):6
            crossSpeciesDs(i,j) = sum(abs(crossSpeciesDiffs{i,j}(:)))*(xx(2)-xx(1))^2;
            crossSpeciesDs(j,i) = crossSpeciesDs(i,j);
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
                imagesc(xx,xx,crossSpeciesDiffs{i,j})
                set(gca,'ydir','normal');axis equal tight off;
                caxis([-3e-4 3e-4])
                if i == 1
                    title(titles{j},'FontSize',16,'FontWeight','Bold');
                end
                subplot(L,L,(j-1)*L+i)
                imagesc(xx,xx,crossSpeciesDiffs{j,i})
                set(gca,'ydir','normal');axis equal tight off;
                caxis([-3e-4 3e-4])
            end
        end
        
        
        figure
        imagesc(1:L,1:L,crossSpeciesDs./2)
        set(gca,'yTickLabel',titles)
        set(gca,'xTickLabel',titles,'FontSize',14,'FontWeight','Bold')
        axis equal tight
       
        figure
        DD = makePdistForm(crossSpeciesDs./2);
        Z = linkage(DD,'single');
        dendrogram(Z,'Orientation','left','Labels',titles);
        
        
        
    end

    
    
    
    