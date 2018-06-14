function meg_atlas_ROIpatch_disp(atlas, savpath)
%
% Make an interactive figure of ROI surfaces (ROI patches) of the atlas
% pre-processed by meg_atlas_ROIpatch function
% Require the function "dispname" to display the name of the ROI
%
%- CREx 20151019

if nargin < 2 || isempty(savpath) || ~exist(savpath, 'file')
    savpath = pwd;
end

if ~isfield(atlas, 'ROIpatch')
    disp(' ')
    disp('This function requires the ROIpatch field in atlas')
    disp('in structure (as obtained by meg_atlas_ROIpatch processing)')
    return;
end

%---- Associate tissue identification number
% id_tis = atlas.tissue(:); %  902629x1 
Alab = atlas.tissuelabel;
isi = cellfun(@(x) isempty(x), Alab);
Alab(isi) = {'Unknw'};

Sroi = atlas.ROIpatch;

Ntis = length(Sroi);
colc = color_group(Ntis);

figure
set(gcf,'units','centimeters', 'position', [10 7 28 20],'color',[0 0 0])
set(gca,'position',[0.005 0.00 .99 .92],'color',[0 0 0]) 
hold on

for n = 1 : Ntis
    patch(Sroi{n},'edgecolor', 'none', 'facecolor', colc(n,:),...
        'facealpha', 0.20, 'facelighting','gouraud','displayname', Alab{n});
end
view(130, 30) 
axis tight equal off;
set(gcf, 'WindowButtonDownFcn', @dispname);

psav = fullfile(savpath, ['atlas_ROIpatch_', num2str(Ntis),'.fig']);
saveas(gcf, psav);

fprintf('\n\nAtlas ROI patches figure saved here:\n %s\n', savpath);
