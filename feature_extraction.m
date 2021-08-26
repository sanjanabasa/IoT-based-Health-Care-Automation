 function [feature_array]=feature_extraction(filename)
data=importdata(filename);
sig=data.';
%a=fir1(100,[0.25 0.29],'stop');
%y1=filter(a,1,sig);
fs=100;
gr=0;
int=[];
[qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(sig,fs,gr);
len=length(qrs_i_raw);
rr_interval= zeros(1,len);
rr_interval(1)= qrs_i_raw(1)/fs;
for i=2:1:len
    rr_interval(i)=(qrs_i_raw(i)-qrs_i_raw(i-1))/fs;
    rr_i_sq(i)=rr_interval(i)*rr_interval(i);
end
%  xc=fft(qrs_amp_raw);
%  k=qrs_i_raw(len);
%  k=k/fs;
%  xc1=xc/k;
%  xc2=abs(xc1);
%  xc2=power(xc2,2);
%  psd=mean(xc2);
mean_sample=mean(rr_interval);
median_sample=median(rr_interval);
e_x=mean(rr_interval);
e_x2=mean(rr_i_sq);
var=e_x2-(e_x*e_x);
std=sqrt(var);
mean_rr_square=mean(rr_i_sq);
rmssd=sqrt(mean_rr_square);
for i=1:len
    rr_1=rr_interval(i)-e_x;
    rr_2=abs(rr_1);
end
mad=mean(rr_2);
rr_sorted=sort(rr_interval);
if(mod(len,2)==0)
    n1=len/2;
    n2=n1+1;
else 
    n1=(len-1)/2;
    n2=n1+2;
end
for i=1:n1
    rr_sorted_1(i)=rr_sorted(i);
    rr_sorted_2(i)=rr_sorted(n2-1+i);
end
q1=median(rr_sorted_1);
q3=median(rr_sorted_2);
irq=q3-q1;
% hrv=length(rr_interval);

%Extracting number of consecutive R-R intervals that differ more than
    %50 ms
    m=0;
    for num=1:1:len-1
        if(rr_interval(num)>=0.05)
            m=m+1;
        end
    end
    nn50=m;
    %Extracting Percentage value of total consecutive RR interval that
    %differ more than 50ms
    pnn50= ((m/length(rr_interval))*100);
    
     % Calculating Power Spectral Entropy
    %sampling rate per second
     Ts1=1/fs;%sampling time interval in second
     t1=0:Ts1:1-Ts1; n1=length(t1);
 
     fresult1=fft(rr_interval);
     sum_fresult1=0.0;
     for i=1:1:length(fresult1)-1
      sum_fresult1= sum_fresult1 + (abs(fresult1(i)));
     end
     fresult1=fresult1/sum_fresult1;
     entropy1=0.0;
     for i=1:1:length(fresult1)-1
      entropy1= entropy1+ abs(fresult1(i))*log(1/abs(fresult1(i)));
      pse_rr=entropy1;
    end
 feature_array=[mean_sample median_sample mad var irq rmssd pse_rr];
% feature_array=[rr_interval];
    %feature_array= [ pnn50];
end