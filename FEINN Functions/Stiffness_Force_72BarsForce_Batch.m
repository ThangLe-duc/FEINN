function [K,F] = Stiffness_Force_72BarsForce_Batch(input,numdat,problem)

% Etrue = 10000e3;     % Young's elastic modulus (lb/in^2)
% Fmax = 1e4;
% E = Etrue/Fmax;
% 
% A = problem.XScale*input(1:16,:);
% F = problem.XScale*input(17:76,:);

Etrue = 10000e3;     % Young's elastic modulus (lb/in^2)
Fmax = 1e4;
E = 1;

A = problem.XScale*input(1:16,:);
F = problem.XScale*input(17:76,:)*Fmax/Etrue;

[ gcoord,element,A_index ] = coordinate_group;
nel     = length(element);    % total element
nnode   = length(gcoord);     % total node
ndof    = 3;                  % number of degree of freedom of one node
sdof    = nnode*ndof;         % total dgree of freedom of system

K = zeros(sdof,sdof,numdat);         % creat matrix of stiffness initial is zeros
F = reshape(F,[],1,numdat);           % creat matrix of force is zeros
%---------------------------
Atensor = reshape(A,[16 1 numdat]);
% calculate stiffness matrix 
for iel=1:nel
    nd = element(:,iel); 
    xel  = gcoord(1,nd); y = gcoord(2,nd); z = gcoord(3,nd);
    % compute long of each bar
    le = sqrt((xel(2)-xel(1))^2 + (y(2)-y(1))^2 + (z(2)-z(1))^2);
    % compute direction cosin
    l_ij = (xel(2)-xel(1))/le;      % Eq.8.19
    m_ij = (y(2)-y(1))/le;      % Eq.8.19
    n_ij = (z(2)-z(1))/le;      % Eq.8.19
    % compute transform matrix  
    Te = [l_ij m_ij  n_ij   0       0     0;
           0    0      0   l_ij   m_ij   n_ij];
    % compute stiffness matrix of element
    ke = E/le*pagemtimes(Atensor(A_index(iel),1,:),[1 -1; -1  1]); 
    ke = pagemtimes(Te',ke);
    ke = pagemtimes(ke,Te);  
    % find index assemble 
    index   = [3*nd(1)-2 3*nd(1)-1 3*nd(1)  3*nd(2)-2 3*nd(2)-1  3*nd(2)];
    % assemble ke in K
    K(index,index,:) = K(index,index,:) + ke;    
end

bcdof   = [(1:4)*3-2, (1:4)*3-1, (1:4)*3];   % boundary condition displacement
bcval   = zeros(1,length(bcdof));                  % value of boundary condition

%% Load case 2
n = length(bcdof);
for i = 1:n
    c = bcdof(i);
    K(c,:,:) = 0;
    K(c,c,:) = 1 ;
    F(c,1,:) = bcval(i);
end