%: main file
%setup global var
function main(uav,wp,M,saveVid,pplot)
%% setting up the plot and vid
if pplot
    figure;hold on;
    plot(wp(1),wp(2),"kx");
    total_path=plot([],[]);
    obs_plots =plot([],[]);
    uav_plot  =plot([],[]);
    p2_plot   =plot([],[]);
    pre_tra   =plot([],[]);
    xlim([-1000,1500]);
    ylim([-2500,0]);
    drawnow;
end
if saveVid
    obj = VideoWriter("UDIS.mp4", 'MPEG-4');
    obj.Quality = 100;
    obj.FrameRate = 5;
    open(obj);
    f = getframe(gcf);
end
%%setting var
total=[]; %totoal path
t=0; % time
po1=[0,0;0,0];
etc=-10;%estimate time collision
p2=[0,0];p1=[0,0];
turnUAV(wp);
dis=distance(wp,uav.pos);
i=0;%counter, just for max num of iteration
while distance(wp,uav.pos)>50 || i>=300%wp diameter is 100
    eta=calc_eta(wp);
    obs_list=t3d_obs_extrapol(M, t, eta,0.001);
    if collide(obs_list,wp)
        p2=calc_p2(obs_list,uav,wp); %obs_list is currently a single obstacle
        tempeta=calc_eta(p2);
        turnUAV(p2);
    else %if uav will not collide with obs just heading towards wp
        tempeta=eta;
        turnUAV(wp);
    end
    %move the uav
    uav.pos=uav.pos+uav.v*[sind(uav.h),cosd(uav.h)];
    %check if colliding:
    if colliding(obs)
        CCCCCCCC=true;
    end
    total=[total;uav.pos];
    %% draw&prt&saveVid
    if prt
        fprintf("%i--pos:[%.2f,%.2f],h:%.2f,p2=[%.2f,%.2f]",t,uav.pos(1),uav.pos(2),uav.h,p2(1),p2(2));
        fprintf(",eta2tempwp=%.2f",tempeta)
        fprintf(",dis2wp=%.2f",distance(uav.pos,wp));
        fprintf(",dis2Obs=%.2f",distance(uav.pos,[obs_list.x(0),obs_list.y(0)])-300)
        fprintf("\n")
    end
    if pplot
        title(sprintf("t=%i",t));
        delete(total_path);
        delete(obs_plots);
        delete(uav_plot);
        delete(p2_plot);
        delete(pre_tra);
        obs_plots = draw_multiple_dy_obs(obs,t);
        uav_plot = plot(uav.pos(1),uav.pos(2), 'go', 'LineWidth', 2, 'MarkerSize', 7);
        p2_plot = plot(p2(1),p2(2),'yo', 'LineWidth', 2, 'MarkerSize', 7);
        pre_tra=plot(linspace(uav.pos(1),wp(1)),linspace(uav.pos(2),wp(2)),'r--');
        total_path=plot(total(:,1),total(:,2),'b-');
        xlim([-1000,1500]);
        ylim([-2500,0]);
        legend([uav_plot,p2_plot,total_path],"uav","p2","Path");
        drawnow;
    end
    if saveVid
        f = getframe(gcf);
        writeVideo(obj,f);
    end
    t=t+1;
    i=i+1;
end
%% plotting total path
if prt
    fprintf("totoal distance=%.4f\n",total_dis(total));
end
if pplot
    plot(total(:,1),total(:,2))
    legend("total path")
end
if saveVid
    f = getframe(gcf);
    obj.close();
end
end