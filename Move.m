function OutputBoard = Move(InputBoard,MoveIndex)
    %If player 2 is the one to move, the board is inverted to preserve
    %the validity of the indices. Also, a flag is activated to undo
    %the inversion once the move has been made.
    if InputBoard(15) == -1
        InputBoard=InvertBoard(InputBoard);
        Player2JustMoved=true;
    elseif InputBoard(15)== 1
        Player2JustMoved=false;
    else% If the turn is neither 1 nor -1 then it will be 2, -2 or 0
        % and thus the game is already over. The board is left the same
        % as itself and the Move() function is interrupted.
        OutputBoard=InputBoard;
        return
    end

    % If all the pits of the player who has to move are empty then
    % all the pebbles in play are moved to the opponent's house,
    % Furthermore, the function must be interrupted, the victory must be
    % assigned to one of the two players and finally the game must end.
    % It's important to remember to undo the POSSIBLE inversion!
    if sum(InputBoard([1 2 3 4 5 6])) == 0
        InputBoard(14)=sum(InputBoard([14 8 9 10 11 12 13]));
        InputBoard(8:13) = 0; 
        if Player2JustMoved
            InputBoard=InvertBoard(InputBoard); %Inversion, if needed
        end
        InputBoard=AssignResult(InputBoard); %Assign the final result
        OutputBoard=InputBoard; %Return the final board state
        return
    end

    seeds = InputBoard(MoveIndex); % Take the pebbles from the chosen pit
    InputBoard(MoveIndex) = 0; % Empty the chosen pit
    
    % Distribute the seeds in the subsequent pits
    index = MoveIndex;
    for i = 1:seeds
        index = mod(index + 1, 14);
        if index == 0
            index = 1;
        end
        InputBoard(index) = InputBoard(index) + 1;
    end
    
    % Check if the last seed fell into an empty pit of the player and
    % there are stones to capture.
    if (InputBoard(index) == 1) && (index >= 1) && (index <= 6) && (InputBoard(14 - index)>0)
        InputBoard(7) = InputBoard(7) + InputBoard(index) + InputBoard(14 - index); % Cattura i semi
        InputBoard(index) = 0;
        InputBoard(14 - index) = 0;
    end
    
    %If player number two played then the initial inversion gets undone
    if Player2JustMoved==true
        InputBoard=InvertBoard(InputBoard);
    end

    %Turn goes to the opponent
    InputBoard(15)=InputBoard(15)*-1;
    % If the last pebble fell into the house of the player who moved
    % then the turn is returned to him
    if index == 7
        InputBoard(15)=InputBoard(15)*-1;
    end
    % Check if someone has won, and set the turn to 2 or -2 depending
    % on the winner
    InputBoard=AssignResult(InputBoard);
    % Return game status after move
    OutputBoard=InputBoard;
end







