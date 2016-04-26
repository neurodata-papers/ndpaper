%% load data

clearvars, clc
filename = 'output.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
cx = dataArray{:, 1};
cy = dataArray{:, 2};
cz = dataArray{:, 3};
unmasked = dataArray{:, 4};
synapses = dataArray{:, 5};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% look at distributino of # synapses / unmasked volume

room=find(unmasked>0);

h=figure(1); clf
ratio = synapses./unmasked;
[nelements,centers]=hist(ratio,100);
plot(centers,nelements/sum(nelements),'k','linewidth',2), grid on
title('histogram of synapses/unmasked region')
xlabel('ratio')

F.fname='hist';
F.PaperSize=[3 2]*1.5;
F.PaperPosition=[0 0 F.PaperSize]; 
set(h,'PaperSize',F.PaperSize,'PaperPosition',F.PaperPosition,'color','w');
saveas(h,F.fname,'fig')
print(h,F.fname,'-dpdf')
print(h,F.fname,'-dpng','-r300')



%% let's look at 3D centers

bigones=find(ratio>centers(end-50));
h=figure(2); cla, hold on
for i=1:length(bigones)
plot3(cx(bigones(i)),cy(bigones(i)),cz(bigones(i)),'.','markersize',(round(ratio(bigones(i))*10000)-16)*3)
end
grid on
%%
xlabel('x')
ylabel('y')
zlabel('z')
view([-0.5, 0.5, 0.5])
F.fname='3D';
F.PaperSize=[3 2]*4;
F.PaperPosition=[0 0 F.PaperSize]; 
set(h,'PaperSize',F.PaperSize,'PaperPosition',F.PaperPosition,'color','w');
saveas(h,F.fname,'fig')
print(h,F.fname,'-dpdf')
print(h,F.fname,'-dpng','-r300')


%% lets look at 2D projections
h=figure(3);
ucx=unique(cx);
xind=ucx(1):39:ucx(end);

ucy=unique(cy);
yind=ucy(1):39:ucy(end);

ucz=unique(cz);
zind=ucz(1):111:ucz(end);

%%
xysum=nan(length(xind),length(yind));
ii=0; 
for i=xind
    ii=ii+1; jj=0;
    for j=yind
        jj=jj+1;
        xyid=find(cx==i & cy==j);
        xysum(ii,jj)=nansum(ratio(xyid));
    end
end
subplot(131), imagesc(xysum), title('xy project'), colorbar


%%
xzsum=nan(length(xind),length(zind));
ii=0; 
for i=xind
    ii=ii+1; jj=0;
    for j=zind
        jj=jj+1;
        xzid=find(cx==i & cz==j);
        xzsum(ii,jj)=nansum(ratio(xzid));
    end
end
subplot(132), imagesc(xzsum), title('xz project'), colorbar

%%
yzsum=nan(length(yind),length(zind));
ii=0; 
for i=yind
    ii=ii+1; jj=0;
    for j=zind
        jj=jj+1;
        yzid=find(cy==i & cz==j);
        yzsum(ii,jj)=nansum(ratio(yzid));
    end
end
subplot(133), imagesc(yzsum), title('yz project'), colorbar

%%
F.fname='2Dproj';
F.PaperSize=[6 2]*2;
F.PaperPosition=[0 0 F.PaperSize]; 
set(h,'PaperSize',F.PaperSize,'PaperPosition',F.PaperPosition,'color','w');
saveas(h,F.fname,'fig')
print(h,F.fname,'-dpdf')
print(h,F.fname,'-dpng','-r300')

