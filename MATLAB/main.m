classdef main < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        EditField_4                     matlab.ui.control.NumericEditField
        EditField_4Label                matlab.ui.control.Label
        EditField_3                     matlab.ui.control.NumericEditField
        EditField_3Label                matlab.ui.control.Label
        EditField_2                     matlab.ui.control.NumericEditField
        EditField_2Label                matlab.ui.control.Label
        EditField                       matlab.ui.control.NumericEditField
        EditFieldLabel                  matlab.ui.control.Label
        ClickonthebuttonbelowtoselectthefunctionyouwantLabel  matlab.ui.control.Label
        OutputPlotofOscilloscopeButton  matlab.ui.control.Button
        AutomaticacquisitionFrequencyResponseandPhasePlotButton  matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: 
        % AutomaticacquisitionFrequencyResponseandPhasePlotButton
        function AutomaticacquisitionFrequencyResponseandPhasePlotButtonPushed(app, event)
             app_FR;
        end

        % Button pushed function: OutputPlotofOscilloscopeButton
        function OutputPlotofOscilloscopeButtonPushed(app, event)
            app_out;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create AutomaticacquisitionFrequencyResponseandPhasePlotButton
            app.AutomaticacquisitionFrequencyResponseandPhasePlotButton = uibutton(app.UIFigure, 'push');
            app.AutomaticacquisitionFrequencyResponseandPhasePlotButton.ButtonPushedFcn = createCallbackFcn(app, @AutomaticacquisitionFrequencyResponseandPhasePlotButtonPushed, true);
            app.AutomaticacquisitionFrequencyResponseandPhasePlotButton.WordWrap = 'on';
            app.AutomaticacquisitionFrequencyResponseandPhasePlotButton.BackgroundColor = [0.0118 0.3294 0.5882];
            app.AutomaticacquisitionFrequencyResponseandPhasePlotButton.FontSize = 20;
            app.AutomaticacquisitionFrequencyResponseandPhasePlotButton.FontColor = [0.902 0.902 0.902];
            app.AutomaticacquisitionFrequencyResponseandPhasePlotButton.Position = [209 234 224 81];
            app.AutomaticacquisitionFrequencyResponseandPhasePlotButton.Text = 'Automatic acquisition Frequency Response and Phase Plot';

            % Create OutputPlotofOscilloscopeButton
            app.OutputPlotofOscilloscopeButton = uibutton(app.UIFigure, 'push');
            app.OutputPlotofOscilloscopeButton.ButtonPushedFcn = createCallbackFcn(app, @OutputPlotofOscilloscopeButtonPushed, true);
            app.OutputPlotofOscilloscopeButton.WordWrap = 'on';
            app.OutputPlotofOscilloscopeButton.BackgroundColor = [0.9098 0.3882 0.0392];
            app.OutputPlotofOscilloscopeButton.FontSize = 20;
            app.OutputPlotofOscilloscopeButton.FontColor = [0.902 0.902 0.902];
            app.OutputPlotofOscilloscopeButton.Position = [209 128 224 64];
            app.OutputPlotofOscilloscopeButton.Text = 'Output Plot of Oscilloscope';

            % Create ClickonthebuttonbelowtoselectthefunctionyouwantLabel
            app.ClickonthebuttonbelowtoselectthefunctionyouwantLabel = uilabel(app.UIFigure);
            app.ClickonthebuttonbelowtoselectthefunctionyouwantLabel.WordWrap = 'on';
            app.ClickonthebuttonbelowtoselectthefunctionyouwantLabel.FontSize = 18;
            app.ClickonthebuttonbelowtoselectthefunctionyouwantLabel.FontWeight = 'bold';
            app.ClickonthebuttonbelowtoselectthefunctionyouwantLabel.FontColor = [0 0.1176 0.4235];
            app.ClickonthebuttonbelowtoselectthefunctionyouwantLabel.Position = [50 350 308 70];
            app.ClickonthebuttonbelowtoselectthefunctionyouwantLabel.Text = 'Click on the button below to select the function you want:';

            % Create EditFieldLabel
            app.EditFieldLabel = uilabel(app.UIFigure);
            app.EditFieldLabel.HorizontalAlignment = 'right';
            app.EditFieldLabel.Visible = 'off';
            app.EditFieldLabel.Position = [26 263 56 22];
            app.EditFieldLabel.Text = 'Edit Field';

            % Create EditField
            app.EditField = uieditfield(app.UIFigure, 'numeric');
            app.EditField.Visible = 'off';
            app.EditField.Position = [97 263 100 22];

            % Create EditField_2Label
            app.EditField_2Label = uilabel(app.UIFigure);
            app.EditField_2Label.HorizontalAlignment = 'right';
            app.EditField_2Label.Visible = 'off';
            app.EditField_2Label.Position = [26 149 56 22];
            app.EditField_2Label.Text = 'Edit Field';

            % Create EditField_2
            app.EditField_2 = uieditfield(app.UIFigure, 'numeric');
            app.EditField_2.Visible = 'off';
            app.EditField_2.Position = [97 149 100 22];

            % Create EditField_3Label
            app.EditField_3Label = uilabel(app.UIFigure);
            app.EditField_3Label.HorizontalAlignment = 'right';
            app.EditField_3Label.Visible = 'off';
            app.EditField_3Label.Position = [452 263 56 22];
            app.EditField_3Label.Text = 'Edit Field';

            % Create EditField_3
            app.EditField_3 = uieditfield(app.UIFigure, 'numeric');
            app.EditField_3.Visible = 'off';
            app.EditField_3.Position = [523 263 100 22];

            % Create EditField_4Label
            app.EditField_4Label = uilabel(app.UIFigure);
            app.EditField_4Label.HorizontalAlignment = 'right';
            app.EditField_4Label.Visible = 'off';
            app.EditField_4Label.Position = [452 149 56 22];
            app.EditField_4Label.Text = 'Edit Field';

            % Create EditField_4
            app.EditField_4 = uieditfield(app.UIFigure, 'numeric');
            app.EditField_4.Visible = 'off';
            app.EditField_4.Position = [523 149 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = main

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