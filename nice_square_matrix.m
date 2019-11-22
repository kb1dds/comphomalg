function [a,ai]=nice_square_matrix(n,elementbound,detbound)
% Draw a random nice integer square matrix with a nice inverse
% 
% Input: n = number of rows/columns
%        elementbound = largest element to use
%        detbound     = largest allowable determinant
% Output: a  = matrix
%         ai = inverse

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
  
if( ~exist('elementbound', 'var' ) )
  elementbound = 4;
end

if( ~exist('detbound','var' ) )
  detbound = 3;
end

a=round(elementbound*2*rand(n)-elementbound); 

while(abs(det(a))>detbound || abs(det(a))<0.5 || any(abs(inv(a))(:)>2*elementbound)), 
  a=round(elementbound*2*rand(n)-elementbound); 
end

ai=inv(a);
