% get list of images in a given folder
function [filePaths,groupNames,groupIdx,namesClasses,numClasses] = getImageList(folder)

    filePaths=cell(1);
    groups=cell(1);
    namesClasses=cell(1);
    imgCtr=0;
    groupCtr=0;
    
    subDirs=dir(folder);
    for n=1:length(subDirs)
        currDir=subDirs(n);
        if(currDir.isdir==1 && ~strcmp(currDir.name,'.') && ~strcmp(currDir.name,'..'))
            groupCtr=groupCtr+1;
            namesClasses{groupCtr}=currDir.name;
            currPath=strcat(folder,'/',currDir.name);
            fileList=dir(currPath);
            for m=1:length(fileList)
                currFile=fileList(m);
                if(currFile.isdir==0)
                    currFilePath=strcat(currPath,'/',currFile.name);;
                    
                    imgCtr=imgCtr+1;
                    filePaths{imgCtr}=currFilePath;
                    groupNames{imgCtr}=currDir.name;
                    groupIdx(imgCtr)=groupCtr;
                end
            end
        end
    end
    
    numClasses=groupCtr;
end