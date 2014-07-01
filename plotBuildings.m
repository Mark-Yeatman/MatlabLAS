function [ output_args ] = plotBuildings(x,y,z,NoOfBins,class)
%Most of this code was copy pasted from plot3colour_Sky...
minZ = min(z);
maxZ = max(z);
if maxZ > 110;
     maxZ = 110;
end
Zvec = linspace(minZ,maxZ,NoOfBins+1);
magenta=[245 0 184];
for i = 1:NoOfBins
   Cmatrix = [0.6-(i-1)/NoOfBins*0.6  0.2+(i/NoOfBins)*0.8 0];
   I = z > Zvec(i) & z <= Zvec(i+1); %& class~=6;
   %Ib= z > Zvec(i) & z <= Zvec(i+1) & class==6;
   h = plot3(x(I),y(I),z(I),'.','MarkerSize',4);hold on
   set(h,'Color',Cmatrix)
   %h=plot3(x(Ib),y(Ib),z(Ib),'.','MarkerSize',4);hold on
   %set(h,'Color',magenta);
   Cmatrix_save(i,:) = Cmatrix;
end

I = z > maxZ;
plot3(x(I),y(I),z(I),'k.','MarkerSize',4)
end

