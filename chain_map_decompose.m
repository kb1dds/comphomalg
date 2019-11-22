function [starts,types]=chain_map_decompose(mats1,mats2,comps)
% Decompose a chain map into a collection of indecomposable bar chain maps
%
% Input: mats1,mats2 = list of matrices in each chain complex (domain = mats1, 
%                                                              codomain = mats2)
%        comps       = list of component maps for the chain map
% Output: starts = list of starting indices for each bar chain map
%         types  = list of types for each bar chain map.  (See README.md)
%
% Note: this is the inverse of chain_map_generator
% Note: If this function is given a sequence map that is not a chain map, it 
%       will produce an error unless all bars that are too long are in the 
%       codomain

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
  
% Debugging output
debugging=0;

% Tolerance for zero vectors
tol=1e-5;

% Copy chain map to variables that we'll overwrite as we decompose
mats1p=mats1;
mats2p=mats2;
compsp=comps;

% Decompose everything in the domain (which might lead into the codomain)
while(1),
  % Is there anything to decompose in the domain?
  done=1;
  for i=1:length(mats1p),
    if size(mats1p{i},2)>0,
      done=0;
      break;
    end
  end
  if size(mats1p{end},1) > 0, % Don't forget the last space!
    done = 0;
  end
  if done,
    break; % Nothing left in the domain.  Might be something left in the codomain
  end
    
  % Select a nontrivial vector from the space at this index
  % Prefer an element of the kernel, if there is a nontrivial kernel
  ker1p = kernel(mats1p{i},tol);
  gen=[];
  if size(ker1p,2) > 0,
    gen = ker1p(:,1);
  elseif (i > 1) && size(mats2p{i-1},2) > 0  && all(isfinite(compsp{i}\mats2p{i-1})),
    preimage=compsp{i}\mats2p{i-1};
    gen=preimage(:,1);
  end
  if isempty(gen) || norm(gen) < tol || norm(gen) > 1/tol,
    % Failing all else, without loss of generality it can be [1; 0; ... ; 0]
    gen=zeros(size(mats1p{i},2),1);
    gen(1)=1;
  end
  codbar=compsp{i}*gen;
  
  if debugging,
    disp('--------- New iteration ---------')
    i
    mats1p
    mats2p
    compsp
    gen
    codbar
  end
  
  % Trace the image of this vector through the domain chain complex
  barlen=1;
  genp = gen;
  for j=i:length(mats1p),
    if norm(mats1p{j}*genp) > tol,
      barlen = barlen + 1;
      genp=mats1p{j}*genp;
    else
      break
    end
  end
  if barlen > 2,
    error('Domain not a chain complex');
  end
  
  % (1) Trace image of this bar from the domain chain complex into the codomain,
  % (2) Classify the bar chain map, and 
  % (3) Remove the bar chain map from the overall chain map via induced maps.
  %     NB: Some of these quotients interact with one another, so the order in 
  %     which they are performed is significant!
  if barlen == 1,
    if norm(compsp{i}*gen) < tol,
      starts(end+1)=i;
      types(end+1)=4;
      
      compsp{i}=induced_map(gen,[],compsp{i});
      
      if( i > 1 ),
        mats1p{i-1}=induced_map([],gen,mats1p{i-1});
      end
      mats1p{i}=induced_map(gen,[],mats1p{i});
    else
      if (i == 1) || ~isfinite(mats2p{i-1}*(mats2p{i-1}\codbar)) || (norm(mats2p{i-1}*(mats2p{i-1}\codbar)-codbar) > tol), % Note: may produce a harmless warning
        starts(end+1)=i;
        types(end+1)=5;
        
        compsp{i}=induced_map(gen,compsp{i}*gen,compsp{i});
        
        if( i > 1 ),
          mats1p{i-1}=induced_map([],gen,mats1p{i-1});
        end
        mats1p{i}=induced_map(gen,[],mats1p{i});
        
        if( i > 1 ),
          mats2p{i-1}=induced_map([],codbar,mats2p{i-1});
        end
        mats2p{i}=induced_map(codbar,[],mats2p{i});
      else
        starts(end+1)=i-1;
        types(end+1)=6;
        
        if( i > 1 ),
          compsp{i-1}=induced_map([],mats2p{i-1}\codbar,compsp{i-1});
        end
        compsp{i}=induced_map(gen,compsp{i}*gen,compsp{i});
        
        if( i > 1 ),
          mats1p{i-1}=induced_map([],gen,mats1p{i-1});
        end
        mats1p{i}=induced_map(gen,[],mats1p{i});
        
        if( i > 2 ),
          mats2p{i-2}=induced_map([],mats2p{i-1}\codbar,mats2p{i-2});
        end
        if( i > 1 ),
          mats2p{i-1}=induced_map(mats2p{i-1}\codbar,codbar,mats2p{i-1});
        end
        mats2p{i}=induced_map(codbar,[],mats2p{i});  
      end
    end
  elseif barlen == 2,
    if (norm(compsp{i}*gen) < tol) && (norm(compsp{i+1}*mats1p{i}*gen) < tol),
      starts(end+1)=i;
      types(end+1)=7;
      
      compsp{i}=induced_map(gen,[],compsp{i});
      if( i < length(compsp) ),
        compsp{i+1}=induced_map(mats1p{i}*gen,[],compsp{i+1});
      end
      
      if( i > 1 ),
        mats1p{i-1}=induced_map([],gen,mats1p{i-1});
      end
      if( i < length(mats1p) ),
        mats1p{i+1}=induced_map(mats1p{i}*gen,[],mats1p{i+1});
      end
      mats1p{i}=induced_map(gen,mats1p{i}*gen,mats1p{i});
    elseif (norm(compsp{i}*gen) > tol) && (norm(compsp{i+1}*mats1p{i}*gen) > tol),
      starts(end+1)=i;
      types(end+1)=9;
      
      compsp{i}=induced_map(gen,codbar,compsp{i});
      if( i < length(compsp) ),
        compsp{i+1}=induced_map(mats1p{i}*gen,compsp{i+1}*mats1p{i}*gen,compsp{i+1});
      end
      
      if( i > 1 ),
        mats1p{i-1}=induced_map([],gen,mats1p{i-1});
      end
      if( i < length(mats1p) ),
        mats1p{i+1}=induced_map(mats1p{i}*gen,[],mats1p{i+1});
      end
      mats1p{i}=induced_map(gen,mats1p{i}*gen,mats1p{i});
      
      if( i > 1 ),
        mats2p{i-1}=induced_map([],codbar,mats2p{i-1});
      end
      if( i < length(mats2p) ),
        mats2p{i+1}=induced_map(mats2p{i}*codbar,[],mats2p{i+1});
      end
      mats2p{i}=induced_map(codbar,mats2p{i}*codbar,mats2p{i});
    elseif (norm(compsp{i}*gen) > tol) && (norm(compsp{i+1}*mats1p{i}*gen) < tol),
      if (i == 1) || ~isfinite(mats2p{i-1}*(mats2p{i-1}\codbar)) || (norm(mats2p{i-1}*(mats2p{i-1}\codbar)-codbar) > tol), % Note: may produce a harmless warning
        starts(end+1)=i;
        types(end+1)=8;
        
        compsp{i}=induced_map(gen,codbar,compsp{i});
        compsp{i+1}=induced_map(mats1p{i}*gen,[],compsp{i+1});
        
        if( i > 1 ),
          mats1p{i-1}=induced_map([],gen,mats1p{i-1});
        end
        if( i < length(mats1p) ),
          mats1p{i+1}=induced_map(mats1p{i}*gen,[],mats1p{i+1});
        end
        mats1p{i}=induced_map(gen,mats1p{i}*gen,mats1p{i});
        
        if( i > 1 ),
          mats2p{i-1}=induced_map([],codbar,mats2p{i-1});
        end
        mats2p{i}=induced_map(codbar,[],mats2p{i});
      else
        starts(end+1)=i-1;
        types(end+1)=10;
        
        if( i > 1 ),
          compsp{i-1}=induced_map([],mats2p{i-1}\codbar,compsp{i-1});
        end
        compsp{i}=induced_map(gen,codbar,compsp{i});
        if( i < length(compsp) ),
          compsp{i+1}=induced_map(mats1p{i}*gen,[],compsp{i+1});
        end
        
        if( i > 1 ),
          mats1p{i-1}=induced_map([],gen,mats1p{i-1});
        end
        if( i < length(mats1p) ),
          mats1p{i+1}=induced_map(mats1p{i}*gen,[],mats1p{i+1});
        end
        mats1p{i}=induced_map(gen,mats1p{i}*gen,mats1p{i});
        
        if( i > 2 ),
          mats2p{i-2}=induced_map([],mats2p{i-1}\codbar,mats2p{i-2});
        end
        if( i > 1 ),
          mats2p{i-1}=induced_map(mats2p{i-1}\codbar,codbar,mats2p{i-1});
        end
        mats2p{i}=induced_map(codbar,[],mats2p{i}); 
      end
    end
  else
    error('Could not identify indecomposable type');
  end
  
  if debugging,
    disp(['--> Found type ' num2str(types(end)) ' indecomposable at index ' num2str(starts(end))]);
  end
end

if debugging,
  mats2p
end

% Compure barcode of whatever is left in the codomain chain complex
codomain_bars=barcode_reader(mats2p,tol);

if debugging,
  codomain_bars
end

% Translate the codomain bars into the correct types
for i=1:size(codomain_bars,1),
  if codomain_bars(i,2)-codomain_bars(i,1) == 0, % Length 1 bar
    starts(end+1)=codomain_bars(i,1);
    types(end+1)=2;
  elseif codomain_bars(i,2)-codomain_bars(i,1) == 1, % Length 2 bar
    starts(end+1)=codomain_bars(i,1);
    types(end+1)=3;
  else
    warning(['Codomain not a chain complex.  Ignoring length ' num2str(codomain_bars(i,2)-codomain_bars(i,1)+1) ' bar']);
  end
end
