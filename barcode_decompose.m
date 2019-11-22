function [bars,generators,mats1,mats2,comps]=barcode_decompose(mats, tol)
% Compute the barcode decomposition from a sequence of matrices
%
% Input: mats = cellarray of matrices in sequence
% Output: bars = nx2 array of bar starts/ends (integers)
%         generators = cell array of vectors generating each bar
%         mats1,mats2 = list of matrices in each chain complex (domain = mats1, 
%                                                              codomain = mats2 = mats)
%         comps       = list of component maps for the chain map
% Note: the original matrix is in the codomain (mats2)
% Note: barcode_reader and this function should agree on bars as output

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

% Preallocate output sequence map
mats1={};
mats2=mats;
comps={};

for i=1:length(mats2),
  mats1{i}=zeros(0,0);
  comps{i}=zeros(size(mats2{i},2),0);
end
comps{end+1}=zeros(size(mats2{end},1),0);
bars=[];
generators={};

while(1),
  % Is there anything to decompose?
  done=1;
  almost_done=0;
  for i=1:length(mats1),
    if size(mats1{i},2)<size(mats2{i},2),
      done=0;
      break;
    end
  end
  if done && (size(mats1{end},1) < size(mats2{end},1)), % Don't forget the last space!
    done = 0;
    almost_done = 1;
  end
  if done,
    break; % Nothing left to decompose
  end
  
  % Find the next basis vector in this space
  if ~almost_done,
    qb=quotient_basis(comps{i});
    generators{end+1}=qb(:,size(comps{i},2)+1);
    bars(end+1,1)=i;
  else
    qb=quotient_basis(comps{i+1});
    generators{end+1}=qb(:,size(comps{i+1},2)+1);
    bars(end+1,:)=[i+1 i+1];
    mats1{i}=add_zero_row(mats1{i});
    comps{i+1}=add_zero_column(comps{i+1});
    comps{i+1}(:,end)=generators{end};
    continue
  end
  
  % Trace bar through the sequence
  % Trace the image of this vector through the domain chain complex
  barlen=1;
  genp = generators{end};
  if( i > 1 ),
    mats1{i-1}=add_zero_row(mats1{i-1});
  end
  for j=i:length(mats1)+1,
    comps{j}=add_zero_column(comps{j});
    comps{j}(:,end)=genp;
    if (j<=length(mats)),
      mats1{j}=add_zero_column(mats1{j});
      if norm(comps{j+1}*(comps{j+1}\(mats{j}*genp))-(mats{j}*genp)) > tol,
        barlen = barlen + 1;
        genp=mats{j}*genp;
      
        mats1{j}=add_zero_row(mats1{j});
        mats1{j}(end,end)=1;
      else
        mats1{j}(:,end)=comps{j+1}\(mats{j}*genp);
        break
      end
    end
  end
  
  bars(end,2)=i+barlen-1;
end

function matout=add_zero_row(matin)
  if( isempty(matin) )
    matout = zeros(size(matin,1)+1,size(matin,2));
  else
    matout=[matin ; zeros(1,size(matin,2))];
  end

function matout=add_zero_column(matin)
  if( isempty(matin) )
    matout = zeros(size(matin,1),size(matin,2)+1);
  else
    matout=[matin, zeros(size(matin,1),1)];
  end
