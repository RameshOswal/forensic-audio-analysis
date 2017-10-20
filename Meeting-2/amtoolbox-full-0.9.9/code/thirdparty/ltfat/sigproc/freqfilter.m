function gout=freqfilter(winname,bw,varargin)
%FREQFILTER Construct filter in frequency domain
%   Usage:   g=freqfilter(winname,bw);
%            g=freqfilter(winname,bw,fc);
%
%   Input parameters:
%      winname  : Name of prototype
%      bw       : Effective support length of the prototype
%      fc       : Center frequency
%   
%   FREQFILTER(winname,bw) creates a full-length frequency response
%   filter. The parameter winname specifies the shape of the frequency
%   response. For accepted shape please see FREQWIN. bw defines a
%   -6dB bandwidth of the filter in normalized frequencies.
%   
%   FREQFILTER(winname,bw,fc) constructs a filter with a centre
%   frequency of fc measured in normalized frequencies.
%
%   If one of the inputs is a vector, the output will be a cell array
%   with one entry in the cell array for each element in the vector. If
%   more input are vectors, they must have the same size and shape and the
%   the filters will be generated by stepping through the vectors. This
%   is a quick way to create filters for FILTERBANK and UFILTERBANK.
%   
%   FREQFILTER accepts the following optional parameters:
%
%     'fs',fs     If the sampling frequency fs is specified then the 
%                 bandwidth bw and the centre frequency fc are 
%                 specified in Hz.
%
%     'complex'   Make the filter complex valued if the centre frequency
%                 is non-zero. This is the default.
%
%     'real'      Make the filter real-valued if the centre frequency
%                 is non-zero.
%
%     'delay',d   Set the delay of the filter. Default value is zero.
%
%     'scal',s    Scale the filter by the constant s. This can be
%                 useful to equalize channels in a filter bank.
%
%     'pedantic'  Force window frequency offset (g.foff) to a subsample 
%                 precision by a subsample shift of the window.
%
%
%   Url: http://ltfat.github.io/doc/sigproc/freqfilter.html

% Copyright (C) 2005-2016 Peter L. Soendergaard <peter@sonderport.dk>.
% This file is part of LTFAT version 2.2.0
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% Authors: Nicki Holighaus & Zdenek Prusa
% Date: September 15, 2016 

if ~iscell(winname), winname = {winname}; end

% Define initial value for flags and key/value pairs.
definput.import={'normalize'};
definput.importdefaults={'energy'};
definput.keyvals.delay=0;
definput.keyvals.fc=0;
definput.keyvals.fs=2;
%definput.keyvals.order=4;
definput.keyvals.scal=1;
definput.keyvals.min_win=1;
%definput.keyvals.trunc_at=10^(-5);
definput.keyvals.bwtruncmul = 4;
definput.flags.pedantic = {'pedantic','nopedantic'};
definput.flags.real={'complex','real'};

[flags,kv]=ltfatarghelper({'fc'},definput,varargin);

[bw,kv.fc,kv.delay,kv.scal]=scalardistribute(bw,kv.fc,kv.delay,kv.scal);

% Sanitize
kv.fc=modcent(2*kv.fc/kv.fs,2);

Lw = @(L,bw) min(ceil(bw*kv.bwtruncmul*L/kv.fs),L);
    
fsRestricted = @(L,bw) kv.fs/L*Lw(L,bw);
if flags.pedantic
    fc_offset = @(L,fc) L/2*fc-round(L/2*fc);
else
    fc_offset = @(L,fc) 0;
end

Nfilt = numel(bw);
gout = cell(Nfilt,1);
for ii=1:Nfilt
    g=struct();
    
    if flags.do_1 || flags.do_area 
        g.H=@(L)    fftshift(freqwin(winname,Lw(L,bw(ii)),bw(ii),fsRestricted(L,bw(ii)),'shift',fc_offset(L,kv.fc(ii))))*kv.scal(ii)*L;                
    end;
    
    if  flags.do_2 || flags.do_energy
        g.H=@(L)    fftshift(freqwin(winname,Lw(L,bw(ii)),bw(ii),fsRestricted(L,bw(ii)),'shift',fc_offset(L,kv.fc(ii))))*kv.scal(ii)*sqrt(L);                        
    end;
        
    if flags.do_inf || flags.do_peak
        g.H=@(L)    fftshift(freqwin(winname,Lw(L,bw(ii)),bw(ii),fsRestricted(L,bw(ii)),'shift',fc_offset(L,kv.fc(ii))))*kv.scal(ii);           
    end;
    
    g.foff=@(L) round(L/2*kv.fc(ii)) - floor(Lw(L,bw(ii))/2);                    
                    
    g.realonly=flags.do_real;
    g.delay=kv.delay(ii);
    g.fs=kv.fs;
    gout{ii}=g;
end;

if Nfilt==1
    gout=g;
end;

