# maxscript-colour_by_speed
based on the colour by distance script but now using the speed to set the colour

loops through all objects based on a certain prefix then loops through all frames and sets a key on the diffuse colour of the material (will create a standard material in case the material is missing)

parameters:

prefix
start frame
end frame

a table a speeds:
* at speed 0 the colour is black
* at speed 20 the colour is green
* at speed 30 the colour is orange
* anything above 50 is red
