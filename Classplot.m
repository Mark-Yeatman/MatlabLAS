
function [] = Classplot(X,Y,Z,C)
%
LowVeg=[15/256,59/256,4/256];   %class 3
MedVeg=[90/256,179/256,7/256];  %4
HighVeg=[26/256,1,0];           %5
Ground=[140/256,56/256,14/256]; %2/1 assuming all unclassified points are ground
Water=[14/256,83/256,140/256];  %9
Building=[0 0 0];               %6
for i=1:size(X)
   G=plot3(X(i),Y(i),Z(i));
   if C(i)==1 ||C(i)==2
       set(G,'Color',Ground);
   elseif C(i)==3    
       set(G,'Color',LowVeg);
   elseif C(i)==4
       set(G,'Color',MedVeg);
   elseif C(i)==5
       set(G,'Color',HighVeg);
   elseif C(i)==6
       set(G,'Color',Building);
   elseif C(i)==9
       set(G,'Color',Water);
   end
end    

end

