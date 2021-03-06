function Sdb = cp_meg_epoching(Sdb, opt)
% Do the final epoching acocrding to the preprocessing options (for cleaning, filtering
% and/or resampling)
%-CREx180726

% Continuous data filtering option
fopt = opt.continuous.filt;

% Epoching options
eopt = opt.epoched;
eopt.res_fs = eopt.resample_fs;

Ns = length(Sdb);

% Initialize waitbar
wb = waitbar(0, 'Epoching...', 'name', 'MEG preprocessing');
wb_custcol(wb, [0 0.6 0.8]);

for i = 1 : Ns
    dpm = Sdb(i).meg;
    Sprep = dpm.preproc;
    
    if ~any(Sprep.do.epch)
        continue;
    end
    
    % Info for figures (TO DO)
    % Subject info
    sinfo = Sdb(i).sinfo;
    % Run directories
    rdir = dpm.run.dir;
    
    Nr = dpm.Nrun;
    for j = 1 : Nr
       
        % If the initial data visualisation was already done
        if ~Sprep.do.epch(j)
            continue;
        end
		
        srun = rdir{j};		
        waitbar((i-1)/Ns + (j-1)/(Nr*Ns), wb, ['Epoching: ', sinfo, '--', srun]);
        
        Spar = Sprep.param_run{j};
        
        % Prepare data for epoching
        ftData = prepare_data(Spar, fopt);
        
        % Epoching carnage
        allTrials = extract_trials(ftData, Spar, eopt);
        
        % Remove bad trials
        [cond, Nc] = get_names(allTrials);
        
        cleanTrials = allTrials;
        
        % Remove bad trials / conditions
        for k = 1 : Nc
            cnam = cond{k};
            trials = allTrials.(cnam);
            
            if isfield(Spar.rm.trials, cnam)
                badtr = Spar.rm.trials.(cnam);
            else
                badtr = Spar.rm.trials.allcond;
            end
            % Add the artefacted trials
            iart = find(trials.hdr.artefact);
            if ~isempty(iart)
                badtr = unique([badtr ; iart]);
            end
            
            if isempty(badtr)
                continue
            end
            Nt = length(trials.trial);
            igoodt = setdiff(1:Nt, badtr);

            cfg = [];
            cfg.trials = igoodt;
            cleanTrials.(cnam) = ft_redefinetrial(cfg, trials);
        end
        pclean = dpm.analysis.clean_dir{j};    
        pmat = [pclean, filesep, 'cleanTrials.mat'];
        save(pmat, '-v7.3', 'cleanTrials');
        
        ppr = [pclean, filesep, 'preproc.mat'];
        preproc = [];
        preproc.rm = Spar.rm;
        save(ppr, 'preproc');
        
        Sdb(i).meg.analysis.clean_mat{j} = pmat;
    end
end
close(wb);