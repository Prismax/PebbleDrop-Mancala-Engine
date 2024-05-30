function OutputBoard=AssignResult(InputBoard)
    if (InputBoard(7) == 24) && (InputBoard(14)==24)
        %Draw
        InputBoard(15)=0;
    elseif(InputBoard(7) >= 25)
        %Player 1 wins
        InputBoard(15)=2;
    elseif (InputBoard(14) >= 25)
        %Player 2 wins
        InputBoard(15)=-2;
    end
    OutputBoard=InputBoard;
end
