function [ChosenMove,EvaluatedPositions,LeafNodes]=MinimaxMoveChoice(InputBoard,Depth)
    EvaluatedPositions=0;
    LeafNodes=0;
    Depth=Depth-1;%to compensate for MinimaxEvaluation being called on already inferior nodes
    AllowedMoves=LegalMoves(InputBoard);
    ValuesList=zeros(1,length(AllowedMoves));
    for v=1:length(AllowedMoves)
        [ValuesList(v),ConsideredPositions,LeafCount]=MinimaxEvaluation(Move(InputBoard,AllowedMoves(v)),Depth,0,0);
    end
    if InputBoard((15))==1
        [~,MaxValueIndex]=max(ValuesList);
        ChosenMove=AllowedMoves(MaxValueIndex);
    elseif InputBoard((15))==-1
        [~,MinValueIndex]=min(ValuesList);
        ChosenMove=AllowedMoves(MinValueIndex);
    end
    disp(['AllowedMoves:', num2str(AllowedMoves)])
    disp(['ChosenMove:', num2str(ChosenMove)])
    disp(['Minimax values:', num2str(ValuesList)])
end
