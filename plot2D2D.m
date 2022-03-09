function [f] = plot2D2D(X,Y,U,V,varargin)
%PLOT2D2D function to create a plot with a 2D data and a 2D colormap.
% ====== INPUTS ==========================
%   X   coordinates
%   Y   coordinates
%   U   Value 1 (if angle, use circular 2D map)
%   V   Value 2 (no angle option)
%   
% ====== Optional inputs =================
%   'Colormap'
%     -- Normal maps --
%       'bramm'           regular 2D map
%       'schumann'        regular 2D map
%       'steiger'         regular 2D map
%       'teuling'         regular 2D map (default)
%       'ziegler'         regular 2D map
%
%     -- Circular maps -- U is interpreted as angle, cmap is labeled in deg
%       'ChromaConst'     circular 2D map (u = angle) (recommended)
%       'chromaMax'       circular 2D map (u = angle) (can cause misleading
%                           edges, but is more vivid)
%       'complex'         circular 2D map
%
%     -- Custom map --
%       'custom'          requires own map 'custom.png'
%
%   'umin' (overwritten for circular colormaps)
%   'umax' (overwritten for circular colormaps)
%   'vmin'
%   'vmax'
%
%   'ulabel'
%       string
%   'vlabel'
%       string
%
%   'AngleUnit'    Only used with a circular colormap
%       - 'rad'     (default)
%       - 'degree'
%
%   'ColormapPlot'
%       true    (default) Colormap will be added with lables and ticks
%       false   No colormap
%
%   'ColormapLocation'
%       'New fig'   (default)
%       'South'     Subplot south
%       'East'      Subplot east
%       
% ====== Credit ==========================
%   This code has been adapted from a first version from Dave B:
%       https://nl.mathworks.com/matlabcentral/profile/authors/14836566
%   The colormaps bramm, schumann, steiger, teuling, ziegler are based on
%   the work presented in
%     Explorative Analysis of 2D Color Maps
%     Steiger, M., et al., Proceedings of WSCG (23), 151-160, 
%       Eurographics Assciation, Vaclav Skala - Union Agency, 2015
%       Source: https://github.com/dominikjaeckle/Color2D
%   The colormaps chroma_const and chroma_max are based on the work
%   presented in this github:
%       https://github.com/endolith/complex_colormap
% Author: Marcus Becker, Date: 2021 - 11 - 23
%
% ====== Examples ========================
% E1 - random data:
%   plot2D2D(rand(10),rand(10),rand(10),rand(10))
%
% E2 - angle data:
%   [X,Y] = meshgrid(linspace(0,10),linspace(0,10))
%   Phi = X;
%   M   = sin(X).*sin(Y);
%   plot2D2D(X,Y,Phi,M,'Colormap','ChromaConst')
%
% E3 - dynamic system - Van der Pol oscillator
%   [X1,X2] = meshgrid(linspace(-3.5,3.5),linspace(-3.5,3.5));
%   X1_d = X1-1/3*X1.^3-X2; X2_d = X1;
%   phi = atan2(X2_d(:),X1_d(:));
%   mag = sqrt(X1_d(:).^2 + X2_d(:).^2);
%   plot2D2D(X1,X2,phi,mag,'Colormap','ChromaConst','ulabel','Direction','vlabel','Magnitude')
%   plot2D2D(X1,X2,phi,mag,'Colormap','ChromaMax','ulabel','Direction','vlabel','Magnitude')
%   plot2D2D(X1,X2,phi,mag,'Colormap','Complex','ulabel','Direction','vlabel','Magnitude','ColormapLocation','East')
%
% E4 - dynamic system - saddle point
% [X1,X2] = meshgrid(linspace(-9,9),linspace(-4,4));
% X1_d = X2; X2_d = -sin(X1) -0.3*X2;
% plot2D2D(X1,X2,X1_d,X2_d,'Colormap','schumann','ulabel','x1 d/dt','vlabel','x2 d/dt')
%% Default parameters
colormap        = 'teuling';
umin            = min(U(:));
umax            = max(U(:));
vmin            = min(V(:));
vmax            = max(V(:));
ulabel          = '';
vlabel          = '';
angleunit       = 'rad';
colormapplot    = true;
colormaplocation = 'newfig';
angledata       = false;
%% Correct depending on arguments passed
if nargin>3
    %varargin is used
    for i=1:2:length(varargin)
        %go through varargin which is build in pairs and assign variable
        %stored in the first entry with the value stored in the second
        %entry.
        if isnumeric(varargin{i+1})
            %Value is a number -> for 'eval' a string is needed, so convert
            %num2str
            eval([lower(varargin{i}) '=' num2str(varargin{i+1}) ';']);
        else
            %Value is a string, can be used as expected
            stringVar = varargin{i+1};
            eval([lower(varargin{i}) '= stringVar;']);
            clear stringVar
        end
    end
end
%% Set limits
ulim = [umin,umax];
vlim = [vmin,vmax];
%% Load a colormap and store in a matrix of RGB values
% Note:
%   Longterm it would be favourable to switch to a mathematical description
%   of the colormaps. Many 2D maps are presented in
%       https://github.com/igd-iva/colormap-explorer/tree/master/colormaps/src/main/java/de/fhg/igd/iva/colormaps/impl
%   And would need translation from Java to Matlab.
%   They are all published under the apache license 2.0:
%       http://www.apache.org/licenses/LICENSE-2.0

switch replace(lower(colormap),' ','')
    case 'teuling'
        try
            im = imread('teuling.png');
        catch
            error(['The map teuling.png is unavailable. See comments for '...
                'map source to download again and replace file.'])
        end
    case 'schumann'
        try
            im = imread('schumann.png');
        catch
            error(['The map schumann.png is unavailable. See comments for '...
                'map source to download again and replace file.'])
        end
    case 'steiger'
        try
            im = imread('steiger.png');
        catch
            error(['The map steiger.png is unavailable. See comments for '...
                'map source to download again and replace file.'])
        end
    case 'ziegler'
        try
            im = imread('ziegler.png');
        catch
            error(['The map ziegler.png is unavailable. See comments for '...
                'map source to download again and replace file.'])
        end
    case 'bremm'
        try
            im = imread('bremm.png');
        catch
            error(['The map bremm.png is unavailable. See comments for '...
                'map source to download again and replace file.'])
        end
    case 'chromaconst' % ========== Circular color map
        try
            im = imread('ChromaConst.jpg');
        catch
            error(['The map ChromaConst.jpg is unavailable. See comments for '...
                'map source to download again and replace file.'])
        end
        angledata = true;
        ulim = [0,360];
    case 'chromamax' % ============ Circular color map
        try
            im = imread('ChromaMax.jpg');
        catch
            error(['The map ChromaMax.jpg is unavailable. See comments for '...
                'map source to download again and replace file.'])
        end
        angledata = true;
        ulim = [0,360];
    case 'complex' % ============== Circular color map
        try
            im = imread('Complex.png');
        catch
            error(['The map ChromaMax.jpg is unavailable. See comments for '...
                'map source to download again and replace file.'])
        end
        angledata = true;
        ulim = [0,360];
    case 'custom'
        try
            im = imread('custom.png');
        catch
            error('The map custom.png is unavailable.')
        end
    otherwise
        error(['Colormap ' colormap ' unknown. See comments for '...
            'available maps.'])
end

rgb = double(reshape(im, [], 3))./255;
%% Mapping
% Normalize data (according to format)
if angledata
    if strcmp(angleunit,'rad')
        u_n = mod(U(:),2*pi)/(2*pi);
    else
        u_n = mod(U(:),360)/360;
    end
else
    u_n = rescale(U(:));
end
v_n = rescale(V(:));


% interpolate to find a color for each x and y, mapping the range of the
% colormap onto [0 1]
c_column = round(interp1(linspace(0,1,size(im,2)), 1:size(im,2), u_n));
c_row    = round(interp1(linspace(0,1,size(im,1)), 1:size(im,1), v_n));
rgb_row  = sub2ind(size(im),c_row,c_column,ones(size(c_row))); % this is the same as the index into im of red values
c = rgb(rgb_row,:);

%% Plotting
DT = delaunay(X,Y);
f = figure;
if colormapplot
    switch colormaplocation
        case 'south'
            subplot(2,1,2)
            image(im)
            axis equal
            set(gca,'YDir','normal')
            xlim([0,size(im,2)])
            ylim([0,size(im,1)])
            xticks([0,.25,.5,.75,1]*size(im,2))
            xticklabels({num2str(ulim(1)),...
                num2str((ulim(2)-ulim(1))/4+ulim(1)),...
                num2str((ulim(2)-ulim(1))/2+ulim(1)),...
                num2str((ulim(2)-ulim(1))*3/4+ulim(1)),...
                num2str(ulim(2))})
            yticks([0,.25,.5,.75,1]*size(im,1))
            yticklabels({num2str(vlim(1)),...
                num2str((vlim(2)-vlim(1))/4+vlim(1)),...
                num2str((vlim(2)-vlim(1))/2+vlim(1)),...
                num2str((vlim(2)-vlim(1))*3/4+vlim(1)),...
                num2str(vlim(2))})
            subplot(2,1,1)
        case 'east'
            subplot(1,2,2)
            image(im)
            axis equal
            xlabel(ulabel)
            ylabel(vlabel)
            set(gca,'YDir','normal')
            xlim([0,size(im,2)])
            ylim([0,size(im,1)])
            xticks([0,.25,.5,.75,1]*size(im,2))
            xticklabels({num2str(ulim(1)),...
                num2str((ulim(2)-ulim(1))/4+ulim(1)),...
                num2str((ulim(2)-ulim(1))/2+ulim(1)),...
                num2str((ulim(2)-ulim(1))*3/4+ulim(1)),...
                num2str(ulim(2))})
            yticks([0,.25,.5,.75,1]*size(im,1))
            yticklabels({num2str(vlim(1)),...
                num2str((vlim(2)-vlim(1))/4+vlim(1)),...
                num2str((vlim(2)-vlim(1))/2+vlim(1)),...
                num2str((vlim(2)-vlim(1))*3/4+vlim(1)),...
                num2str(vlim(2))})
            subplot(1,2,1)
        otherwise
            f2 = figure;
            image(im)
            axis equal
            xlabel(ulabel)
            ylabel(vlabel)
            set(gca,'YDir','normal')
            xlim([0,size(im,2)])
            ylim([0,size(im,1)])
            xticks([0,.25,.5,.75,1]*size(im,2))
            xticklabels({num2str(ulim(1)),...
                num2str((ulim(2)-ulim(1))/4+ulim(1)),...
                num2str((ulim(2)-ulim(1))/2+ulim(1)),...
                num2str((ulim(2)-ulim(1))*3/4+ulim(1)),...
                num2str(ulim(2))})
            yticks([0,.25,.5,.75,1]*size(im,1))
            yticklabels({num2str(vlim(1)),...
                num2str((vlim(2)-vlim(1))/4+vlim(1)),...
                num2str((vlim(2)-vlim(1))/2+vlim(1)),...
                num2str((vlim(2)-vlim(1))*3/4+vlim(1)),...
                num2str(vlim(2))})
            figure(f);
    end
end
patch('Faces',DT,'Vertices',[X(:),Y(:)],'FaceVertexCData',c,...
    'EdgeColor','none','FaceColor','interp')
xlim([min(X(:)),max(X(:))])
ylim([min(Y(:)),max(Y(:))])
end

