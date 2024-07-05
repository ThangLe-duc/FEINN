function [Nodes, Rectangles]=Rectangles_Mesh(xx,yy)

%This function generates rectangular mesh accoarding to grid set by vectors xx and yy.

%function [Nodes, Rectangles]=Rectangles_Mesh(xx,yy)
%where inputs
%xx and yy are vectors for grids of size (Nx,1) and (Ny,1), respectively.
%output:
%Nodes (Nx*Ny,2) is a matrix of x-coordinate of y-coordinates of the mesh nodes.
%Rectangles((Nx-1)*(Ny-1),4) is a matrix of nodes connectivity for each element in counter clockwise direction.

Nx=length(xx);
Ny=length(yy);
for j=1:1:Ny
for i=1:1:Nx
c=Nx*(j-1)+i;    
Nodes(c,1)=xx(i);
Nodes(c,2)=yy(j);    
end
end
for j=1:1:Ny-1
for i=1:1:Nx-1
d=(Nx-1)*(j-1)+i;    
Rectangles(d,1)=Nx*(j-1)+i;
Rectangles(d,2)=Nx*(j-1)+i+1;
Rectangles(d,3)=Nx*j+i+1;
Rectangles(d,4)=Nx*j+i;
end
end
end