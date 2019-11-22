% Very simple chain map unit test script.  Basically tests to verify that everything commutes

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

startlength=5;

for idx1=1:startlength,
  for type1=1:10,
    [mats1, mats2, comps]=chain_map_generator([idx1],[type1]);
    if( ~is_sequence_map(mats1,mats2,comps))
      disp([num2str(idx1) ' : ' num2str(type1)])
    end
    for idx2=1:startlength,
      for type2=1:10,
        [mats1, mats2, comps]=chain_map_generator([idx1 idx2],[type1 type2]);
        if( ~is_sequence_map(mats1,mats2,comps))
          disp([num2str([idx1 idx2]) ' : ' num2str([type1 type2])])
        end
%        for idx3=1:startlength,
%          for type3=1:10,
%            [mats1, mats2, comps]=chain_map_generator([idx1;idx2;idx3],[type1;type2;type3]);
%            if( ~is_sequence_map(mats1,mats2,comps))
%              disp([num2str([idx1 idx2 idx3]) ' : ' num2str([type1 type2 type3])])
%            end
%          end
%        end
      end
    end
  end
end
