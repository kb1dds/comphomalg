function [mats,comps]=barcode_scramble_mats(mats1)
% Scramble a sequence by invertible (and nice) matrices
% 
% Input:  mats1 = cellarray of matrices
% Output: mats = cellarray of matrices
%         comps = cellarray of sequence map components
% Note: Original sequence is domain of the returned sequence map

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
  
% Generate basis scrambing matrices
basis_cells = {};
dets=[];
for i=1:length(mats1)+1,
  if( i <= length(mats1) )
    basis_cells{i}=nice_square_matrix(size(mats1{i},2));
  else
    basis_cells{i}=nice_square_matrix(size(mats1{i-1},1));
  end
  dets(i) = round(abs(det(basis_cells{i})));
end

% Clear fractions
comps = {};
for i=1:length(basis_cells),
  comps{i} = basis_cells{i}/prod(dets(i:end));
end

% Apply scrambling matrices
mats={};
for i=1:length(mats1),
  mats{i} = round(comps{i+1}*mats1{i}/comps{i});
end
