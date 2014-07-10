%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>


function adjacency_matrix= create_adjacency (cycles,transition_labels)
%create new adjacency matrix from cycles
    
    adjacency_matrix=zeros(length(transition_labels));
    
    for i = 1:length(cycles)
        
        temp_cycle=cycles{i};
        %because the cycles are more like a torus, this is required to
        %ensure that transition from last to first step is also possible
        temp_cycle=[temp_cycle temp_cycle(1)];

        for j= 1:length(temp_cycle)-1
            adjacency_matrix(temp_cycle(j),temp_cycle(j+1))=1;
        end


    end
    
    %set diagonal elements to zero to prevent cycling between states
    adjacency_matrix(eye(size(adjacency_matrix))~=0)=0;
end