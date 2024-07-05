function [K,F,E] = Stiffness_Force_BernBeam_Batch_True(Ainp, numdat, XScale, numberElements)
% E; modulus of elasticity
% I: second moment of area
% L: length of bar
E = 2e11;
A = Ainp(1:3,:);
A = A*XScale;
Atensor = reshape(A,[3 1 numdat]);
L = Atensor(1,1,:); P = Atensor(2,1,:); k = Atensor(3,1,:);
t = L/1000;

% calculate stiffness matrix 
I = 1*t.^3/12;  EI = E*I; 
% generation of coordinates and connectivities
for i=1:numdat
    nodeCoord(:,i) = linspace(0,L(i),numberElements+1)';
end
nodeCoordinates = reshape(nodeCoord,[numberElements+1 1 numdat]);
for i=1:numberElements
    elementNodes(i,1)=i; 
    elementNodes(i,2)=i+1;
end
numberNodes = numberElements+1;
xx = nodeCoordinates(:,1,:);

% for structure:
    % displacements: displacement vector
    % force : force vector
    % stiffness: stiffness matrix
    % GDof: global number of degrees of freedom
GDof = 2*numberNodes; 
stiffnessSpring = zeros(GDof+1,GDof+1,numdat);
forceSpring = zeros(GDof+1,1,numdat);

% stiffess matrix and force vector
[stiffness,force] = formStiffnessBernoulliBeam(GDof,numberElements,...
    elementNodes,numberNodes,xx,EI,P,numdat);
% spring added
stiffnessSpring(1:GDof,1:GDof,:) = stiffness;
forceSpring(1:GDof,1,:) = force;
% k = 10;
stiffnessSpring([GDof-1 GDof+1],[GDof-1 GDof+1],:)=...
    stiffnessSpring([GDof-1 GDof+1],[GDof-1 GDof+1],:) + [k -k;-k k];

% boundary conditions and solution
fixedNodeU = [1]'; fixedNodeV = [2]';
prescribedDof = [fixedNodeU;fixedNodeV;GDof+1];

% F([4 8],1,j) = -P; 
n = length(prescribedDof);
for i = 1:n
    c = prescribedDof(i);
    stiffnessSpring(c,:,:) = 0;
    stiffnessSpring(:,c,:) = 0;
    stiffnessSpring(c,c,:) = 1 ;
    forceSpring(c,1,:) = 0;
end
K = stiffnessSpring;
F = forceSpring;