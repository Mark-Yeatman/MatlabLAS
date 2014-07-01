%Author: Mark Yeatman
%findLASfile: outputs list of LAS files in the same directory that contain 
%   input coordinates
%   zone_of_data specifies the coordinate system of the DataSet. should be
%       in the format of ('number letter') e.g ('32 U')
%   relies on the files utm2deg and deg2utm to be present in same directory
%   computes based on max X, min X, max Y, min Y
function [output] = findLASfile(x,y,zone_of_data)
    filetype='*.las';
    listing=dir(filetype);  
    index=1;
    output=cell(size(listing));
    for j=1:size(listing)
        filename=listing(j).name;
        fileIn=fopen(filename);
        fseek(fileIn,179,'bof');
        max_X=fread(fileIn,1,'double');
        min_X=fread(fileIn,1,'double');
        max_Y=fread(fileIn,1,'double');
        min_Y=fread(fileIn,1,'double');   
        %conditional statement allows user to specify zone 
        if nargin==3
            [min_X min_Y]=utm2deg(min_X,min_Y,zone_of_data);
            [min_X min_Y]=deg2utm(min_X,min_Y);
            [max_X max_Y]=utm2deg(max_X,max_Y,zone_of_data);
            [max_X max_Y]=deg2utm(max_X,max_Y);
        end    
        if x<=max_X && x>=min_X && y<=max_Y && y>=min_Y
            output{index}=listing(j).name;
            index=index+1;
        end    
    end
    fclose('all');
    output(cellfun(@isempty,output))=[];
end

