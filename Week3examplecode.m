clear all
clc
DATATYPE='double';
FILENAME='road.wav'; %input filename
SAVENAME='newroad.wav'; %output filename
[snd,FS]=audioread(FILENAME);
audiosize=size(snd);%Return audiosize as [Length in samples, number of channels]
leftchannel=snd(:,1); %Return audioize as [Length in samples, number of channels]
rightchannel=snd(:,2);%Extract right channel
START=1;
END=audiosize(1); %The size of the audio file in number of samples.

%UNCOMMENT THE FOLLOWING COMMAND TO ENABLE THE TEST
sound(snd,FS); %Play original audio
sound(snd,2*FS); %Play original audio using twice the sample rate
sound(leftchannel,FS); %play original audio using twice the sample rate
forcemono=[leftchannel,zeros(size(leftchannel))];
sound(forcemono,FS); %Force to play only leftchannel in left speaker.
sound(snd(START:round(END/2)),FS); %Play half of the original audio

firstcut=leftchannel(1:FS*2); %Extract two seconds of audio
secondcut=leftchannel(1:FS*2); %lower volume
thirdcut=leftchannel(FS*3:FS*5)*0.2; %increase volume
newedit=[firstcut;secondcut;thirdcut]; %create a new edit by joining thre cuts together.
figure(1), plot(newedit);
%wavrite(newedit,FS,SAVENAME); %Save the new edit to a file
sound(newedit,FS);