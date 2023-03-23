function s = skew6(S)

s = skew3(S(1:3));
s(1:3,4) = S(4:6);
s(4,:) = 0;

end