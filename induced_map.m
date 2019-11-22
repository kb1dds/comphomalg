function mapout=induced_map(subspace1,subspace2,mapin,tol)
% Compute the induced map on quotients
% 
% Input: subspace1 = M columns spanning subspace NxM for quotient in the domain 
%                    or empty if no quotient is desired
%        subspace2 = P columns spanning subspace QxP for quotient in the codomain 
%                    or empty if no quotient is desired
%        mapin     = QxN matrix for the original map
%        tol       = tolerance (optional)
% Output: mapout = (Q-P)x(N-M) induced map matrix

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

if isempty(mapin), % Special handling of zero matrices
  mapout=zeros(size(mapin,1)-size(subspace2,2),size(mapin,2)-size(subspace1,2));
else
  if ~isempty(subspace1),
    qb=quotient_basis(subspace1,tol);
  else
    qb=eye(size(mapin,2));
  end

  if ~isempty(subspace2),
    q=canonical_projection(subspace2,tol);
  else
    q=eye(size(mapin,1));
  end

  mapout = q*mapin*qb(:,size(subspace1,2)+1:end);
  
  % Flush very small entries
  mapout(abs(mapout)<tol)=0;
end
