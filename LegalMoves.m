function LegalitiesList = LegalMoves(InputBoard)
    LegalityArray=[0 0 0 0 0 0];
    if InputBoard(15)==1
        for L=1:6
           if InputBoard(L) ~= 0
                LegalityArray(L)=1;
           end
        end
    elseif InputBoard(15)==-1
        for L=8:13
           if InputBoard(L) ~= 0
                LegalityArray(L-7)=1;
           end
        end
    elseif InputBoard(15)==2
        %Do nothing. Game is already over, so no legal moves
    elseif InputBoard(15)==-2
        %Do nothing. Game is already over, so no legal moves
    end
    LegalitiesList=find(LegalityArray);
end