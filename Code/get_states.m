%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>


function [new_states adjacency_matrix]= get_states (new_cycles, new_state_transitions,new_transition_probabilities, min_distance)

    %new_state_transitions=[0 new_state_transitions'];
    %THIS NEEDS TO BE MODIFIED> RIGHT NOW IT CANNOT HANDLE CASES WHERE THE
    %SAME THING APPEARS IN A COLUMN MULTIPLE TIMES
    
    for i = 1:length(new_cycles)
        
        for j = 1:length(new_cycles{i})
            
            states_temp{i}(j)=sum(new_state_transitions(new_cycles{i}(1:j)));
            
            states_temp{i}(j)=round (states_temp{i}(j));
            
           
            
            
        end
        
        if abs(states_temp{i}(j))>2
            %dbstop in get_states.m
            display('There might be an error in ZLSC here')
        end
    end
    
    new_states=unique(cell2mat(states_temp));
    
    %check the proximity of new found states and classify them as same if
    %they are close enough
    [temp_new_states,new_states_label, states_temp_new]= ...
        combine_close_states2(new_states, states_temp, min_distance);
    
    
    for i =1:length(states_temp)
        for i2 = 1:length(states_temp{i})
            states_label{i}(i2)=find(new_states==states_temp{i}(i2));
        end     
    end
    
    temp_matrix2=zeros(length(new_states));
    a=cell2mat(states_label);
    b=a(2:end);
    
    
    
    a=a(1:end-1);
    temp2=cell2mat(new_cycles);

    adjacency_matrix=create_adjacency(new_states_label,temp_new_states);
    new_states=temp_new_states;

end