function func = print_boundary_and_fit(img, lower_retinal_layer, lower_retinal_layer_fit)

% This function prints the estimated lower retinal layer
% and it's polynomial fit
    x = 1:length(lower_retinal_layer);
    figure; imshow(img);
    hold on;
    imshow(img);
    scatter(x,lower_retinal_layer,25,'r','filled')
    hold off;
    f = getframe;
    %saveas(f,'lower_retinal_layer',eps)

    figure; imshow(img);
    hold on;
    imshow(img);
    scatter(x,lower_retinal_layer_fit,25,'g','filled')
    hold off;
    f = getframe;

end
