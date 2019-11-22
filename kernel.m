function ker=kernel(mat,tol)
% Compute the kernel of a matrix using the method of free columns
%
% Input: mat = matrix to computer (MxN)
%        tol = tolerance (optional)
% Output: ker = columns of kernel (MxK)
% Note: output should be structurally similar to the builtin null() function
%       but will be numerically different (and generally a bit more rational)

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
  tol=1e-5;
end

if size(mat,2) == 0, % No columns -- no kernel
  ker=zeros(size(mat,1),0);
elseif size(mat,1) == 0, % No rows -- all kernel
  ker=eye(size(mat,2));
else % otherwise we need to compute something...
  m=rref(mat,tol);
  ker=zeros(size(mat,2),0);
  
  % Locate free columns (assumes rref!)
  free_columns=[];
  free_rows=[];
  for i=1:size(m,1),
    for j=i:size(m,2),
      if abs(m(i,j)) > tol,
        free_columns=[free_columns; j];
        free_rows=[free_rows; i];
        break
      end
    end
  end
  
  % Scan over non-free columns; each starts an element of the kernel
  for j=1:size(m,2),
    if ~ismember(j,free_columns),
      v=zeros(size(mat,2),1);
      v(j)=1;
      for k=1:length(free_columns),
        v(free_columns(k))=-m(free_rows(k),j); % Again, assuming rref
        %v(free_columns(k))=-m(free_rows(k),j)/m(free_rows(k),free_columns(k)); % row echelon form only
      end
      ker=[ker v];
    end
  end
end
