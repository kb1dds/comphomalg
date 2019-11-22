function bars=bar_chain_map_to_bar(starts,types,codomainflg)
% Translate bar chain map types into bars
%
% Input: starts      = list of starting indices for each indecomposable
%        types       = list of types for each indecomposable 
%        codomainflg = (0 = translate domain chain complex, 1 = translate codomain)
% Output: bars = nx2 array of bar starts/ends (integers)

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

bars=zeros(0,2);
for i=1:length(starts),
  % Type = 1 is trivial
  if codomainflg == 0, % Translte domain
   if types(i) == 4,
     bars=[bars; starts(i) starts(i)];
   elseif types(i) == 5,
     bars=[bars; starts(i) starts(i)];
   elseif types(i) == 6,
     bars=[bars; starts(i)+1 starts(i)+1];
   elseif types(i) == 7,
     bars=[bars; starts(i) starts(i)+1];
   elseif types(i) == 8,
     bars=[bars; starts(i) starts(i)+1];
   elseif types(i) == 9,
     bars=[bars; starts(i) starts(i)+1];
   elseif types(i) == 10,
     bars=[bars; starts(i)+1 starts(i)+2];
    end
  else % Translate codomain
    if types(i) == 2,
     bars=[bars; starts(i) starts(i)];
   elseif types(i) == 3,
     bars=[bars; starts(i) starts(i)+1]; 
   elseif types(i) == 5,
     bars=[bars; starts(i) starts(i)];
   elseif types(i) == 6,
     bars=[bars; starts(i) starts(i)+1];
   elseif types(i) == 8,
     bars=[bars; starts(i) starts(i)];
   elseif types(i) == 9,
     bars=[bars; starts(i) starts(i)+1];
   elseif types(i) == 10,
     bars=[bars; starts(i) starts(i)+1];
    end
  end
end
