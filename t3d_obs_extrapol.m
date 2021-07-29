% Function to extrapolate 3D obstacle paths from server output
% Inputs: 
%  - obs_gen: structure output from obstacle generation for one obstacle 
%  - timestamp
%  - h_uav: altitude of the uav
%  - Tf: time frame 
% Output: struct
%  - .x = [x_a, x_b]  coefficients (Linear path of the form: z = at + b)
%  - .y = [y_a, y_b]  coefficients (Linear path of the form: z = at + b)
%  - .r = initial radius  
%  - .r_array = size: 1 x (Tf+1)
%  -.oid = obs id

function path = t3d_obs_extrapol(obs_gen, current_timestamp, Tf,threshold)
h_uav = 120;
% Number of obstacles
num_obs = length(obs_gen);
 
% Initialise struct array
path = struct([]);

% only save when there is an obstacle
count = 0;

% Iterate through each obstacle
for i = 1:num_obs

    % Check active status 
    if current_timestamp >= obs_gen(i).t(1) && current_timestamp < obs_gen(i).t(end)
        
        count = count + 1;
        
        index = find(floor(current_timestamp) == obs_gen(i).t); % change in the future
        if obs_gen(i).v(index)<threshold && obs_gen(i).ROC(index)<threshold
            path(count).S=true;
            path(count).v=0;
            path(count).h=0;
            path(count).x=obs_gen(i).x(index);
            path(count).y=obs_gen(i).y(index);
            path(count).pos=[obs_gen(i).x(index),obs_gen(i).y(index)];
            path(count).oid=obs_gen(i).oid;
            path(count).r=obs_gen(i).r(index);
        else
            path(count).S=false;
            theta = obs_gen(i).H(index)*pi/180; % TODO: check format
        
            % x displacement function coefficients
            x_a = obs_gen(i).v(index) * sin(theta); % TODO: check if x_a & x_b is the same as the polynomial coeffs + cos
            x_b = obs_gen(i).x(index); 
            path(count).v=obs_gen(i).v(index);
            path(count).h=obs_gen(i).H(index);
            path(count).x = @(t) x_a*t+x_b;
            path(count).oid=obs_gen(i).oid;

            % y displacement function coefficients
            y_a = obs_gen(i).v(index) * cos(theta); % TODO: check if x_a & x_b is the same as the polynomial coeffs
            y_b = obs_gen(i).y(index);

            path(count).y = @(t) y_a*t+y_b;
            path(count).pos=[obs_gen(i).x(index),obs_gen(i).y(index)];
            % z displacement function coefficients
            z_a = obs_gen(i).ROC(index);
            z_b = obs_gen(i).z(index);

            % Radius array, 
            path(count).r=zeros(1,floor(Tf)+1);
            init_r = obs_gen(i).r(index);

            j = 0;
            for time = current_timestamp:current_timestamp+Tf

                % Calculate height of obstacle and distance from uav
                z = z_a*time + z_b;
                alt_diff = abs(z - h_uav);

                % Check obstacle on xy-plane
                switch obs_gen(i).id
                case {1,3} % Aircrafts, migrating birds
                    if alt_diff < 150
                        path(count).r(j+1) = init_r;
                    else
                        path(count).r(j+1) = 0;
                    end
                case {2} % birds of prey
                    if z > h_uav
                        path(count).r(j+1) = init_r;
                    else
                        path(count).r(j+1) = 0;
                    end
                case {4} % convective weather
                    path(count).r(j+1) = init_r;
                end

                j = j + 1;
            end
        end
        
    end        
end
%% Notes:
% - Whole number thing is still a problem