classdef app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure          matlab.ui.Figure
        ClockInOutButton  matlab.ui.control.Button
        Switch            matlab.ui.control.Switch
        TimeInLabel       matlab.ui.control.Label
        TimeOutLabel      matlab.ui.control.Label
        Label             matlab.ui.control.Label
        Label_2           matlab.ui.control.Label
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
                app.Label.Text = strcat(currDate, " ", currTime);
                app.Label_2.Text = "Currently clocked in!";
		dataCell{end + 1, 1} = date;
		dataCell{end, 2} = currTime; % Sign In Time Column!!! Use the same row as the new date logged!
                %writetable(cell2table(cellstr(datestr(now))), 'SignInSheet_2.csv','WriteVariableNames',false);
                %system(command);
            else
		app.Label_2.Text = strcat(currDate, " ", currTime);
		dataCell{end, 3} = currTime; % Same Row as the signing in, but one column over for the Sign OUT column!!!
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
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create ClockInOutButton
            app.ClockInOutButton = uibutton(app.UIFigure, 'push');
            app.ClockInOutButton.ButtonPushedFcn = createCallbackFcn(app, @ClockInOutButtonPushed, true);
            app.ClockInOutButton.Visible = 'off';
            app.ClockInOutButton.Position = [271 274 100 22];
            app.ClockInOutButton.Text = 'Clock In/Out';

            % Create Switch
            app.Switch = uiswitch(app.UIFigure, 'slider');
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.Position = [298 231 45 20];

            % Create TimeInLabel
            app.TimeInLabel = uilabel(app.UIFigure);
            app.TimeInLabel.FontName = 'Tibetan Machine Uni';
            app.TimeInLabel.FontWeight = 'bold';
            app.TimeInLabel.Position = [197 193 54 24];
            app.TimeInLabel.Text = 'Time In';

            % Create TimeOutLabel
            app.TimeOutLabel = uilabel(app.UIFigure);
            app.TimeOutLabel.FontName = 'Tibetan Machine Uni';
            app.TimeOutLabel.FontWeight = 'bold';
            app.TimeOutLabel.Position = [188 159 63 24];
            app.TimeOutLabel.Text = 'Time Out';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.Position = [356 194 236 22];
            app.Label.Text = '-';

            % Create Label_2
            app.Label_2 = uilabel(app.UIFigure);
            app.Label_2.Position = [356 160 256 22];
            app.Label_2.Text = '-';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app

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
