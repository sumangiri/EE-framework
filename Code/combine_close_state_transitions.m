%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>

function [assigned_clusters, new_state_transitions, new_transition_labels]=...
        combine_close_state_transitions(temp_assigned_clusters, ...
        state_transitions, transition_labels, threshold)
    
 %takes in state transitions that are given by clustering algorithm
 %the state transitions that are close by are replaced by the one with
 %lower value. labels and cluster assignments are replace accordingly.
 
 %the test is done for on and off separately.
 
    on_steps=state_transitions(state_transitions>0);
    off_steps=state_transitions(state_transitions<0);
    
    on_steps=sort(on_steps);
    off_steps=sort(abs(off_steps));
    
    on_error_index=find(diff(on_steps) < threshold);
    off_error_index=find(diff(off_steps) < threshold);
    
    %if there are none that satisfy the threshold return with original
    %values
    if ~(sum([length(on_error_index) length(off_error_index)]))
        new_state_transitions=state_transitions;
        new_transition_labels=transition_labels;
        assigned_clusters=temp_assigned_clusters;
        return
    end
    
    display ('combining close state transitions');
    
    %iteratively remove closer values. Keep the lower one.
    k1=1;
    %for on
    while length(on_error_index)
        label_tbr(k1)=transition_labels(find(ismember(state_transitions,on_steps(on_error_index(1)+1))));
        new_label(k1)=transition_labels(find(ismember(state_transitions,on_steps(on_error_index(1)))));
        on_steps(on_error_index(1)+1)=[];
        on_error_index=find(diff(on_steps) < threshold);
        k1=k1+1;
    end
    %for off
    while length(off_error_index)
        label_tbr(k1)=transition_labels(find(ismember(state_transitions,-1*off_steps(off_error_index(1)+1))));
        new_label(k1)=transition_labels(find(ismember(state_transitions,-1*off_steps(off_error_index(1)))));
        off_steps(off_error_index(1)+1)=[];
        off_error_index=find(diff(off_steps) < threshold);
        k1=k1+1;
    end
    
    temp_state_transitions=state_transitions;    
    state_transitions(~ismember(temp_state_transitions,[on_steps, -1*off_steps]))=[];
    transition_labels(~ismember(temp_state_transitions,[on_steps, -1*off_steps]))=[];
    
    for i = 1:length(label_tbr)
        temp_assigned_clusters(temp_assigned_clusters==label_tbr(i))=new_label(i);
    end
    
    new_state_transitions=state_transitions;
    new_transition_labels=transition_labels;
    assigned_clusters=temp_assigned_clusters;
    
    
end