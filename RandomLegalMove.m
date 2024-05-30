function ChosenMove = RandomLegalMove(InputLegalities)
    if isempty(InputLegalities)
        ChosenMove=0;
        return
    else
        ChosenMove=InputLegalities(randi(length(InputLegalities)));
    end
end