%Setup third party Matlab libraries.
%
%   GRASP_INIT_3RD_PARTY() downloads and install in this directory third
%   party Matlab libraries.
%
% Authors:
%  - Benjamin Girault <benjamin.girault@ens-lyon.fr>

% Copyright Benjamin Girault, École Normale Supérieure de Lyon, FRANCE /
% Inria, FRANCE (2015-11-01)
% 
% benjamin.girault@ens-lyon.fr
% 
% This software is a computer program whose purpose is to provide a Matlab
% / Octave toolbox for handling and displaying graph signals.
% 
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software.  You can  use, 
% modify and/ or redistribute the software under the terms of the CeCILL
% license as circulated by CEA, CNRS and INRIA at the following URL
% "http://www.cecill.info". 
% 
% As a counterpart to the access to the source code and  rights to copy,
% modify and redistribute granted by the license, users are provided only
% with a limited warranty  and the software's author,  the holder of the
% economic rights,  and the successive licensors  have only  limited
% liability. 
% 
% In this respect, the user's attention is drawn to the risks associated
% with loading,  using,  modifying and/or developing or reproducing the
% software by the user in light of its specific status of free software,
% that may mean  that it is complicated to manipulate,  and  that  also
% therefore means  that it is reserved for developers  and  experienced
% professionals having in-depth computer knowledge. Users are therefore
% encouraged to load and test the software's suitability as regards their
% requirements in conditions enabling the security of their systems and/or 
% data to be ensured and,  more generally, to use and operate it in the 
% same conditions as regards security. 
% 
% The fact that you are presently reading this means that you have had
% knowledge of the CeCILL license and that you accept its terms.

function grasp_init_3rd_party
    %% List
    softwares = grasp_dependencies_list;
    
    %% Matlab version
    package_save = @(url, file) urlwrite(url, file);
    matlab_ver = ver('Matlab');
    if numel(matlab_ver) > 1 && str2double(matlab_ver.Version) >= 8.4
        package_save = @(url, file) websave(file, url);
    end

    %% Subaxis
    pwd = [fileparts(mfilename('fullpath')), filesep];
    for soft_id = 1:numel(softwares)
        soft = softwares(soft_id);
        dir = [pwd, soft.name];
        package_save(soft.url, 'tmp.zip');
        mkdir(pwd, soft.name);
        unzip('tmp.zip', dir);
        delete('tmp.zip');
        if numel(soft.patches) ~= 0
            addpath('MyPatcher/');
            for i = 1:2:numel(soft.patches)
                mypatcher(soft.patches{1}, soft.patches{2}, soft.patches{1});
            end
            rmpath('MyPatcher/');
        end
        if numel(soft.init_script) ~= 0
            path = [fileparts(mfilename('fullpath')), filesep, soft.name, soft.root_dir];
            addpath(path);
            init = str2func(soft.init_script);
            init();
            rmpath(path);
        end
    end
end