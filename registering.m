[Cell(1:size(number,1),1:numel(files_tif))] = struct('X', [], 'Y', [], 'Pixels', []);

for g=1:numel(files_tif)
    cc_cells = bwconncomp(L_new{g});
    s_cells = regionprops(cc_cells, Cad_im2{g},'PixelList','PixelValues','Centroid');
    for i=1: size(number,1)
        Cell(i,g).X =  s_cells(i).PixelList(:,1)-round(s_cells(i).Centroid(1)); 
        Cell(i,g).Y =  s_cells(i).PixelList(:,2)-round(s_cells(i).Centroid(2)); 
        Cell(i,g).Pixels =  s_cells(i).PixelValues;
    end
end

