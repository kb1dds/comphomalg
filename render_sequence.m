function [out,xybreaks,xyindices,arrowindices]=render_sequence(mats,up)
% Render a sequence of matrices as LaTeX
%
% Input: mats = cellarray of matrices
%        up   = nonzero if matrices go above arrows, zero if matrices go below
% Output: string renderable using XyPic and AMS-LaTeX

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
  
if(~exist('up','var') )
  up=1;
end

out='0 \ar[r] & ';
xyindices=[1];
xybreaks=[1];
arrowindices=[];

for i=1:length(mats),
  if size(mats{i},2) == 0,
    out = [out '0 \ar[r'];
    arrowindices = [arrowindices length(out)];
    out = [out '] '];
    xybreaks=[xybreaks length(out)];
    xyindices=[xyindices xyindices(end)+1];
    out = [out ' & '];
  else
    out = [out '\mathbb{R}'];
    if size(mats{i},2) > 1,
      out = [out '^' num2str(size(mats{i},2))];
    end
    if( isempty(mats{i})),
      out = [out '\ar[r'];
      arrowindices = [arrowindices length(out)];
      out = [out '] '];
      xybreaks=[xybreaks length(out)];
      xyindices=[xyindices xyindices(end)+1];
      out = [out ' & '];
      continue;
    end
    
    out = [out ' \ar[' repmat('r', 1, size(mats{i},2))];
    arrowindices = [arrowindices length(out)];
    if up,
      out=[out ']^-{' ];
    else
      out=[out ']_-{' ];
    end
    out=[out render_matrix(mats{i}) '} '];
    xybreaks=[xybreaks length(out)];
    xyindices=[xyindices xyindices(end)+size(mats{i},2)];
    out = [out repmat('&', 1, size(mats{i},2)) ];
  end
end

if( size(mats{end},1) == 0 )
  out = [out ' 0'];
elseif( size(mats{end},1) == 1 )
  out = [out '\mathbb{R} \ar[r'];
  arrowindices = [arrowindices length(out)];
  out = [out '] '];
  xybreaks=[xybreaks length(out)];
  xyindices=[xyindices xyindices(end)+1];
  out = [out '& 0'];
else
  out = [out '\mathbb{R}^' num2str(size(mats{end},1)) ' \ar[r'];
  arrowindices = [arrowindices length(out)];
  out = [out '] '];
  xybreaks=[xybreaks length(out)];
  xyindices=[xyindices xyindices(end)+1];
  out = [out '& 0'];
end
