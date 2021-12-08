function plot_slice(datastruct, dim, slice_offset, contour_plot)
%plot_slice : Plots a 2D slice of a volume, either in the x, y or z dimension.
%   * datastruct : 3D struct of the retina. Must contain x, y, z, and V, of 
%   size (sizeX x sizeY x sizeZ)
%   * dim : char. Either 'x', 'y', or 'z'
%   * slice_offset : in m, the offset at which you want to slice
%   * contour_plot : optional !! If set to 1, plots also a contourf plot. Otherwise, it
%   only plots an imagesc plot.


if nargin == 3 
    contour_plot = 0;
end

switch dim
    case 'x'
        "X slice plot"
        xslice = slice_offset;   
        yslice = [];
        zslice = [];
        
        slice3D = figure;
        s = slice(datastruct.x,datastruct.y,datastruct.z,datastruct.V,xslice,yslice,zslice);
        
        x = s.YData;
        y = s.ZData;
        V = s.CData;
        title_plot = "Plot of X plane slice at offset x = " + num2str(slice_offset) + " m";
       
        if contour_plot == 1
            plot_contourf(x, y, V, title_plot)
        end

        plot_imagesc(x(:,1)', y(1,:),V', title_plot)
        close(slice3D);
        

    case 'y'
        "Y slice plot"
        xslice = [];   
        yslice = slice_offset;
        zslice = [];
        
        slice3D= figure;
        s = slice(datastruct.x,datastruct.y,datastruct.z,datastruct.V,xslice,yslice,zslice);
        
        x = s.XData;
        y = s.ZData;
        V = s.CData;
        title_plot = "Plot of Y plane slice at offset y = " + num2str(slice_offset) + " m";

        if contour_plot == 1
            plot_contourf(x, y, V, title_plot)
        end
            
        plot_imagesc(x(:,1)', y(1,:), V', title_plot)
        
        close(slice3D);        


    case 'z'
        "Z slice plot"
        xslice = [];   
        yslice = [];
        zslice = slice_offset;
       
        slice3D = figure;
        s = slice(datastruct.x,datastruct.y,datastruct.z,datastruct.V,xslice,yslice,zslice);

        x = s.XData;
        y = s.YData;
        V = s.CData;
        title_plot = "Plot of Z plane slice at offset z = " + num2str(slice_offset) + " m";

        if contour_plot == 1 
            plot_contourf(x, y, V, title_plot)
        end
        
        plot_imagesc(x(1,:),y(:,1)',V, title_plot)

        close(slice3D);


    otherwise 
        "Non correct axis"
        return

end














end
