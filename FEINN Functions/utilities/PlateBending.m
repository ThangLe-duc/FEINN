function [pb]=PlateBending(nnel,dhdx,dhdy,numdat)

%--------------------------------------------------------------------------
%  Purpose:
%     determine the kinematic matrix expression relating bending curvatures 
%     to rotations and displacements for shear deformable plate bending
%
%  Synopsis:
%     [pb]=PlateBending(nnel,dhdx,dhdy) 
%
%  Variable Description:
%     nnel - number of nodes per element
%     dhdx - derivatives of shape functions with respect to x   
%     dhdy - derivatives of shape functions with respect to y
%--------------------------------------------------------------------------

 for i=1:nnel
 i1=(i-1)*3+1;  
 i2=i1+1;
 i3=i2+1;
 pb(2,i2,:)=dhdy(1,i,:);
 pb(3,i2,:)=dhdx(1,i,:);
 pb(1,i3,:)=-dhdx(1,i,:);
 pb(3,i3,:)=-dhdy(1,i,:);
 pb(3,i1,:)=zeros(1,1,numdat);
 end
