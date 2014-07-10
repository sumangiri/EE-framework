%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>


function [state_transitions transition_labels]=get_state_transitions(assigned_clusters,P_diff, min_elem)

% calculate the median power value for state transitions. 
% filters out noise (anything that occurs less than 3% of time)
   
    unique_labels=unique(assigned_clusters);
    c=1;
    state_transitions=[];
    for i = 1:length(unique_labels)
        temp_index=find(assigned_clusters==unique_labels(i));
        
        if length(temp_index)>min_elem %filter out noise
            state_transitions(c)=median(P_diff(temp_index));
            transition_labels(c)=unique_labels(i);
            c=c+1;
        end
        
    end

end