function plot_contourf(axis1, axis2, cdata, title_plot)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


figure
contourf(axis1, axis2, cdata)
axis equal
colorbar
title("contourf - " + title_plot)

end

