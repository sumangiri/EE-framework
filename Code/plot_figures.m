%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>


function []= plot_figures(plot_options, assigned_clusters, transition_labels, state_transitions,...
    feature, new_transition_probabilities, new_state_transitions, adjacency_matrix, new_states,...
    power_trace, energy,ID_of_interest, index, file_path)

   
   
    
    %plot clustering results
    if strcmp(plot_options.cluster_flag,'true')
        figure (1)
        group_labels=600*ones(length(assigned_clusters),1);
        for i1= 1:length(transition_labels)
            group_labels(find(assigned_clusters==transition_labels(i1)))=...
                round(state_transitions(i1));
        end
        
        subplot(2,2,index)
        gscatter(feature(:,1),feature(:,2),group_labels,'','o+x*+')
        title ([plot_options.cluster_alg ' ' num2str(ID_of_interest(index))]);
    end
    
    
    %plot FSMs
    if strcmp(plot_options.fsm_flag,'true')
        %DG=sparse(new_transition_probabilities);%, new_state_transitions);
        %view(biograph(DG,[],'ShowWeights','on'))
        bg=(biograph(adjacency_matrix,cellstr(num2str(new_states'))));
        bg1=bg.getnodesbyid;
        set(bg1,'Shape','circle','FontSize',36);
        set(bg.edges,'LineWidth',1.5,'LineColor',[0 0 0])
        %view(bg)
        
        g = biograph.bggui(bg);
        f1=figure;
        %f1=subplot(4,2,index);
        copyobj((g.biograph.hgAxes),f1);
        print(['-f' num2str(f1)],'-deps','print.eps')
        title(['FSM States' ' ' num2str(ID_of_interest(index))],'position',[0.5 0.5],'Fontsize',20)
        close(g.hgFigure);
    end
    
        %plot FSMs
    if strcmp(plot_options.state_transitions,'true')
        bg=biograph(new_transition_probabilities,cellstr(num2str(new_state_transitions)));
        bg1=bg.getnodesbyid;
        set(bg1,'Shape','box','FontSize',36);
        set(bg.edges,'LineWidth',1.5,'LineColor',[0 0 0])
        %view(bg)
        
        g = biograph.bggui(bg);
        f1=figure;
        %f1=subplot(4,2,index);
        copyobj((g.biograph.hgAxes),f1);
        print(['-f' num2str(f1)],'-deps','print.eps')
        title(['State transition diagrams' ' ' num2str(ID_of_interest(index))],...
            'position',[0.5 0.5],'Fontsize',20)
        %close(g.hgFigure);
    end
    
    
    
    %plot energy trace
    if strcmp(plot_options.recon_trace,'true')
            figure
            load ([file_path '/P_sensor_' num2str(ID_of_interest(index)) '.mat']);
            
            t_unix=round((P.t-datenum(1970,1,1))*86400);
            [~,start_time]=min(abs(t_unix-power_trace(1,1)));
            [~,end_time]=min(abs(t_unix-power_trace(end,1)));
            t_unix=t_unix(start_time:end_time);
            P.P1=P.P1(start_time:end_time);
            %subplot(4,2,index);
            plot(t_unix,P.P1);hold on;
            plot(power_trace(:,1),power_trace(:,2),'r')
            
            
            trace_time=power_trace(:,1);
            trace_time(diff(trace_time)<1)=[];
            power_trace(diff(trace_time)<1,2)=[];
            
            common_index=find(ismember(t_unix,trace_time));
            t_unix=t_unix(common_index);
            P.P1=P.P1(common_index);
            
            error=(sum(P.P1)-sum(power_trace(:,2)))/sum(P.P1)*100;
            
            title(['appliance: ' num2str(ID_of_interest(index)) ' estimated error: ' num2str(error)]);
     end
        

end