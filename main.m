
clear; clc; close all
%Ŀ�꺯��Solving (D, X) = \arg\min_{D,X} ||Y - DX||_F^2 + lambda||X||_1+alphaTr(DUD')+betaTr(X'UX)+Tr(XZX')+||a-d||_F^2;a��Դ���ݾ�ֵ��bĿ�����ݾ�ֵ
 m=0;%ÿ����������
 c=31;%����������
 train_num=5;%Դ��ÿ��ѵ�������ĸ���
 train_num1=5;%Ŀ����ÿ��ѵ�������ĸ���
addpath(genpath('.\ksvdbox'));  %���K-SVD box·��
addpath(genpath('.\OMPbox')); % add sparse coding algorithem OMP������ƥ��׷���㷨��
sparsitythres = 30; % sparsity prior��ϡ����ֵT0=30��
iterations4ini=1; % ������
addpath('ODL');%Solving (D, X) = \arg\min_{D,X} 0.5||Y - DX||_F^2 + lambda||X||_1
addpath('LRSDL_FDDL');%LRSDL�����ض���DDL�㷨��FDDL�ض���DDL�㷨
addpath('utils');
max_iter=30;%��������30

 for jj=1%:10%
     sumd=0; 
     sumd1=0; 
%��ȡԴ���ݺ�Ŀ������
for p=1:10
[tr_dat,Train1_label]=read_data(train_num,m,c);%����Դ������

  [train1_data,train1_data_label,tt_dat,Test_label]=read_data3(train_num1,m,c);%����Ŀ����ѵ������������
  
  %%��ÿ��Դ��Ŀ����ѵ����������Ϊһ��

    tr_all=tr_all_310(tr_dat,train1_data);

% %��ǩ����
clear H_train H_train1 H_test
H_train =lcksvd_buildH(Train1_label);%Դ��ѵ�������ı�ǩ����
H_train1 =lcksvd_buildH(train1_data_label);%Ŀ����ѵ�������ı�ǩ����
 
H_train2= H_train_310( H_train, H_train1); 

H_test= lcksvd_buildH(Test_label);%Ŀ�������ڲ��Եı�ǩ����
%
for dictsize=310% �ֵ���=ѵ����
sumd=sumd+1;
% clear Dinit%�ֵ��ʼ��%
 [Dinit,Tinit,Cinit,Q_train,Xinit,D_label] = initialization4LCKSVD(tr_all,H_train2,dictsize,iterations4ini,sparsitythres);
%������ѵ��������ʼ���ֵ�
PA=[1e-5,1e-4,1e-3,1e-2,1e-1,1,0,10,100,1e+3,1e+4,1e+5];%����alpha,beta,gam
for alpha1=1%1:6 %
    for beta1=1%1:6%
         for gam1=4%1:6%4
             for gams1=6%1:6%
          alpha=PA(alpha1);
          beta=PA(beta1);
          gam=PA(gam1);
          gams=PA(gams1);
  
   Train_label=  Train_label_310( Train1_label,train1_data_label); 
    


  Y_range = label_to_range(Train_label);%�ֳ�10�飬ÿ����20��
D_range = (dictsize/c)*(0:c);  
[Q]=construct_Q(D_label);
U=(eye(dictsize)+(1/dictsize)*ones(dictsize,dictsize)-2*Q);

% % ѧϰ�ֵ�    

[D,X,obj] = Learn_D_X(tr_all,Dinit,Xinit,alpha,beta,gam,gams,max_iter,U,Y_range); %��ѵ������ѧϰ�õ��ֵ�ͱ���ϵ���ĺ��� 

% % Mean vectors
    CoefM = zeros(size(X, 1), c);
    for i = 1: c
        Xc = get_block_col(X, i, Y_range);
       CoefM(:, i) = mean(Xc,2);
    end
   
% clasification  ����

fprintf('GC:\n');
opts.verbose = 0;
opts.weight = 0.5;
opts.D_range = D_range;
acc = [];
for vgamma = [0.0001, 0.001, 0.01, 0.1]%vgamma�ֱ�������ĸ�ֵ��ʶ���ʷ������
           opts.gamma = vgamma;
           pred = FDDL_pred(tt_dat, D, CoefM, opts);%predict
           acc = [acc calc_acc(pred, Test_label')];%calculate
%            fprintf('vgamma = %.4f, acc = %.4f\n', vgamma, acc(end));
end 
 acc(p)= max(acc);%��¼10�ε�׼ȷ��
 b=fopen('ceshi.txt','a+'); %���ÿ�β��Ե�ʶ����
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
ave_acc=mean(rec);%ƽ��ʶ����
ave_acc_1=rec.*100;
sigm=sqrt(mean(ave_acc_1.^2)-mean(ave_acc_1)^2)/sqrt(10);

fprintf('ave_acc=%.4f,sigm=%.2f\n',ave_acc,sigm);
% Ravg = mean(rec);                  % average recognition rateƽ��ʶ����
% Rstd = std(rec);                   % standard deviation of the recognition rateʶ���ʵı�׼��
% fprintf('===============================================');
% fprintf('Average classification accuracy: %f\n', Ravg);
% fprintf('Standard deviation: %f\n', Rstd);    
% fprintf('===============================================');
% b=fopen('averceshi.txt','a+');
% fprintf(b,'%.03f,%.03f\r\n',Ravg, Rstd);
% fclose(b);
%  clear
