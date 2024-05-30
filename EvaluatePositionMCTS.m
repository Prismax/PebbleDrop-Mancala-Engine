function PositionEvaluation = EvaluatePositionMCTS(InputBoard,NumberOfGames,c)
    %In this function 1000000 is used instead of intmax to assure
    %the in32() value is equal to its double() counterpart this 
    %allows the sporadic use of double([NewBoard(15)*1000000,1]) when
    %needed, without having to do frequent conversions or mismatching max values
    if isempty(LegalMoves(InputBoard))
        PositionEvaluation=[];
        return
    end
    PositionKeys={'...............'};
    %PositionAttributes{x}{1}=Position Score
    %PositionAttributes{2}{2}=Position Encounters
    PositionsAttributes={[-1000000 0]};
    PositionAttributesDictionary=dictionary(PositionKeys,PositionsAttributes);
    PositionMoves={{'01101010101010*','...............','1001010101010*','...............','10100110101010*','...............'}};
    PositionMovesDictionary=dictionary(PositionKeys,PositionMoves);
    OriginalInputBoard=InputBoard;
    for k=1:NumberOfGames
        InputBoard=OriginalInputBoard;
        IterationPositionList=cell(120,1);
        ZeroMovesPositionEsclusion=0;
        EndOfIteration=false;
        for i=1:120
            GameStateNumber=InputBoard(15);
            if (GameStateNumber==1) || (GameStateNumber==-1)
                CurrentPositionCode=Position2Code(InputBoard);
                %_____________________________________________________________________________________________
                MoveValueArray=[-1000000,-1000000,-1000000,-1000000,-1000000,-1000000];
                AllowedMoves=LegalMoves(InputBoard);
                if isempty(AllowedMoves)
                    MoveOfChoice=0;
                else
                    if isKey(PositionMovesDictionary,{CurrentPositionCode})%If we have encountered the position before, and so if we have data about the child positions...
                        for u=1:length(AllowedMoves)%Then we iterate through all the child positions resulting from legal moves
                            ChildPositionU=PositionMovesDictionary{{CurrentPositionCode}}{AllowedMoves(u)};
                            if strcmp(ChildPositionU,'...............')%If the particolar child position has never been encountered and we just know there is a child position resulting from this move...
                                MoveValueArray(AllowedMoves(u))=1000000; %Then we give it maximum move value, to encourage exploration
                            else%If instead the particular child position has been encountered before...
                                if isKey(PositionAttributesDictionary,{ChildPositionU}) %And if we have gathered data about the child position score...
                                    %then we prepare everything to
                                    %calculate the Upper Confidence Bound
                                    %formula and use it to assign a
                                    %balanced value to the move (which is different from the position score),
                                    %according to Exploitation term and Explore term
                                    ParentPosition_visits=PositionAttributesDictionary{{CurrentPositionCode}}(2);
                                    ChildPositionUAttributes=PositionAttributesDictionary{{ChildPositionU}};
                                    ChildPositionU_visits=ChildPositionUAttributes(2);
                                    if GameStateNumber==-1%Of course we have to take account of the player who is making a move. If it's player number 2 we change sign to the position score, to always prize the best move for the moving player
                                        ChildPositionU_score=-1*ChildPositionUAttributes(1);
                                    else
                                        ChildPositionU_score=ChildPositionUAttributes(1);
                                    end
                                    ExploitationTerm=ChildPositionU_score/ChildPositionU_visits;
                                    ExplorationTerm=c*sqrt(ParentPosition_visits/ChildPositionU_visits);%c is the exploration balancing costant. The preferred value of c depends also on the number of evaluation games.
                                    MoveValueArray(AllowedMoves(u))=ExploitationTerm+ExplorationTerm;
                                else %If instead we have NOT gathered data about the child position, it must be a game over position.
                                     %So we assign the move an 1000000 value with a sign based both on the player who would make the move who ends the game and the game result
                                    if ChildPositionU(15)=='+'%Take account of game result
                                        MoveValueArray(AllowedMoves(u))=1000000;
                                    elseif ChildPositionU(15)=='-'
                                        MoveValueArray(AllowedMoves(u))=-1000000;
                                    end
                                    if GameStateNumber==-1% Invert the move value in case the player number 2 played the move
                                        MoveValueArray(AllowedMoves(u))=-1*MoveValueArray(AllowedMoves(u));
                                    end
                                end
                            end
                        end
                        MaxValueMoves=find(MoveValueArray==max(MoveValueArray));
                        if length(MaxValueMoves)==1 %If there is only one move with max value
                            MoveOfChoice=MaxValueMoves; %That's the chosen move
                        else
                            MoveOfChoice=randsample(find(MoveValueArray==max(MoveValueArray)),1);%The the chosen move is a random move between the ones who share the same max value
                        end
                    else
                       MoveOfChoice=RandomLegalMove(AllowedMoves);
                    end
                end                
                %_______________________________________________________________________________________________
                NewBoard=Move(InputBoard, MoveOfChoice);
                if MoveOfChoice~=0
                    NewBoardCode=Position2Code(NewBoard);
                    if not(isKey(PositionMovesDictionary,{CurrentPositionCode}))
                        PositionMovesDictionary{{CurrentPositionCode}}={'...............','...............','...............','...............','...............','...............'};
                        PositionMovesDictionary{{CurrentPositionCode}}{MoveOfChoice}=NewBoardCode;  
                    elseif PositionMovesDictionary{{CurrentPositionCode}}{MoveOfChoice}~=NewBoardCode
                        PositionMovesDictionary{{CurrentPositionCode}}{MoveOfChoice}=NewBoardCode;
                    end
                    if not(isKey(PositionAttributesDictionary,{CurrentPositionCode}))
                        PositionAttributesDictionary{{CurrentPositionCode}}=[0,1];
                    else
                        PositionAttributesDictionary{{CurrentPositionCode}}(2)=1+PositionAttributesDictionary{{CurrentPositionCode}}(2);
                    end
                    if (NewBoard(15)==1) || (NewBoard(15)==-1)
                        IterationPositionList{i}=NewBoardCode;
                    end
                else
                    PositionAttributesDictionary{{CurrentPositionCode}}=double([NewBoard(15)*1000000/2,1]);
                    ZeroMovesPositionEsclusion=1;
                end
                InputBoard=NewBoard;
            elseif GameStateNumber==2
                PositionAttributesDictionary{{Position2Code(InputBoard)}}=double([1000000,1]);
                ScoreChange=1;
                EndOfIteration=true;
            elseif GameStateNumber==-2
                PositionAttributesDictionary{{Position2Code(InputBoard)}}=double([-1000000,1]);
                ScoreChange=-1;
                EndOfIteration=true;
            elseif GameStateNumber==0
                PositionAttributesDictionary{{Position2Code(InputBoard)}}=double([0,1]);
                ScoreChange=0;
                EndOfIteration=true;
            end
            if EndOfIteration==true
                PositionAttributesDictionary{{CurrentPositionCode}}=double([InputBoard(15)*1000000/2,1]);
                for p=1:(i-2-ZeroMovesPositionEsclusion)%Second last cycle doesn't record last position because its a gameover, last cycle gets here to update score values.Whenever the second-last position has 0 moves, it has to be excluded too.
                    PositionAttributesDictionary{IterationPositionList(p)}(1)=ScoreChange+PositionAttributesDictionary{IterationPositionList(p)}(1);
                end
                break
            end
        end
    end
    OriginalAllowedMoves=LegalMoves(OriginalInputBoard);
    PositionEvaluation=ones(6,1);
    PositionVisits=zeros(6,1);
    PositionScore=ones(6,1);
    for t=1:length(OriginalAllowedMoves)
        ConsideredMoveIndex=OriginalAllowedMoves(t);
        PositionFromMoveT = PositionMovesDictionary{{Position2Code(OriginalInputBoard)}}{ConsideredMoveIndex};
        PositionScore(ConsideredMoveIndex)=PositionAttributesDictionary{{PositionFromMoveT}}(1);
        PositionVisits(ConsideredMoveIndex)=PositionAttributesDictionary{{PositionFromMoveT}}(2);
        if PositionVisits(ConsideredMoveIndex)==0
            PositionEvaluation(ConsideredMoveIndex)=0;
        else
            PositionEvaluation(ConsideredMoveIndex)=PositionScore((ConsideredMoveIndex))/PositionVisits((ConsideredMoveIndex));
        end
        if NumberOfGames>500
            disp(['Move ',num2str(ConsideredMoveIndex),':---------:',num2str(PositionEvaluation(ConsideredMoveIndex))])
            disp(['Move ',num2str(ConsideredMoveIndex),' visits:__:',num2str(PositionVisits(ConsideredMoveIndex))])
        end
    end
    if NumberOfGames>500
        disp(['_____________________________________VisitsStandardDeviation:',num2str(std(PositionVisits))])
    end
end