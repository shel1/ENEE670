function [ outputData ] = fimport( folderStr )
    %FIMPORT Import flysight data into a structure
    %Example
    % out = fimport('flysightdata\Logan')
    
    prefix = pwd;
    % folderStr = 'Logan';
    % folderStr = 'Jamie';


    fInfo = dir(folderStr); % return the top level folder

    stack = [];
    for a = 1:length(fInfo)
        if strcmp(fInfo(a).name,'.') || strcmp(fInfo(a).name,'..')
            %don't add the entry if it's . or ..
        else
            if (strcmp(fInfo(a).name(1:2),'._')) || (fInfo(a).isdir == 0)
                %or if its a temp file, or is not a folder
            else
            stack = [stack fInfo(a)];        
            end

        end

    end
    
    %renaming, since fInfo came first
    fInfo = stack;

    for i = 1:length(fInfo)
            %for each of the entries in fInfo, add the subdirInfo to the
            %struct
            if(fInfo(i).isdir) == 1
                %build the subfolder path
                subFolder = [folderStr filesep fInfo(i).name];
                %get the dir info for that subfolder
                subdirinfo = dir(subFolder);
                %find the folders in the subfolder
                sdisdir = [subdirinfo.isdir];
                subdirinfo = subdirinfo(~sdisdir);
                fInfo(i).subdirinfo = subdirinfo;
            end
    end
    fNames = {};
    for i = 1:length(fInfo)
        len = length(fInfo(i).subdirinfo);
%         fprintf('J length: %g\n',len);
        for j = 1:len
            tName = fInfo(i).subdirinfo(j).name;
            if tName(1) ~= '.'
                % skip the temp files
                curName = [prefix filesep folderStr filesep fInfo(i).name filesep tName];
                fNames{end+1} = {curName};
            end
        end
    end
    fNames = fNames';
    % ok, got the nanmes together, need to cat the dirnames with names inside.
    %will be able to cat everything together after that.
    vn = fNames;%simple rename, vn came first
    outputData = struct([]); %initialize an empty  struct
    h=.2; % time step size
    for j = 1:length(vn)
        [~,~,ext] = fileparts(cell2mat(vn{j}));
        if strcmp(ext,'.CSV')
            tmpTable = flysightimportTbl(cell2mat(vn{j})); %assign the table of data
            outputData(j).name = vn{j};
            
            outputData(j).maxAlt = max(tmpTable.hMSL);
            outputData(j).meanhAcc = mean(tmpTable.hAcc);
            outputData(j).meanhScc = mean(tmpTable.sAcc);            
            tmpTable.time = datetime(tmpTable.time,'Format','uuuu-MM-dd''T''HH:mm:ss.SS''Z');

            %let the games begin
            locDerivative = [];
            [r,~] = size(tmpTable);
            for k = 1:r-1
                locDerivative(k) = geoDiff(tmpTable.lat(k),tmpTable.lon(k),tmpTable.hMSL(k),...
                    tmpTable.lat(k+1),tmpTable.lon(k+1),tmpTable.hMSL(k+1));
            end
            locDerivative(r) = 0; % makes the table happy
            tmpTable.locDerivative = locDerivative'/h;
            % don't care about XY here, just for exit finding
            tmpTable.velDownDerivative = [diff(tmpTable.velD)/.2; 0]; 
            outputData(j).jump = tmpTable;
        end
    end
end