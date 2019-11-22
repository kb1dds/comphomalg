function out=render_sequence_map(mats1,mats2,comps)
% Render a sequence map as LaTeX
%
% Input: mats1,mats2 = list of matrices in each chain complex (domain = mats1, codomain = mats2)
%        comps       = list of component maps for the chain map
%        tol         = tolerance
% Output: string parsable by XyPic and AMS-LaTeX
  
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

% Preliminary renderings of the two sequences
[out1,xybreaks1,xyindices1,arrowindices1]=render_sequence(mats1,1);
[out2,xybreaks2,xyindices2,arrowindices2]=render_sequence(mats2,0);

% Align the xypic indices of the two sequences
xyindices=[1];
for i=2:length(xyindices1),
  xyindices(end+1)=xyindices(end)+max([ceil(size(comps{i-1},2)/2),xyindices1(i)-xyindices1(i-1),xyindices2(i)-xyindices2(i-1)]);
end

% Determine the amount of spacing between rows needed
maxheight=1;
for i=1:length(comps),
  maxheight = max([maxheight,size(comps{i},1)]);
end
rows=ceil(maxheight/2);

% Render first sequence, interspersing the component maps as we go
out='';
for i=1:length(comps),
  out=[out out1(xybreaks1(i):arrowindices1(i))];
  out=[out repmat('r', 1, (xyindices(i+1) -xyindices(i)) - (xyindices1(i+1) - xyindices1(i)))];
  out=[out out1(arrowindices1(i)+1:xybreaks1(i+1))];
  out=[out ' \ar[' repmat('d',1,rows) ']^-{' render_matrix(comps{i}) '} '];
  % Append any extra xypic spaces as needed
  out=[out repmat('&', 1, (xyindices(i+1) -xyindices(i)) - (xyindices1(i+1) - xyindices1(i)))];
end
out = [out out1(xybreaks1(end):end) repmat('\\ ',1,rows)];

% Render the second sequence, interspersing extra xypic spaces
for i=1:length(comps),
  out=[out out2(xybreaks2(i):arrowindices2(i))];
  out=[out repmat('r', 1, (xyindices(i+1) -xyindices(i)) - (xyindices2(i+1) - xyindices2(i)))];
  out=[out out2(arrowindices2(i)+1:xybreaks2(i+1))];
  % Append any extra xypic spaces as needed
  out=[out repmat('&', 1, (xyindices(i+1) -xyindices(i)) - (xyindices2(i+1) - xyindices2(i)))];
end
out = [out out2(xybreaks2(end):end)];
