% get list of images: filepath + group (class label)
function [filePaths,groups] = getImageList(folder)

    filePaths=cell(1);
    groups=cell(1);
    imgCtr=0;
    
    subDirs=dir(folder);
    for n=1:length(subDirs)
        currDir=subDirs(n);
        if(currDir.isdir==1 && ~strcmp(currDir.name,'.') && ~strcmp(currDir.name,'..'))
            currPath=strcat(folder,'/',currDir.name);
            fileList=dir(currPath);
            for m=1:length(fileList)
                currFile=fileList(m);
                if(currFile.isdir==0)
                    currFilePath=strcat(currPath,'/',currFile.name);;
                    
                    imgCtr=imgCtr+1;
                    filePaths{imgCtr}=currFilePath;
                    groups{imgCtr}=currDir.name;
                end
            end
        end
    end
end