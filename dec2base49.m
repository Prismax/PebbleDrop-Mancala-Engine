function base49str = dec2base49(n)
    digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklm';  % Digits for base 49
    base49str = digits(n+1);
end