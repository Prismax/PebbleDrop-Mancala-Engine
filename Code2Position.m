function DecodedPosition = Code2Position(InputCode)
    DecodedPosition = zeros(1, 15);
    for k=1:14
        DecodedPosition(k)=base49todec(InputCode(k));
    end
    if InputCode(15)=='°'
        DecodedPosition(15)=1;
    elseif InputCode(15)=='*'
        DecodedPosition(15)=-1;
    elseif InputCode(15)=='+'
        DecodedPosition(15)=2;
    elseif InputCode(15)=='-'
        DecodedPosition(15)=-2;
    elseif InputCode(15)=='='
        DecodedPosition(15)=0;
    else
        error('ERROR: final character not recognized')
    end
end