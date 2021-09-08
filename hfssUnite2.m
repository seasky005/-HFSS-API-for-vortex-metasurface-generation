% ----------------------------------------------------------------------------
% function hfssUnite(fid, varargin)
% 
% Description :
% -------------
% Creates the VB Script necessary for unite a given set of objects already
% present in the HFSS 3D Modeler.
%
% Parameters :
% ------------
% fid      - file identifier of the HFSS script file.
% varargin - names of the objects that need to be united. It can be specified
%            either as a single cell array of strings, or several individual
%            cell strings containing a single object name (see example ...)
% 
% Note :
% ------
%
% Example :
% ---------
% fid = fopen('myantenna.vbs', 'wt');
% ... 
% % Method 1.
% hfssUnite(fid, {'Object1', 'Object2', Object3'});
% % ... or Method 2.
% hfssUnite(fid, {'Object1'}, {'Object2'}, {'Object3'});
%
% ----------------------------------------------------------------------------

% ----------------------------------------------------------------------------
% This file is part of HFSS-MATLAB-API.
%
% HFSS-MATLAB-API is free software; you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the Free 
% Software Foundation; either version 2 of the License, or (at your option) 
% any later version.
%
% HFSS-MATLAB-API is distributed in the hope that it will be useful, but 
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
% or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License 
% for more details.
%
% You should have received a copy of the GNU General Public License along with
% Foobar; if not, write to the Free Software Foundation, Inc., 59 Temple 
% Place, Suite 330, Boston, MA  02111-1307  USA
%
% Copyright 2004, Vijay Ramasami (rvc@ku.edu)
% ----------------------------------------------------------------------------

function hfssUnite2(fid, n,name)

% Preamble.
fprintf(fid, '\n');
fprintf(fid, 'oEditor.Unite  _\n');
fprintf(fid, 'Array("NAME:Selections", _\n');
fprintf(fid, '"Selections:=", _\n');
fprintf(fid,'"');
for i=1:n-1
    fprintf(fid,strcat(name,num2str(i),','));
end
fprintf(fid,strcat(name,num2str(n),'"), _\n'));
fprintf(fid, 'Array("NAME:UniteParameters", "KeepOriginals:=", false)\n');

