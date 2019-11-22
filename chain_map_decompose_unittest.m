function [mats1,mats2,comps,starts,types,starts_,types_]=chain_map_decompose_unittest(iterations)
% Unit test for chain_map_generator and chain_map_decompose; they should be inverses!
%
% Input: iterations = number of iterations to perform (default = 1)
% Output: mats1,mats2 = list of matrices in each chain complex (domain = mats1, 
%                                                              codomain = mats2)
%         comps       = list of component maps for the chain map
%         starts      = list of starting indices for each bar chain map
%         types       = list of types for each bar chain map
%         starts_, types_ = the same, but produced by chain_map_decompose
%
% This function will 
% (1) Use chain_map_generator to make a random chain map
% (2) Check that the chain map is a sequence map
% (3) Decompose the chain map using chain_map_decompose
% (4) Verify that chain_map_decompose and chain_map_generator agree
%
% If any errors are found in the above, the return values are for the 
% problematic chain map.  Otherwise, they are simply the last one computed.

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
		    
if ~exist('iterations','var')
  iterations=1;
end

if exist('OCTAVE_VERSION','builtin'),
    w1=warning('query','Octave:nearly-singular-matrix');
    w2=warning('query','Octave:singular-matrix');
    w3=warning('query','Octave:divide-by-zero');
    
    warning('off','Octave:nearly-singular-matrix','local');
    warning('off','Octave:singular-matrix','local');
    warning('off','Octave:divide-by-zero','local');
end

for i=1:iterations,
  indecs=floor(rand*8)+1;
  starts=floor(rand(indecs,1)*4)+1;
  types=floor(rand(indecs,1)*9)+2;  % Prohibit type 1 -- empty bars
  [mats1,mats2,comps]=chain_map_generator_scramble(starts,types);
  
  if ~is_sequence_map(mats1,mats2,comps),
    if exist('OCTAVE_VERSION','builtin'),
        warning(w1.state,'Octave:nearly-singular-matrix');
        warning(w2.state,'Octave:singular-matrix');
        warning(w3.state,'Octave:divide-by-zero');
    end

    disp('chain_map_generator generated malformed sequence map!')
    return
  end
  
  [starts_,types_]=chain_map_decompose(mats1,mats2,comps);
  
  inputs=sortrows([starts(:) types(:)]);
  outputs=sortrows([starts_(:) types_(:)]);
  
  if(any(inputs(:) ~= outputs(:))),
    if exist('OCTAVE_VERSION','builtin'),
      warning(w1.state,'Octave:nearly-singular-matrix');
      warning(w2.state,'Octave:singular-matrix');
      warning(w3.state,'Octave:divide-by-zero');
    end

    disp('chain_map_decompose and chain_map_generator disagree!')
    return
  end
end

if iterations > 1,
  disp(['Tests passed: ' num2str(iterations)]);
end

if exist('OCTAVE_VERSION','builtin'),
  warning(w1.state,'Octave:nearly-singular-matrix');
  warning(w2.state,'Octave:singular-matrix');
  warning(w3.state,'Octave:divide-by-zero');
end
