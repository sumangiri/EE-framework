%% Back to Main
% * <file:///Users/sumangiri/Desktop/FSM/Code/Energy%20estimation%20v2/html/main_file_v2.html Back to Main>

function [similarity, preferance]=similarity_function(x)


    N=size(x,1);
    M=N*N-N; similarity=zeros(M,3); % Make ALL N^2-N similarities
    j=1;
    for i1=1:N
      for k=[1:i1-1,i1+1:N]
        similarity(j,1)=i1; similarity(j,2)=k; similarity(j,3)=-sum((x(i1,:)-x(k,:)).^2);
        j=j+1;
      end;
    end;
    preferance=median(similarity(:,3)); % Set preference to median similarity
    
end