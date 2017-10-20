function gp_save(file,data,header)
% GP_SAVE save x,y as a text file in a Gnuplot compatible format
%
%   Usage: gp_save(file,data,[header])
%
%   Input parameters:
%       file    - filename of the data file
%       data    - data matrix
%       header  - header comment added before the data
%
%   GP_SAVE(file,data,header) saves the values data in a text file in a
%   format useable by Gnuplot
%
%   See also: gp_save_matrix

%*****************************************************************************
% The MIT License (MIT)                                                      *
%                                                                            *
% Copyright (c) 2010-2017 SFS Toolbox Developers                             *
%                                                                            *
% Permission is hereby granted,  free of charge,  to any person  obtaining a *
% copy of this software and associated documentation files (the "Software"), *
% to deal in the Software without  restriction, including without limitation *
% the rights  to use, copy, modify, merge,  publish, distribute, sublicense, *
% and/or  sell copies of  the Software,  and to permit  persons to whom  the *
% Software is furnished to do so, subject to the following conditions:       *
%                                                                            *
% The above copyright notice and this permission notice shall be included in *
% all copies or substantial portions of the Software.                        *
%                                                                            *
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *
% IMPLIED, INCLUDING BUT  NOT LIMITED TO THE  WARRANTIES OF MERCHANTABILITY, *
% FITNESS  FOR A PARTICULAR  PURPOSE AND  NONINFRINGEMENT. IN NO EVENT SHALL *
% THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *
% LIABILITY, WHETHER  IN AN  ACTION OF CONTRACT, TORT  OR OTHERWISE, ARISING *
% FROM,  OUT OF  OR IN  CONNECTION  WITH THE  SOFTWARE OR  THE USE  OR OTHER *
% DEALINGS IN THE SOFTWARE.                                                  *
%                                                                            *
% The SFS Toolbox  allows to simulate and  investigate sound field synthesis *
% methods like wave field synthesis or higher order ambisonics.              *
%                                                                            *
% http://sfstoolbox.org                                 sfstoolbox@gmail.com *
%*****************************************************************************


%% ===== Checking of input  parameters ==================================
nargmin = 2;
nargmax = 3;
narginchk(nargmin,nargmax);
if nargin==nargmax-1
    header = '';
end
isargchar(file);
isargmatrix(data);
isargchar(header);


%% ===== Main ============================================================
% Write header to the file
fid = fopen(file,'w');
fprintf(fid,'# Data file generated by gp_save.m\n');
fprintf(fid,['# ',header,'\n']);
fclose(fid);
% Append the data to the file using tabulator as a delimiter between the data
if isoctave
    dlmwrite(file,data,'\t','-append');
else
    dlmwrite(file,data,'delimiter','\t','-append');
end
