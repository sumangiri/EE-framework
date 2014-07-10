%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>


function [energy, power_trace, gt_energy]=...
    calculate_energy(corrected_sequence,time_stamps, new_state_transitions, ...
    transition_labels,new_states,ID_of_interest, file_path)
    %% Calculate ground truth energy
    % <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/calculate_gt.html calculate_gt>
    [gt_energy, gt_time_stamp]=calculate_gt(ID_of_interest, time_stamps, file_path);
    
    %%
    for i = 1:length(new_state_transitions)
        states(corrected_sequence==transition_labels(i))=new_state_transitions(i);
    end
   
    state_duration=round(diff(time_stamps));
    on_transitions_counter=0;
    off_transitions_counter=0;
    %energy=states(1:end-1)*state_duration;
    c=0;
    %create power trace      
    for k = 1:length(state_duration)
        
        %make sure nothing exceeds the max state
        if sum(states(1:k))>max(new_states)
            states(k)=max(new_states)-sum(states(1:k-1));
        
            %make sure nothing goes below zero
        elseif sum(states(1:k))<0
            states(k)=-1*sum(states(1:k-1));
        end
        
        if states(k)>0
            on_transitions_counter=on_transitions_counter+1;
        else
            off_transitions_counter=off_transitions_counter+1;
        end
        
        %crude heuristic. make sure no errors are accrued
        if on_transitions_counter==off_transitions_counter &&...
                sum(states(1:k))>0 &&states(k)<0
            states(k)=-1*sum(states(1:k-1));
        end
        
        %reset counters after equilibrium.
        if sum(states(1:k))==0
            on_transitions_counter=0;
            off_transitions_counter=0;
        end
        
        power_trace(c+1:state_duration(k)+c,2)=sum(states(1:k));
        c=c+state_duration(k);
    end
    
    %simulate time
    temp_time_stamp=[];
    for k2 = 1:length(state_duration)
        temp1=linspace(time_stamps(k2),time_stamps(k2+1),state_duration(k2));
        temp_time_stamp=[temp_time_stamp round(temp1)];
    end
    
    
    
    missing_data=gt_time_stamp(find(diff(gt_time_stamp)>50));
    temp_diff=diff(gt_time_stamp);
    missing_duration=temp_diff(temp_diff>50);
    
    for i = 1:length(missing_data)
        temp_index= find(ismember(temp_time_stamp,missing_data(i):missing_data(i)+missing_duration(i)));
        power_trace(temp_index,:)=[];
        temp_time_stamp(temp_index)=[];

    end
        
    power_trace(:,1)=temp_time_stamp';
    states(states<0)=0;
    energy=(states(1:end-1)*state_duration)/3600000;
    power_trace(diff(power_trace(:,1))<1,:)=[];
    
    energy=sum(power_trace(:,2))/3600000;
    
   
    
    
    
end
    
    