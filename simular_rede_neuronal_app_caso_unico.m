function predicted_target = simular_rede_neuronal_app_caso_unico(v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,net)

    load(net, "net");

    % Create an array with the input values
    unique_case = {v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12};
    unique_case = cellfun(@str2double, unique_case);
    
    % Use the sim function to predict the target for the unique case
    out = sim(net, unique_case');

    % Round the predicted target
    predicted_target = round(out);

end