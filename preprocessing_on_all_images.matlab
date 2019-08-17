function f = preprocessing_on_all_images()
% This script iterates through all raw images
% dlattening and segmentation is performed
% and resizing is done, finally all images are 
% stored in an output folder

	% original categories of raw OCT images
    ccc = ["CNV","DME","DRUSEN","NORMAL"];
    for i = 1:4

		% folder with big images
	    Input_folder = convertStringsToChars(strcat('C:\Users\Simran Barnwal\Documents\BTP DATA\ZhangLabData\CellData\nonprocessedOCT\train\',ccc(i),'\')); 
	    Output_folder = convertStringsToChars(strcat('C:\Users\Simran Barnwal\Documents\BTP DATA\no_median_filter_60_200\train\',ccc(i),'\'));
	    D = dir([Input_folder convertStringsToChars(strcat(ccc(i),'*.jpeg'))]);
	    Inputs = {D.name}';

	    % preallocate
	    Outputs = Inputs; 

	    for k = 1:length(Inputs)
	        X = imread([Input_folder Inputs{k}]);
	        l = size(size(X));

	        % convert o grayscale if not in grayscale
	        if l(2)==3
	            X = rgb2gray(X);
	        end

	        X = flattenning_and_segmentation(X);
	       
	        idx = k; % index number
	        Y = imresize(X, [60 200]);
	        imwrite(Y, [Output_folder Outputs{k}],'jpeg');
	    end
    end
end