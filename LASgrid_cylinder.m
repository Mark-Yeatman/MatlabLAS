function [zmingrid,densgrid,LAIgrid,LADgrid, xvec,yvec] = LASgridcylinder(infilename,cylrad,dz)
% The purpose of the function is to produce gridded LAD data in a matlab
% fromat. 

% INPUT
% infilename:   input file name in LAS 1.1 format 
%               (for example, 'myinfile.las') 
% outfilename:  output file name in text format 
%               (for example, 'myoutfile.txt')
% nFields:      default value of 1 outputs X, Y and Z coordinates of the 
%               point - [X Y Z]. 
%               A value of 2 gives Intensity as an additional attribute - [X Y Z I].
%               A value of 3 gives the Return number and the Number of returns 
%               in addition to the above - [X Y Z I R N].                
%           
% OUTPUT
% outfile:      the output matrix
% 
%
% Cici Alexander
% September 2008 (updated 26.09.2008)
%keyboard
% Open the file
fid =fopen(infilename);

% Check whether the file is valid
if fid == -1
    error('Error opening file')
end

% Check whether the LAS format is 1.1
fseek(fid, 24, 'bof');
VersionMajor = fread(fid,1,'uchar');
VersionMinor = fread(fid,1,'uchar');
if VersionMajor ~= 1 %|| VersionMinor ~= 1
    error('LAS format is not 1.1')
end

% Read in the offset to point data
fseek(fid, 96, 'bof');
OffsetToPointData = fread(fid,1,'uint32');

% Read in the scale factors and offsets required to calculate the coordinates
fseek(fid, 131, 'bof');
XScaleFactor = fread(fid,1,'double');
YScaleFactor = fread(fid,1,'double');
ZScaleFactor = fread(fid,1,'double');
XOffset = fread(fid,1,'double');
YOffset = fread(fid,1,'double');
ZOffset = fread(fid,1,'double');

% The number of bytes from the beginning of the file to the first point record
% data field is used to access the attributes of the point data
%
c = OffsetToPointData;



% Read in the X coordinates of the points
%
% Reads in the X coordinates of the points making use of the 
% XScaleFactor and XOffset values in the header.
fseek(fid, c, 'bof');
X1=fread(fid,inf,'int32',24);
X=X1*XScaleFactor+XOffset;
%I = X > 333100.66 & X < 333473;%333272.00 m E
% Read in the Y coordinates of the points
fseek(fid, c+4, 'bof');
Y1=fread(fid,inf,'int32',24);
Y=Y1*YScaleFactor+YOffset;
%I = I & Y > 6472500 & Y < 6473000; %6472771.00 m N
% Read in the Z coordinates of the points
fseek(fid, c+8, 'bof');
Z1=fread(fid,inf,'int32',24);
Z=Z1*ZScaleFactor+ZOffset;


% Read in the Intensity values of the points
fseek(fid, c+12, 'bof');
Int=fread(fid,inf,'uint16',26);
% 

% Read in the Return Number of the points. The first return will have a
% return number of one, the second, two, etc.
fseek(fid, c+14, 'bof');
Rnum=fread(fid,inf,'bit3',221);

fseek(fid, c+15, 'bof');
flag=fread(fid,inf,'uchar',27);

fseek(fid, c+16, 'bof');
phi=fread(fid,inf,'schar',27);

% figure(1);clf
% hist(phi,100)


I = Rnum == 1 & Z < 50 & Z > 0;
%I = z < 50 & z > 0;

X = X(I);Y = Y(I);Z = Z(I);flag = flag(I);phi = phi(I);

minx = min(X);miny = min(Y);

% I = X > minx & X <= (minx+dxdy) & Y > miny & Y <= (miny + dxdy);
% X = X(I);Y = Y(I);Z = Z(I);flag = flag(I);phi = phi(I);
%keyboard
clear Rnum Int
i = 1;
xi = min(X) + cylrad;
%hgrid = ones(248,248);densgrid = hgrid;zgrid = hgrid;zmingrid = hgrid;
hmax = 45;
while xi < max(X)-cylrad
    xvec(i) = xi;
    j = 1;yi = min(Y) + cylrad;
    I = X >= xi-cylrad & X < xi+cylrad;
    Xslab = X(I);Yslab = Y(I);Zslab = Z(I);flagslab = flag(I);phislab = phi(I);
    while yi < max(Y)-cylrad  
        yvec(j) = yi; 
        J = sqrt((Yslab-yi).^2 + (Xslab -xi).^2) <= cylrad;   
        Xcyl = Xslab(J);Ycyl = Yslab(J);Zcyl = Zslab(J);flagcyl = flagslab(J);phicyl = phislab(J);
        densgrid(i,j) = length(Xcyl)/(pi*cylrad^2);  
        if isempty(Zcyl)
            zmin = 0; 
            LAIgrid(i,j) = 0;
        else 
            zmin = mean(Zcyl(flagcyl == 2));
            LAIgrid(i,j) = -2*log(length(Zcyl(flagcyl == 2))/length(Zcyl));
        end
        zmingrid(i,j) = zmin;
%        Nground(i,j) = length(Zcyl(flagcyl == 2));
%        Ntot(i,j) = length(Zcyl);
        for k = hmax:-1:1
            %keyboard
            K = Zcyl > (k-1+zmin) & Zcyl <= (hmax+zmin);
            Kminus = Zcyl > (k+zmin) & Zcyl <= (hmax+zmin);
            if isempty(find(K))
                LADgrid(i,j,k) = 0;
            elseif k == hmax
                LADgrid(i,j,k) = -2*cosd(mean(abs(phicyl(K))))/dz*log((length(Zcyl)-length(Zcyl(K)))/length(Zcyl));
                %LADgrid(i,j,k) = -2/dz*log((length(Zcyl)-length(Zcyl(K)))/length(Zcyl));
             elseif k == 1               
                 LADgrid(i,j,k) = -2*cosd(mean(abs(phicyl(K))))/dz*log(length(Zcyl(flagcyl==2))/(length(Zcyl)-length(Zcyl(Kminus))));
                 %LADgrid(i,j,k) = -2/dz*log(length(Zcyl(Zcyl < zmin+0.5))/(length(Zcyl)-length(Zcyl(Kminus))));
            else
                LADgrid(i,j,k) = -2*cosd(mean(abs(phicyl(K))))/dz*log((length(Zcyl)-length(Zcyl(K)))/(length(Zcyl)-length(Zcyl(Kminus))));
                %LADgrid(i,j,k) = -2/dz*log((length(Zcyl)-length(Zcyl(K)))/(length(Zcyl)-length(Zcyl(Kminus))));
            end
            k
        end
        yi = yi + 10 
        j = j + 1;
    end
    
    xi = xi + 10;
    i = i + 1
    %pause
end
%keyboard
%Write out the file with X, Y and Z coordinates, Intensity, Return Number 
% and Number of Returns depending on the fields specified in the input 
% if nFields == 1
% outfileheader = ['X' 'Y' 'Z'];
% outfile = [X Y Z];
% elseif nFields == 2
% outfileheader = ['X' 'Y' 'Z' 'I'];
% outfile = [X Y Z Int]; 
% elseif nFields == 3
% outfileheader = ['X' 'Y' 'Z' 'I' 'R' 'N'];
% outfile = [X Y Z Int Rnum Num];
% end
% 
% dlmwrite(outfilename,outfileheader);
% dlmwrite(outfilename,outfile, '-append','precision','%.2f','newline','pc');
 
