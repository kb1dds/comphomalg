function tf=is_sequence_map(mats1,mats2,comps,tol)
% Check if a proported sequence map is indeed a sequence map
%
% Input: mats1,mats2 = list of matrices in each chain complex (domain = mats1, codomain = mats2)
%        comps       = list of component maps for the chain map
%        tol         = tolerance
% Output: false if the diagram does not commute or has some other problem.  Otherwise true
  
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

for i=2:length(comps),
  if( any(abs(mats2{i-1}*comps{i-1} - comps{i}*mats1{i-1})(:) > tol ) ),
    tf=0;
    disp([ 'Not commuting at index ' num2str(i) ])
    disp('Bottom path')
    disp(mats2{i-1}*comps{i-1})
    disp('versus top path')
    disp(comps{i}*mats1{i-1})
    return
  end
end

tf=1;
