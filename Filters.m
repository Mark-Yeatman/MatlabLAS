classdef Filters <handle
    %FILTERS contains filter functions
    %Sort of designed to be used with input from LAStoMatrix function
    
    % X,Y,Z are coordinates, C is classification, Int is intensity, Rnum is
    % return number, Num is number of returns, 
    properties
        X; 
        Y;
        Z; 
        C; 
        Int; 
        Rnum; 
        Num;
        filterIndex;
    end
    
    methods
        function obj= Filters(x,y,z,c,int,rnum,num)
            obj.X=x; 
            obj.Y=y;
            obj.Z=z; 
            obj.C=c; 
            obj.Int=int; 
            obj.Rnum=rnum; 
            obj.Num=num;
            obj.filterIndex=ones(size(x));
        end
        %filters out all points where the z coordinate is less than height
        function[x y z c int rnum num]=ZLessThan(obj,height)
           I= obj.Z>height;
           obj.filterIndex= obj.filterIndex&I;
           x=obj.X(I); y=obj.Y(I); z=obj.Z(I); c=obj.C(I); 
           int=obj.Int(I); rnum=obj.Rnum(I); num=obj.Num(I);
        end
        %filters out all points where the z coordinate is greater than height
        function[x y z c int rnum num]=ZGreaterThan(obj,height)
           I=obj.Z<height;
           obj.filterIndex= obj.filterIndex&I;
           x=obj.X(I); y=obj.Y(I); z=obj.Z(I); c=obj.C(I); 
           int=obj.Int(I); rnum=obj.Rnum(I); num=obj.Num(I);
        end   
        %filters out all points not in the area defined by X0,Y0,dx,dy
        %where X0,Y0 is the center of a rectangle, dx,dy are max distances
        %from X0,Y0
        function[x y z c int rnum num]=KeepArea(obj,X0,Y0,dx,dy)
            I= abs(obj.X-X0)<dx & abs(obj.Y-Y0)<dy;
            obj.filterIndex= obj.filterIndex&I;
            x=obj.X(I); y=obj.Y(I); z=obj.Z(I); c=obj.C(I); 
            int=obj.Int(I); rnum=obj.Rnum(I); num=obj.Num(I);
        end
        %filters out all water points
        function[x y z c int rnum num]=Water(obj)
            I= obj.C==9;
            obj.filterIndex= obj.filterIndex&I;
            x=obj.X(I); y=obj.Y(I); z=obj.Z(I); c=obj.C(I); 
            int=obj.Int(I); rnum=obj.Rnum(I); num=obj.Num(I);
        end
        %filters points classified as ground
        function[x y z c int rnum num]=GroundClass(obj)
            I= obj.C==2;
            obj.filterIndex= obj.filterIndex&I;
            x=obj.X(I); y=obj.Y(I); z=obj.Z(I); c=obj.C(I); 
            int=obj.Int(I); rnum=obj.Rnum(I); num=obj.Num(I);
        end
        %resets filterIndex to all ones
        function ClearFilter(obj)
            obj.filterIndex=ones(size(obj.X));
        end
        %filters out return numbers specified by returns
        function[x y z c int rnum num]=Returns(obj,returns)
            if returns>5
                error('LAS format does not support data with more than 5 returns');
            end
            for i=1:size(returns)
                I= obj.Rnum~=returns(i);
                x=obj.X(I); y=obj.Y(I); z=obj.Z(I); c=obj.C(I); 
                int=obj.Int(I); rnum=obj.Rnum(I); num=obj.Num(I);
            end    
        end
        %implements MCC-Lidar algorithm to filter ground points, INCOMPLETE
        function[x y z c int rnum num]=Ground(obj)
            %{
            SD=1; % : scale domain, integer in [1,3] (variable l (lowercase "L") in paper)
            tSD=0.3; %: curvature tolerance for scale domain SD
            
            t1 = specified by user
            t2 = t1 + 0.1
            t3 = t2 + 0.1
            CRSD=1.5 % : cell resolution for scale domain SD (lambda variable in paper)
            CR1 = 0.5 * CR2
            CR2 = specified by user (nominal post-spacing of input LiDAR data)
            CR3 = 1.5 * CR2
            f : tension parameter (invariant across scale domains)
            f = 1.5
            U : vector of points that remain unclassified
            U = (P1 , P2 , P3 , ... Pn)
            n : # of points in U (at the start of each loop pass)
            Pj : single LiDAR point
            Pj = (xj , yj , zj)
            U0 = initial point-cloud data specified by user
            U = filter out higher points at same x,y using filterxy in U0 and classify them as non-ground
            for scale domain (SD) = 1 to 3:
            . . repeat
            . . . . S = interpolate new raster surface using TPS(U, CRSD, f)
            . . . . S' = surface resulting from passing 3x3 averaging kernel over S
            . . . . for each point Pj in U:
            . . . . . . if zj > S'(xj , yj) + tSD then
            . . . . . . . . classify Pj as non-ground and remove it from U
            . . . . nC : # of points classified and removed from U during current iteration through inner loop
            . . until nC < 0.1% * n
            classify all the points remaining in U as ground
        %}    
        end    
        %helper function to MCC-lidar algorithm INCOMPLETE
        function[x y z c int rnum num]=MCCFilterXY(obj)
            %{
         Interpolation of a raster surface requires that no two points have the same x and y coordinates 
        (it causes problems mathematically). If two or more points are at the same x,y location, 
        then all the points except the lowest point (i.e., with minimum z coordinate) must be non-ground. 
        So those higher points can be classified and removed from the list of unclassified points.
                for each x,y location in U0 with two or points:
                . . zlowest = minimum z coordinate of the points at x,y
                . . for each point Pj at x,y:
                . . . . if zj > zlowest then
                . . . . . . classify Pj as non-ground and remove it from U0
            %}
        end    
        %supposed to get unqiue x,y points, picking the lowest z coordinate ? INCOMPLETE
        function[x y z c int rnum num]=FilterXY(obj)
            X=obj.X;
            Y=obj.Y;
            Z=obj.Z;
            Point=[X;Y];
            Point=transpose(Point);
            [UniPoint,ia,ic] = unique(Point,'rows');
            countOfX = hist(ic,unique(ic));
            i= (countOfX~=1);
            indexToRepeatedValue=ic(i);
            
            repeatedValues = uniqueX(indexToRepeatedValue);
            numberOfAppearancesOfRepeatedValues = countOfX(indexToRepeatedValue);
        end 
        %supposed to thin data while maintaining representitive information
        %IMCOMPLETE
        function[x y z c int rnum num]=Thin(obj)
            
        end
        %IMCOMPLETE, makes new las file based on applied filters
        function las2las(obj,inputfilename, newfilename)
            inputfile=fopen(inputfilename);
            newfile=fopen(newfilename);
            headerinfo=readHeaderLAS(inputfilename);
            recordLength=headerinfo{17};
            
            %{ 
                need to change:
                generating software
                number of points records
                no of points by return
                max x, min z, max y, min y, max z, min z
            %}
            
            %writes all the data
            for k=1: size(obj.filterIndex)
                if obj.filterIndex(k)
                    
                end    
            end
        end
    end
    
end

