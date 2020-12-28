function [train_data,train_data_label]=read_data(trainnum,canshu_num,cnum)
% function [train_data,train_data_label,test_data,test_data_label]=read_data(trainnum,canshu_num,cnum)
% trainnum=20;cnum=10;
% % Dis = dir('C:\Users\Administrator\Desktop\office31\usps_4096\*');
% % Diecell=struct2cell(Dis);
% % Dir=sort_nat(Diecell(1,:));
 file_read = dir('C:\Users\Administrator\Desktop\office31\webcam31_4096\*');%�г���ǰĿ¼�µ��������ļ��к��ļ�
file_length = length(file_read);%�ļ�����
 tempdata=load('C:\Users\Administrator\Desktop\office31\webcam31_4096\webcam_1.mat');%�����������ļ�
dim=size(tempdata.fts(1,:),2);%���Ϊһ�����󣬼�һ��2��ʾ��������4096

folder='C:\Users\Administrator\Desktop\office31\webcam31_4096\';%�ļ���

sample_num=0;
for i = 3:file_length%�ӵ������࿪ʼ������ǰ����������ļ�
    file_name = file_read(i).name;%����ÿһ����ļ���
    filename=[folder file_name];%����С�ļ������ļ��е�����
    tempdata=load(filename);%tempdata���������fts��name
    data{i-2}=tempdata.fts;%������ʽ
    eachclass_num(i-2)=size(tempdata.fts,1);%tempdata.fts����������ÿ���ж��ٸ�����
    sample_num= sample_num+eachclass_num(i-2);%����10��������֮��
end

%ȡÿ���ѵ���Ͳ������� 
Class =cnum;%�����Ŀ10��

train_data=zeros(dim,Class*trainnum);%��dim=4096���ܵ�ѵ������ȫΪ0�ľ���
% test_data=zeros(dim,sample_num-Class*trainnum);%��dim=4096���ܵĲ�������ȫΪ0�ľ���

 m=0;%������m=m+(eachclass_num(j)-trainnum)���
 
for j=1:Class
 randIdx=randperm(eachclass_num(j));
% randIdx=randperm(eachclass_num(j)-canshu_num)+canshu_num;%randperm(n)���򷵻ش�1��n��n����ͬ������
b_train=[1:canshu_num,randIdx(1:trainnum-canshu_num)];

% 
% b_test=(1:eachclass_num(j));%1��eachclass_num(j)
% b_test(b_train)=[];%1��eachclass_num(j)�ҳ�ȥ������

train_num=b_train;%ѵ�����������
% test_num=b_test;%�������������
temp=data{j};%��j�����������1��55��4096
temp1=temp(train_num,:);%temp1���Ǵ�ĳһ��������������ҵ�10��ѵ��������ŵ�����10��4096
% temp2=temp(test_num,:);%temp2���Ǵ�ĳһ��������������ҵ�����������ŵ�����45��4096
train_data(:,((j-1)*trainnum+1):((j-1)*trainnum+trainnum))=temp1';%�õ�1-10�е���temp1��ת�� eg  A(:,(1:3))=A',������ת��Ϊ4096��10
train_data_label(((j-1)*trainnum+1):((j-1)*trainnum+trainnum),1)=j;%���ѵ����������һ���1-10�е���1��11-20=2
% p=eachclass_num(j)-trainnum;%ÿһ���������-ѵ����10,������������
% test_data(:,m+1:m+p)=temp2';
% test_data_label(m+1:m+p,1)=j;%��ǲ�����������һ��
m=m+(eachclass_num(j)-trainnum);%ÿ��һ��j�ͼ�һ�β�����������ܺ�Ӧ����7667
% %  a=mean(train_data,2) ;%ѵ�������ľ�ֵ
% % d=mean(test_data,2) ;%���������ľ�ֵ
% % min(norm(a-d,'fro')^2);%��С��Frobenius ������ƽ��
clear temp1  temp
end

%��һ������
train_data=normc(train_data);
% test_data= normc(test_data);
