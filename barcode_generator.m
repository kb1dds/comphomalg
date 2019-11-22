function mats=barcode_generator( bars, randomize )
% Generate a sequence of permutation matrices whose barcode decomposition
% is given
%
% Input: bars = nx2 array of bar starts/ends (integers)
%        randomize = nonzero if the order of the bars should be shuffled
% Output: mats = cellarray of matrices

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

% Determine sequence indices for matrices
indxs=min(bars(:)):max(bars(:));

% Initialize output
mats={};

% Expand bars into a cellarray of vectors of bar indices
bar_cells={};
for i=1:length(indxs),
  bar_cells{i}=[];
end
for i=1:size(bars,1),
  start_idx = find(indxs==bars(i,1));
  end_idx = find(indxs==bars(i,2));
  for k=start_idx:end_idx,
    bar_cells{k}=[bar_cells{k} i];
  end
end

% Shuffle order if requested
if( randomize )
  for i=1:length(indxs),
    p = randperm(length(bar_cells{i}));
    bar_cells{i}=bar_cells{i}(p);
  end
end

% Construct matrices
for i=1:length(indxs)-1,
  mats{i}=zeros(length(bar_cells{i+1}),length(bar_cells{i}));
  for j=1:length(bar_cells{i}),
    k = find(bar_cells{i+1}==bar_cells{i}(j));
    if k > 0,
      mats{i}(k,j)=1;
    end
  end
end
