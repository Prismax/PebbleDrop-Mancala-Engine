function DisplayBoard(InputBoard,MovesDone)
    if InputBoard(15)==1
        PlayerString='Player 1 to move';
    elseif InputBoard(15)==-1
        PlayerString='Player 2 to move';
    elseif InputBoard(15)==2
        PlayerString='Player 1 won';
    elseif InputBoard(15)==-2
        PlayerString='Player 2 won';
    elseif InputBoard(15)==0
        PlayerString='Players reached draw';
    end
    disp(" ")
    % Display the number of moves that have been done
    disp(['Moves Played:',num2str(MovesDone),'_________________________',PlayerString])
    % Display the small pots of player 2
    disp(['  ',num2str(fliplr(InputBoard(8:13)))])
    % Display the big pots
    disp([num2str(InputBoard(14)),'                  ',num2str(InputBoard(7)),'                    Code:[',Position2Code(InputBoard),']'])
    % Display the small pots of player 1
    disp(['  ',num2str(InputBoard(1:6))])
end