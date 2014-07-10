%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>

function assigned_clusters=reassign_clusters(new_state_transitions,...
        transition_labels, P_diff)
    
    %function to reassign clusters once perturbation is done. basically
    %does Euclidean distance computation
    
    for i = 1:length(P_diff)
        [~,index]=min(abs(new_state_transitions-P_diff(i)));
        assigned_clusters(i)=transition_labels(index);
    end
      
end
    