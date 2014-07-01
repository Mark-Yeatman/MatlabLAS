function[X Y Z C Int Rnum Num]=LAStoMatrix(infilename,X0,Y0,dx,dy)
%Summary: returns reflections in Matrix format

% INPUT
% infilename:   input file name in LAS 1.1 format 
%               (for example, 'myinfile.las') 
% X0, Y0, dx,dy, define parameters for selecting a subset of data points
% from the input file. X0,Y0 is the center of the desired rectangle
% subset. dx,dy are the max distances from X0,Y0. 
% OUTPUT:
% X,Y,Z are the  coordinates of the points
% C is the class of each point, Int=Intensity of the Reflection
% RNum=return number, Num=Number of Returns for the X,Y,Z coordinate
% note, not every X,Y,Z coordinate is unique
%
% Cici Alexander(although at this point its mostly by Mark Yeatman)
% September 2008 (updated 26.09.2008)

% Open the file
fid =fopen(infilename);

% Check whether the file is valid
if fid == -1
    error('Error opening file')
end

% Check the record format
fseek(fid, 104, 'bof');
RecordFormat=fread(fid,1,'uchar');
fclose(fid);
if RecordFormat==1
    if nargin<6
        [X Y Z C Int Rnum Num]=readVersion1(infilename);
    else 
        [X Y Z C Int Rnum Num]=readVersion1(infilename,X0,Y0,dx,dy);
    end
end
if RecordFormat==3
    if nargin<6
        [X Y Z C Int Rnum Num]=readVersion3(infilename);
    else
        [X Y Z C Int Rnum Num]=readVersion3(infilename,X0,Y0,dx,dy);
    end    
end
   fclose(fid);
end
%helper functions
function[X Y Z C Int Rnum Num]=readVersion1(infilename,X0,Y0,dx,dy)
    fid =fopen(infilename);
    %Read in the offset to point data
    fseek(fid, 96, 'bof');
    OffsetToPointData = fread(fid,1,'uint32');
    c = OffsetToPointData;
    
    % Read in the scale factors and offsets required to calculate the coordinates
    fseek(fid, 131, 'bof');
    XScaleFactor = fread(fid,1,'double');
    YScaleFactor = fread(fid,1,'double');
    ZScaleFactor = fread(fid,1,'double');
    XOffset = fread(fid,1,'double');
    YOffset = fread(fid,1,'double');
    ZOffset = fread(fid,1,'double');

    % Read in the X coordinates of the points
    %
    % Reads in the X coordinates of the points making use of the 
    % XScaleFactor and XOffset values in the header.
    fseek(fid, c, 'bof');
    X1=fread(fid,inf,'int32',24);
    X=X1*XScaleFactor+XOffset;clear X1

    % Read in the Y coordinates of the points
    fseek(fid, c+4, 'bof');
    Y1=fread(fid,inf,'int32',24);
    Y=Y1*YScaleFactor+YOffset;clear Y1

    % Read in the Z coordinates of the points
    fseek(fid, c+8, 'bof');
    Z1=fread(fid,inf,'int32',24);
    Z=Z1*ZScaleFactor+ZOffset;clear Z1
    %read classification
    fseek(fid,c+15,'bof');
    C=fread(fid,inf,'char*1',27);

    % Read in the Intensity values of the points
    fseek(fid, c+12, 'bof');
    Int=fread(fid,inf,'uint16',26);

    % Read in the Return Number of the points. The first return will have a
    % return number of one, the second, two, etc.
    fseek(fid, c+14, 'bof');
    Rnum=fread(fid,inf,'bit3',221);

    % Read in the Number of Returns for a given pulse.
    fseek(fid, c+14, 'bof');
    fread(fid,1,'bit3');
    Num=fread(fid,inf,'bit3',221);

    %cuts points not in bounds defiend by X0,Y0,dx,dy
    
end
function[X Y Z C Int Rnum Num]=readVersion3(infilename,X0,Y0,dx,dy)
    fid =fopen(infilename);
    % Read in the offset to point data
    fseek(fid, 96, 'bof');
    OffsetToPointData = fread(fid,1,'uint32');
    c = OffsetToPointData;

    % Read in the scale factors and offsets required to calculate the coordinates
    fseek(fid, 131, 'bof');
    XScaleFactor = fread(fid,1,'double');
    YScaleFactor = fread(fid,1,'double');
    ZScaleFactor = fread(fid,1,'double');
    XOffset = fread(fid,1,'double');
    YOffset = fread(fid,1,'double');
    ZOffset = fread(fid,1,'double');

    % Read in the X coordinates of the points
    %
    % Reads in the X coordinates of the points making use of the 
    % XScaleFactor and XOffset values in the header.
    fseek(fid, c, 'bof');
    X1=fread(fid,inf,'int32',30);
    X=X1*XScaleFactor+XOffset;clear X1

    % Read in the Y coordinates of the points
    fseek(fid, c+4, 'bof');
    Y1=fread(fid,inf,'int32',30);
    Y=Y1*YScaleFactor+YOffset;clear Y1

    % Read in the Z coordinates of the points
    fseek(fid, c+8, 'bof');
    Z1=fread(fid,inf,'int32',30);
    Z=Z1*ZScaleFactor+ZOffset;clear Z1
    %read classification
    fseek(fid,c+15,'bof');
    C=fread(fid,inf,'char*1',33);

    %Read in the Intensity values of the points
    fseek(fid, c+12, 'bof');
    Int=fread(fid,inf,'uint16',32);

    % Read in the Return Number of the points. The first return will have a
    % return number of one, the second, two, etc.
    fseek(fid, c+14, 'bof');
    Rnum=fread(fid,inf,'bit3',269);

    % Read in the Number of Returns for a given pulse.
    fseek(fid, c+14, 'bof');
    fread(fid,1,'bit3');
    Num=fread(fid,inf,'bit3',269);

   

end
