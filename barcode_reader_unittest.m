% Script to generate a random barcode with arbitrary, but easy to work with
% matrices.  Matrices are not guaranteed to be really anything beyond that.
% Make sure to sanity check the output!

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

% Desired barcode
bars=sortrows(sort(round(rand(5,2)*4),2)); 
bars=bars-min(bars(:))+1, 

% Construct sequence
mats=barcode_generator_scramble(bars), 

% Verify barcode using quick method
if( any(barcode_reader(mats)(:)-bars(:)) )
  disp('barcode_reader Failed to recover barcode');
  disp(barcode_reader(mats));
end

% Verify using another method that finds isomorphism (generators)
[bars_check,generators,mats1,mats2,comps]=barcode_decompose(mats);
if( any(sortrows(bars_check)(:)-bars(:)) )
  disp('barcode_decompose: Failed to recover barcode');
  disp(bars_check);
end

if ~is_sequence_map(mats1,mats2,comps),
  disp('barcode_decompose produced a non-sequence map');
end

for i=1:length(comps),
  if size(comps{i},1) ~= size(comps{i},2),
    disp('barcode_decompose produced a non-square component');
  end
  if cond(comps{i}) > 1e6,
      disp('barcode_decompose produced a likely-singular component');
      disp(['i = ' num2str(i)])
      disp(comps{i})
  end
end

