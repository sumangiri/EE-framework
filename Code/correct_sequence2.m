%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>


function corrected_sequence= correct_sequence2(new_cycles, assigned_clusters, ...
    transition_labels,transition_probabilities,temp_transition_probabilities)

%any transition that violates the FSM will be replaced by the most likely
%state transition


    
    temp_assigned_clusters=assigned_clusters;
    %rename the cluster labels so that it corresponds to row and column
    %numbers of adjacency matrix
    for i = 1: length(transition_labels)
           assigned_clusters(find(assigned_clusters==transition_labels(i)))=i;
    end
    
    %convert it to column vector
    if size(new_cycles,1)<2
        new_cycles=new_cycles';
    end
    
    %put the length as second column
    for i = 1:length(new_cycles)
        new_cycles{i,2}=length(new_cycles{i,1});
        new_cycles{i,1}=num2str(new_cycles{i,1});
        new_cycles{i,1}(new_cycles{i,1}==' ')=[];
    end
    
    %sort according to descending order of cycle length
    new_cycles=sortrows(new_cycles,-2);
    
    %convert to string
    %assigned_clusters=num2str(assigned_clusters);  
   
    %convert assigned clusters to column vector for string handling
    %purposes
    assigned_clusters=assigned_clusters(:);
%     if size(assigned_clusters,1)>size(assigned_clusters,2)
%         assigned_clusters=assigned_clusters';
%     end

    %get rid of trailing spaces
%    assigned_clusters(assigned_clusters==' ')='';    
    transition_prob=temp_transition_probabilities;
    temp=assigned_clusters(1);
    
    
    corrections=0;
    max_segment_length=new_cycles{1,2}; %length of the biggest piece
    

    for i =2: length(assigned_clusters)
           
         index_of_interest=zeros(length(transition_labels),1);
         flag2=0;
         
         if assigned_clusters(i)<length(transition_labels)/2+1
             index_of_interest=1:floor(length(transition_labels)/2);
             flag2=0;
         else
             index_of_interest=floor(length(transition_labels)/2)+1:length(transition_labels);
             flag2=1;
         end
         
         temp_transition_probabilities=transition_prob; 
         counter2=1;
         
         while counter2
             
            %if transition is not possible
            if ~transition_probabilities(assigned_clusters(i-1),assigned_clusters(i))
                    %dbstop at 70 in correct_sequence2
                    
                    temp_transition_probabilities(assigned_clusters(i-1),assigned_clusters(i))=0;
                    
                    previous_index=temp(end);
                    %find the next most likely transition
                    
                    [max_val,max_index]=...
                        max(temp_transition_probabilities(previous_index,index_of_interest));
                    
                    %if its off look for offs only
                    if flag2
                        max_index=max_index+floor(length(transition_labels)/2);  
                    end
                    
                    %if no transitions are possible keep it as it is
                    if ~max_val
                          display('No transition correction possible');
                          max_index=assigned_clusters(i);
%                         [~,max_index]=...
%                             max(transition_prob(previous_index,index_of_interest));
                        %transition_probabilities(max_index, assigned_clusters(i+1))=1;
                        
                    end
                    
                    
                    
                    
                    %if transition_probabilities(max_index, assigned_clusters(i+1))
                    temp=[temp; max_index];
                    corrections=corrections+1;
                    counter2=0;
                        
                    %end
            else

                      temp=[temp; assigned_clusters(i)];
                      counter2=0;
                      
            end
                  
         end
         
       end
    
    display(corrections)

    for i =1:length(temp)
        corrected_sequence(i,1)=transition_labels(temp(i));
    end
    %     
%     if sum(corrected_sequence(:)~=temp_assigned_clusters(:))~=corrections-1
%         error('There might be an error here')
%     end
   
end