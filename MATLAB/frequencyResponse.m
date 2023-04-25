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

% Connect to instrument object, obj1.

fopen(obj1);

%% Instrument Configuration and Control
fprintf(obj1,'*RST') % reset scope

fprintf(obj1,'CHAN1:STAT ON') % turn on Channel 1 and 2
fprintf(obj1,'CHAN2:STAT ON') 
fprintf(obj1,'CHAN3:STAT OFF') % turn off Channel 3 and 4
fprintf(obj1,'CHAN4:STAT OFF') 

fprintf(obj1,'DCL'); % *DCL and *CLS clear status registers and output queue
fprintf(obj1,'*CLS');

%% Obtaining Data
fprintf(obj1,'WGENerator:FUNCtion SINusoid')
fprintf(obj1,'WGENerator:OUTPut:LOAD HIGHz') 
fprintf(obj1,'WGENerator:OUTPut ON')

freqMax = 5; % 10^6
freqMin = 3; % 10^3
numberOfDataPoints = 29; %define the inital number of data points to be taken 
freqs = logspace(freqMin,freqMax,numberOfDataPoints) %Create a log space list of frequencies

Vpp = 5;
fprintf(obj1,['WGENerator:VOLTage ' num2str(Vpp)]);

printFreqs1 = [];
H2 = [];
phaseOutput = [];

for i = 1:1:length(freqs) %Iterate through each frequency and record the value of each frequency
  
    fprintf(obj1,['WGENerator:FREQuency ' num2str(freqs(i))]); % Set the current frequency 
    pause(3)
    fprintf(obj1,'AUToscale');
    pause(4)

    setyscale(obj1); %function to Set the trigger level
    timespan1 = (1 / freqs(i)) * 3; %Set timescale of oscilloscope 
    fprintf(obj1,['TIMebase:SCALe ' num2str(timespan1/12)]); 
    pause(2) 

    [VppOut,VppIn,phase]=measurevolts(obj1);
    printFreqs = freqs(i);
    H = VppOut / VppIn;
    printFreqs1 = [printFreqs1 ; printFreqs];
    H2 = [H2 ; H];
    phaseOutput = [phaseOutput,phase];
end


figure  
semilogx(printFreqs1,H2); 
xlabel('Frequency (Hz)')
grid;
title('Magnitude of the transfer function')

% Plot magnitude of transfer function in dB
H_amp_dB = 20*log10(H2); 
figure
semilogx(printFreqs1,H_amp_dB);
ylabel('dB')
xlabel('Frequency (Hz)')
grid;
title('Magnitude of the transfer function in dB')

% Plot phase 
figure
semilogx(printFreqs1,phaseOutput);
xlabel('Frequency (Hz)')
ylabel('deg')
grid;
title('Phase of the transfer function in degrees')

function autoScale(obj1, channel) 
    channel = num2str(channel);
    fprintf(obj1,['CHAN' channel ':OFFset 0']);
    pause(0.5)
    fprintf(obj1,['TRIGger:A:SOURce CH' channel]); 
    
    fprintf(obj1,'TRIGger:A:TYPE EDGE'); % Set positive edge trigger (page 319)
    fprintf(obj1,'TRIGger:A:EDGE:SLOpe POSitive'); 

    fprintf(obj1,'TRIGger:A:FINDlevel' );% Set the trigger level
    pause(0.5)
    
end

function setyscale(obj1) 
    autoScale(obj1, '1') % autoscale channel 1
    autoScale(obj1, '2') % autoscale channel 2
end


function [Vpout,Vpin,phase]=measurevolts(obj1) %function to measure average peak to peak voltages 
    
     %Measure Vin
     fprintf(obj1,'MEASurement1:ON');
     fprintf(obj1,'MEASurement1:SOURce CH1'); 
     fprintf(obj1,'MEASurement1:MAIN PEAK'); 
     fprintf(obj1,'MEASurement1:STATistics ON');
     pause(1) 
     fprintf(obj1,'MEASurement1:RESult:AVG?');
     test = fscanf(obj1);
     verticalrange = 1.25 * str2double(test);
     pause(1)

    %Adjusting the size of the vertical axis
     fprintf(obj1,['CHANnel1:RANGe ' num2str(verticalrange)]); 
     pause(2)
     fprintf(obj1,'MEASurement1:RESult:AVG?');
     pause(2)

     %store Vin
     vin = fscanf(obj1);
     Vpin = str2double(vin);
     pause(1)

     %Measure Vout
     fprintf(obj1,'MEASurement2:ON');
     fprintf(obj1,'MEASurement2:SOURce CH2'); 
     fprintf(obj1,'MEASurement2:MAIN PEAK');
     fprintf(obj1,'MEASurement2:STATistics ON');
     pause(1)
     fprintf(obj1,'MEASurement2:RESult:AVG?');
     test2 = fscanf(obj1);
     verticalrange2 = 1.25 * str2double(test2);

     fprintf(obj1,['CHANnel2:RANGe ' num2str(verticalrange2)]);
     pause(2)
     fprintf(obj1,'MEASurement2:RESult:AVG?');
     pause(2)

     %store Vout
     vout = fscanf(obj1);
     Vpout = str2double(vout);
     pause(1)

     %Measure phase
     fprintf(obj1,'MEASurement3:ON');
     fprintf(obj1,'MEASurement3:SOURce CH2,CH1'); %Set sources to be C2-C1 
     fprintf(obj1,'MEASurement3:MAIN PHASe'); 
     pause(2) 
     fprintf(obj1,'MEASurement3:RESult:AVG?'); 
     pause(2)
     phase_data = fscanf(obj1)
     phase = str2double(phase_data);
     pause(1)
end


