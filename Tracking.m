clc
clear variables
close all

%% Determening paths and setting folders
currdir = pwd;
addpath(pwd);
filedir = uigetdir();
cd(filedir);
L_cells = struct([]);
Cad_im2 = struct([]);
%cc_cells = struct([]);
se90I = strel('line', 7, 90);
se0I = strel('line', 7, 0);

tif8_dir =[filedir, '/8bit']; 
tif16_dir =[filedir, '/16bit']; 
%Folder to save information about cells
mkdir(filedir, 'Cells');
cells_dir = [filedir, '/Cells'];

cd(tif16_dir);
files_tif = dir('*.tif');

for g=1:numel(files_tif)
    cd(tif16_dir);
    if g<11
        Image = ['embr6000', num2str(g-1),'.tif'];
        Border = [tif8_dir, '/embryo6000', num2str(g-1)];
    elseif g<101
        Image = ['embr600', num2str(g-1),'.tif'];
        Border = [tif8_dir, '/embryo600', num2str(g-1)];
    else 
        Image = ['embr60', num2str(g-1),'.tif'];
        Border = [tif8_dir, '/embryo60', num2str(g-1)];
    end
    cd(tif16_dir);
    Cad_im = imread(Image);
    Cad_im2{g} = uint16(Cad_im);
    
    cd(Border);
    B = imread('tracked_bd.png');
    
    B=im2bw(B,1/255);
    B = imdilate(B, [se90I se0I]);
    B2 =  imcomplement(B);
    B2 = imclearborder(B2);
    cc_cells = bwconncomp(B2);
    L_cells{g} = labelmatrix(cc_cells);

end

number = zeros(max(max(L_cells{1})),g-1);
number(:,1) = 1:max(max(L_cells{1}));
L_new = struct([]);
L_new{1} = L_cells{1};
for g=2:numel(files_tif)
    L_new{g} = zeros(size(L_cells{1},1),size(L_cells{1},2));
    for i=1:max(max(L_cells{1}))
        number(i,g) = mode(L_cells{g}(L_new{g-1}==i));
        L_new{g}(L_cells{g}==number(i,g)) = i;
    end    
end
number2=number;
for l=1:size(number,1)
    for k=1:size(number,2)
        if number2(l,k)==0 || isnan(number2(l,k)) == 1;
            number(l,:)=[];
        end
    end
end

registering;

cd(currdir);
%% Matching cells

%     Cad_new = zeros(size(Cad_im2,1), size(Cad_im2,1));
%     for i=1:size(Cad_im2,1)
%         for l=1:size(Cad_im2,1)
%             Cad_new(i,l) = Cad_im2(i,l)*uint16(B2(i,l));
%         end
%     end