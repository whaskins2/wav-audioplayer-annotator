function varargout = assignmentGUI(varargin)
% ASSIGNMENTGUI MATLAB code for assignmentGUI.fig
%      ASSIGNMENTGUI, by itself, creates a new ASSIGNMENTGUI or raises the existing
%      singleton*.
%
%      H = ASSIGNMENTGUI returns the handle to a new ASSIGNMENTGUI or the handle to
%      the existing singleton*.
%
%      ASSIGNMENTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSIGNMENTGUI.M with the given input arguments.
%
%      ASSIGNMENTGUI('Property','Value',...) creates a new ASSIGNMENTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before assignmentGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to assignmentGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help assignmentGUI

% Last Modified by GUIDE v2.5 29-Nov-2016 16:58:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @assignmentGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @assignmentGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
%Your sound annotator must allow the user to:
%1)	Import one music file in “wav” format and extract one track from it.
%2)	Import one short voice file (pre-recorded or recorded live) and extract one track from it.
%3)	Play the two sound tracks in full independently,
%4)	Allow user to merge the voice track and a selected section of the music track so that the voice annotates the music (i.e., you can hear both the voice and the music). 
%5)	Play the new sound,
%6)	Save the new edited sound to disk in “wav” format.

%Notes - 
%When overlaying tracks in order to make them the same length add '0's to
%the shorter track until it is the same length as the longer track, this
%will increase the length of the track without adding any noise.

%Problems - 
%Dunno how to combine stereo and mono without forcing stereo on mono files
%which makes it sound pretty bad.

%Ideas - 
%http://homepages.udayton.edu/~hardierc/ece203/sound.htm

%TODO - 
%Make slider dictate where in the song to play from. Try and make it so it
%works for songs in progress.
%Current Slider progression doesn't work well with pausing. Spamming pause
%will cause the slider to fail to properly track the time. Try finding a
%way to track the time based on the song rather than just incrementing a
%time everytime the timer ticks.

% --- Executes just before assignmentGUI is made visible.
function assignmentGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to assignmentGUI (see VARARGIN)

% Choose default command line output for assignmentGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes assignmentGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global playing1 % Tracks whether track 1 is currently playing.
playing1 = false; 
global songloaded1 % Tracks whether track 1 is loaded.
songloaded1 = false;
global playing2 % Tracks whether track 2 is currently playing.
playing2 = false;
global songloaded2 % Tracks whether track 2 is loaded.
songloaded2 = false;
global time1; %Stores length of track 1.
global time2; %Stores the length of track 2.
time1 = 0;
time2 = 0;
global sampleRate; %Stores the sample rate to apply to all tracks.
sampleRate = 48000;
global paused1; %Stores whether track 1 is paused.
global paused2; %Stores whether track 2 is paused.
paused1 = false;
paused2 = false;

function playSound(trackNum) %Play the selected sound file
display('playSound Called');
if trackNum == 1
    global sound1;
    global playing1;
    global songloaded1;
    global paused1;
    if ~playing1 && songloaded1
        resume(sound1);
        playing1 = true;
        paused1 = false;
        %playMonitor(1, handles, sound1);
    end
elseif trackNum == 2
    global sound2;
    global playing2;
    global songloaded2;
    global paused2;
    if ~playing2 && songloaded2
        resume(sound2);
        playing2 = true;
        paused2 = false;
    end
end
    

function pauseSound(trackNum) %Pause currenly playing sound
if trackNum == 1
    global sound1;
    global playing1;
    global paused1;
    
    playing1 = false;
    paused1 = true;
    pause(sound1);
elseif trackNum == 2
    global sound2;
    global playing2;
    global paused2;
    
    playing2 = false;
    paused2 = true;
    pause(sound2);
end

function restartSound(trackNum) %stop playing current sound file without saving place in the track.
% --- Outputs from this function are returned to the command line.
% not finished

global songloaded1;
global sound1;
global playing1;
global songloaded2;
global sound2;
global playing2;
global paused1;
global paused2;
if trackNum == 1
    if songloaded1
        playing1 = false;
        stop(sound1);
        paused1 = false;
    end
elseif trackNum == 2
    if songloaded2
        playing2 = false;
        stop(sound2);
        paused2 = false;
    end
end

function loadFile(handles, trackNum) %opens explorer window and loads selected sound file.
FILENAME = uigetfile({'*.wav';'*.mp3';'*.*'}, 'Select an audio file');
global data1;
global data2;
if FILENAME
    [snd,FS]=audioread(FILENAME); %snd = sample data, FS = sample rate for that data.
    
    if trackNum == 1
        global sound1;
        global playing1;
        playing1 = false;
        global paused1;
        paused1 = false;
        global songloaded1;
        songloaded1 = true;
        if FS ~= 48000
            [P,Q] = rat(48000/FS);
            data1 = resample(snd,P,Q);
        end
        sound1 = audioplayer(data1,48000);
        sound1.StopFcn = {@songEnded, trackNum, handles};
        set(sound1,'TimerFcn',{@timerUpdate,trackNum, handles}, 'TimerPeriod', 0.1);
        stop(sound1);
        samples = get(sound1,'TotalSamples');
        frequency = get(sound1,'SampleRate');
    elseif trackNum == 2
        global sound2;
        global songloaded2;
        global paused2;
        paused2 = false;
        
        if songloaded2
            stop(sound2);
        end
        
        global playing2
        playing2 = false;
        songloaded2 = true;
        if FS ~= 48000
            [P,Q] = rat(48000/FS);
            data2 = resample(snd,P,Q);
        end
        sound2 = audioplayer(data2,48000);
        sound2.StopFcn = {@songEnded, trackNum, handles};
        set(sound2,'TimerFcn',{@timerUpdate,trackNum, handles}, 'TimerPeriod', 0.1);
        samples = get(sound2,'TotalSamples');
        frequency = get(sound2,'SampleRate');
    end
    display(samples);
    display(frequency);
    updateUI(snd, FS, handles, trackNum);
end

function songEnded(obj,event,track, handles)
global playing1;
global playing2;
global time1;
global time2;
global paused1;
global paused2;
if track == 1
    display('Track 1 Finished');
    if playing1 == true
        playing1 = false;
        if paused1 == false
            time1 = 0;
        end
        if get(handles.loop1, 'Value') == true
            playSound(1);
        end
    end
elseif track == 2
    display('Track 2 Finished');
    if playing2 == true
        playing2 = false;
        if paused2 == false
            time2 = 0;
        end
        if get(handles.loop2, 'value') == true
            playSound(2);
        end
    end
else
    display('failed to pass track');
end

function updateUI(snd, FS, handles, trackNum)
%t=1/FS:1/FS:length(snd)/FS;
%above explained - FS is sample rate (samples per second) and length(snd)
%obtains the total number of samples. To get the length we divide 1
%(second) by the number of samples per second and the multiply it by the
%total number of samples we have. The result is the number of seconds of
%the track's duration.
time=round((1/FS)*length(snd),1);

if trackNum == 1
    axes = handles.mainAxes1;
    axesLabels(axes);
    slider = handles.slider1;
    set(handles.insertSlider, 'MAX', time);
    set(handles.insertSlider, 'VALUE', 0);
    set(handles.insertSlider, 'MIN', 0);
elseif trackNum == 2
    axes = handles.mainAxes2;
    axesLabels(axes);
    slider = handles.slider2;
end

t=linspace(0,time,length(snd));
plot(axes,t,snd);
axes.YLabel.String = 'Signal Strength';
axes.XLabel.String = 'Time(Sec)';

set(slider, 'MAX', time);
set(slider, 'VALUE', 0);
set(slider, 'MIN', 0);

function playMonitor(state,handles, song)
%Intends to track when a song has finished and also handle gui timers.
global playing1;
global playing2;
set(song,'TimerFcn',{@timerCallback,song}, 'TimerPeriod', 0.1);
%timer.timerfunction = %insert stuff wat happens
while isplaying(song)
    %timergo
end
%timerstop
if state == 1
    playing1 = false;
    display(playing1);
elseif state ==2
    playing2 = false;
    display(playing2);
end

%c_sample = get(player,'CurrentSample'); - might do something cool if used
%to plot.

function timerUpdate(hObject,event,track, handles)
global time1;
global time2;
if track == 1
    slider = handles.slider1;
    text = handles.sliderText1;
    time = time1;
    time1 = time1 + 0.1;
elseif track == 2
    slider = handles.slider2;
    text = handles.sliderText2;
    time = time2;
    time2 = time2 + 0.1;
end
finalTime = get(slider, 'MAX');
if time < finalTime
    set(slider, 'VALUE', time);
    set(text, 'String', time);
else
    set(slider, 'VALUE', finalTime);
    set(text, 'String', finalTime);
end


function varargout = assignmentGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
hListener = addlistener(handles.slider1,'Value','PostSet',@(s,e) set(handles.sliderText1, 'String', round(handles.slider1.Value, 1)));

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
hListener = addlistener(handles.slider2,'Value','PostSet',@(s,e) set(handles.sliderText2, 'String', round(handles.slider2.Value, 1)));

% --- Executes on slider movement.
function insertSlider_Callback(hObject, eventdata, handles)
hListener = addlistener(handles.insertSlider,'Value','PostSet',@(s,e) set(handles.insertTime, 'String', round(handles.insertSlider.Value, 1)));

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pauseButton1.
function pauseButton1_Callback(hObject, eventdata, handles)
pauseSound(1);

% --- Executes on button press in pauseButton2.
function pauseButton2_Callback(hObject, eventdata, handles)
pauseSound(2);

% --- Executes on button press in playButton1.
function playButton1_Callback(hObject, eventdata, handles)
playSound(1);

% --- Executes on button press in playButton2.
function playButton2_Callback(hObject, eventdata, handles)
playSound(2);

% --- Executes on button press in restartButton1.
function restartButton1_Callback(hObject, eventdata, handles)
% hObject    handle to restartButton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
restartSound(1);

% --- Executes on button press in restartButton2.
function restartButton2_Callback(hObject, eventdata, handles)
% hObject    handle to restartButton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
restartSound(2);

% --- Executes on button press in selectFile1.
function selectFile1_Callback(hObject, eventdata, handles)
loadFile(handles,1);

% --- Executes on button press in selectFile2.
function selectFile2_Callback(hObject, eventdata, handles)
loadFile(handles,2);

% --- Executes on button press in combineButton.
function combineButton_Callback(hObject, eventdata, handles)
global songloaded1;
global songloaded2;
global sound1;
global sound2;
global data1;
global data2;
if get(sound2, 'NumberOfChannels') == 1
    data2 = [data2 data2];
end
if get(sound1, 'NumberOfChannels') == 1
    data1 = [data1 data1];
end
if songloaded1 && songloaded2
    snd1=get(sound1,'TotalSamples');
    FS1=get(sound1,'SampleRate');
   
    snd2=get(sound2,'TotalSamples');
    
    insertTime=round(get(handles.insertSlider,'value')) * FS1;
    display(insertTime);
    if (snd2+insertTime) > snd1
        %add empty sound to track 1 equal to difference.
        toBeAdded = snd2+insertTime-snd1;
        silence = zeros(toBeAdded,2);
        data1 = [data1 ; silence];
    end
        toBeAddedPre = insertTime;
        silencePre = zeros(toBeAddedPre,2);
    if (snd2+insertTime) < snd1
        toBeAddedPost = snd1 - insertTime - snd2;
        silencePost = zeros(toBeAddedPost,2);
        data2Manip = [silencePre ; data2 ; silencePost];
    else
        data2Manip = [silencePre ; data2];
    end
    data1 = data1 + data2Manip;
    sound1 = audioplayer(data1,FS1);
    sound1.StopFcn = {@songEnded, 1, handles};
    set(sound1,'TimerFcn',{@timerUpdate,1, handles}, 'TimerPeriod', 0.1);
    updateUI(data1,FS1,handles,1);
end

% --- Executes during object creation, after setting all properties.
function mainAxes1_CreateFcn(hObject, eventdata, handles)
axesLabels(hObject);

% Hint: place code in OpeningFcn to populate mainAxes1

function axesLabels(hObject)
axes = hObject;
axes.YLabel.String = 'Signal Strength';
axes.XLabel.String = 'Time(Sec)';

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in saveButton1.
function saveButton1_Callback(hObject, eventdata, handles)
global sound1;
global data1;
global songloaded1;
if songloaded1
    folderName = uigetdir('','Select a folder to save into');
    if folderName
        fileName = inputdlg('Enter a file name:',...
                     'choose file name', [1 50]);
        if length(fileName) == 1
            path = strcat(folderName,'\',fileName,'.wav');
                display(path{1});
                %Want to add a check to see if file by that name already exists.
                %doesn't work
                %if fileName == '';
                    %exists fileName folderName;
                %end

                audiowrite(path{1},data1,48000);
        else
            display('box closed');
        end
    end
end

% hObject    handle to saveButton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in test.
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes during object creation, after setting all properties.

global data1;
global songloaded1;
global sound1;
if songloaded1
    display('test called');
    dataTest = flipud(data1);
    sound1 = audioplayer(dataTest,48000);
    display(get(sound1, 'TotalSamples'));
    play(sound1);
end

function insertSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to insertSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function mainAxes2_CreateFcn(hObject, eventdata, handles)
axesLabels(hObject);
% hObject    handle to mainAxes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate mainAxes2


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data1;
global songloaded1;
global sound1;
global playing1;
if songloaded1
    pause(sound1);
    display('box checked');
    data1 = flipud(data1);
    sound1 = audioplayer(data1,48000);
    sound1.StopFcn = {@songEnded, 1, handles};
    set(sound1,'TimerFcn',{@timerUpdate,1, handles}, 'TimerPeriod', 0.1);
    
    if playing1
        playSound(1);
    end
end
% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data2;
global songloaded2;
global sound2;
global playing2;
if songloaded2
    pause(sound2);
    display('box checked');
    data2 = flipud(data2);
    sound2 = audioplayer(data2,48000);
    sound2.StopFcn = {@songEnded, 2, handles};
    set(sound2,'TimerFcn',{@timerUpdate,2, handles}, 'TimerPeriod', 0.1);
    
    if playing2
        playSound(2);
    end
end
% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in loop1.
function loop1_Callback(hObject, eventdata, handles)
% hObject    handle to loop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loop1


% --- Executes on button press in loop2.
function loop2_Callback(hObject, eventdata, handles)
% hObject    handle to loop2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loop2
