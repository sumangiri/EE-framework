%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>


function new_cycles=check_cycles(cycles,new_state_transitions)
    new_cycles={};
%checks cycles for feasibility (i.e. whether or not they satisfy ZLSC)
    k2=1;
    
    for i = 1:length(cycles)
        %get rid of the redundant last element
        %cycles are typically returned as [1 2 3 4 1];
        
        cycles{i}(end)=[];
        temp_index1=cycles{i};
        
        %if they satisfy ZLSC, save it
        s=0; k1=0;
        if abs(sum(new_state_transitions(temp_index1)))<5 
            %checking for zero (but making sure that rounding errors dont
            %contribute)
        
            %check to see that the sum of states never goes below zero in a
            %temporal sense
            
            for j = 1:length(temp_index1)
                s=s+new_state_transitions(temp_index1(j));
                if s<0
                    k1=k1+1;
                end
            end
            k1=0
            if k1==0 
            
                new_cycles{k2}=cycles{i};
                k2=k2+1;
            end
            
        end
       
    end
    
    if length(new_cycles)<1
        display ('None of the options satisfy ZLSC, returning all')
        new_cycles=cycles;
    end
    


end