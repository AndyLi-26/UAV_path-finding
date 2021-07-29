function eta=calc_eta(wp)
global uav
eta=distance(uav.pos,wp)/uav.v;
end