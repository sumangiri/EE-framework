%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>

function transition_probabilities = ...
    get_transition_probabilities(assigned_clusters, transition_labels)

%take time series of state transitions and calculate 1st order markovian
%transition probabilities

    transition_probabilities=zeros(length(transition_labels));
    
    for i = 1:length(transition_labels)
        a=find(assigned_clusters==transition_labels(i));
        
        if length(a)==0
            display ('might be an error here')
        end
        
        for j = 1:length(transition_labels)
            b=find(assigned_clusters==transition_labels(j));
            c= length(find(ismember(a+1,b)));
            transition_probabilities(i,j)=c/length(a);
        end
        
    end
    
    
    %to prevent cycling between states
    transition_probabilities(eye(size(transition_probabilities))~=0)=0;
 
end