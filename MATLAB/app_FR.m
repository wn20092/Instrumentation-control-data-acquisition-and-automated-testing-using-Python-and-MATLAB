classdef app_FR < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        EditField_3                     matlab.ui.control.EditField
        EditField_3Label                matlab.ui.control.Label
        EditField_2                     matlab.ui.control.EditField
        EditField_2Label                matlab.ui.control.Label
        NoiseLabel                      matlab.ui.control.Label
        Switch                          matlab.ui.control.Switch
        MaximumFrequencyEditFieldLabel_4  matlab.ui.control.Label
        MaximumFrequencyEditFieldLabel_3  matlab.ui.control.Label
        MaximumFrequencyEditFieldLabel_2  matlab.ui.control.Label
        AcquireButton                   matlab.ui.control.Button
        VoltageEditField                matlab.ui.control.NumericEditField
        VoltageEditFieldLabel           matlab.ui.control.Label
        NumberofDataPointsEditField     matlab.ui.control.NumericEditField
        NumberofDataPointsEditFieldLabel  matlab.ui.control.Label
        MinimumFrequencyEditField       matlab.ui.control.NumericEditField
        MinimumFrequencyEditFieldLabel  matlab.ui.control.Label
        MaximumFrequencyEditField       matlab.ui.control.NumericEditField
        MaximumFrequencyEditFieldLabel  matlab.ui.control.Label
        UIAxes_3                        matlab.ui.control.UIAxes
        UIAxes_1                        matlab.ui.control.UIAxes
        UIAxes_2                        matlab.ui.control.UIAxes
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
        end

        % Button pushed function: AcquireButton
        function AcquireButtonPushed(app, event)

            freqMaxInput=(get(app.MaximumFrequencyEditField,'Value'))
            freqMinInput=(get(app.MinimumFrequencyEditField,'Value'))
       
            freqMax = log10(freqMaxInput); % Convert frequency limits into log10 form
            freqMin = log10(freqMinInput);
            
            numberOfDataPoints = (get(app.NumberofDataPointsEditField,'Value'))
            voltage = (get(app.VoltageEditField,'Value'))
            Noise  = (get(app.Switch,'Value'))
            
            [printFreqs,List1,List2]=BodePlotFunc(app, freqMax,freqMin,numberOfDataPoints,voltage,Noise) %Run Bode Plot function and pass through variables
            
            H_amp_dB = 20*log10(List1);
            
            % Plot magnitude of transfer function
            semilogx(app.UIAxes_1,printFreqs,List1);
            
            % Plot magnitude of transfer function in dB
            semilogx(app.UIAxes_2,printFreqs,H_amp_dB);
            
            % Plot phase difference
            semilogx(app.UIAxes_3,printFreqs,List2);

        end

        % Value changed function: VoltageEditField
        function VoltageEditFieldValueChanged(app, event)
            value = app.VoltageEditField.Value;
            
        end

        % Value changed function: NumberofDataPointsEditField
        function NumberofDataPointsEditFieldValueChanged(app, event)
            value = app.NumberofDataPointsEditField.Value;
            
        end

        % Value changed function: MinimumFrequencyEditField
        function MinimumFrequencyEditFieldValueChanged(app, event)
            value = app.MinimumFrequencyEditField.Value;
            
        end

        % Value changed function: MaximumFrequencyEditField
        function MaximumFrequencyEditFieldValueChanged(app, event)
            value = app.MaximumFrequencyEditField.Value;
            
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
            app.UIFigure.Position = [100 100 673 518];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.UIFigure);
            title(app.UIAxes_2, {'Magnitude of the transfer function in dB'; ''})
            xlabel(app.UIAxes_2, 'Frequency (Hz)')
            ylabel(app.UIAxes_2, 'dB')
            zlabel(app.UIAxes_2, 'Z')
            app.UIAxes_2.Position = [332 269 278 173];
            app.UIAxes_2.XGrid = 'on';
            app.UIAxes_2.YGrid = 'on';

            % Create UIAxes_1
            app.UIAxes_1 = uiaxes(app.UIFigure);
            title(app.UIAxes_1, {'Magnitude of the transfer function'; ''})
            xlabel(app.UIAxes_1, 'Frequency (Hz)')
            zlabel(app.UIAxes_1, 'Z')
            app.UIAxes_1.Position = [19 44 278 173];
            app.UIAxes_1.XGrid = 'on';
            app.UIAxes_1.YGrid = 'on';
            % Create UIAxes_3
            app.UIAxes_3 = uiaxes(app.UIFigure);
            title(app.UIAxes_3, {'Phase of the transfer function in degrees'; ''})
            xlabel(app.UIAxes_3, 'Frequency (Hz)')
            ylabel(app.UIAxes_3, 'degrees')
            zlabel(app.UIAxes_3, 'Z')
            app.UIAxes_3.Position = [331 44 278 173];
            app.UIAxes_3.XGrid = 'on';
            app.UIAxes_3.YGrid = 'on';
            % Create MaximumFrequencyEditFieldLabel
            app.MaximumFrequencyEditFieldLabel = uilabel(app.UIFigure);
            app.MaximumFrequencyEditFieldLabel.HorizontalAlignment = 'center';
            app.MaximumFrequencyEditFieldLabel.Position = [42 428 127 22];
            app.MaximumFrequencyEditFieldLabel.Text = 'Maximum Frequency';

            % Create MaximumFrequencyEditField
            app.MaximumFrequencyEditField = uieditfield(app.UIFigure, 'numeric');
            app.MaximumFrequencyEditField.Limits = [0 10000000];
            app.MaximumFrequencyEditField.ValueDisplayFormat = '%8.f';
            app.MaximumFrequencyEditField.ValueChangedFcn = createCallbackFcn(app, @MaximumFrequencyEditFieldValueChanged, true);
            app.MaximumFrequencyEditField.HorizontalAlignment = 'center';
            app.MaximumFrequencyEditField.Position = [191 428 96 22];
            app.MaximumFrequencyEditField.Value = 10000;

            % Create MinimumFrequencyEditFieldLabel
            app.MinimumFrequencyEditFieldLabel = uilabel(app.UIFigure);
            app.MinimumFrequencyEditFieldLabel.HorizontalAlignment = 'center';
            app.MinimumFrequencyEditFieldLabel.Position = [42 395 127 22];
            app.MinimumFrequencyEditFieldLabel.Text = 'Minimum Frequency';

            % Create MinimumFrequencyEditField
            app.MinimumFrequencyEditField = uieditfield(app.UIFigure, 'numeric');
            app.MinimumFrequencyEditField.Limits = [1.001 1000];
            app.MinimumFrequencyEditField.ValueChangedFcn = createCallbackFcn(app, @MinimumFrequencyEditFieldValueChanged, true);
            app.MinimumFrequencyEditField.HorizontalAlignment = 'center';
            app.MinimumFrequencyEditField.Position =  [191 395 96 22];
            app.MinimumFrequencyEditField.Value = 100;

            % Create NumberofDataPointsEditFieldLabel
            app.NumberofDataPointsEditFieldLabel = uilabel(app.UIFigure);
            app.NumberofDataPointsEditFieldLabel.HorizontalAlignment = 'center';
            app.NumberofDataPointsEditFieldLabel.Position = [42 327 127 22];
            app.NumberofDataPointsEditFieldLabel.Text = 'Number of Data Points';

            % Create NumberofDataPointsEditField
            app.NumberofDataPointsEditField = uieditfield(app.UIFigure, 'numeric');
            app.NumberofDataPointsEditField.Limits = [0.001 100];
            app.NumberofDataPointsEditField.ValueChangedFcn = createCallbackFcn(app, @NumberofDataPointsEditFieldValueChanged, true);
            app.NumberofDataPointsEditField.HorizontalAlignment = 'center';
            app.NumberofDataPointsEditField.Position = [191 327 96 22];
            app.NumberofDataPointsEditField.Value = 10;

            % Create VoltageEditFieldLabel
            app.VoltageEditFieldLabel = uilabel(app.UIFigure);
            app.VoltageEditFieldLabel.HorizontalAlignment = 'center';
            app.VoltageEditFieldLabel.VerticalAlignment = 'top';
            app.VoltageEditFieldLabel.Position = [42 361 127 22];
            app.VoltageEditFieldLabel.Text = 'Voltage';

            % Create VoltageEditField
            app.VoltageEditField = uieditfield(app.UIFigure, 'numeric');
            app.VoltageEditField.Limits = [0.001 1000];
            app.VoltageEditField.ValueChangedFcn = createCallbackFcn(app, @VoltageEditFieldValueChanged, true);
            app.VoltageEditField.HorizontalAlignment = 'center';
            app.VoltageEditField.Position = [191 361 96 22];
            app.VoltageEditField.Value = 5;

            % Create AcquireButton
            app.AcquireButton = uibutton(app.UIFigure, 'push');
            app.AcquireButton.ButtonPushedFcn = createCallbackFcn(app, @AcquireButtonPushed, true);
            app.AcquireButton.Position = [126 245 91 31];
            app.AcquireButton.Text = 'Acquire';
            % Create MaximumFrequencyEditFieldLabel_2
            app.MaximumFrequencyEditFieldLabel_2 = uilabel(app.UIFigure);
            app.MaximumFrequencyEditFieldLabel_2.HorizontalAlignment = 'center';
            app.MaximumFrequencyEditFieldLabel_2.Position = [286 428 36 22];
            app.MaximumFrequencyEditFieldLabel_2.Text = 'Hz';

            % Create MaximumFrequencyEditFieldLabel_3
            app.MaximumFrequencyEditFieldLabel_3 = uilabel(app.UIFigure);
            app.MaximumFrequencyEditFieldLabel_3.HorizontalAlignment = 'center';
            app.MaximumFrequencyEditFieldLabel_3.Position = [286 395 36 22];
            app.MaximumFrequencyEditFieldLabel_3.Text = 'Hz';

            % Create MaximumFrequencyEditFieldLabel_4
            app.MaximumFrequencyEditFieldLabel_4 = uilabel(app.UIFigure);
            app.MaximumFrequencyEditFieldLabel_4.HorizontalAlignment = 'center';
            app.MaximumFrequencyEditFieldLabel_4.Position = [286 361 36 22];
            app.MaximumFrequencyEditFieldLabel_4.Text = 'V';

            % Create Switch
            app.Switch = uiswitch(app.UIFigure, 'slider');
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.Position = [216 290 45 20];
            app.Switch.Value = 'Off';
            % Create NoiseLabel
            app.NoiseLabel = uilabel(app.UIFigure);
            app.NoiseLabel.HorizontalAlignment = 'center';
            app.NoiseLabel.Position = [42 289 127 22];
            app.NoiseLabel.Text = 'Noise Reduce';

            % Create EditField_2Label
            app.EditField_2Label = uilabel(app.UIFigure);
            app.EditField_2Label.HorizontalAlignment = 'right';
            app.EditField_2Label.Visible = 'off';
            app.EditField_2Label.Position = [216 249 56 22];
            app.EditField_2Label.Text = 'Edit Field';            
            % Create EditField_2
            app.EditField_2 = uieditfield(app.UIFigure, 'text');
            app.EditField_2.Visible = 'off';
            app.EditField_2.Position = [287 249 10 22];

            % Create EditField_3Label
            app.EditField_3Label = uilabel(app.UIFigure);
            app.EditField_3Label.HorizontalAlignment = 'right';
            app.EditField_3Label.Visible = 'off';
            app.EditField_3Label.Position = [42 249 56 22];
            app.EditField_3Label.Text = 'Edit Field';

            % Create EditField_3
            app.EditField_3 = uieditfield(app.UIFigure, 'text');
            app.EditField_3.Visible = 'off';
            app.EditField_3.Position = [113 249 10 22];
            
            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app_FR

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

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


function [printFreqs1, H2, phaseOutput]=BodePlotFunc(app, freqMax,freqMin,numberOfDataPoints,voltage,Noise)
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

% Connect to instrument object, obj1.

fopen(obj1);

%% Instrument Configuration and Control
fprintf(obj1,'*RST') % reset scope

fprintf(obj1,'CHAN1:STAT ON')
fprintf(obj1,'CHAN2:STAT ON') % turn off Channel 2,3 and 4
fprintf(obj1,'CHAN3:STAT OFF') 
fprintf(obj1,'CHAN4:STAT OFF') 

fprintf(obj1,'DCL'); % *DCL and *CLS clear status registers and output queue
fprintf(obj1,'*CLS');

%% Obtaining Data
fprintf(obj1,'WGENerator:FUNCtion SINusoid')
fprintf(obj1,'WGENerator:OUTPut:LOAD HIGHz') 
fprintf(obj1,'WGENerator:OUTPut ON')

freqs = logspace(freqMin,freqMax,numberOfDataPoints); %Create a log space list of frequencies
fprintf(obj1,['WGENerator:VOLTage ' num2str(voltage)]);
printFreqs1 = [];
H2 = [];
phaseOutput = [];

for i = 1:1:length(freqs) %Iterate through every frequency and record values for each frequency
  
    fprintf(obj1,['WGENerator:FREQuency ' num2str(freqs(i))]); % Set the current frequency 
    pause(3)
    fprintf(obj1,'AUToscale');
    pause(4)

    setyscale(obj1); %function to Set the trigger level
    timespan1 = (1 / freqs(i)) * 3; %Set timescale of oscilloscope 
    fprintf(obj1,['TIMebase:SCALe ' num2str(timespan1/12)]); 
    pause(2) 

    if strcmp(Noise,'On') %Noise option
        fprintf(obj1,['CHANnel1:BANDwidth B20']);
        fprintf(obj1,['CHANnel2:BANDwidth B20']);         
    end

    [VppOut,VppIn,phase]=measurevolts(obj1);
    printFreqs = freqs(i);
    H = VppOut / VppIn;
    printFreqs1 = [printFreqs1 ; printFreqs];
    H2 = [H2 ; H];
    phaseOutput = [phaseOutput,phase];
end                   

function autoScale(obj1, channel) 
    channel = num2str(channel);
    fprintf(obj1,['CHAN' channel ':OFFset 0']);
    pause(0.5)
    fprintf(obj1,['TRIGger:A:SOURce CH' channel]);    
    fprintf(obj1,'TRIGger:A:TYPE EDGE'); % Set positive edge trigger
    fprintf(obj1,'TRIGger:A:EDGE:SLOpe POSitive'); 
    fprintf(obj1,['TRIGger:A:FINDlevel']);% Set the trigger level
    pause(0.5)
end

function setyscale(obj1) 
    autoScale(obj1, '1') % autoscale channel 1
    autoScale(obj1, '2') % autoscale channel 2
end


function [Vpout,Vpin,phase]=measurevolts(obj1) 
    
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
     pause(1)
     pause(1) 
     fprintf(obj1,'MEASurement2:RESult:AVG?');
     pause(2) 

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
     phase_data = fscanf(obj1);
     phase = str2double(phase_data);
     pause(1)
end

end