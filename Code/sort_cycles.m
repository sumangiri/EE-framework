%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>

function new_cycles=sort_cycles(cycles)

%keep on shifting permutations until the ons are at the front.

    for i = 1:length(cycles)

        while cycles{i}(1)~=min(cycles{i})
            cycles{i}=cycles{i}(:);
            cycles{i}=circshift(cycles{i},1);
        end

        new_cycles{i}=cycles{i};
    end
    
    
end