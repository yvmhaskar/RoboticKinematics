function S = S_from_wq(w,q)

S = [w;-skew3(w)*q];

end