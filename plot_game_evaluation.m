function plot_game_evaluation(MovesDone,GameEvaluation)
    area(0:MovesDone,GameEvaluation)
    title(['Current Evaluation: ',num2str(GameEvaluation(end)),'    Game Evaluation plot:'])
    hold on
    yline(0)
    yline(1)
    yline(-1)
    xlim([0, MovesDone]);
    ylim([-1.3, 1.3]);
end