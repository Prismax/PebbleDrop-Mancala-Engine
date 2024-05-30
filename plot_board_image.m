function plot_board_image(InputBoard,MovesDone,PassedFigure)
    % Check if the input array has exactly 15 elements
    if numel(InputBoard) ~= 15
        error('Input array must contain exactly 15 integers.');
    end
    
    % Create a figure
    PassedFigure;
    hold on;
    
    % Define circle properties
    radius = 0.3;
    num_vertices = 18; % Number of vertices for each circle
    
    % Plot circles and add text labels (first row)
    for i = 1:6
        x = i; % x-coordinate for the center of the circle
        y = 0; % y-coordinate for the center of the circle
        
        % Calculate green intensity based on the number (normalized to [0, 1])
        green_intensity = (InputBoard(i) - min(InputBoard)) / (max(InputBoard) - min(InputBoard));
        
        % Create a color with varying green intensity
        color = [1 - green_intensity, 1, 1 - green_intensity]; % RGB triplet
        
        % Generate vertices for the circle
        theta = linspace(0, 17/18*2*pi, num_vertices);
        x_vertices = x + radius * cos(theta);
        y_vertices = y + radius * sin(theta);
        
        % Create the polyshape
        circle = polyshape(x_vertices, y_vertices);
        plot(circle, 'FaceColor', color);
        
        % Add text label
        text(x, y, num2str(InputBoard(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end
    
    % Plot circles and add text labels (second row, right to left)
    for i = 8:13
        x = 14 - i; % x-coordinate for the center of the circle (right to left)
        y = 1.5; % y-coordinate for the center of the circle (higher row)
        
        % Calculate green intensity based on the number (normalized to [0, 1])
        green_intensity = (InputBoard(i) - min(InputBoard)) / (max(InputBoard) - min(InputBoard));
        
        % Create a color with varying green intensity
        color = [1 - green_intensity, 1, 1 - green_intensity]; % RGB triplet
        
        % Generate vertices for the circle
        theta = linspace(0, 17/18*2*pi, num_vertices);
        x_vertices = x + radius * cos(theta);
        y_vertices = y + radius * sin(theta);
        
        % Create the polyshape
        circle = polyshape(x_vertices, y_vertices);
        plot(circle, 'FaceColor', color);
        
        % Add text label
        text(x, y, num2str(InputBoard(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end
    
    % Add circles on the right and left portions
    radiusBig=radius*1.3;
    x_right = 6.75;
    x_left = 0.25;
    y=1.5/2;
    % Circle on the right
    green_intensity_right = (InputBoard(7) - min(InputBoard)) / (max(InputBoard) - min(InputBoard));
    color_right = [1 - green_intensity_right, 1, 1 - green_intensity_right];
    x_vertices_right = x_right + radiusBig * cos(theta);
    y_vertices_right = y + radiusBig * sin(theta);
    circle_right = polyshape(x_vertices_right, y_vertices_right);
    plot(circle_right, 'FaceColor', color_right);
    text(x_right, y, num2str(InputBoard(7)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    
    % Circle on the left
    green_intensity_left = (InputBoard(14) - min(InputBoard)) / (max(InputBoard) - min(InputBoard));
    color_left = [1 - green_intensity_left, 1, 1 - green_intensity_left];
    x_vertices_left = x_left + radiusBig * cos(theta);
    y_vertices_left = y + radiusBig * sin(theta);
    circle_left = polyshape(x_vertices_left, y_vertices_left);
    plot(circle_left, 'FaceColor', color_left);
    text(x_left, y, num2str(InputBoard(14)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    
    % Set axis limits and labels
    xlim([-1, 8]);
    ylim([0, 1]);
    if InputBoard(15)==1
        title(['Move ',num2str(MovesDone),': Player 1 to move. | ',' Code:',Position2Code(InputBoard)]);
    elseif InputBoard(15)==-1
         title(['Move ',num2str(MovesDone),': Player 2 to move. | ',' Code:',Position2Code(InputBoard)]);
    elseif InputBoard(15)==2
         title(['Move ',num2str(MovesDone),': Player 1 won. | ',' Code:',Position2Code(InputBoard)]);
    elseif InputBoard(15)==-2
         title(['Move ',num2str(MovesDone),': Player 2 won. | ',' Code:',Position2Code(InputBoard)]);
    elseif InputBoard(15)==0
         title(['Move ',num2str(MovesDone),': Player reached draw. | ',' Code:',Position2Code(InputBoard)]);
    end
    
    % Set the aspect ratio to be equal
    axis equal;
    
    % Turn off axis ticks
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    
    hold off;
end
