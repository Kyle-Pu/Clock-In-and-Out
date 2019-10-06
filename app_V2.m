classdef app_V2 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        TimeCardUIFigure        matlab.ui.Figure
        ClockInOutButton        matlab.ui.control.Button
        Switch                  matlab.ui.control.Switch
        TimeInLabel             matlab.ui.control.Label
        TimeOutLabel            matlab.ui.control.Label
        TimeIn                  matlab.ui.control.Label
        TimeOut                 matlab.ui.control.Label
        ActivityEditFieldLabel  matlab.ui.control.Label
        ActivityEditField       matlab.ui.control.EditField
        ActivityLabel           matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ClockInOutButton
        function ClockInOutButtonPushed(app, event)
            dataCell = readcell('Time_Card.xlsx');
	    currDate = date; % Take current date and time (below) at the button click for precision
	    currTime = datestr(now, 'HH:MM:SS');
            global numClicks;
            %global data;
            numClicks = numClicks + 1;
            
            %command = "cat SignInSheet_* >> SignInSheet.txt";
            
            if mod(numClicks, 2) == 1
                app.TimeIn.Text = strcat(currDate, " ", currTime);
                app.TimeOut.Text = "Currently clocked in!";
                app.ActivityEditField.Editable = false; % Can't edit activity while clocked in
                app.ActivityEditField.Visible = false;
                app.ActivityLabel.Text = app.ActivityEditField.Value;
                app.ActivityLabel.Visible = true;
		dataCell{end + 1, 1} = date;
                dataCell{end, 2} = app.ActivityEditField.Value;
		dataCell{end, 3} = currTime; % Sign In Time Column!!! Use the same row as the new date logged!
                %writetable(cell2table(cellstr(datestr(now))), 'SignInSheet_2.csv','WriteVariableNames',false);
                %system(command);
            else
		app.TimeOut.Text = strcat(currDate, " ", currTime);
                app.ActivityLabel.Visible = false;
                app.ActivityEditField.Visible = true;
                app.ActivityEditField.Editable = true;
		dataCell{end, 4} = currTime; % Same Row as the signing in, but one column over for the Sign OUT column!!!
                app.ActivityEditField.Editable = true;
		%writetable(cell2table(cellstr(datestr(now))), 'SignInSheet_3.csv','WriteVariableNames',false);
                %system(command);
                %writetable(cell2table(cellstr(datestr(now))), "SignInSheet");
            end

	    writetable(cell2table(dataCell), 'Time_Card.xlsx', 'WriteVariableNames', false);
            
        end

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
            value = app.Switch.Value;
            global numClicks;
            numClicks = 0;
            %global data;
            %data = readtable('SignInSheet.txt');
            app.ClockInOutButton.Visible = true;
            app.Switch.Visible = false;
            
            if ~isfile('Time_Card.xlsx')
                tempCell = {'Date', 'Activity', 'Time In', 'Time Out'};
                writetable(cell2table(tempCell), 'Time_Card.xlsx', 'WriteVariableNames', false);
            end
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create TimeCardUIFigure and hide until all components are created
            app.TimeCardUIFigure = uifigure('Visible', 'off');
            app.TimeCardUIFigure.Position = [100 100 640 480];
            app.TimeCardUIFigure.Name = 'Time Card';

            % Create ClockInOutButton
            app.ClockInOutButton = uibutton(app.TimeCardUIFigure, 'push');
            app.ClockInOutButton.ButtonPushedFcn = createCallbackFcn(app, @ClockInOutButtonPushed, true);
            app.ClockInOutButton.Visible = 'off';
            app.ClockInOutButton.Position = [271 274 100 22];
            app.ClockInOutButton.Text = 'Clock In/Out';

            % Create Switch
            app.Switch = uiswitch(app.TimeCardUIFigure, 'slider');
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.Position = [298 231 45 20];

            % Create TimeInLabel
            app.TimeInLabel = uilabel(app.TimeCardUIFigure);
            app.TimeInLabel.FontName = 'Tibetan Machine Uni';
            app.TimeInLabel.FontWeight = 'bold';
            app.TimeInLabel.Position = [197 193 54 24];
            app.TimeInLabel.Text = 'Time In';

            % Create TimeOutLabel
            app.TimeOutLabel = uilabel(app.TimeCardUIFigure);
            app.TimeOutLabel.FontName = 'Tibetan Machine Uni';
            app.TimeOutLabel.FontWeight = 'bold';
            app.TimeOutLabel.Position = [188 159 63 24];
            app.TimeOutLabel.Text = 'Time Out';

            % Create TimeIn
            app.TimeIn = uilabel(app.TimeCardUIFigure);
            app.TimeIn.Position = [356 194 236 22];
            app.TimeIn.Text = '-';

            % Create TimeOut
            app.TimeOut = uilabel(app.TimeCardUIFigure);
            app.TimeOut.Position = [356 160 256 22];
            app.TimeOut.Text = '-';

            % Create ActivityEditFieldLabel
            app.ActivityEditFieldLabel = uilabel(app.TimeCardUIFigure);
            app.ActivityEditFieldLabel.HorizontalAlignment = 'right';
            app.ActivityEditFieldLabel.FontName = 'Tibetan Machine Uni';
            app.ActivityEditFieldLabel.Position = [206 102 50 24];
            app.ActivityEditFieldLabel.Text = 'Activity';

            % Create ActivityEditField
            app.ActivityEditField = uieditfield(app.TimeCardUIFigure, 'text');
            app.ActivityEditField.Position = [271 104 100 22];

            % Create ActivityLabel
            app.ActivityLabel = uilabel(app.TimeCardUIFigure);
            app.ActivityLabel.Visible = 'off';
            app.ActivityLabel.Position = [271 103 98 22];
            app.ActivityLabel.Text = '';

            % Show the figure after all components are created
            app.TimeCardUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app_V2

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.TimeCardUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.TimeCardUIFigure)
        end
    end
end