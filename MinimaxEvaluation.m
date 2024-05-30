function [Evaluation,ConsideredPositions,LeafCount]=MinimaxEvaluation(InputBoard,Depth,ConsideredPositions,LeafCount)
    ConsideredPositions=ConsideredPositions+1;
    if InputBoard(15)==2
        Evaluation=intmax;
        return
    elseif InputBoard(15)==-2
        Evaluation=-intmax;
        return
    elseif InputBoard(15)==0
        Evaluation=0;
        return
    end    
    if Depth==0
        LeafCount=LeafCount+1;
        Evaluation=InputBoard(7)-InputBoard(14);
        if Evaluation==0
            Evaluation=0.001;
        end
        return
    elseif Depth>0
        AllowedMoves=LegalMoves(InputBoard);
        if InputBoard((15))==1
            Evaluation=-intmax;
            for z=1:length(AllowedMoves)
                [ValueAfterMoveK,ConsideredPositions,LeafCount]=MinimaxEvaluation(Move(InputBoard,AllowedMoves(z)),Depth-1,ConsideredPositions,LeafCount);
                if ValueAfterMoveK>Evaluation
                    Evaluation=ValueAfterMoveK;
                end
            end
        elseif InputBoard((15))==-1
            Evaluation=intmax;
            for z=1:length(AllowedMoves)
                [ValueAfterMoveK,ConsideredPositions,LeafCount]=MinimaxEvaluation(Move(InputBoard,AllowedMoves(z)),Depth-1,ConsideredPositions,LeafCount);
                if ValueAfterMoveK<Evaluation
                    Evaluation=ValueAfterMoveK;
                end
            end
        end
    end
end