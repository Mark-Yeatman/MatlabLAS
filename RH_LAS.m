%Need to intialize inputfilename in workspace before execution 
%script reads the header of an LAS file and displays the information to the
%terminal and stores the variables in the workspace 
%array contains all the data bundled together 
warning('off','all');
fid=fopen(inputFileName);
array=cell(36,1);
FileSignature = fread(fid,4,'uchar');
array{1}=FileSignature;
Reserved=fread(fid,4,'uchar');
array{2}=Reserved;
GUIDE1 = fread(fid,4);
array{3}=GUIDE1;
GUIDE2 = fread(fid,4);
array{4}=GUIDE2;
GUIDE3 = fread(fid,4);
array{5}=GUIDE3;
GUIDE4 = fread(fid,4);
array{6}=GUIDE4;
VersionMajor = fread(fid,1);
array{7}=VersionMajor;
VersionMinor = fread(fid,1);
array{8}=VersionMinor;
SystemIdentifier = fread(fid,32);
%SystemIdentifier=char(SystemIdentifier);
array{9}=SystemIdentifier;
GeneratingSoftware = fread(fid,32,'char');
array{10}=GeneratingSoftware;
FlightDateJulian = fread(fid,1,'short');
array{11}=FlightDateJulian;
Year = fread(fid,1,'short');
array{12}=Year;
HeaderSize = fread(fid,1,'short');
array{13}=HeaderSize;
Offsettodata = fread(fid,1,'long');
array{14}=Offsettodata;
NoOfVariableLengthRecords = fread(fid,1,'long');
array{15}=NoOfVariableLengthRecords;
PointDataFormatID= fread(fid,1,'uchar');
array{16}=PointDataFormatID;
PointDataRecordLength = fread(fid,1,'short');
array{17}=PointDataRecordLength;
NoOfPointRecords = fread(fid,1,'long');
array{18}=NoOfPointRecords;
NoOfpointsbyReturn1= fread(fid,1,'long');
array{19}=NoOfpointsbyReturn1;
NoOfpointsbyReturn2= fread(fid,1,'long');
array{20}=NoOfpointsbyReturn2;
NoOfpointsbyReturn3= fread(fid,1,'long');
array{21}=NoOfpointsbyReturn3;
NoOfpointsbyReturn4= fread(fid,1,'long');
array{22}=NoOfpointsbyReturn4;
NoOfpointsbyReturn5= fread(fid,1,'long');
array{23}=NoOfpointsbyReturn5;
XScaleFactor = fread(fid,1,'double');
array{24}=XScaleFactor;
YScaleFactor = fread(fid,1,'double');
array{25}=YScaleFactor;
ZScaleFactor = fread(fid,1,'double');
array{26}=ZScaleFactor;
XOffset = fread(fid,1,'double');
array{27}=XOffset;
YOffset = fread(fid,1,'double');
array{28}=YOffset;
ZOffset = fread(fid,1,'double');
array{29}=ZOffset;
MaxX= fread(fid,1,'double');
array{30}=MaxX;
MinX= fread(fid,1,'double');
array{31}=MinX;
MaxY= fread(fid,1,'double');
array{32}=MaxY;
MinY= fread(fid,1,'double');
array{33}=MinY;
MaxZ= fread(fid,1,'double');
array{34}=MaxZ;
MinZ= fread(fid,1,'double');
array{35}=MinZ;
pid=fid;
array{36}=pid;
%dispaly formatting
disp(strcat('File Signature =',FileSignature'));
disp(strcat('Reserved = ',num2str(Reserved')));
disp(strcat('GUID data 1 = ',num2str(GUIDE1')));
disp(strcat('GUID data 2 = ',num2str(GUIDE2')));
disp(strcat('GUID data 3 = ',num2str(GUIDE3')));
disp(strcat('GUID data 4 =',num2str(GUIDE4')));
disp(strcat('Version Major =',num2str(VersionMajor)));
disp(strcat('Version Minor = ',num2str(VersionMinor)));
disp(strcat('System Identifier = ',num2str(SystemIdentifier)'));
disp(strcat('Generating Software = ',GeneratingSoftware'));
disp(strcat('Flight Date Julian = ',num2str(FlightDateJulian)));
disp(strcat('Year = ',num2str(Year)));
disp(strcat('Header Size = ',num2str(HeaderSize)));
disp(strcat('Offset to data = ',num2str(Offsettodata)));
disp(strcat('No Of Variable LengthRecords = ',num2str(NoOfVariableLengthRecords)));
disp(strcat('Point Data Format ID = ',num2str(PointDataFormatID)));
disp(strcat('Point Data Record Length = ',num2str(PointDataRecordLength)));
disp(strcat('No Of Point Records = ',num2str(NoOfPointRecords)));
disp(strcat('No Of points by Return 1 = ',num2str(NoOfpointsbyReturn1)));
disp(strcat('No Of points by Return 2 = ',num2str(NoOfpointsbyReturn2)));
disp(strcat('No Of points by Return 3 = ',num2str(NoOfpointsbyReturn3)));
disp(strcat('No Of points by Return 4 = ',num2str(NoOfpointsbyReturn4)));
disp(strcat('No Of points by Return 5 = ',num2str(NoOfpointsbyReturn5)));
disp(strcat('X Scale Factor = ',num2str(XScaleFactor)));
disp(strcat('Y Scale Factor = ',num2str(YScaleFactor)));
disp(strcat('Z Scale Factor = ',num2str(ZScaleFactor)));
disp(strcat('X Offset = ',num2str(XOffset)));
disp(strcat('Y Offset = ',num2str(YOffset)));
disp(strcat('Z Offset = ',num2str(ZOffset)));
disp(strcat('Max X = ',num2str(MaxX)));
disp(strcat('Min X = ',num2str(MinX)));
disp(strcat('Max Y = ',num2str(MaxY)));
disp(strcat('Min Y = ',num2str(MinY)));
disp(strcat('Max Z = ',num2str(MaxZ)));
disp(strcat('Min Z = ',num2str(MinZ)));
warning('on','all');