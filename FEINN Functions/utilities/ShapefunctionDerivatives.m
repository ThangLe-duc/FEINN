function [dhdx,dhdy]=ShapefunctionDerivatives(nnel,dhdr,dhds,invjacob,numdat)

%------------------------------------------------------------------------
%  Purpose:
%     determine derivatives of  isoparametric Q4 shape functions with 
%     respect to physical coordinate system
%
%  Synopsis:
%     [dhdx,dhdy]=shapefunctionderivatives(nnel,dhdr,dhds,invjacob)  
%
%  Variable Description:
%     dhdx - derivative of shape function w.r.t. physical coordinate x
%     dhdy - derivative of shape function w.r.t. physical coordinate y
%     nnel - number of nodes per element   
%     dhdr - derivative of shape functions w.r.t. natural coordinate r
%     dhds - derivative of shape functions w.r.t. natural coordinate s
%     invjacob - inverse of  Jacobian matrix
%------------------------------------------------------------------------
dhdx = zeros(1,nnel,numdat);
dhdy = zeros(1,nnel,numdat);
 for i=1:nnel
 dhdx(1,i,:) = pagemtimes(dhdr(i),invjacob(1,1,:)) + pagemtimes(dhds(i),invjacob(1,2,:));
 dhdy(1,i,:) = pagemtimes(dhdr(i),invjacob(2,1,:)) + pagemtimes(dhds(i),invjacob(2,2,:));
 end
