function Ls=laplacian(mats)
% Compute the sequence of Laplacian maps for a chain complex
%
% Input: mats  = cellarray of matrices in sequence
% Output: Ls = cellarray of Laplacian matrices

% Copyright (c) 2020 Michael Robinson
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

Ls={};

% First Laplacian has a special form assuming the very first map (not stored) is zero
Ls{1}=mats{1}'*mats{1}; 

% General term for Laplacians in the middle of the sequence
for m=2:length(mats),
  Ls{m}=mats{m}'*mats{m}-mats{m-1}*mats{m-1}';
end

% Last Laplacian has a special form because the last map (not stored) is zero
Ls{end+1}=-mats{end}*mats{end}';