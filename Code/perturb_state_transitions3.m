%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>

function new_state_transitions=perturb_state_transitions3(state_transitions, threshold1, threshold3)
%May 24th. Written in order to get rid of the limitation of pairing in
%previous versions
    

%threshold1: far the error variables can fluctuate
%threshold3: (anything below this will be considered as accumulated noise.
%for each combination of offs and ons, anything below this will consider
%the subset to be a cycle).

%THINK ABOUT THIS SOME MORE: CAN THIS REPLACE SEARCH FOR CYCLES based on observed data?


    on_steps=state_transitions(state_transitions>0);
    off_steps=state_transitions(state_transitions<0);
%%
% Find all subsets of on_steps : Calls <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/AllSubsets.html AllSubsets>

    on_comb = AllSubsets(on_steps);
    
    on_subsets={};
    for i =1 :size(on_comb,1)
        on_subsets{i,1}=on_comb(i,~isnan(on_comb(i,:)));
    end
    on_subsets(end)=[];
    
    off_comb = AllSubsets(off_steps);
    off_subsets={};
    for i =1 :size(off_comb,1)
        off_subsets{i,1}=off_comb(i,~isnan(off_comb(i,:)));
    end
    off_subsets(end)=[];
    
    k=1;
    %threshold=min(abs(state_transitions));
    
    constraint_indices=[];
    opt_weights=[];
    
    for i = 1:length(on_subsets)
        for j = 1:length(off_subsets)
            possible_cycles{k,1}=[on_subsets{i} off_subsets{j}]; 
            k=k+1;
        end
    end
  
  A=zeros(length(possible_cycles), length(state_transitions));
  
  for i = 1:length(possible_cycles)
        index_1=ismember(state_transitions,possible_cycles{i});
        A(i,index_1)=state_transitions(index_1);
        B(i,:)=double(index_1);
  end
  
  A=double(A);
  b=ones(size(A,1),1);
  n=length(state_transitions);
  lambda=10e10;
  

  temp_threshold3=threshold3;
  temp_threshold1=threshold1;
  x=nan*ones(n,1);
  
  while sum(isnan(x))
      
      temp1=sum(A,2);
      temp2=temp1(abs(temp1)<threshold3);
     
      if ~length(temp2)
          temp2=0;
      end
      
      B1=B(abs(temp1)<threshold3,:);
      
      cvx_begin
        variable x(n)
            resulting_cycles=sum(A + B.*repmat(x',size(A,1),1),2);
            minimize(norm(resulting_cycles, 1)+lambda*(norm(x, 1)))
            subject to
            % This is an extra check in place to make sure that some rare 
            % appliances for whom total sum of state transitions
            % doesn't equal zero aren't unfairly forced to follow the
            % constraint
            if abs(sum(state_transitions))/max(abs(state_transitions)) <0.3 || abs(sum(state_transitions))<50
                sum((A(1,:)'+x))==0;
            end
                temp2+B1*x==0;
                -threshold1 <= x <=threshold1;
      cvx_end
      
      threshold3=threshold3-5;
      
      if threshold3 < 1
          threshold3=temp_threshold3;
          threshold1=threshold1+5;
          
          if threshold1>200
              
              display ('no optimal solution could be found');
              
              break
          end
          
      end
    
  end
  
  %resulting_cycles=sum(A + B.*repmat(x',size(A,1),1),2);
  new_state_transitions=x(:)+state_transitions(:);  
  %compare= [state_transitions' new_state_transitions];

  
end