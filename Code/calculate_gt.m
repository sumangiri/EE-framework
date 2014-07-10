function [gt_energy gt_time_stamp]=calculate_gt(ID_of_interest, time_stamps, file_path)
    
    load ([file_path '/P_sensor_' num2str(ID_of_interest) '.mat']);
    
    t_unix=round((P.t-datenum(1970,1,1))*86400);
    
    [~,start_time]=min(abs(t_unix-time_stamps(1,1)));
    [~,end_time]=min(abs(t_unix-time_stamps(end,1)));
    
    
    t_unix=sort(t_unix(start_time:end_time));
    diff_t=diff(t_unix);
   
    t_unix(find(diff_t<1))=[];
    
    
    P.P1=P.P1(start_time:end_time);
    P.P1(find(diff_t<1))=[];
    
    
    
    
    diff_t=abs(diff(t_unix));
    gt_time_stamp=t_unix;
    diff_t(diff_t>50)=0;
    
    diff_t=diff_t(:);
    P.P1=P.P1(:)';
    gt_energy=(P.P1(1:end-1)*diff_t)/3600000;
    
    
    
    
end