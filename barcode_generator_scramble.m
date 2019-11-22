function [mats,comps,mats1]=barcode_generator_scramble( bars )
% Generate a sequence of matrices whose barcode decomposition is given, but
% allow bases to be scrambled by invertible (and nice) matrices
%
% Input: bars = nx2 array of bar starts/ends (integers)
% Output: mats  = cellarray of matrices (unscrambled)
%         mats1 = cellarray of matrices (scrambled)
%         comps = cellarray of sequence map components
% Note: Original sequence is domain of the returned sequence map
%       There is a slight incompatibility with the usual sequence map
%       calling convention (domain,codomain,components); this function
%       uses (codomain,comps,domain) to keep compatibility with
%       barcode_generator's output.

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

% Generate barcode without scrambling
mats1=barcode_generator( bars, 1);

[mats,comps]=barcode_scramble_mats(mats1)