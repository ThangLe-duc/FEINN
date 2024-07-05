function [K,F] = Stiffness_Force_10Bars(A,numdat,XScale)

A = A*XScale;
E    = 1;      % Young's elastic modulus (N/m^2)
P    = 1e5/(10e6);

%--------------------------------------------------------------------------
%           1        2      3     4       5   6          
gcoord  = [360*2,  360*2,  360,  360,     0,  0 
           360,        0,  360,    0,   360,  0];
%          1  2  3  4  5  6  7  8  9  10
element = [3, 1, 4, 2, 3, 1, 4, 3, 2, 1
           5, 3, 6, 4, 4, 2, 5, 6, 3, 4];
nel     = length(element);    % total element
nnode   = length(gcoord);     % total node
ndof    = 2;                  % number of degree of freedom of one node
sdof    = nnode*ndof;         % total dgree of freedom of system
K     = zeros(sdof,sdof,numdat);         % creat tensor of stiffness initial is zeros
F     = zeros(sdof,1,numdat);            % creat matrix of force is zeros
%---------------------------
% calculate stiffness matrix 
for j = 1:numdat
for i=1:nel
    nd = element(:,i); 
    x  = gcoord(1,nd); y = gcoord(2,nd);
    % compute long of each bar
    le = sqrt((x(2)-x(1))^2 + (y(2)-y(1))^2);
    % compute direction cosin
    l_ij = (x(2)-x(1))/le;      % Eq.5.19
    m_ij = (y(2)-y(1))/le;      % Eq.5.19
    % compute transform matrix  
    Te = [l_ij m_ij   0      0;
           0    0    l_ij   m_ij];    
    % compute stiffness matrix of element
    ke = A(i,j)*E/le*[1 -1;
                   -1  1]; 
    ke = Te'*ke*Te;   
    % find index assemble
    index = [2*nd(1)-1 2*nd(1)  2*nd(2)-1  2*nd(2)];
    % assemble ke in K
    K(index,index,j) = K(index,index,j) + ke;    
end
end

bcdof = [9 10 11 12];   % boundary condition displacement
bcval = zeros(1,length(bcdof));                  % value of boundary condition         

for j = 1:numdat
F([4 8],1,j) = -P; 
n = length(bcdof);
for i = 1:n
    c = bcdof(i);
    K(c,:,j) = 0;
    K(c,c,j) = 1 ;
    F(c,1,j) = bcval(i);
end
end