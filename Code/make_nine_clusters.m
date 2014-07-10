%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>

function [new_assigned_clusters, new_state_transitions, new_transition_labels]= ...
    make_nine_clusters(assigned_clusters, state_transitions, transition_labels)

% %function to make sure that clusters are even (i.e. every positive cluster
% %has a pair. if not it connects two closest clusters to ensure this
% %happens.

    [idx_1,new_steps]=kmeans(state_transitions,9);
    old_steps=[];
    
    %indices in the one with higher elements that need to be replaced
    index_tbr=(find(~ismember(state_transitions,[new_steps;old_steps])));
    
   
    new_state_transitions=zeros(length(state_transitions),1);
    new_transition_labels=zeros(length(transition_labels),1);
    
    for i =1:length(index_tbr)
        [~,idx_2]=min(abs(new_steps-state_transitions(index_tbr(i))));
        new_state_transitions(index_tbr(i))=new_steps(idx_2); 
    end
    
    unique_replacements=unique(new_state_transitions);
    unique_replacements=unique_replacements(find(unique_replacements));
    
    for i = 1:length(unique_replacements)
        idx_3=find(new_state_transitions==unique_replacements(i));
        new_transition_labels(idx_3)=transition_labels(idx_3(1));
    end
    
    unreplaced_indices=find(new_state_transitions==0);
    
    new_state_transitions(unreplaced_indices)=state_transitions(unreplaced_indices);
    new_transition_labels(unreplaced_indices)=transition_labels(unreplaced_indices);
    
    
    [new_state_transitions,temp_index]=unique(new_state_transitions);
    new_transition_labels=new_transition_labels(temp_index);
    new_assigned_clusters=assigned_clusters;
    
    %STOPPED HERE: MAY 12 4:53, airplane: Miami to Pittsburgh
    
    removed_labels=transition_labels(find(~ismember(transition_labels,new_transition_labels)));
    
    for i = 1:length(removed_labels)
        [~,replacement_index]=min(abs(new_state_transitions-state_transitions(transition_labels==removed_labels(i))));
        
        new_assigned_clusters(new_assigned_clusters==removed_labels(i))=...
            new_transition_labels(replacement_index);
    end
    
    
   
    


 end