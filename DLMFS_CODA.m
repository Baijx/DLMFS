%% Sparse and structural learning for supervised multi-label feature selection 
%  
%
% Written by Zhiling Cai (zhilingcai@126.com), September 3, 2015.
%
function [J,value] = CLRMFS4(X,Y,alpha,beta,gamma,W,B,S)
%
%% Input:  
% X: data matrix (n x d)
% Y: label matrix (n x l)
% k: the number of the selected features
% type: the type of structural learning regularizer
%
%% Output:
% I: feature subset 
%
% obj = min
% 0.5*||Y-XS||_{F}^{2}+0.5*alpha*Tr(S'LS)+0.5*beta*L21(S)
%
% compute the structural learning regularizer
[PY,AY,LY] = cLLR_k(Y',3,5);
% AY=constructW_PKN(Y, 5, 0);
% AY = AY-diag(diag(AY));
A0=constructW_PKN(X, 10, 0);
A0 = A0-diag(diag(A0));
[n,d] = size(X);
[~,m] = size(Y);
AY=AY+eye(m);
I=eye(n);
E=ones(n,1);
D=I-E*E'/n;
maxIte = 50;
% Initialization
S=(S+S')/2;
PS=diag(sum(S));
for i=1:maxIte
    W=W.*((X'*D*Y*B'+beta*S*W*B*B')./(X'*D*X*W*B*B'+beta*PS*W*B*B'));
    B=B.*((W'*X'*D*Y+beta*W'*S*W*B+2*gamma*B*AY)./(W'*X'*D*X*W*B+beta*W'*PS*W*B+2*gamma*(B*B')*B));
    [S,PS,LS] = DGCLR_F(A0,W,beta/alpha);
    b=(E'*Y-E'*X*W*B)./n;
    % Objective function 
     J(i) = 1/(m*n)*(sum(sum((Y-X*W*B-E*b).*(Y-X*W*B-E*b)))+alpha*sum(sum(abs(S-A0)))+beta*trace(B'*W'*LS*W*B)+gamma*sum(sum((AY-B'*B).*(AY-B'*B))));
end
tempVector = sum((W*B).*(W*B),2);
[~, value] = sort(tempVector, 'descend'); % sort W in a descend order
clear tempVector;
% I= value(1:k);
end
    
   
    
