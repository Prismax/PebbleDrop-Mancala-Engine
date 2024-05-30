function [ChosenMove,StateEvaluation] = MoveChoiceMTCS(InputBoard,EvaluationGames,c)
    GameStateNumber=InputBoard(15);
    if GameStateNumber==2
        ChosenMove=0;
        StateEvaluation=1;
        return
    elseif GameStateNumber==-2
        ChosenMove=0;
        StateEvaluation=-1;
        return
    elseif GameStateNumber==0
        ChosenMove=0;
        StateEvaluation=0;
        return
    elseif GameStateNumber==1
        MoveValueArray=EvaluatePositionMCTS(InputBoard,EvaluationGames,c);
    elseif GameStateNumber==-1
        MoveValueArray=EvaluatePositionMCTS(InputBoard,EvaluationGames,c);
        MoveValueArray=-1*MoveValueArray;
    end
    LegalMask=[0 0 0 0 0 0];
    LegalMask(LegalMoves(InputBoard))=1;
    MoveValueArray(LegalMask==0)=-1000000;
    MaxValueMoves=find(MoveValueArray==max(MoveValueArray));
    if length(MaxValueMoves)==1 %If there is only one move with max value
        ChosenMove=MaxValueMoves; %That's the chosen move
    else
        ChosenMove=randsample(find(MoveValueArray==max(MoveValueArray)),1);%The the chosen move is a random move between the ones who share the same max value
    end
    if GameStateNumber==1
        StateEvaluation=MoveValueArray(ChosenMove);
    elseif GameStateNumber==-1
        StateEvaluation=-1*MoveValueArray(ChosenMove);
    end
    if StateEvaluation>1
        StateEvaluation=1;
    elseif StateEvaluation<-1
        StateEvaluation=-1;
    end
    if EvaluationGames>500
        disp(['MCTS Move:',num2str(ChosenMove)])
    end

end