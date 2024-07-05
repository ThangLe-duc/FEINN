%................................................................

function  [stiffness,force] = formStiffnessBernoulliBeam(GDof,numberElements,elementNodes,numberNodes,xx,EI,P,numdat)

force=zeros(GDof,1,numdat);
stiffness=zeros(GDof,GDof,numdat); 
% calculation of the system stiffness matrix
% and force vector
for e=1:numberElements
  % elementDof: element degrees of freedom (Dof)
  indice = elementNodes(e,:)   ;       
  elementDof=[ 2*(indice(1)-1)+1 2*(indice(2)-1)...
      2*(indice(2)-1)+1 2*(indice(2)-1)+2]; 
 % ndof=length(indice);  
  % length of element
  LElem = xx(indice(2),:,:) - xx(indice(1),:,:);
%   ll=LElem;
  EI_L = pagemtimes(EI,1/((LElem).^3));
  k1_1 = [12*ones(1,1,numdat)   6*LElem -12*ones(1,1,numdat) 6*LElem;
     6*LElem 4*LElem.^2 -6*LElem 2*LElem.^2;
     -12*ones(1,1,numdat) -6*LElem 12*ones(1,1,numdat) -6*LElem ;
     6*LElem 2*LElem.^2 -6*LElem 4*LElem.^2];
  k1 = pagemtimes(EI_L,k1_1);
  
  f1 = pagetranspose([pagemtimes(P,LElem/2) pagemtimes(pagemtimes(P,LElem),LElem/12) pagemtimes(P,LElem/2) ...
      pagemtimes(pagemtimes(-P,LElem),LElem/12)]);
  
  % equivalent force vector
  force(elementDof,1,:)=force(elementDof,1,:)+f1;  
  
  % stiffness matrix
  stiffness(elementDof,elementDof,:)=...
      stiffness(elementDof,elementDof,:)+k1;
end
