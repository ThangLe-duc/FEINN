function [detjacobian,invjacobian]=Jacobian(nnel,dhdr,dhds,xcoord,ycoord,numdat)

%------------------------------------------------------------------------
%  Purpose:
%     determine the Jacobian for two-dimensional mapping
%
%  Synopsis:
%     [detjacobian,invjacobian]=Jacobian(nnel,dhdr,dhds,xcoord,ycoord) 
%
%  Variable Description:
%     jacobian - Jacobian for one-dimension
%     nnel - number of nodes per element   
%     dhdr - derivative of shape functions w.r.t. natural coordinate r
%     dhds - derivative of shape functions w.r.t. natural coordinate s
%     xcoord - x axis coordinate values of nodes
%     ycoord - y axis coordinate values of nodes
%------------------------------------------------------------------------

 jacobian=zeros(2,2,numdat);

 for i=1:nnel
 jacobian(1,1,:) = jacobian(1,1,:) + pagemtimes(dhdr(i),xcoord(i,1,:));
 jacobian(1,2,:) = jacobian(1,2,:) + pagemtimes(dhdr(i),ycoord(i,1,:));
 jacobian(2,1,:) = jacobian(2,1,:) + pagemtimes(dhds(i),xcoord(i,1,:));
 jacobian(2,2,:) = jacobian(2,2,:) + pagemtimes(dhds(i),ycoord(i,1,:));
 end

 detjacobian = zeros(1,1,numdat);
%  invjacobian = zeros(2,2,numdat);
 for i=1:numdat
 detjacobian(:,:,i) = det(jacobian(:,:,i)) ;  % Determinant of Jacobian matrix
%  invjacobian(:,:,i) = inv(jacobian(:,:,i)) ;  % Inverse of Jacobian matrix
 end
 invjacobian = pageinv(jacobian);