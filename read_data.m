function [train_data,train_data_label]=read_data(trainnum,canshu_num,cnum)
% function [train_data,train_data_label,test_data,test_data_label]=read_data(trainnum,canshu_num,cnum)
% trainnum=20;cnum=10;
% % Dis = dir('C:\Users\Administrator\Desktop\office31\usps_4096\*');
% % Diecell=struct2cell(Dis);
% % Dir=sort_nat(Diecell(1,:));
 file_read = dir('C:\Users\Administrator\Desktop\office31\webcam31_4096\*');%列出当前目录下的所有子文件夹和文件
file_length = length(file_read);%文件长度
 tempdata=load('C:\Users\Administrator\Desktop\office31\webcam31_4096\webcam_1.mat');%导入具体的子文件
dim=size(tempdata.fts(1,:),2);%结果为一个矩阵，加一个2表示返回列数4096

folder='C:\Users\Administrator\Desktop\office31\webcam31_4096\';%文件夹

sample_num=0;
for i = 3:file_length%从第三个类开始，减掉前面的两个空文件
    file_name = file_read(i).name;%读入每一类的文件名
    filename=[folder file_name];%包含小文件及大文件夹的名字
    tempdata=load(filename);%tempdata结果里面有fts和name
    data{i-2}=tempdata.fts;%矩阵形式
    eachclass_num(i-2)=size(tempdata.fts,1);%tempdata.fts的行数，即每类有多少个样本
    sample_num= sample_num+eachclass_num(i-2);%所有10类样本数之和
end

%取每类的训练和测试样本 
Class =cnum;%类别数目10类

train_data=zeros(dim,Class*trainnum);%（dim=4096，总的训练数）全为0的矩阵
% test_data=zeros(dim,sample_num-Class*trainnum);%（dim=4096，总的测试数）全为0的矩阵

 m=0;%与下面m=m+(eachclass_num(j)-trainnum)相关
 
for j=1:Class
 randIdx=randperm(eachclass_num(j));
% randIdx=randperm(eachclass_num(j)-canshu_num)+canshu_num;%randperm(n)乱序返回从1到n的n个不同的数字
b_train=[1:canshu_num,randIdx(1:trainnum-canshu_num)];

% 
% b_test=(1:eachclass_num(j));%1到eachclass_num(j)
% b_test(b_train)=[];%1到eachclass_num(j)且除去测试项

train_num=b_train;%训练样本的序号
% test_num=b_test;%测试样本的序号
temp=data{j};%第j类样本比如第1类55×4096
temp1=temp(train_num,:);%temp1就是从某一类的所有样本中找到10个训练样本序号的样本10×4096
% temp2=temp(test_num,:);%temp2就是从某一类的所有样本中找到测试样本序号的样本45×4096
train_data(:,((j-1)*trainnum+1):((j-1)*trainnum+trainnum))=temp1';%让第1-10列等于temp1的转置 eg  A(:,(1:3))=A',这里是转置为4096×10
train_data_label(((j-1)*trainnum+1):((j-1)*trainnum+trainnum),1)=j;%标记训练样本是哪一类第1-10列等于1，11-20=2
% p=eachclass_num(j)-trainnum;%每一类的样本数-训练数10,即测试样本数
% test_data(:,m+1:m+p)=temp2';
% test_data_label(m+1:m+p,1)=j;%标记测试样本是哪一类
m=m+(eachclass_num(j)-trainnum);%每到一个j就加一次测试数，最后总和应该是7667
% %  a=mean(train_data,2) ;%训练样本的均值
% % d=mean(test_data,2) ;%测试样本的均值
% % min(norm(a-d,'fro')^2);%最小化Frobenius 范数的平方
clear temp1  temp
end

%归一化数据
train_data=normc(train_data);
% test_data= normc(test_data);
