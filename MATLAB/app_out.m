classdef app_out < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        VoltageEditField                matlab.ui.control.NumericEditField
        VoltageEditFieldLabel           matlab.ui.control.Label
        FrequencyEditField              matlab.ui.control.NumericEditField
        FrequencyEditFieldLabel         matlab.ui.control.Label
        NoiseLabel                      matlab.ui.control.Label
        Switch                          matlab.ui.control.Switch
        MaximumFrequencyEditFieldLabel_3  matlab.ui.control.Label
        MaximumFrequencyEditFieldLabel  matlab.ui.control.Label
        AcquireButton                   matlab.ui.control.Button
        UIAxes                          matlab.ui.control.UIAxes
    end
    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
        end
        % Button pushed function: AcquireButton
        function AcquireButtonPushed(app, event)

            
            frequency=(get(app.FrequencyEditField,'Value'))

            voltage = (get(app.VoltageEditField,'Value'));
            Noise  = (get(app.Switch,'Value'));
            [timelist,pointin] = BodePlotFunc(app, frequency,voltage,Noise);

            plot(app.UIAxes,timelist,pointin)
        end

        % Value changed function: FrequencyEditField
        function FrequencyEditFieldValueChanged(app, event)
            value = app.FrequencyEditField.Value;
            
        end


        % Value changed function: VoltageEditField
        function VoltageEditFieldValueChanged(app, event)
            value = app.VoltageEditField.Value;
            
        end

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
            value = app.Switch.Value;
            
        end


    end
    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 617 482];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Output of Oscilloscope')
            xlabel(app.UIAxes, 'Time (s)')
            ylabel(app.UIAxes, 'Voltage (V)')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [52 60 516 261];

            % Create AcquireButton
            app.AcquireButton = uibutton(app.UIFigure, 'push');
            app.AcquireButton.ButtonPushedFcn = createCallbackFcn(app, @AcquireButtonPushed, true);
            app.AcquireButton.Position = [410 363 124 31];
            app.AcquireButton.Text = 'Acquire';

            % Create MaximumFrequencyEditFieldLabel
            app.MaximumFrequencyEditFieldLabel = uilabel(app.UIFigure);
            app.MaximumFrequencyEditFieldLabel.HorizontalAlignment = 'center';
            app.MaximumFrequencyEditFieldLabel.Position = [286 400 36 22];
            app.MaximumFrequencyEditFieldLabel.Text = 'Hz';

            % Create MaximumFrequencyEditFieldLabel_3
            app.MaximumFrequencyEditFieldLabel_3 = uilabel(app.UIFigure);
            app.MaximumFrequencyEditFieldLabel_3.HorizontalAlignment = 'center';
            app.MaximumFrequencyEditFieldLabel_3.Position = [286 363 36 22];
            app.MaximumFrequencyEditFieldLabel_3.Text = 'V';

            % Create Switch
            app.Switch = uiswitch(app.UIFigure, 'slider');
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.Position = [525 401 45 20];
            app.Switch.Value = 'Off';

            % Create NoiseLabel
            app.NoiseLabel = uilabel(app.UIFigure);
            app.NoiseLabel.HorizontalAlignment = 'center';
            app.NoiseLabel.Position = [351 400 127 22];
            app.NoiseLabel.Text = 'Noise Reduce';

            % Create FrequencyEditFieldLabel
            app.FrequencyEditFieldLabel = uilabel(app.UIFigure);
            app.FrequencyEditFieldLabel.HorizontalAlignment = 'center';
            app.FrequencyEditFieldLabel.Position = [42 400 127 22];
            app.FrequencyEditFieldLabel.Text = 'Frequency';

            % Create FrequencyEditField
            app.FrequencyEditField = uieditfield(app.UIFigure, 'numeric');
            app.FrequencyEditField.Limits = [0 10000000];
            app.FrequencyEditField.ValueDisplayFormat = '%8.f';
            app.FrequencyEditField.ValueChangedFcn = createCallbackFcn(app, @FrequencyEditFieldValueChanged, true);
            app.FrequencyEditField.HorizontalAlignment = 'center';
            app.FrequencyEditField.Position = [191 400 96 22];
            app.FrequencyEditField.Value = 1000;

            % Create VoltageEditFieldLabel
            app.VoltageEditFieldLabel = uilabel(app.UIFigure);
            app.VoltageEditFieldLabel.HorizontalAlignment = 'center';
            app.VoltageEditFieldLabel.VerticalAlignment = 'top';
            app.VoltageEditFieldLabel.Position = [42 362 127 22];
            app.VoltageEditFieldLabel.Text = 'Voltage(Vpp)';

            % Create VoltageEditField
            app.VoltageEditField = uieditfield(app.UIFigure, 'numeric');
            app.VoltageEditField.Limits = [0.001 1000];
            app.VoltageEditField.ValueChangedFcn = createCallbackFcn(app, @VoltageEditFieldValueChanged, true);
            app.VoltageEditField.HorizontalAlignment = 'center';
            app.VoltageEditField.Position = [191 363 96 22];
            app.VoltageEditField.Value = 5;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app_out

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end



function [timelist,pointin] = BodePlotFunc(app, frequency,voltage,Noise)
%% Instrument Connection

% Assumes channel one connected to Aux Out
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

fprintf(obj1,'WGENerator:FUNCtion SINusoid')
fprintf(obj1,['WGENerator:FREQuency ' num2str(frequency)]);
fprintf(obj1,['WGENerator:VOLTage ' num2str(voltage)]);
fprintf(obj1,'WGENerator:OUTPut:LOAD HIGHz')
fprintf(obj1,'WGENerator:OUTPut ON')
fprintf(obj1,'AUToscale'); 
pause(3)
%% Adjust the vertical axis so that the waveform is 75% of the screen.
fprintf(obj1,'MEASurement1:ON');
fprintf(obj1,'MEASurement1:SOURce CH1'); 
fprintf(obj1,'MEASurement1:MAIN PEAK'); 
fprintf(obj1,'MEASurement1:STATistics ON');
pause(1) 
fprintf(obj1,'MEASurement1:RESult:AVG?');
test = fscanf(obj1);
verticalrange = 1.25 * str2double(test);
pause(1)
fprintf(obj1,['CHANnel1:RANGe ' num2str(verticalrange)]); 
fprintf(obj1,'MEASurement1 OFF');
%% Adjust the timespan axis so that have 3 peroid     
timespan1 = (1 / frequency) * 3; 
fprintf(obj1,['TIMebase:SCALe ' num2str(timespan1/12)]); %Set timescale 
%% WAVEFORM acquisition
fprintf(obj1,'EXPORT:WAVeform:SOURce CH1');
pause(1) 

%% Noise option
if strcmp(Noise,'On')
    fprintf(obj1,['CHANnel1:BANDwidth B20']);        
end
%% x axis set

fprintf(obj1,'FORMat[:DATA] UINT,8'); % set transfer format to a byte(this changes the output format from FLT to BIN)
pause(1)

fprintf(obj1,'CHANnel1:DATA:XINCrement?'); % Time between data points
pause(1)
xinc = fscanf(obj1,'%f'); 
pause(1)

fprintf(obj1,'CHANnel1:DATA:XORigin?'); % origin of the time axis
pause(1)
xorg = fscanf(obj1,'%f'); 

%% Y-axis set
fprintf(obj1,'FORMat[:DATA] UINT,16'); % resolution: WORD
pause(1)
fprintf(obj1,'FORMat:BORDer LSBFirst') %LSB come first

%% Setting output

fprintf(obj1,'SING;*OPC?') %Start single acquisition
fprintf(obj1,'CHANnel1:DATA:HEAD?') %Output header which will give information about output waveform
headdata=fscanf(obj1);
headdata=regexp(headdata, ',', 'split');

bin_size=obj1.InputBufferSize;
L=str2double(headdata(3));%Identify the number of data points

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


end
