function obss = draw_multiple_dy_obs(obs,timestamp)
global aircraft_height;
h_uav = aircraft_height;

n=length(obs);
obss = [];
for j=1:n % for every obstacle
    if timestamp<=obs(j).end && timestamp>=obs(j).start
        x0=polyval(obs(j).pos.x,timestamp);
        y0=polyval(obs(j).pos.y,timestamp);
        z0=polyval(obs(j).pos.z,timestamp);
        r=polyval(obs(j).r,timestamp);
        switch obs(j).id
            case {1,3} % Aircrafts, migrating birds
                alt_diff = abs(z0 - h_uav);
                if alt_diff >= 150
                    r = 0;
                end
            case {2} % birds of prey                
                if z0 <= h_uav
                    r = 0;
                end
        end
        obss = [obss; circle(x0,y0,r,'black')];
    end
end
end