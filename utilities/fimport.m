function [ tStruct ] = fimport( folderStr )
    prefix = pwd;
    % folderStr = 'Logan';
    % folderStr = 'Jamie';


    fInfo = dir(folderStr);
    names = squeeze({fInfo(:).name}');

    stack = [];
    for a = 1:length(fInfo)
        if strcmp(fInfo(a).name,'.') || strcmp(fInfo(a).name,'..')
            %don't add it
        else
            if (strcmp(fInfo(a).name(1:2),'._')) || (fInfo(a).isdir == 0)
                %don't add it
            else
            stack = [stack fInfo(a)];        
            end

        end

    end

    fInfo = stack;

    for i = 1:length(fInfo)
        % adsf
            if(fInfo(i).isdir) == 1
                subFolder = [folderStr filesep fInfo(i).name];
                subdirinfo = dir(subFolder);
                sdisdir = [subdirinfo.isdir];
                subdirinfo = subdirinfo(~sdisdir);
    %             begDot = cellfun(@(s) find(s(1)~='.'),{subdirinfo.name},'UniformOutput',0);
    %             begDot2 = cellfun(@(s) s(s=='')='0',begDot,'UniformOutput',0);
    %             subdirinfo = subdirinfo(begDot);
                fInfo(i).subdirinfo = subdirinfo;
            end
    end
    fNames = {};
    for i = 1:length(fInfo)
        i
        len = length(fInfo(i).subdirinfo);
        fprintf('J length: %g\n',len);
        for j = 1:len
            fNames
            tName = fInfo(i).subdirinfo(j).name;
            if tName(1) ~= '.'
                % skip the temp files
                curName = [prefix filesep folderStr filesep fInfo(i).name filesep tName];
                fNames{end+1} = {curName};
            end


    %         fNames(end+1) = curName;
        end
    end
    fNames = fNames';
    % ok, got the nanmes together, need to cat the dirnames with names inside.
    %will be able to cat everything together after that.
    vn = fNames;
    % vnames = relthin;
    tStruct = struct([]); %initialize an empty  struct

    % for i = 1:length(vnames)
    %     temp = vnames{i};
    %     temp = temp(3:end); %trim ./ from front
    %     temp = temp(1:end-4); % trim the .csv from the end
    %     slashidx = find(temp=='/');
    %     temp(slashidx) = '_';
    %     dashidx = find(temp=='-');
    %     temp(dashidx) = '_';
    %     temp = ['LD_' temp];
    %     vn{i} = temp;
    % end
    % vn = vn'; %return to original format
    % cd Logan
    for j = 1:length(vn)
        fprintf('Count: %g\n',j);
        fprintf('Importing: %s\n',cell2mat(vn{j}));

        [~,~,ext] = fileparts(cell2mat(vn{j}));
        if strcmp(ext,'.CSV')
            tmpTable = flysightimportTbl(cell2mat(vn{j})); %assign the table of data
        %     tStruct(j).data = 
            tStruct(j).name = vn{j}; % give it a name
            tStruct(j).time = tmpTable.time;
            tStruct(j).lat =  tmpTable.lat;
            tStruct(j).lon =  tmpTable.lon;
            tStruct(j).hMSL =  tmpTable.hMSL;
            tStruct(j).velN =  tmpTable.velN;
            tStruct(j).velE =  tmpTable.velE;
            tStruct(j).velD =  tmpTable.velD;
            tStruct(j).hAcc =  tmpTable.hAcc;
            tStruct(j).vAcc =  tmpTable.vAcc;
            tStruct(j).sAcc =  tmpTable.sAcc;
            tStruct(j).gpsFix =  tmpTable.gpsFix;
            tStruct(j).numSV =  tmpTable.numSV;
            tStruct(j).maxAlt = max(tmpTable.hMSL);
        end
    
end