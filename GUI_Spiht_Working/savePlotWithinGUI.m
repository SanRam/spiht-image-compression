function savePlotWithinGUI(axesObject)
%this function takes in two arguments
%axesObject is the axes object that will be saved (required input)
%legendObject is the legend object that will be saved (optional input)
 


 
%get the units and position of the axes object
axesObject = get(axesObject,'UserData');
 

 disp(axesObject)
%saves the plot
imsave
 formats = imformats('*.bmp');