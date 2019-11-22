function [mats1s,mats2s,compss]=chain_map_generator_scramble(starts,types)
% Generate a chain map from a collection of bar chain maps
% in which the bases are scrambled randomly
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
		    
[mats1,mats2,comps]=chain_map_generator(starts,types);

% Scramble the barcodes
[mats1s,comps1]=barcode_scramble_mats(mats1);
[mats2s,comps2]=barcode_scramble_mats(mats2);

% Verify that we have sequence maps
if( ~is_sequence_map(mats1,mats1s,comps1) )
  disp('Domain not a sequence map')
end
if( ~is_sequence_map(mats2,mats2s,comps2) )
  disp('Codomain not a sequence map')
end

% Compose the chain map with the descrambling chain maps
compss={};
for i=1:length(comps),
  compss{i} = comps2{i}*comps{i}/comps1{i};
end

% Verify that the result decomposes correctly
[starts_,types_]=chain_map_decompose(mats1s,mats2s,compss);

inputs=sortrows([starts(:) types(:)]);
outputs=sortrows([starts_(:) types_(:)]);

if(any(size(inputs(:)) ~= size(outputs(:))) || any(inputs(:) ~= outputs(:))),
  comps1
  comps2
  inputs
  outputs
  disp('chain_map_decompose and chain_map_generator disagree!')
end
