function thetalist=IKinBodyIterations(Blist, M, T, thetalist0, eomg, ev)

thetalist = thetalist0;
i = 0;
maxiterations = 20;
Vb = se3ToVec(MatrixLog6(TransInv(FKinBody(M, Blist, thetalist)) * T));
err = norm(Vb(1: 3)) > eomg || norm(Vb(4: 6)) > ev;

while err && i < maxiterations
%     fprintf('\n Iteration number i = %f',i)
%     fprintf('\n Joint vector theta is \n')
%     display(thetalist)
%     fprintf('\n Current end-effector configuration T_sb is \n ') 
%     display(FKinBody(M,Blist, thetalist))
%     fprintf('\n Error Twist V_b is \n ')
%     display(Vb)
%     fprintf('\n Angular Error ||w_b|| is \n ') 
%     disp(norm(Vb(1:3)))
%     fprintf('\n Linear Error ||v_b|| is \n ')
%     disp(norm(Vb(4:6)))
    w_b(i+1) = norm(Vb(1:3));
    v_b(i+1) = norm(Vb(4:6));

    thetalist = thetalist + pinv(JacobianBody(Blist, thetalist)) * Vb;
    for j = 1:length(thetalist)

        if thetalist(j)>pi()
            thetalist(j) = thetalist(j)-2*pi();
        elseif thetalist(j)<-pi()
            thetalist(j) = thetalist(j)+2*pi();
        end
    end
    i = i + 1;
    Vb = se3ToVec(MatrixLog6(TransInv(FKinBody(M, Blist, thetalist)) * T));
    err = norm(Vb(1: 3)) > eomg || norm(Vb(4: 6)) > ev;
end
% figure(1)
% plot(0:length(w_b)-1, w_b, LineWidth=2)
% xlabel('Iteration Number')
% ylabel('Angular Error Magnitude')
% title('||w_b|| over IK iterations')
% figure(2)
% plot(0:length(v_b)-1, v_b, LineWidth=2)
% xlabel('Iteration Number')
% ylabel('Linear Error Magnitude')
% title('||v_b|| over IK iterations')
end