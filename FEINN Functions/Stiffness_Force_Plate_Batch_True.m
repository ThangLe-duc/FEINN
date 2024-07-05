function [K,F,E] = Stiffness_Force_Plate_Batch_True(Ainp, numdat, XScale)
% Static Analysis of  plate
% Problem : To find the maximum bedning of plate when uniform transverse
% pressure is applied. 
% Two Boundary conditions are used, simply supported and clamped
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Warning : On running this the workspace memory will be deleted. Save if
% any data present before running the code !!
%
% Variable descriptions                                                      
%   ke = element stiffness matrix                                             
%   kb = element stiffness matrix for bending
%   ks = element stiffness matrix for shear 
%   f = element force vector
%   stiffness = system stiffness matrix                                             
%   force = system vector                                                 
%   displacement = system nodal displacement vector
%   coordinates = coordinate values of each node
%   nodes = nodal connectivity of each element
%   index = a vector containing system dofs associated with each element     
%   pointb = matrix containing sampling points for bending term
%   weightb = matrix containing weighting coefficients for bending term
%   points = matrix containing sampling points for shear term
%   weights = matrix containing weighting coefficients for shear term
%   bcdof = a vector containing dofs associated with boundary conditions     
%   bcval = a vector containing boundary condition values associated with    
%           the dofs in 'bcdof'                                              
%   B_pb = matrix for kinematic equation for bending
%   D_pb = matrix for material property for bending
%   B_ps = matrix for kinematic equation for shear
%   D_ps = matrix for material property for shear
%
%--------------------------------------------------------------------------
% Input data for nodal connectivity for each element
%--------------------------------------------------------------------------
gridx = linspace(0,1,11);
gridy = linspace(0,1,11);
[coordinates, nodes] = Rectangles_Mesh(gridx,gridy);

%--------------------------------------------------------------------------
% Geometrical and material properties of plate
%--------------------------------------------------------------------------
% Etrue = 10920;                        % elastic modulus
E = 10920;
nu = 0.3;                         % Poisson's ratio

A = Ainp(1:3,:);
A = A*XScale;
Atensor = reshape(A,[3 1 numdat]);
t = Atensor(1,1,:); L = Atensor(2,1,:); P = Atensor(3,1,:);
% t = A(1);                         % plate thickness
% L = A(2);
% P = A(3) ;  % Transverse uniform pressure on plate
I = t.^3/12 ;

coorTensor = pagemtimes(L,repmat(coordinates,1,1,numdat));
% nodeTensor = repmat(nodes,1,1,numdat);
nodeTensor = nodes;

nel = length(nodes) ;                  % number of elements
nnel = 4;                                % number of nodes per element
ndof = 3;                                % number of dofs per node
nnode = length(coordinates) ;          % total number of nodes in system
sdof = nnode*ndof;                       % total system dofs  
edof = nnel*ndof;                        % degrees of freedom per element
%--------------------------------------------------------------------------
% Order of Gauss Quadrature
%--------------------------------------------------------------------------
nglb = 2;                     % 2x2 Gauss-Legendre quadrature for bending 
ngls = 1;                     % 1x1 Gauss-Legendre quadrature for shear 

%--------------------------------------------------------------------------
% Initialization of matrices and vectors
%--------------------------------------------------------------------------
force = zeros(sdof,1,numdat) ;             % System Force Vector
stiffness = zeros(sdof,sdof,numdat);         % system stiffness matrix
index = zeros(edof,1,numdat);                % index vector
B_pb = zeros(3,edof,numdat);                 % kinematic matrix for bending
B_ps = zeros(2,edof,numdat);                 % kinematic matrix for shear

%--------------------------------------------------------------------------
%  Computation of element matrices and vectors and their assembly
%--------------------------------------------------------------------------
%
%  For bending stiffness
%
[pointb,weightb] = GaussQuadrature('second');     % sampling points & weights
D_pb= pagemtimes(I*E/(1-nu*nu),[1  nu 0; nu  1  0; 0  0  (1-nu)/2]);
                                           % bending material property
%
%  For shear stiffness
%
[points,weights] = GaussQuadrature('first');    % sampling points & weights
G = 0.5*E/(1.0+nu);                             % shear modulus
shcof = 5/6;                                    % shear correction factor
D_ps = pagemtimes(G*shcof*t,[1 0; 0 1]);                      % shear material property

for iel=1:nel                        % loop for the total number of elements

for i=1:nnel
%     node(i,1,:) = nodeTensor(iel,i,:);               % extract connected node for (iel)-th element
    node(i) = nodeTensor(iel,i);
    xx(i,1,:) = coorTensor(node(i),1,:);       % extract x value of the node
    yy(i,1,:) = coorTensor(node(i),2,:);       % extract y value of the node
end

ke = zeros(edof,edof,numdat);              % initialization of element stiffness matrix 
kb = zeros(edof,edof,numdat);              % initialization of bending matrix 
ks = zeros(edof,edof,numdat);              % initialization of shear matrix 
f = zeros(edof,1,numdat) ;                 % initialization of force vector                   
%--------------------------------------------------------------------------
%  Numerical integration for bending term
%--------------------------------------------------------------------------
for intx=1:nglb
xi=pointb(intx,1);                     % sampling point in x-axis
wtx=weightb(intx,1);                   % weight in x-axis
for inty=1:nglb
eta=pointb(inty,2);                    % sampling point in y-axis
wty=weightb(inty,2) ;                  % weight in y-axis

[shape,dhdr,dhds] = Shapefunctions(xi,eta);    
    % compute shape functions and derivatives at sampling point

[detjacobian,invjacobian] = Jacobian(nnel,dhdr,dhds,xx,yy,numdat);  % compute Jacobian

[dhdx,dhdy] = ShapefunctionDerivatives(nnel,dhdr,dhds,invjacobian,numdat);
                                     % derivatives w.r.t. physical coordinate
B_pb = PlateBending(nnel,dhdx,dhdy,numdat);    % bending kinematic matrix

%--------------------------------------------------------------------------
%  compute bending element matrix
%--------------------------------------------------------------------------

kb = kb + pagemtimes(pagemtimes(pagemtimes(pagemtimes(pagemtimes(pagetranspose(B_pb),D_pb),B_pb),wtx),wty),detjacobian);

end
end                      % end of numerical integration loop for bending term

%--------------------------------------------------------------------------
%  numerical integration for shear term
%--------------------------------------------------------------------------

for intx=1:ngls
xi=points(intx,1);                  % sampling point in x-axis
wtx=weights(intx,1);               % weight in x-axis
for inty=1:ngls
eta=points(inty,2);                  % sampling point in y-axis
wty=weights(inty,2) ;              % weight in y-axis

[shape,dhdr,dhds] = Shapefunctions(xi,eta);   
        % compute shape functions and derivatives at sampling point

[detjacobian,invjacobian] = Jacobian(nnel,dhdr,dhds,xx,yy,numdat);  % compute Jacobian

[dhdx,dhdy] = ShapefunctionDerivatives(nnel,dhdr,dhds,invjacobian,numdat); 
            % derivatives w.r.t. physical coordinate

fe = Force(nnel,shape,P) ;             % Force vector
B_ps = PlateShear(nnel,dhdx,dhdy,shape);        % shear kinematic matrix

%--------------------------------------------------------------------------
%  compute shear element matrix
%--------------------------------------------------------------------------
                
ks = ks + pagemtimes(pagemtimes(pagemtimes(pagemtimes(pagemtimes(pagetranspose(B_ps),D_ps),B_ps),wtx),wty),detjacobian);
f = f + pagemtimes(pagemtimes(pagemtimes(fe,wtx),wty),detjacobian);

end
end                      % end of numerical integration loop for shear term

%--------------------------------------------------------------------------
%  compute element matrix
%--------------------------------------------------------------------------

ke = kb + ks ;

index = elementdof(node,nnel,ndof);% extract system dofs associated with element

[stiffness,force] = assemble(stiffness,force,ke,f,index);      
                           % assemble element stiffness and force matrices 
end
%--------------------------------------------------------------------------
% Boundary conditions
%--------------------------------------------------------------------------
typeBC = 'ss-ss-ss-ss' ;        % Boundary Condition type
% typeBC = 'c-c-c-c'   ;
bcdof = BoundaryCondition(typeBC,coordinates) ;
bcval = zeros(1,length(bcdof),numdat) ;

% bcdof = repmat(bcdof,1,1,numdat);
% bcdofsize = size(bcdof);
% bcval = zeros(1,max(bcdofsize(1:2)),numdat) ;

[stiffness,force] = constraints(stiffness,force,bcdof,bcval);

K = stiffness;
F = force;