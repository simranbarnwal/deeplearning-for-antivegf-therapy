function f = flattenning_and_segmentation(img)
%    The function flatten(img) corrects the lower_retinal_layerl curvature of OCT lower_retinal_layer scans 
%    and gives uniformity to all lower_retinal_layer scans.
	
    % original image copy for formatting
    img_cpy = img;

    % applied to remove the speckle noises present
    img_cpy = medfilt2(medfilt2(img_cpy,[7 7]),[7 7]);

    % high intensity white patches resulting from random orientation in raw OCT scans
    % removed by replacing pixels with values above 250 with zero. 

    img_cpy(img_cpy>=250) = 0;

    % binarization of image to obtain sections with intensities above
    % mean intensity of image, highlighting the lower_retinal_layerl layers

    img_cpy = binarize_image(img_cpy)
    
    [upper_retinal_layer, lower_retinal_layer, mx] = boundary_and_interploation(img_cpy)
    
    % Fit polynomial
    x = 1:length(lower_retinal_layer);
    p = polyfit(x, lower_retinal_layer, 2);
    lower_retinal_layer_fit = round(polyval(p, x));
    
    print_boundary_and_fit(img, lower_retinal_layer, lower_retinal_layer_fit);
     
    % correcting retinal curvature by pixel shifting on original image
    img_shift = zeros(size(img), 'uint8');

    for j = 1:length(lower_retinal_layer_fit)
        img_shift(:,j) = circshift(img(:,j), -20-lower_retinal_layer_fit(j));
        lower_retinal_layer_fit(j);
    end

    % replacing high intensity defects due to rotation of image
    mn = mean(mean(img_shift));
    img_shift(img_shift>250)=mn;
    
	
    % finding how much part of the image to segment 
    % such that image has only retinal layers  
    if abs((size(img,1)/2.5+50)-(mx+10))>100
       mx = min((size(img,1)/2.7+50),mx+10);
    end
    
    crop = imcrop(img_shift,[1 (size(img,1)-mx-40) size(img,2) (mx+40)]);
    
    f = crop;
end
    
