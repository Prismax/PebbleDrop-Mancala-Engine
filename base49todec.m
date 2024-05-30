function base10num = base49todec(n)
    digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklm';  % Digits for base 49
    base10num=find(digits == n)-1;
end