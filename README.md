# plot2D2D
Function to plot 2D data [u,v] at 2D locations [x,y]. Useful for vector fields, complex numbers etc.

Highlights:
* The function lets you choose from 7 different colormaps, two of which are for circular data. This is especially useful for angle/magnitude plots.
* The function returns a function handle to the plot and can generate a colormap as a subfigure, as an individual figure or not at all.
* By adding an image custom.png to the folder, you can easily use your own colormap.
* Four examples (commented in the code) demonstrate how to use the function
* Works with scattered data

Remarks:
* The figures will most likely need some postprocessing before they are presentable
* The use of the circular colormap ChromaMax is discouraged as it can create unintenional edges and highlights in the plot. But is more vivid than ChromaConst.  
* Ticks of the colormap plot are currently fixed to ticks at 0%, 25%, 50%, 75% and 100% of the values.
![Snapshot 1](https://github.com/MarcusBecker-GitHub/plot2D2D/blob/main/Snapshot_01.png)
![Snapshot 2](https://github.com/MarcusBecker-GitHub/plot2D2D/blob/main/Snapshot_02.png)

# Credit
This repo uses colormaps from the [Complex Colormap repo](https://github.com/endolith/complex_colormap) and from the work of 
> Explorative Analysis of 2D Color Maps
> Steiger, M., Bernard, J., Mittelstädt, S., Hutter, M., Keim, D., Thum, S., Kohlhammer, J.
> Proceedings of WSCG (23), 151-160, Eurographics Assciation, Vaclav Skala - Union Agency, 2015

which was highlighted in this [Color 2D repo](https://github.com/dominikjaeckle/Color2D).

The initial version of the code was suggested by [Dave B](https://nl.mathworks.com/matlabcentral/profile/authors/14836566) in a [Matlab Forum Discussion](https://nl.mathworks.com/matlabcentral/answers/1592664-use-of-2d-colormaps-possible-in-matlab) 
