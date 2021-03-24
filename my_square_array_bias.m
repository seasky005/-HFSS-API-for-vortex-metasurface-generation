%Ŀ�꣺���ڽ�������ƫ������ۡ��������Ե�metasurface.
%2020.5.26�� by Ling-Jun Yang(��)

clear, clc

units = 'mm';
Units = 'mm';
Type = 'csv';

% add paths to the required m-files.���·��
% relPath = 'D:\matlab_HFSS�����ļ�\matlab��hfss����\MatlaHFSSApi/';%API·��
% addpath(relPath);
% hfssIncludePaths(relPath);
%%%%%%%��Ҫ�ı���
fc=8.5;
M=10;
N=M;
arraynum=M*N;
%design Variables
    f=8.5;%GHz
    p=10;%��Ԫ����
    h=3;
    b1=3;
    b2=8;
    s1=0.3;
    s2=3.5;
    da=12;
    g1=p-b1;
    g2=p-b2;
    ob_h=100;%�۲�߶�
    
%%�˶�Ϊ���㲻ͬģʽ������λ�ֲ�(squar_loop)��a����Ϊ�����λ����
clc , close all
a=ones(N,M);%a����Ϊ������ܣ���λ����
a1=ones(N,M);%a1����Ϊ�������������λ����
a2=ones(N,M);%a2����Ϊ�����ƫ��������Դ�ڣ�Xk,Yk,Zk����λΪÿ���ڣ���λ����
a3=ones(N,M);%a3����Ϊ�������۽�����Zf����λ����
l=1;%��Ҫ��OAMģ
Zf=M+M/2;
Zk=M/2;
Xk=Zk;
Yk=0;
k=1/2;
for n=1:N
    for m=1:M
      a1(n,m)=l.*(angle(m-0.5-M/2+1j*(N/2-n+0.5))/pi*180);
      a2(n,m)=fc*360/300*p*sqrt((m-0.5-M/2-Xk)^2+(N/2-n+0.5-Yk)^2+(Zk)^2);
      a3(n,m)=fc*360/300*p*sqrt((m-0.5-M/2)^2+(N/2-n+0.5)^2+(Zf)^2);
      a(n,m)=a1(n,m)+a2(n,m)+a3(n,m);

      if a(n,m)<0
          a(n,m)=a(n,m)+360;
      end

    end
end
%�����Ϊ������ת�Ƕ�
      a=k*a;
      a=rem(a,360);%ȡ��
      a=roundn(a,-2);%����С�������λ
%%%%%%%%%%%%����a����Ϊ�����ת��λ����

%%%%%%%%%�ű���ʼ׼��
false = 0;
true = 1;
fileName = ['squareloopN',num2str(N),'_',num2str(fc),'G_',num2str(arraynum),'N_l=',num2str(l)];
tmpScriptFile = ['D:\Bվ��Ƶ\������Ľ���\metasurface_HFSS_API\',fileName,'.vbs'];
% HFSS Executable Path.
% hfssExePath = '"D:\SimulationWare\HFSS19\AnsysEM19.0\Win64\ansysedt.exe"'; 

%��ʼдVBS�ű�
    fid = fopen(tmpScriptFile, 'wt');   % 'wt'��ʾ���ı�ģʽ���ļ�����д������ԭ������
   % ����һ���µĹ��̲�����һ���µ����
    hfssNewProject(fid);
    hfssInsertDesign(fid, fileName);
%     hfssPre(fid);
   
    hfssaddVar(fid, 'f0', f, []);
    hfssaddVar(fid, 'p', p, units);
    hfssaddVar(fid, 'h', h, units);
    hfssaddVar(fid, 'b1', b1, units);
    hfssaddVar(fid, 'b2', b2, units);  
    hfssaddVar(fid, 's1', s1, units);
    hfssaddVar(fid, 's2', s2, units);  
    hfssaddVar(fid, 'da', da, units); 
    hfssaddVar(fid, 'M', M, []);  
    hfssaddVar(fid, 'N', N, []); 
    hfssaddVar(fid, 'ob_h', ob_h, units); 
    hfssaddVar(fid, 'g1', g1, units);
    hfssaddVar(fid, 'g2', g2, units); 
    %%%%%%%%Array of metasrface(square loop)
    squareloopName = cell(arraynum, 1);
    squareloopName1 = cell(arraynum, 1);
    squareloopName2 = cell(arraynum, 1);
   % ObjectList = cell(arraynum,1);
   cell_squareloopName=cell(1,1);
    for n=1:N
        for m=1:M
            i=N*(m-1)+n;
            %%%%add local CS
            CSName = ['CS', num2str(i)];
            Origin = {['(',num2str(m),' -(M+1)/2)*p'],['((N+1)/2-',num2str(n),')*p'],'0'};
            XAxisVec = [1 0 0 ];
            YAxisVec = {0, 1, 0};
            hfssCreateRelativeCS(fid, CSName, Origin,XAxisVec, YAxisVec, units);
            hfssSetWCS(fid, CSName);
   %%%%%%%Array of metasrface(square loop)
            squareloopName{i} = ['squareloop_',num2str(i)];
            Start_squareloop = {'-b1/2','-b2/2','h'};
            hfssRectangle(fid, squareloopName{i}, 'Z', Start_squareloop, 'b1', 'b2', units);

            squareloopName1{i} = ['squareloop1_',num2str(i)];
            Start_squareloop1 = {'-b1/2+s1','-b2/2+s2','h'};
            hfssRectangle(fid, squareloopName1{i}, 'Z', Start_squareloop1, 'b1-2*s1', 'b2-2*s2', units);
  
            hfssSubtract(fid, squareloopName{i}, squareloopName1{i}); 
            cell_squareloopName{1,1}= squareloopName{i};
            hfssRotate(fid,cell_squareloopName , 'Z', a(n,m));
            hfssSetWCS(fid, 'Global');
        end
    end
     %%%%%%%sub gud
hfssRectangle(fid, 'gud', 'Z',{'-M/2*p','-N/2*p',0} , 'M*p', 'N*p', Units);
% hfssBox(fid, 'sub',{'-M/2*p','-N/2*p',0},{'M*p','N*p','h'}, Units);
gudObject = cell(1,1);
gudObject{1,1} = 'gud';
hfssAssignPE(fid, 'ground', gudObject,  false);
hfssAssignPE(fid, 'PEsquareloop', squareloopName,  false);
     % ����Զ��������ϵ
%          hfssFarFieldSphere(fid, 'EH', -180, 180, 1, 0, 90, 90);
%          hfssFarFieldSphere(fid,'3D',0,180,1,0,360,1);
     %����߽�����
%         hfssBox(fid, 'radRegion',{'-M/2*p-da','-N/2*p-da','-da'},{'M*p+2*da','N*p+2*da','ob_h+2*da'}, Units);
%         hfssAssignRadiation(fid, 'Radiation', 'radRegion');

    fclose(fid);

% remove all the added paths.
%  hfssRemovePaths(relPath);
%  rmpath(relPath);
