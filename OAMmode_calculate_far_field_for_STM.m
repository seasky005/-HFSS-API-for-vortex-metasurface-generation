%CLACULATE_FIELD �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��         $$$����һ��donut��״�ĳ�����  ������λ����matlab���㳡
clc
clear all
close all
R0=0.06;%��ģ�����İ뾶  ��λm
R1=0.06;%��ģ�Ĳ����뾶   ��λm
d=0.01;  %���ڴ�С   ��λm
rn=(R0+R1)/d;%��ģ�뾶rn������ڽ�ģR0+R1������
l=[11];%��Ҫ��OAMģ,����Ϊ����
mag_l=[1];%��Ҫ��OAMģ��Ӧ��ģʽ����,����Ϊ����
% distance,  ����   ��λm
f=19*10^9; %  Ƶ��  Hz
% [sample_m],  �������д�С����
% [sp]  �������ڴ�С  ��λm
fto=[15];%GHz

for fi=1:length(fto)

  f=fto(fi)*10^9; %  Ƶ��  Hz  
%׼������
theta=0:2*pi/1000:2*pi;
a1_total=zeros(1,length(theta));%��Ҫ�ĸ���OAM��
for o=1:length(l)
    a1_total= a1_total+mag_l(o)*exp(-1j*l(o)*theta);
end
max_a= max(abs(a1_total));%��Ҫ�ĸ���OAM�������ֵ���ڹ�һ��
% cin=12-4/max_a.*abs(a1_total)-0.5;
% cin=12+4/max_a.*abs(a1_total)+0.5;
% phase=angle(al_total);

N=ceil(rn*2/sqrt(3));%���ģNȦ������
% N=10;
% arraynum=6*(1+N)*N/2;%��൥Ԫ����

k=2*pi*f/(3*10^8);

%������sampling_m
theta_S=0:1:90;
phi_S=1:1:360;

sampling_matrix=zeros(length(theta_S),length(phi_S));
% phi0=phi0/180*pi;

for o=1:1:length(theta_S)
    for p=1:1:length(phi_S)
   
        for n=1:N %Ȧ��
            for j=1:6 %��
               for i=1:n %��
                     x=n*d*cos((j-1)*pi/3)-(i-1)*cos((j-2)*pi/3)*d;%%����n,j,i,ʱ��x��y�������
                     y=n*d*sin((j-1)*pi/3)+(i-1)*sin((j+1)*pi/3)*d;
                     al=angle(x+1j*y)/pi*180;%%%����n,j,i,ʱ�̷�λ��al
                    if al<0
                              al=al+360;
                    end
                 a_total=0;%�ۼ���Ҫ�ķ��Ⱥ���λA��
                    for m=1:length(l)
                        a_total= a_total+mag_l(m)*exp(-1j*l(m)*al*pi/180);%�÷�λ��al�ĸ���ֵa_total��
                    end
                a_total=a_total/max_a;%�������ȹ�һ��
                a_=angle(a_total);%�õ�Ԫ��Ҫ����λrad

                    %�ж��Ƿ���Ҫ��ģ
                     if sqrt(x^2+y^2)<abs(a_total)*R1+R0 && sqrt(x^2+y^2)>R0-abs(a_total)*R1     %abs(a_total)

%                          r=sqrt((x+(o-0.5-sample_m/2)*sp)^2+(y+(sample_m/2-p+0.5)*sp)^2+distance^2);
%                             r=sin(theta_S(o)/180*pi)*cos(phi_S(p)/180*pi)*x+sin(theta_S(o)/180*pi)*sin(phi_S(p)/180*pi)*y;
%                          sampling_matrix(o,p)=(1+cos(theta_S(o)/180*pi))*exp(-1j*(k.*r)-1j*a_)+sampling_matrix(o,p);
                           r=sin(theta_S(o)/180*pi)*cos(phi_S(p)/180*pi)*x+sin(theta_S(o)/180*pi)*sin(phi_S(p)/180*pi)*y;
                         sampling_matrix(o,p)=(1+cos(theta_S(o)/180*pi))*exp(-1j*(k.*r)-1j*a_)+sampling_matrix(o,p);
                     end
               end
            end
        end      
     end
end
mag_s=abs(sampling_matrix);
angle_s=angle(sampling_matrix);
[A,B]=max(mag_s);
thetaM=mean(B)-1;

% [X,Y] = meshgrid(theta_S,phi_S);
[X,Y] = meshgrid(phi_S,fliplr(theta_S));
figure(1)
mesh(X,Y,mag_s)
colormap(hot)
 colorbar
 view(0,90)
figure(2)
mesh(X,Y,angle_s)
load mycolor
colormap(rad2blue)
view(0,90)
 colorbar



end

