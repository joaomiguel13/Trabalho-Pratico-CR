function tp_3_4_a()
    %clear all
    clc

    % Carrega o arquivo CSV
    data = readmatrix('Dataset1 - Hepatitis/Start.csv', 'Delimiter', ';', 'DecimalSeparator', '.'); 
    
    inputs = data(:,3:14)'; % inputs: colunas 3 a 14
    target = data(:,2)';    % target: coluna 2
    target_encoded = onehotencode(target, 1, 'ClassNames', 0:4);

    %% CRIAR REDE COM 1 CAMADA ESCONDIDA COM 10 NÓS
    net = feedforwardnet(10);

    %% FUNCAO DE TREINO 
    net.trainFcn = 'trainlm';
    
    %% FUNCAO DE ATIVACAO DA CAMADA DE SAIDA
    net.layers{1}.transferFcn = 'tansig'; % tansig
    net.layers{2}.transferFcn = 'purelin';   %purelin
    
    %% DIVISÃO DOS EXEMPLOS
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = 1.0; % 100% dos dados para treinamento
    net.divideParam.valRatio = 0.0;  % Nenhum exemplo para validação
    net.divideParam.testRatio = 0.0; % Nenhum exemplo para teste

    %% TREINAR REDE
    tic;
    [net, tr] = train(net,inputs,target_encoded);
    training_time = toc;

    %% SIMULAR
    out = sim(net, inputs);     % Aqui os valores vão de 0 a 4 -> possiveis TARGET
    
    %% VISUALIZAR DESEMPENHO

    %plotconfusion(target_encoded,out);    % Matriz Confusion
    %plotperf(tr);    % Grafico com o desempenho da rede nos 3 conjuntos 

    %% Cálculos e Prints
    
    % Calcular o erro
    erro = perform(net, out, target_encoded);

    % Cálculo da precisão total
    r=0;
    for i=1:size(out,2)               % Para cada classificacao
      [~, b] = max(out(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
      [~, d] = max(target_encoded(:,i));  %d guarda a linha onde encontrou valor mais alto da saida desejada
      if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
          r = r+1;
      end
    end
    
    accuracy = r/size(out,2)*100;

    %fprintf('Tempo de execução do treinamento: %.2f segundos\n', training_time);
    fprintf('Tempo total de treino: %f\n', training_time);
    fprintf('Precisão total (nos %d exemplos): %.4f%%\n', length(target), accuracy);
    fprintf('Erro: %.4f\n', erro);

end