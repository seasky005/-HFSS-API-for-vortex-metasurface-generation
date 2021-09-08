%����tri-lattice-array floquet
clear, clc
% R0=110;%��ģ�����İ뾶
% R1=40;%��ģ�Ĳ����뾶
d=10;
%%%%%%%%%%%%a����Ϊ�����ת��λ����
units = 'mm';
Units = 'mm';
Type = 'csv';

% add paths to the required m-files.
relPath = 'E:\�ϵ�������2020\E�ĵ�\����\matlab��hfss����\MatlaHFSSApi/';
addpath(relPath);
hfssIncludePaths(relPath);
%%%%%%%bianliang

%%%%%%%%%�ű���ʼ׼��
false = 0;
true = 1;

fileName = ['hexagonal_element'];%�ļ���
% PrjFile = ['E:\����\matlab��hfss����\my_tmptext\',fileName,'.aedt'];
% tmpDataFile = 'E:\����\matlab��hfss����\my_tmptext\tmpData.m'
tmpScriptFile = ['E:\�ϵ�������2020\any OAM mode\shape_based script\',fileName,'.vbs'];%stript�ļ�λ��
% HFSS Executable Path.
% hfssExePath = '"D:\SimulationWare\HFSS19\AnsysEM19.0\Win64\ansysedt.exe"'; 
    fid = fopen(tmpScriptFile, 'wt');   % 'wt'��ʾ���ı�ģʽ���ļ�����д������ԭ������ 
   % ����һ���µĹ��̲�����һ���µ����
    hfssNewProject(fid);
    hfssInsertDesign(fid, fileName);
%     hfssPre(fid);
    %%%%%%%%%%%%%design Variables
%     f=7;%GHz
%     d=10;%����
    h=3;
    b1=2.6;
    b2=7.8;
    s1=0.3;
    s2=2.6;
    da=20;
%     g1=d-b1;
%     g2=d-b2;
    ob_h=100;%�۲�߶�
%     hfssaddVar(fid, 'f0', f, []);
    hfssaddVar(fid, 'd', d, units);
    hfssaddVar(fid, 'h', h, units);
    hfssaddVar(fid, 'b1', b1, units);
    hfssaddVar(fid, 'b2', b2, units);  
    hfssaddVar(fid, 's1', s1, units);
    hfssaddVar(fid, 's2', s2, units);  
    hfssaddVar(fid, 'da', da, units);  
    hfssaddVar(fid, 'p', 'sqrt(3)*d', units);
    hfssaddVar(fid, 'angl', 0 , 'deg');
%     hfssaddVar(fid, 'N', N, []); 
%     hfssaddVar(fid, 'ob_h', ob_h, units); 
%     hfssaddVar(fid, 'g1', g1, units);
%     hfssaddVar(fid, 'g2', g2, units); 
    %%%%%%%%Array of metasrface(square loop)
%     squareloopName = cell(arraynum, 1);%��Ƭ���ֹ�arraynum��
%     squareloopName1 = cell(arraynum, 1);
%     hexagonalName1 = cell(arraynum, 1);
%     numb=1;
%%  %%%%��ʼ���㽨ģ
    %��������
    hfssBox(fid, 'airbox',{'-d/2','-p/2','-da'},{'d','p','h+2*da'}, Units);
    %����sub�Ͳ���
    hfssBox(fid, 'sub',{'-d/2','-p/2','0'},{'d','p','h'}, Units);
    Er=2.65;
    bSigma=0;
    tanDelta=0.002;
    hfssAddMaterial(fid, 'myf4b', Er, bSigma, tanDelta)
    hfssAssignMaterial(fid, 'sub', 'myf4b')
    %������
    Start_gud = {'-d/2','-p/2','0'};
    hfssRectangle(fid, 'ground', 'Z', Start_gud , 'd', 'p', units);  
    CellGroundName={'ground'};
    hfssAssignPE(fid, 'gud', CellGroundName,  false);%PEC 

%% ������Ԫpatch��
patch = cell(4,1);%ԭ�ӵ��ĸ�����Ƭ
patch1 = cell(4,1);
for i=1:4
        %add local CS1
            CSName = ['CS',num2str(i)];
            if i==1
                  Origin = {'-d/2','0','h'};
            end
            if i==2
                  Origin = {'d/2','0','h'}; 
            end
            if i==3
                  Origin = {'0','p/2','h'};
            end
            if i==4
                  Origin = {'0','-p/2','h'};
            end
            XAxisVec = [1 0 0];
            YAxisVec = [0 1 0];
            hfssCreateRelativeCS(fid, CSName, Origin,XAxisVec, YAxisVec, units);
            hfssSetWCS(fid, CSName);%%����������������꽨ģloop
  %%��������
  patch{i}=['patch',num2str(i)];
  patch1{i}=['patch1',num2str(i)];
   Start_squareloop = {0,0,0};
%   hfssEllipse(fid, patch{i}, 'Z', [0,0,0], 'b1', 'b2/b1', units) 
%   hfssEllipse(fid, patch1{i}, 'Z', [0,0,0], 's1', 's2/s1', units)
            Start_squareloop = {'-b1/2','-b2/2','h-h'};
            hfssRectangle(fid,  patch{i}, 'Z', Start_squareloop, 'b1', 'b2', units);
            Start_squareloop1 = {'-b1/2+s1','-b2/2+s2','h-h'};
            hfssRectangle(fid, patch1{i}, 'Z', Start_squareloop1, 'b1-2*s1', 'b2-2*s2', units);
  hfssSubtract(fid, patch{i}, patch1{i});
  CellR_patchName={patch{i}};
  hfssRotate_y(fid, CellR_patchName, 'Z', 'angl');
   hfssSetWCS(fid, 'Global');
   %%%%%��������������
end
%�͵�һ��   
  hfssUnite2(fid, 4,'patch')

  %% cut�� ����Ҫ�Ĳ���
  %1.������cut�Ŀ��ĺ���
hfssBox(fid, 'cut_airbox',{'-d/2','-p/2','-da'},{'d','p','h+2*da'}, Units);%��������
hfssBox(fid, 'cut',{'-d/2-da','-p/2-da','-da'},{'d+2*da','p+2*da','h+2*da'}, Units);%��Ҫ��cut�Ŀ��ĺ���
CutName={'cut'};
CutairboxName={'cut_airbox'};
hfssSubtract(fid, CutName, CutairboxName);
%2.�����������ĺ���
hfssSubtract(fid, patch{1}, 'cut');

%%      %%%%%%%�߽�����
  CellpatchName={'patch1'};
hfssAssignPE(fid, 'patch',  CellpatchName,  false);%PEC


%% �������ӱ߽�
hfssAssignMaster_y(fid, 'Master1', '10', [-5, 8.66025403784439, -20], ...
	                 [-5, 8.66025403784439, 23], 'mm', false);
hfssAssignSlave_y(fid, 'Slave1', '12', [5, 8.66025403784439, -20], ...
	                 [5, 8.66025403784439, 23], 'mm','Master1', true);
hfssAssignMaster_y(fid, 'Master2', '9', [5, -8.66025403784439, -20], ...
	                 [5, -8.66025403784439, 23], 'mm', true);
hfssAssignSlave_y(fid, 'Slave2', '11', [5, 8.66025403784439, -20], ...
	                 [5, 8.66025403784439, 23], 'mm','Master2', false);

% hfssAssignPE(fid, 'hexagonalground', hexagonalName1,  false);
% hfssAssignPE(fid, 'PEsquareloop', squareloopName,  false);
%% ������� 
hfssInsertSolution(fid, 'Setup1', 9, 0.05, 20) %1��fid��,2(name),3(fGHz),4(maxDeltaS)���ޣ�5��maxPass������
hfssInterpolatingSweep_y(fid,'Sweep','Setup1', 6, 21, 0.5);
%% ��ӱ���
% fprintf(fid, 'Set oModule = oDesign.GetModule("OutputVariable")\n');
% %PCR
% fprintf(fid, 'oModule.CreateOutputVariable "PCR",  _\n');
% fprintf(fid, ' "(mag(S(FloquetPort1:2,FloquetPort1:2)-S(FloquetPort1:1,FloquetPort1:1)))^2/((m" & _\n');
% fprintf(fid, ' "ag(S(FloquetPort1:2,FloquetPort1:2)-S(FloquetPort1:1,FloquetPort1:1)))^2+(mag(" & _\n');
% fprintf(fid, ' "S(FloquetPort1:2,FloquetPort1:2)+S(FloquetPort1:1,FloquetPort1:1)))^2)",  _\n');
% fprintf(fid, '  "Setup1 : Sweep", "Modal Solution Data", Array()\n');
% %end PCR
% %d_phase
% fprintf(fid, 'oModule.CreateOutputVariable "d_phase",  _\n');
% fprintf(fid, ' "ang_deg(S(FloquetPort1:2,FloquetPort1:2))-ang_deg(S(FloquetPort1:1,FloquetPort" & _\n');
% fprintf(fid, '"1:1))", "Setup1 : Sweep", "Modal Solution Data", Array()\n');
% %end
% %rll
% fprintf(fid, 'oModule.CreateOutputVariable "rll",  _\n');
% fprintf(fid, '  "1/2*(S(FloquetPort1:1,FloquetPort1:1)-S(FloquetPort1:2,FloquetPort1:2))-1j/2*(" & _\n');
% fprintf(fid, '  "S(FloquetPort1:1,FloquetPort1:2)+S(FloquetPort1:2,FloquetPort1:1))",  _\n');
% fprintf(fid, '  "Setup1 : Sweep", "Modal Solution Data", Array()\n');
% %end rll


%     hfssSaveProject(fid, PrjFile, true);
%     fprintf(fid, 'oDesign.AnalyzeAll\n');
%     ��������
%      FileName = [tmpDataFile, 'VSWR', num2str(i)];
%      hfssExportToFile(fid, 'VSWR', FileName, Type);
% end
    fclose(fid);
    % ����HFSSִ�нű�����
%     hfssExecuteScript(hfssExePath, tmpScriptFile);

% remove all the added paths.
 hfssRemovePaths(relPath);
 rmpath(relPath);
% add paths to the required m-files.

