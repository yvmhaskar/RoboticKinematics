function B = StoB(S,M)

b = inv(M)*skew6(S)*M;
B = [b(3,2);b(1,3);b(2,1);b(1:3,4)];

end