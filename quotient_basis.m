function basis=quotient_basis(subspace,tol)
% Compute a basis for a vector space such that the first few columns are a given subspace
% 
% Input: subspace = M columns spanning subspace NxM
% Output: basis = NxN full rank matrix, in which the first M columns are given by subspace

% Copyright (c) 2019 Michael Robinson
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

if ~exist('tol','var'),
  tol = 1e-5;
end

n=size(subspace,1);
m=size(subspace,2);

original=eye(n);
M = [subspace original];
Mp=rref(M,tol);
basis=subspace;

for i=m+1:n,
  for j=m+1:m+n,
    if abs(Mp(i,j)) > tol,
      basis(:,end+1)=original(:,j-m);
      break;
    end
  end
end
