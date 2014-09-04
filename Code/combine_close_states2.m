function [new_states,new_states_label,states_temp_new]=  combine_close_states2(new_states,states_temp,min_distance)
    
%a better way of combining states that are close together using k means
%min distance controls what range of power states to combine together
    

    
    new_states=sort(new_states);

    states1=new_states(2:end);
    diff_states=diff(states1);

    states2=states1;
    k=0;
    %this is to count k for k means
    for i = 1:length(diff_states)

        if diff_states(i)>min_distance
            k=k+1;
        else
            states2(i)=0;
        end
    end
    states2(states2==0)=[];
    
    if min(diff(states2))<min_distance
        error('There might be an issue in finding unique states here')
    end
    
    if ~k
        k=1;
        if length(new_states)~=2
            error('There might be an error in estimating k here')
        end
    end
    
    cluster_labels=kmeans(states1,k);
    labels=unique(cluster_labels);

    for i = 1:length(labels)
        index_temp=find(cluster_labels==labels(i));
        states1(index_temp)=states1(index_temp(end));
    end


    new_states=unique([0 states1]);
    
    for i =1:length(states_temp)
        for i2 = 1:length(states_temp{i})
            if ~ismember(states_temp{i}(i2),new_states)
                [~,temp_var]=min(abs(new_states(2:end)-states_temp{i}(2)));
                if length(temp_var)==0
                    temp_var=0;
                end
                states_temp{i}(i2)=new_states(temp_var+1);
            end
            new_states_label{i}(i2)=find(new_states==states_temp{i}(i2));
        end
            
    end
   
    states_temp_new=states_temp;
    %new_states_label=labels;

end

