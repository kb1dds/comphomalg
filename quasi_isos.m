% Generate a sequence pair that is quasi-isomorphic and one that isn't

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

homology_bars1=floor(4*rand(floor(rand*4)+1,1))+1; 
homology_bars1=[homology_bars1, homology_bars1];

homology_bars2=floor(4*rand(floor(rand*4)+1,1))+1; 
homology_bars2=[homology_bars2, homology_bars2];

exact_bars1=floor(4*rand(floor(rand*4)+1,1))+1; 
exact_bars1=[exact_bars1, exact_bars1+1];

exact_bars2=floor(4*rand(floor(rand*4)+1,1))+1; 
exact_bars2=[exact_bars2, exact_bars2+1];

disp('-----Start A------')
barsA=[exact_bars1; homology_bars1]
matsA=barcode_generator_scramble(barsA)
render_sequence(matsA)
disp('-----End A------')

disp('-----Start B: A qi B------')
barsB=[exact_bars2; homology_bars1]
matsB=barcode_generator_scramble(barsB)
render_sequence(matsB)
disp('-----End B ------')

disp('-----Start C: A nqi C------')
barsC=[exact_bars1; homology_bars2]
matsC=barcode_generator_scramble(barsC)
render_sequence(matsC)
disp('-----End C------')
