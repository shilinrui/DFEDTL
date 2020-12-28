%——————————程序———————————
function [D,X,obj] =gaiLearn_D_X(train_data,Dinit,Xinit,alpha,beta,gam,gams,max_iter,U,Y_range)

L_size1=size(Dinit,2);
D=Dinit;
X=full(Xinit);%将稀疏矩阵变为全矩阵



% % MMD
 
%  n_s=train_num*c;%200个
% n_t=train_num1*c;%30个
n_s=155;%200个
n_t=155;%30个
w=n_s+n_t;
M=[w,w];
for i =1:n_s
    for j =1:n_s
 M(i,j)=1/(n_s*n_s);
    end
end   
 for i =n_s+1:w
    for j =n_s+1:w
  M(i,j)=1/(n_t*n_t);
    end
 end
 for i =1:n_s
     for j =n_s+1:w
          M(i,j)=-1/(n_s*n_t);
     end
 end
  for i =n_s+1:w
     for j =1:n_s
          M(i,j)=-1/(n_s*n_t);
     end
  end    
  M;
  lamad=1;
% a=diag(M);
%  S=diag(a);
iter=0;

while iter < max_iter
iter=iter+1;

%Mx = buildMean(X);
Mx=buildM_2M(X, Y_range, beta);
X=pinv(D'*D+beta*U+(2*beta+gam)*eye(L_size1)+lamad*M)*(D'*train_data-Mx);
% X=pinv(D'*D+(2*beta+gam)*eye(L_size1)+lamad*M)*(D'*train_data-Mx);
%   A=(D'*D+beta*U+(2*beta+gam)*eye(L_size1))/lamad;
%   B=M;
%   C=(D'*train_data-Mx)/lamad;
%   C1=reshape(C',52900,1);%将C拉成一列
% %   X=inv(kron(A,eye(230))+kron(eye(230),B'))*C1;
%   X=(kron(A,eye(230))+kron(eye(230),B'))\C1;
  
%Updata D

% D=(train_data*X')*pinv(X*X'+alpha*U+gams*eye(L_size1));
% a=(train_data-D*X)*(train_data-D*X)';
% b=alpha*trace(D*U*D');
% c=beta*trace(X'*U*X);
% d=beta*trace(X*U*X');
% e=gam*X*X';
% f=gams*D*D';
% g=lamad*trace(X'*M*X);
% h=norm(train_data-D*X);
% q=gam*norm(X);
% p=gams*norm(D);
% obj(iter)=norm(train_data-D*X)+alpha*trace(D*U*D')+beta*trace(X'*U*X)+beta*trace(X*U*X')+gam*norm(X)+gams*norm(D)+lamad*trace(X'*M*X);
obj(iter)=norm(train_data-D*X,2)+alpha*trace(D*U*D')+beta*trace(X'*U*X)+beta*trace(X*U*X')+gam*norm(X,2)+gams*norm(D,2)+lamad*trace(X'*M*X);


% %  MMD=trace(X*M);
% % min(min(MMD));%最小化源域和目标域之间的分布差异

end 





