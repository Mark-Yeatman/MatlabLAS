% function for plotting 'plot3' in colours 
function [] = plot3colour(x,y,z,NoOfBins,class)
% Create matrix with colors corresponding to NoOfBins

%Cmatrix(1,:) = [0.6 0.2 0];
%Cmatrix(NoOfBins,:) = [0 1 0];
% I = z > 1000 | z < -2;
% z(I) = mean(z);

minZ = min(z);
maxZ = max(z);
if maxZ > 110;
     maxZ = 500;
end
Zvec = linspace(minZ,maxZ,NoOfBins+1);
for i = 1:NoOfBins
   Cmatrix = [0.6-(i-1)/NoOfBins*0.6  0.2+(i/NoOfBins)*0.8 0];     
   I = z > Zvec(i) & z <= Zvec(i+1);
   h = plot3(x(I),y(I),z(I),'.','MarkerSize',4);hold on
   set(h,'Color',Cmatrix)
   Cmatrix_save(i,:) = Cmatrix;
end
I = z > maxZ;
plot3(x(I),y(I),z(I),'k.','MarkerSize',4);hold on

if nargin~=5
    %Cmatrix((class==6),:)=[205 7 245];    
    set(h,'Color',Cmatrix);
end
h = plot3(x(I),y(I),z(I),'.','MarkerSize',4);hold on
%h = plot3(x(I),y(I),z(I),'.','MarkerSize',9);hold on
%set(h,'Color',[0 0 0])
% colorbar
% colormap(Cmatrix_save)
% caxis([minZ maxZ])





%%
function dir = plotdata(x,y)
%meanx= 5.594849926415094e+05;meany = 6.348563059245287e+06;
meanx = mean(x);meany = mean(y);
plot(x-meanx,y-meany,'*');hold on
p1 = polyfit(x-meanx,y-meany,1);
%minx1 = min(x-meanx);maxx1 = max(x-meanx);
x1 = -3:1:3;
%dir = atand(p1(1))+360;
dir = abs(atand(p1(1)))+270;

y1 = polyval(p1,x1);
plot(x1,y1,'k-')
axis([-3 3 -3 3]);axis square;grid on
