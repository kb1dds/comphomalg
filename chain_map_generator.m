function [mats1, mats2, comps]=chain_map_generator(starts,types)
% Generate a chain map from a collection of bar chain maps
%
% input: starts = list of starting indices for each bar chain map
%        types  = list of types for each bar chain map (see README.md)
% Output: mats1,mats2 = list of matrices in each chain complex (domain = mats1, codomain = mats2)
%         comps       = list of component maps for the chain map

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
  
% Number of indices consumed by each type
type_lens = [1, 1, 2, 1, 1, 2, 2, 2, 2, 3];

mats1={};
comps={};
mats2={};
for i=1:length(starts),
  mats1{starts(i)+type_lens(types(i))-1}=[];
  mats2{starts(i)+type_lens(types(i))-1}=[];
  comps{starts(i)+type_lens(types(i))-1}=[];
end
for i=1:length(starts),
  if( types(i) == 1 )
    continue;
  elseif( types(i) == 2 )
    comps{starts(i)} = add_zero_row(comps{starts(i)}); % Add a zero row to the indexed component
    mats2{starts(i)} = add_zero_column(mats2{starts(i)}); % Add a zero column to the indexed codomain map
    if(starts(i)>1)
      mats2{starts(i)-1} = add_zero_row(mats2{starts(i)-1}); % Add a zero tow to the prevoious indexed codomain map
    end
  elseif( types(i) == 3 )
    comps{starts(i)} = add_zero_row(comps{starts(i)}); % Add a zero row to the indexed component
    comps{starts(i)+1} = add_zero_row(comps{starts(i)+1}); % Add a zero row to the next indexed component
    mats2{starts(i)} = add_identity_row_column(mats2{starts(i)}); % Add a identity row and column to the indexed codomain map
    mats2{starts(i)+1} = add_zero_column(mats2{starts(i)+1}); % Add a zero column to the next indexed codomain map
    if(starts(i)>1)
      mats2{starts(i)-1} = add_zero_row(mats2{starts(i)-1}); % Add a zero row to the prevoious indexed codomain map
    end
  elseif( types(i) == 4 )
    mats1{starts(i)} = add_zero_column(mats1{starts(i)}); % Add a zero column to the indexed domain map
    if(starts(i)>1)
      mats1{starts(i)-1} = add_zero_row(mats1{starts(i)-1}); % Add a zero row to the previous indexed domain map
    end
    comps{starts(i)} = add_zero_column(comps{starts(i)}); % Add a zero column to the indexed component
  elseif( types(i) == 5 )
    mats1{starts(i)} = add_zero_column(mats1{starts(i)}); % Add a zero column to the indexed domain map
    if(starts(i)>1)
      mats1{starts(i)-1} = add_zero_row(mats1{starts(i)-1}); % Add a zero row to the previous indexed domain map
    end
    comps{starts(i)} = add_identity_row_column(comps{starts(i)}); % Add a identity row and column to the indexed component
    mats2{starts(i)} = add_zero_column(mats2{starts(i)}); % Add a zero column to the indexed codomain map
    if(starts(i)>1)
      mats2{starts(i)-1} = add_zero_row(mats2{starts(i)-1}); % Add a zero row to the prevoious indexed codomain map
    end
  elseif( types(i) == 6 )
    mats1{starts(i)+1} = add_zero_column(mats1{starts(i)+1}); % Add a zero column to the next indexed domain map
    mats1{starts(i)} = add_zero_row(mats1{starts(i)}); % Add a zero row to the indexed domain map
    comps{starts(i)} = add_zero_row(comps{starts(i)}); % Add a zero row to the indexed component
    comps{starts(i)+1} = add_identity_row_column(comps{starts(i)+1}); % Add an identity row and zero row to the next indexed component
    mats2{starts(i)} = add_identity_row_column(mats2{starts(i)}); % Add a identity row and column to the indexed codomain map
    mats2{starts(i)+1} = add_zero_column(mats2{starts(i)+1}); % Add a zero column to the next indexed codomain map
    if(starts(i)>1)
      mats2{starts(i)-1} = add_zero_row(mats2{starts(i)-1}); % Add a zero row to the prevoious indexed codomain map
    end
  elseif( types(i) == 7 )
    mats1{starts(i)} = add_identity_row_column(mats1{starts(i)}); % Add an identity row and column to the indexed domain map
    if(starts(i)>1)
      mats1{starts(i)-1} = add_zero_row(mats1{starts(i)-1}); % Add a zero row to the previous indexed domain map
    end
    mats1{starts(i)+1} = add_zero_column(mats1{starts(i)+1}); % Add a zero column to the next indexed domain map
    comps{starts(i)} = add_zero_column(comps{starts(i)}); % Add a zero column to the indexed component
    comps{starts(i)+1} = add_zero_column(comps{starts(i)+1}); % Add a zero column to the next indexed component
  elseif( types(i) == 8 )
    mats1{starts(i)} = add_identity_row_column(mats1{starts(i)}); % Add an identity row and column to the indexed domain map
    if(starts(i)>1)
      mats1{starts(i)-1} = add_zero_row(mats1{starts(i)-1}); % Add a zero row to the previous indexed domain map
    end
    mats1{starts(i)+1} = add_zero_column(mats1{starts(i)+1}); % Add a zero column to the next indexed domain map
    comps{starts(i)} = add_identity_row_column(comps{starts(i)}); % Add a identity row and column to the indexed component
    comps{starts(i)+1} = add_zero_column(comps{starts(i)+1}); % Add a zero column to the next indexed component
    mats2{starts(i)} = add_zero_column(mats2{starts(i)}); % Add a zero column to the indexed codomain map
    if(starts(i)>1)
      mats2{starts(i)-1} = add_zero_row(mats2{starts(i)-1}); % Add a zero row to the prevoious indexed codomain map
    end
  elseif( types(i) == 9 )
    mats1{starts(i)} = add_identity_row_column(mats1{starts(i)}); % Add an identity row and column to the indexed domain map
    if(starts(i)>1)
      mats1{starts(i)-1} = add_zero_row(mats1{starts(i)-1}); % Add a zero row to the previous indexed domain map
    end
    mats1{starts(i)+1} = add_zero_column(mats1{starts(i)+1}); % Add a zero column to the next indexed domain map
    comps{starts(i)} = add_identity_row_column(comps{starts(i)}); % Add a identity row and column to the indexed component
    comps{starts(i)+1} = add_identity_row_column(comps{starts(i)+1}); % Add a identity row and column to the next indexed component
    mats2{starts(i)} = add_identity_row_column(mats2{starts(i)}); % Add a identity row and column to the indexed codomain map
    if(starts(i)>1)
      mats2{starts(i)-1} = add_zero_row(mats2{starts(i)-1}); % Add a zero row to the prevoious indexed codomain map
    end
    mats2{starts(i)+1} = add_zero_column(mats2{starts(i)+1}); % Add a zero column to the next indexed codomain map
  elseif( types(i) == 10 )
    mats1{starts(i)} = add_zero_row(mats1{starts(i)}); % Add a zero row to the indexed domain map
    mats1{starts(i)+1} = add_identity_row_column(mats1{starts(i)+1}); % Add an identity row and column to the next indexed domain map
    mats1{starts(i)+2} = add_zero_column(mats1{starts(i)+2}); % Add a zero column to the next^2 indexed domain map
    comps{starts(i)} = add_zero_row(comps{starts(i)}); % Add a zero row to the indexed component map
    comps{starts(i)+1} = add_identity_row_column(comps{starts(i)+1}); % Add an identity row and column to the next indexed component map
    comps{starts(i)+2} = add_zero_column(comps{starts(i)+2}); % Add m zero column to the next^2 indexed component map
    if(starts(i)>1)
      mats2{starts(i)-1} = add_zero_row(mats2{starts(i)-1}); % Add a zero row to the previous indexed codomain map
    end
    mats2{starts(i)} = add_identity_row_column(mats2{starts(i)}); % Add an identity row and column to the indexed codomain map
    mats2{starts(i)+1} = add_zero_column(mats2{starts(i)+1}); % Add a zero column to the next indexed codomain map
  else
    error('Invalid type of indecomposable requested');
  end
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
  
function matout=add_identity_row_column(matin)
  matout=matin;
  matout(end+1,end+1)=1;
