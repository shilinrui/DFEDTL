function [train1_data,train1_data_label,test_data,test_data_label]=read_data3(trainnum1,canshu_num,cnum)

file_read = dir('C:\Users\Administrator\Desktop\office31\dslr31_4096\*');%列出当前目录下的所有子文件夹和文件C:\Users\Administrator\Desktop\office31
file_length = length(file_read);%文件长度
tempdata=load('C:\Users\Administrator\Desktop\office31\dslr31_4096\dslr_1.mat');%导入具体的子文件
dim=size(tempdata.fts(1,:),2);%结果为一个矩阵，加一个2表示返回列数4096
folder='C:\Users\Administrator\Desktop\office31\dslr31_4096\';%文件夹

sample_num=0;
for i = 3:file_length%从第三个类开始，减掉前面的两个空文件
    file_name = file_read(i).name;%读入每一类的文件名
    filename=[folder file_name];%包含小文件及大文件夹的名字
    tempdata=load(filename);%tempdata结果里面有fts和name
    data{i-2}=tempdata.fts;%矩阵形式
    eachclass_num(i-2)=size(tempdata.fts,1);%tempdata.fts的行数，即每类有多少个样本
    sample_num= sample_num+eachclass_num(i-2);%所有类样本数之和
 
end
%取每类的训练和测试样本 
Class =cnum;%类别数目

train1_data=zeros(dim,Class*trainnum1);%每类取多少个作为训练，
test_data=zeros(dim,sample_num-Class*trainnum1);%其余作为测试

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

%归一化数据
train1_data=normc(train1_data);
test_data= normc(test_data);
