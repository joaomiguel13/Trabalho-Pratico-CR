function criar_treinar_rede_neuronal_app(csv, num_camadas, num_neuronios, funcao_ativacao1, funcao_ativacao2, funcao_treino, proporcao_train, proporcao_val, proporcao_teste)
    
    net = feedforwardnet(repmat(num_neuronios, 1, num_camadas));

    net.trainFcn = funcao_treino;
    
    n=0;
    for i = 1:num_camadas-1
        n=n+1;
        net.layers{n}.transferFcn = funcao_ativacao1;
    end
    net.layers{n+1}.transferFcn = funcao_ativacao2;

    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = proporcao_train; 
    net.divideParam.valRatio = proporcao_val;  
    net.divideParam.testRatio = proporcao_teste;

    data = readmatrix(csv, 'Delimiter', ';', 'DecimalSeparator', '.'); 

    inputs = data(:,3:14)'; % inputs: colunas 3 a 14
    target = data(:,2)';    % target: coluna 2
    target_encoded = onehotencode(target, 1, 'ClassNames', 0:4);

    [net, tr] = train(net,inputs,target_encoded);

    save("app_net_treinada.mat", "net");

end