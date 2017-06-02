[Cell(1:size(number,1),1:numel(files_tif))] = struct('X', [], 'Y', [], 'Pixels', []);
[Image_new(1:size(number,1),1:numel(files_tif))] = struct('Values',[]);

for g=1:numel(files_tif)
    cc_cells = bwconncomp(L_new{g});
    s_cells = regionprops(cc_cells, Cad_im2{g},'PixelList','PixelValues','Centroid');
    for i=1: size(number,1)
        Cell(i,g).X =  s_cells(i).PixelList(:,1)-round(s_cells(i).Centroid(1)); 
        Cell(i,g).Y =  s_cells(i).PixelList(:,2)-round(s_cells(i).Centroid(2)); 
        Cell(i,g).Pixels =  s_cells(i).PixelValues;
    end
end

maxima = zeros(size(number,1),2);
minima = zeros(size(number,1),2);
for i=1: size(number,1)
    for g=1:numel(files_tif)
        if max(Cell(i,g).X)>maxima(i,1)
            maxima(i,1)= max(Cell(i,g).X);
        end
        if max(Cell(i,g).Y)>maxima(i,2)
            maxima(i,2)= max(Cell(i,g).Y);
        end
        if min(Cell(i,g).Y)<minima(i,2)
            minima(i,2)= min(Cell(i,g).Y);
        end
        if min(Cell(i,g).X)<minima(i,1)
            minima(i,1)= min(Cell(i,g).X);
        end
    end
end

for i=1: size(number,1)
    cd(cells_dir);
    mkdir(cells_dir,num2str(i));
    cd([cells_dir, '/', num2str(i)]);
    for g=1:numel(files_tif)
        Image_new(i,g).Values = zeros(maxima(i,2)+1-minima(i,2),maxima(i,1)+1-minima(i,1));
        for k=1:length(Cell(i,g).X);
            NewX = Cell(i,g).X(k)- minima(i,1)+1;
            NewY = Cell(i,g).Y(k)- minima(i,2)+1;
            Image_new(i,g).Values(NewY,NewX) = Cell(i,g).Pixels(k);
        end
        I=struct2cell(Image_new(i,g));
        I=cell2mat(I);
        %Image_temp = figure;
        %imshow(I,[min(min(I)) max(max(I))]);
        if g<11
            Name = [num2str(i),'000', num2str(g-1),'.tif'];
        elseif g<101
            Name = [num2str(i),'00', num2str(g-1),'.tif'];
        else
            Name = [num2str(i),'0', num2str(g-1),'.tif'];
        end
        imwrite(uint16(I), Name);
        close all
    end
end

