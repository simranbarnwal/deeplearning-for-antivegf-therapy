function f = flattenning_and_segmentation(img)
%	The function flatten(img) corrects the lower_retinal_layerl curvature of OCT lower_retinal_layerl scans 
%	and gives uniformity to all lower_retinal_layerl scans.
%	
%	
	% original image copy for formatting
    img_cpy = img;

    %figure; imshow(img_cpy); 
    %saveas(img_cpy, 'original', '.eps')

    % applied to remove the speckle noises present

    img_cpy = medfilt2(medfilt2(img_cpy,[7 7]),[7 7]);

    % high intensity white patches resulting from random orientation in raw OCT scans
    % removed by replacing pixels with values above 250 with zero. 

    img_cpy(img_cpy>=250) = 0;

    %figure; imshow(img_cpy); % high intensity removal
    %saveas(img_cpy, 'white_patch_gone', eps)

    % binarization of image to obtain sections with intensities above
    % mean intensity of image, highlighting the lower_retinal_layerl layers

    img_cpy = binarize_image(img_cpy)

    %saveas(img_cpy, 'binary', eps)
    %figure; imshow(img_cpy); % binarization
    
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
    %saveas(img_shift, 'shifted', eps)
    %figure; imshow(img_shift); %shifted image with white removal
	
	% finding how much part of the image to segment 
	% such image has only retinal layers  
    if abs((size(img,1)/2.5+50)-(mx+10))>100
       mx = min((size(img,1)/2.7+50),mx+10);
    end
    
    crop = imcrop(img_shift,[1 (size(img,1)-mx-40) size(img,2) (mx+40)]);
    
    f = crop;
    
    %figure; imshow(img_shift);
    %hold on;
    %imshow(img_shift);
    %scatter(x,(size(img,1)-mx-40)*ones(1,size(img,2)),25,'w','filled')
    %hold off;
    %f = getframe;
    %saveas(f,'fit',eps)
    %saveas(img_cpy, 'final', eps)
    %figure; imshow(crop);
    
    %crop = medfilt2(crop,[5 5]);
    
    %figure; imshow(crop);
end
    