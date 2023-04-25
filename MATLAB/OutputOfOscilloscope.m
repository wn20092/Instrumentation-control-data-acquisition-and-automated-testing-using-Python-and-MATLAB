 clear all

%% Instrument Connection

% Find a VISA-TCPIP object.
obj1 = instrfind('Type', 'visa-tcpip', 'RsrcName', 'TCPIP0::192.168.1.2::inst0::INSTR', 'Tag', '');
% Create the VISA-TCPIP object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = visa('KEYSIGHT', 'TCPIP0::192.168.1.2::inst0::INSTR');
else
    fclose(obj1);
    obj1 = obj1(1);
end

fopen(obj1);
%% Instrument Configuration and Control
fprintf(obj1,'*RST') % reset scope
fprintf(obj1,'CHAN2:STAT OFF') % turn off Channel 2,3 and 4
fprintf(obj1,'CHAN3:STAT OFF') 
fprintf(obj1,'CHAN4:STAT OFF') 
fprintf(obj1,'CHAN1:STAT ON') % turn on Channel 1

fprintf(obj1,'DCL'); % *DCL and *CLS clear status registers and output queue
fprintf(obj1,'*CLS');
%% Set the Voltage, frequency
fprintf(obj1,'WGENerator:FUNCtion SINusoid')
frequency = 1000000;
fprintf(obj1,['WGENerator:FREQuency ' num2str(frequency)]);
Vpp = 5; 
fprintf(obj1,['WGENerator:VOLTage ' num2str(Vpp)]);
fprintf(obj1,'WGENerator:OUTPut:LOAD HIGHz')
fprintf(obj1,'WGENerator:OUTPut ON')
fprintf(obj1,'AUToscale'); 
pause(4) % Wait for the instrument to get ready

%% Adjust the vertical axis so that the waveform is 75% of the screen.
fprintf(obj1,'MEASurement1:ON'); % Measure channel 1
fprintf(obj1,'MEASurement1:SOURce CH1'); 
fprintf(obj1,'MEASurement1:MAIN PEAK'); % Set to measure peak voltage
fprintf(obj1,'MEASurement1:STATistics ON');
pause(1) % Wait for the instrument to get ready
fprintf(obj1,'MEASurement1:RESult:AVG?');
test = fscanf(obj1);
verticalrange = 1.25 * str2double(test);
pause(1)
fprintf(obj1,['CHANnel1:RANGe ' num2str(verticalrange)]); 
fprintf(obj1,'MEASurement1 OFF');

%% Adjust the timespan axis so that have 3 peroid
timespan1 = (1 / frequency) * 3; 
fprintf(obj1,['TIMebase:SCALe ' num2str(timespan1/12)]); 
pause(1)

%%  WAVEFORM acquisition
fprintf(obj1,'EXPORT:WAVeform:SOURce CH1'); % specify that the waveform data and source is channel 1
pause(1) % Wait for the instrument to get ready

fprintf(obj1,'FORMat[:DATA] UINT,8'); % set transfer format to a byte(this changes the output format from FLT to BIN)
pause(1)

fprintf(obj1,'CHANnel1:DATA:XINCrement?'); % Time between data points
pause(1)

xinc = fscanf(obj1,'%f'); % stored it
pause(1)

fprintf(obj1,'CHANnel1:DATA:XORigin?'); % find the first point
pause(1)

xorg = fscanf(obj1,'%f'); % and store the response in the variable xorg


fprintf(obj1,'FORMat[:DATA] UINT,16'); % the Y-axis 
pause(1)
fprintf(obj1,'FORMat:BORDer LSBFirst') %each data point will be the Least Significant Byte (LSB) will come first

%% Set output

fprintf(obj1,'SING;*OPC?') %Start single acquisition

fprintf(obj1,'CHANnel1:DATA:HEAD?') %Output header 
headdata=fscanf(obj1);
headdata=regexp(headdata, ',', 'split');

bin_size=obj1.InputBufferSize;
L=str2double(headdata(3)); %Identify the number of data points

fprintf(obj1,'CHANnel1:DATA?'); %Request the data
pointin=[]; %Create a character array

%% Reading output

while L > 0
    currentData = fread(obj1, bin_size, 'char'); %read the buffer
    points=convertCharsToStrings(char(currentData')); %Convert list to character and transpose
    C = str2double(regexp(points, ',', 'split'));
    numOfPoints = length(C);
    C = C(2:end-1);
    pointin=[pointin,C];
    L = L-numOfPoints;
end    

timelist=xorg:xinc:xinc*length(pointin)+xorg-xinc; 

%% Plotting waveform
plot(timelist,pointin) 
title('Output of Oscilloscope')
ylabel('Voltage (V)')
xlabel('Time (s)')
grid

fclose(obj1);


