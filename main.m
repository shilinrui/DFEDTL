
clear; clc; close all
%目标函数Solving (D, X) = \arg\min_{D,X} ||Y - DX||_F^2 + lambda||X||_1+alphaTr(DUD')+betaTr(X'UX)+Tr(XZX')+||a-d||_F^2;a是源数据均值，b目标数据均值
 m=0;%每类样本个数
 c=31;%样本的类数
 train_num=5;%源域每类训练样本的个数
 train_num1=5;%目标域每类训练样本的个数
addpath(genpath('.\ksvdbox'));  %添加K-SVD box路径
addpath(genpath('.\OMPbox')); % add sparse coding algorithem OMP（正交匹配追踪算法）
sparsitythres = 30; % sparsity prior（稀疏阈值T0=30）
iterations4ini=1; % 迭代数
addpath('ODL');%Solving (D, X) = \arg\min_{D,X} 0.5||Y - DX||_F^2 + lambda||X||_1
addpath('LRSDL_FDDL');%LRSDL共享特定类DDL算法；FDDL特定类DDL算法
addpath('utils');
max_iter=30;%最大迭代数30

 for jj=1%:10%
     sumd=0; 
     sumd1=0; 
%获取源数据和目标数据
for p=1:10
[tr_dat,Train1_label]=read_data(train_num,m,c);%读入源域数据

  [train1_data,train1_data_label,tt_dat,Test_label]=read_data3(train_num1,m,c);%读入目标域训练、测试数据
  
  %%将每类源域、目标域训练样本整合为一组

    tr_all=tr_all_310(tr_dat,train1_data);

% %标签矩阵
clear H_train H_train1 H_test
H_train =lcksvd_buildH(Train1_label);%源域训练样本的标签矩阵
H_train1 =lcksvd_buildH(train1_data_label);%目标域训练样本的标签矩阵
 
H_train2= H_train_310( H_train, H_train1); 

H_test= lcksvd_buildH(Test_label);%目标域用于测试的标签矩阵
%
for dictsize=310% 字典数=训练数
sumd=sumd+1;
% clear Dinit%字典初始化%
 [Dinit,Tinit,Cinit,Q_train,Xinit,D_label] = initialization4LCKSVD(tr_all,H_train2,dictsize,iterations4ini,sparsitythres);
%用所有训练样本初始化字典
PA=[1e-5,1e-4,1e-3,1e-2,1e-1,1,0,10,100,1e+3,1e+4,1e+5];%参数alpha,beta,gam
for alpha1=1%1:6 %
    for beta1=1%1:6%
         for gam1=4%1:6%4
             for gams1=6%1:6%
          alpha=PA(alpha1);
          beta=PA(beta1);
          gam=PA(gam1);
          gams=PA(gams1);
  
   Train_label=  Train_label_310( Train1_label,train1_data_label); 
    


  Y_range = label_to_range(Train_label);%分成10组，每组有20个
D_range = (dictsize/c)*(0:c);  
[Q]=construct_Q(D_label);
U=(eye(dictsize)+(1/dictsize)*ones(dictsize,dictsize)-2*Q);

% % 学习字典    

[D,X,obj] = Learn_D_X(tr_all,Dinit,Xinit,alpha,beta,gam,gams,max_iter,U,Y_range); %用训练样本学习得到字典和编码系数的函数 

% % Mean vectors
    CoefM = zeros(size(X, 1), c);
    for i = 1: c
        Xc = get_block_col(X, i, Y_range);
       CoefM(:, i) = mean(Xc,2);
    end
   
% clasification  分类

fprintf('GC:\n');
opts.verbose = 0;
opts.weight = 0.5;
opts.D_range = D_range;
acc = [];
for vgamma = [0.0001, 0.001, 0.01, 0.1]%vgamma分别等于这四个值的识别率分类参数
           opts.gamma = vgamma;
           pred = FDDL_pred(tt_dat, D, CoefM, opts);%predict
           acc = [acc calc_acc(pred, Test_label')];%calculate
%            fprintf('vgamma = %.4f, acc = %.4f\n', vgamma, acc(end));
end 
 acc(p)= max(acc);%记录10次的准确率
 b=fopen('ceshi.txt','a+'); %存放每次测试的识别率
fprintf(b,'%d,%d,%d,%d,%d,%.03f\r\n',dictsize,alpha1,beta1,gam1,gams1,acc);
 fclose(b); 
             end
         end
    end
end
end
rec(jj,sumd)=acc(p);
fprintf('%f,',acc(p));
end
 end
ave_acc=mean(rec);%平均识别率
ave_acc_1=rec.*100;
sigm=sqrt(mean(ave_acc_1.^2)-mean(ave_acc_1)^2)/sqrt(10);

fprintf('ave_acc=%.4f,sigm=%.2f\n',ave_acc,sigm);
% Ravg = mean(rec);                  % average recognition rate平均识别率
% Rstd = std(rec);                   % standard deviation of the recognition rate识别率的标准差
% fprintf('===============================================');
% fprintf('Average classification accuracy: %f\n', Ravg);
% fprintf('Standard deviation: %f\n', Rstd);    
% fprintf('===============================================');
% b=fopen('averceshi.txt','a+');
% fprintf(b,'%.03f,%.03f\r\n',Ravg, Rstd);
% fclose(b);
%  clear
