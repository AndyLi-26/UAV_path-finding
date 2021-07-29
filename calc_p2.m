function p2 = calc_p2(obs, uav, wp)
    %global uav
    v_obs_x = obs.v*sind(obs.h);
    v_obs_y = obs.v*cosd(obs.h);
    c_o_x = obs.pos(1);
    c_o_y = obs.pos(2);
    R = obs.r(1); %taking first value of R array for now???????
    v_uav = uav.v;
    wp_x = wp(1);
    wp_y = wp(2);
    uav_x_0 = uav.pos(1);
    uav_y_0 = uav.pos(2);

    %% Function handles
    heading = @(a_x, a_y, b_x, b_y) atan2(b_y-a_y, b_x - a_x);
    %% Equations
    syms c_wp_x c_wp_y thet bet p3_x p3_y t_s1 t_s2 t_s3;
    eqns1 =  c_wp_x - v_obs_x*t_s3 + R*cosd(thet) == wp_x + v_uav*t_s3*cosd(bet);
    eqns2 = c_wp_y - v_obs_y*t_s3 + R*sind(thet) == wp_y + v_uav*t_s3*sind(bet);
    eqns3 = cosd(thet)*cosd(bet)+sind(thet)*sind(bet) == 0;
    eqns4 = c_wp_x == c_o_x + v_obs_x*(t_s1 + t_s2 + t_s3);
    eqns5 = c_wp_y == c_o_y + v_obs_y*(t_s1 + t_s2 + t_s3);
    eqns6 = p3_x == c_wp_x - v_obs_x*t_s3 + R*cosd(thet);
    eqns7 = p3_y == c_wp_y - v_obs_y*t_s3 + R*sind(thet);
    % cw or acw
    obs_pos_p3_x = c_o_x + v_obs_x*(t_s1 + t_s2);
    obs_pos_p3_y = c_o_y + v_obs_y*(t_s1 + t_s2);
    alpha2 = heading(wp_x, wp_y, p3_x, p3_y);
    alpha1 = heading(wp_x, wp_y, c_wp_x - v_obs_x*t_s3, c_wp_y - v_obs_y*t_s3);
    sg = -sign(alpha2 - alpha1);
    %sg = -(alpha2 - alpha1)/abs(alpha2 - alpha1);
    eqns8 = (obs_pos_p3_x + R*cosd(thet + sg*t_s2) - v_obs_x*(t_s2) - uav_x_0)/ (-sg*R*sind(thet + sg*t_s2) - v_obs_x) == ...
        (obs_pos_p3_y + R*sind(thet + sg*t_s2) - v_obs_y*(t_s2) - uav_y_0)/(sg*R*cosd(thet + sg*t_s2) - v_obs_y);
    dist_s1 = sqrt(...
        (obs_pos_p3_x + R*cosd(thet + sg*t_s2) - v_obs_x*(t_s2) - uav_x_0)^2 + ...
        (obs_pos_p3_y + R*sind(thet + sg*t_s2) - v_obs_y*(t_s2) - uav_y_0)^2);
    eqns9 = t_s1 == dist_s1/v_uav;
    s = vpasolve([eqns1, eqns2, eqns3, eqns4, eqns5, eqns6, eqns7, eqns8, eqns9], [c_wp_x, c_wp_y, thet, bet, p3_x, p3_y, t_s1, t_s2, t_s3]);
    p3 = [];
    for i = 1:length(s.p3_x)
        p3 = [p3; s.p3_x(i), s.p3_y(i)];
    end
    %% Determing P2
    alpha2 = heading(wp_x, wp_y, s.p3_x, s.p3_y);
    alpha1 = heading(wp_x, wp_y, s.c_wp_x - v_obs_x*s.t_s3, s.c_wp_y - v_obs_y*s.t_s3);
    sg = -sign(alpha2 - alpha1);
    obs_pos_p3_x = c_o_x + v_obs_x*(s.t_s1 + s.t_s2);
    obs_pos_p3_y = c_o_y + v_obs_y*(s.t_s1 + s.t_s2);
    p2_x = obs_pos_p3_x + R*cosd(s.thet + sg*s.t_s2) - v_obs_x*(s.t_s2);
    p2_y = obs_pos_p3_y + R*sind(s.thet + sg*s.t_s2) - v_obs_y*(s.t_s2);
    p2 = double([p2_x,p2_y]);
    fprintf('p2_x is %.3f, p2_y is %.3f\n',[p2(1),p2(2)])
    fprintf('ts_1 is %.3f\n',s.t_s1)
    fprintf('ts_2 is %.3f\n',s.t_s2)
    fprintf('ts_3 is %.3f\n',s.t_s3)
    fprintf('p3_x is %.3f\n',s.p3_x)
    fprintf('p3_y is %.3f\n',s.p3_y)
    fprintf('thet is %.3f\n',s.thet)
    fprintf('bet is %.3f\n',s.bet)
end
