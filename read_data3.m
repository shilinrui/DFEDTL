function [train1_data,train1_data_label,test_data,test_data_label]=read_data3(trainnum1,canshu_num,cnum)

file_read = dir('C:\Users\Administrator\Desktop\office31\dslr31_4096\*');%�г���ǰĿ¼�µ��������ļ��к��ļ�C:\Users\Administrator\Desktop\office31
file_length = length(file_read);%�ļ�����
tempdata=load('C:\Users\Administrator\Desktop\office31\dslr31_4096\dslr_1.mat');%�����������ļ�
dim=size(tempdata.fts(1,:),2);%���Ϊһ�����󣬼�һ��2��ʾ��������4096
folder='C:\Users\Administrator\Desktop\office31\dslr31_4096\';%�ļ���

sample_num=0;
for i = 3:file_length%�ӵ������࿪ʼ������ǰ����������ļ�
    file_name = file_read(i).name;%����ÿһ����ļ���
    filename=[folder file_name];%����С�ļ������ļ��е�����
    tempdata=load(filename);%tempdata���������fts��name
    data{i-2}=tempdata.fts;%������ʽ
    eachclass_num(i-2)=size(tempdata.fts,1);%tempdata.fts����������ÿ���ж��ٸ�����
    sample_num= sample_num+eachclass_num(i-2);%������������֮��
 
end
%ȡÿ���ѵ���Ͳ������� 
Class =cnum;%�����Ŀ

train1_data=zeros(dim,Class*trainnum1);%ÿ��ȡ���ٸ���Ϊѵ����
test_data=zeros(dim,sample_num-Class*trainnum1);%������Ϊ����

m=0;
for j=1:Class

randIdx=randperm(eachclass_num(j)-canshu_num)+canshu_num;
b_train1=[1:canshu_num,randIdx(1:trainnum1-canshu_num)];
b_test=(1:eachclass_num(j));
b_test(b_train1)=[];

train1_num=b_train1;
test_num=b_test;
temp=data{j};
temp1=temp(train1_num,:);
temp2=temp(test_num,:);
train1_data(:,((j-1)*trainnum1+1):((j-1)*trainnum1+trainnum1))=temp1';
train1_data_label(((j-1)*trainnum1+1):((j-1)*trainnum1+trainnum1),1)=j;
p=eachclass_num(j)-trainnum1;
test_data(:,m+1:m+p)=temp2';
test_data_label(m+1:m+p,1)=j;
m=m+(eachclass_num(j)-trainnum1);
test_num=m;
clear temp1 temp2 temp
end

%��һ������
train1_data=normc(train1_data);
test_data= normc(test_data);
