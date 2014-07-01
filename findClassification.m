%Reads all LAS files in the directory, returns name of files 
%who's points contain the input classification.
function [output] = findClassification(class)
    filetype='*.las';
    listing=dir(filetype);  
    index=1;
    output=cell(size(listing));
    for j=1:size(listing)
        [x y z c]=LAStoMatrix(listing(j).name,5);
        if ismember(class,c)
            temp=cell(2);
            temp{1}=listing(j).name;
            temp{2}=unique(c);
            output{index}=temp;
            index=index+1;
        end
    end
end

