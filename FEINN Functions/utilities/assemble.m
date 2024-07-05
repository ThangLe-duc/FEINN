function [kk,ff]=assemble(kk,ff,k,f,index)
%----------------------------------------------------------
%  Purpose:
%     Assembly of element stiffness matrix into the system matrix &
%     Assembly of element force vector into the system vector
%
%  Synopsis:
%     [kk,ff]=assemble(kk,ff,k,f,index)
%
%  Variable Description:
%     kk - system stiffnes matrix
%     ff - system force vector
%     k  - element stiffness matrix
%     f  - element force vector
%     index - d.o.f. vector associated with an element
%-----------------------------------------------------------

 
% %  edof = length(index);
%  edof = size(index,1);
%  for i=1:edof
%    ii=index(i,1,:);
%      ff(ii,1,:)=ff(ii,1,:)+f(i,1,:);
%      for j=1:edof
%        jj=index(j,1,:);
%          kk(ii,jj,:)=kk(ii,jj,:)+k(i,j,:);
%      end
%  end
 
 %  edof = length(index);
 edof = size(index,2);
 for i=1:edof
   ii=index(i);
     ff(ii,1,:)=ff(ii,1,:)+f(i,1,:);
     for j=1:edof
       jj=index(j);
         kk(ii,jj,:)=kk(ii,jj,:)+k(i,j,:);
     end
 end

