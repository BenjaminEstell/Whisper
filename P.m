function beta = P(alpha,gamma)
%
% Name: P
%
% Inputs:
%    alpha - n-by-1 vector of candidate basis coefficients
%    gamma - scalar value representing the degree of sparsity
% Outputs:
%    beta - n-by-1 vector of soft-thresholded basis coefficients
%
% Created by: Adam C. Lammert (2021)
%
% Description: Implementation of the soft thresholding function "P"
%               described by Zhang et al. (2014).
%
% Reference: Zhang, L., Yi, J., & Jin, R. (2014, June). Efficient 
%               algorithms for robust one-bit compressive sensing. In 
%               International Conference on Machine Learning (pp. 820-828). 
% 

beta = zeros(length(alpha),1);

ind = abs(alpha)>gamma;

beta(ind) = sign(alpha(ind)).*(abs(alpha(ind))-gamma);

return
%eof