%________________PEBBLEDROP ENGINE 1.0___________________
% This is a Game Engine for the popular board game       |
% known as Mancala, formally called Wari. The user is    |
% able to chose the playing algorithm independently      |
% for both player from the command line once the script  |
% is runned. Line 25->30 contain parameters for the      |
% engine. Lowering these numbers makes the move choice   |
% faster but also determines worse moves.                |
% To make the game more informative while also avoiding  |
% excessive wait times, the engine proceds to give a     |
% rough evaluation of every position.                    |
% Written by Enrico Conti in 2024                        |
% AGPL-3.0 license                                       |
%________________________________________________________|
clear
clc
close all

% 1=Human   2=Random move   3=Monte Carlo Tree Search   4=Minimax
while true
    Player1Index=input('Choose who is the FIRST player to play[1=Human][2=Random move][3=MonteCarloTreeSearch][4=Minimax]: ');
    if Player1Index>0 && Player1Index<5
        break
    end
end
while true
    Player2Index=input('Choose who is the SECOND player to play[1=Human][2=Random move][3=MonteCarloTreeSearch][4=Minimax]: ');
    if Player2Index>0 && Player2Index<5
        break
    end
end
%Engine parameters, tweak if needed.
Player1MTCSiterations=8000;
Player2MTCSiterations=8000;
Player1MTCSExplorationCoefficient=1;
Player2MTCSExplorationCoefficient=1;
Player1MinimaxDepth=9;
Player2MinimaxDepth=9;
MovesDone=0;
% Mancala board initialization
board = Code2Position('44444404444440°');
DisplayBoard(board,MovesDone)
[~,GameEvaluation(1)]=MoveChoiceMTCS(board,500,1);
plot_BoardAndEvaluation(board,1,[GameEvaluation(1), GameEvaluation(1)])
drawnow
%__________Playing  loop__________
for G=1:130
    if board(15)==1 || board(15)==-1    %If game has not ended...
        if board(15)==1
            PlayerIndex=Player1Index;
        elseif board(15)==-1
            PlayerIndex=Player2Index;
        end
        %--------------------------------------------------------------------------
        tic
        if PlayerIndex==1
            AllowedMoves=LegalMoves(board);
            if isempty(AllowedMoves)
                board=Move(board,0);
                DisplayBoard(board,MovesDone)
                plot_BoardAndEvaluation(board,MovesDone,GameEvaluation)
                drawnow
                disp("End of the playing loop")
                break
            end
            while true
                MoveChoice=input('Human to move. Choose a legal move number from 1 to 6: ');
                if MoveChoice>0 && MoveChoice<7
                    if sum(AllowedMoves==MoveChoice)>0
                        board=Move(board,MoveChoice);%Human Plays
                        break
                    end
                end
            end
        elseif PlayerIndex==2
            disp('Now playing random move')
            if Player1Index==1 || Player2Index==1
                pause(1)
            end
            board=Move(board,RandomLegalMove(LegalMoves(board)));%CPU plays a random move
        elseif PlayerIndex==3
            disp('[MTCS] Waiting for CPU to move...')
            if board(15)==1
                [MoveChoice,~]=MoveChoiceMTCS(board,Player1MTCSiterations,Player1MTCSExplorationCoefficient);
            elseif board(15)==-1
                [MoveChoice,~]=MoveChoiceMTCS(board,Player2MTCSiterations,Player2MTCSExplorationCoefficient);
            end
            board=Move(board,MoveChoice); %CPU plays with MTCS
        elseif PlayerIndex==4
            disp('[Minimax] Waiting for CPU to move...')
            if board(15)==1
                MoveChoice=MinimaxMoveChoice(board,Player1MinimaxDepth);
            elseif board(15)==-1
                MoveChoice=MinimaxMoveChoice(board,Player2MinimaxDepth);
            end
            board=Move(board,MoveChoice); %CPU plays with Minimax
        end
        toc
        %-------------------------------------------------------------------------
    else
        disp("End of the playing loop")
        break
    end
    MovesDone=MovesDone+1;
    DisplayBoard(board,MovesDone)
    disp('Now storing a rough game state evaluation...')
    [~,GameEvaluation(G+1)]=MoveChoiceMTCS(board,500,1);
    disp('Rough evaluation stored')
    plot_BoardAndEvaluation(board,MovesDone,GameEvaluation)
    drawnow
end
