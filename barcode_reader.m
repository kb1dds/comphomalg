function bars=barcode_reader(mats,tol)
% Compute the barcode decomposition from a sequence of matrices
%
% Input: mats = cellarray of matrices in sequence
% Output: bars = nx2 array of bar starts/ends (integers)

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
  % Tolerance for zero vectors
  tol=1e-5;
end

bars=[];

for j=1:length(mats)+1, % Candidate bar starting index
  for k=j:length(mats)+1, % Candidate bar ending index
  
    % Construct matrix transforming starting term to ending term. 
    % Assume trivial spaces appear after last listed matrix
    if( j < length(mats) + 1 )
      mt = eye(size(mats{j},2)); % First matrix
    else
      mt = zeros(size(mats{j-1},1)); % Last mstrix is always a zero matrix
    end
    if k < length(mats)+1,
      for i=j:k,
        mt = mats{i} * mt; % Compose matrices in between
      end
    else
       mt = zeros(1,size(mt,2)); % Last matrix is always a zero matrix
    end
    
    % Compute the number of bars that end at k or earlier and start at j or earlier.
    if ~isempty(mt),
      G1 = size(kernel(mt,tol),2);
    else
      G1 = size(mt,2);
    end
    
    % Find the number of bars already computed that end within the interval under consideration
    G2 = 0;
    for i=1:size(bars,1),
      if( j <= bars(i,2) && bars(i,2) <= k )
        G2 = G2 + 1;
      end
    end
    
    %disp(['j = ' num2str(j) ', k = ' num2str(k) ', G1 = ' num2str(G1) ', G2 = ' num2str(G2)])
    
    % Append G1-G2 bars to the list that start at j and end at k
    %disp([j k G1 G2]);
    if ( G1-G2 > 0 )
      bars=[bars ; repmat([j,k], [G1-G2,1])];
    end
  end
end
