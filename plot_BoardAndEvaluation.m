function plot_BoardAndEvaluation(InputBoard,MovesDone,GameEvaluation)
    figure
    BoardFigure=subplot(2,1,1);
    plot_board_image(InputBoard,MovesDone,BoardFigure)
    subplot(2,1,2)
    plot_game_evaluation(MovesDone,GameEvaluation)
end