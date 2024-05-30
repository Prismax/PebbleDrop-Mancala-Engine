function PositionCode = Position2Code(InputBoard)
    PositionCode='zzzzzzzzzzzzzzz';
    for i=1:14
        PositionCode(i)=dec2base49(InputBoard(i));
    end
    if InputBoard(15)==1
        PositionCode(15)='°';
    elseif InputBoard(15)==-1
        PositionCode(15)='*';
    elseif InputBoard(15)==2
        PositionCode(15)='+';
    elseif InputBoard(15)==-2
        PositionCode(15)='-';
    elseif InputBoard(15)==0
        PositionCode(15)='=';
    else
        error('ERROR: final digit not recognized')
    end
end