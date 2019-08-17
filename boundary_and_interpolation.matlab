function [f1, f2, f3] = binarize_image(img)

% This script estimates the hyper-reflective retinal pigment epithelium (RPE) layer
% by locating the last occurrences of high intensities in the binarized image

% This script also returns the upper boundary of the retinal layer and 
%the maximum pixel width between lower and upper retinal boundary which would help 
% in image segmentation: focusing only on the parts of image containing the information
% about the disease


	lower_retinal_layer = NaN(1, size(img,2));
    for j = 1:size(img,2)
        last = find(img(:,j) >= 1, 1, 'last');
    
        if isempty(last)
            if j==1
                lower_retinal_layer(j) = size(img,1)/2;
            else
                lower_retinal_layer(j)=lower_retinal_layer(j-1);
            end
        else
            if j==1
                lower_retinal_layer(j) = last;
            end
            % Interpolation is applied to remove outliers from the estimated RPE layer
            if j~=1 && abs(last-lower_retinal_layer(j-1))>3
                last = round((0.1*last+lower_retinal_layer(j-1)*0.9));
                lower_retinal_layer(j) = last;
                lower_retinal_layer(j-1) = last;
            else
                lower_retinal_layer(j) = last;
            end
        end
    end

    upper_retinal_layer = NaN(1, size(img,2));  
    mx = 0;
    for j = 1:size(img,2)
    	first = find(img(:,j) >= 1, 1, 'first');
        if isempty(first)
            if j==1
                upper_retinal_layer(j) = size(img,1)/2;
            else
                upper_retinal_layer(j)=upper_retinal_layer(j-1);
            end
        else
            if j==1
                upper_retinal_layer(j) = first;
            end
            if j~=1 && abs(upper_retinal_layer(j)-upper_retinal_layer(j-1))>10
                first = int((upper_retinal_layer(j)+upper_retinal_layer(j-1))/2);
                upper_retinal_layer(j) = first;
                upper_retinal_layer(j-1) = first;
            else
                upper_retinal_layer(j) = first;
            end
        end
        if abs(upper_retinal_layer(j)-lower_retinal_layer(j))>mx
            mx = abs(upper_retinal_layer(j)-lower_retinal_layer(j));
        end
    end

    f1 = upper_retinal_layer
    f2 = lower_retinal_layer
    f3 = mx

end
