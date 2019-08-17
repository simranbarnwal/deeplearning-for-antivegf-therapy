function f = binarize_image(img)

% This function binarizes the image to obtain sections with intensities 
% above mean intensity of image, highlighting the retinal layers

	img(img<mean(mean(img))) = 0;

	% median filtering to reduce uneveness in the retinal layers boundaries 
    img = medfilt2(img,[5 5]);

    % distinguishes the retinal layers from the low intensity(<10) background
    img(img>10) = 200;

    f = img;

end