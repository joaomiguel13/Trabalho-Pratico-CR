function tp_3_4_b()
    clc

    % Carrega o arquivo CSV
    data = readmatrix('Dataset1 - Hepatitis/Filtered_Train.csv', 'Delimiter', ';', 'DecimalSeparator', '.'); 

    inputs = data(:,3:end)'; % inputs: colunas 3 a 14
    target = data(:,2)';    % target: coluna 2
    target_encoded = onehotencode(target, 1, 'ClassNames', 0:4);


    media_global = 0;
    media_teste = 0;
    media_erro_global = 0;
    media_erro_teste = 0;

% fazer varias iteraçoes na mesma configuraçao de rede e obter uma media
    for x = 1:50
        %% CRIAR REDE COM 1 CAMADA ESCONDIDA COM 10 NÓS
        net = feedforwardnet(10);
    
        %% FUNCAO DE TREINO 
        net.trainFcn = 'trainlm';
        
        %% FUNCAO DE ATIVACAO DA CAMADA DE SAIDA
        net.layers{1}.transferFcn = 'tansig';
        net.layers{2}.transferFcn = 'purelin';
        
        %% DIVISÃO DOS EXEMPLOS
        net.divideFcn = 'dividerand';
        net.divideParam.trainRatio = 0.7; 
        net.divideParam.valRatio = 0.15;  
        net.divideParam.testRatio = 0.15;
    
        %% TREINAR REDE
        tic;
        [net, tr] = train(net,inputs,target_encoded);
        training_time = toc;
    
        %% SIMULAR
        out = sim(net, inputs);     % Aqui os valores vão de 0 a 4 -> possiveis TARGET 

        %disp(out)
        %disp(target_encoded)

        %% VISUALIZAR DESEMPENHO
        %plotconfusion(target,out_rounded);    % Matriz Confusion
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

        fprintf('-------------------------------------------\n');
        fprintf('Tempo total de treino: %f\n', training_time);
        fprintf('Precisão total (nos %d exemplos): %.4f%%\n', length(target), accuracy);
        fprintf('Erro: %.4f\n', erro);
        
        media_global = media_global + accuracy;
        media_erro_global = media_erro_global + erro;


        % Guardar rede neuronal
        % List all .mat files in the current directory
        files = dir('*.mat');

        % Iterate through each file
        if length(files) < 3
            save(append(num2str(accuracy),'.mat'),'net');
        else
            for i = 1:length(files)
                filename = files(i).name;
    
                % Remove the .mat extension
                file_accuracy = strrep(filename, '.mat', '');

                if(accuracy < str2double(file_accuracy))
                    delete(filename)
                    save(append(num2str(accuracy),'.mat'),'net'); 
                    break;
                end
            end
        end


        %% SIMULAR A REDE APENAS NO CONJUNTO DE TESTE
        TInput = inputs(:, tr.testInd);
        TTargets = target(:, tr.testInd);
        TTargets_encoded = onehotencode(TTargets, 1, 'ClassNames', 0:4);
        
        out = sim(net, TInput);
        
        erro = perform(net, out, TTargets_encoded);
        
        
        %Calcula e mostra a percentagem de classificacoes corretas no conjunto de teste
        % Cálculo da precisão total
        r=0;
        for i=1:size(out,2)               % Para cada classificacao
          [~, b] = max(out(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
          [~, d] = max(TTargets_encoded(:,i));  %d guarda a linha onde encontrou valor mais alto da saida desejada
          if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
              r = r+1;
          end
        end
        
        accuracy = r/size(tr.testInd,2)*100;
        fprintf('-------------------------------------------\n');
        fprintf('Precisao teste: %.4f%%\n', accuracy)
        fprintf('Erro na classificação do conjunto de teste: %.4f\n', erro)

        media_teste = media_teste + accuracy;
        media_erro_teste = media_erro_teste + erro;

    
    end

    media_global = media_global/50;
    media_teste = media_teste/50;
    media_erro_global = media_erro_global/50;
    media_erro_teste = media_erro_teste/50;

    fprintf('==================================================\n');
    fprintf('Precisão Global média em 50 iterações: %.4f%%\n',media_global);
    fprintf('Média erro global: %.4f\n',media_erro_global);
    fprintf('==================================================\n');

    fprintf('==================================================\n');
    fprintf('Precisão Teste média em 50 iterações: %.4f%%\n',media_teste);
    fprintf('Média erro teste: %.4f\n',media_erro_teste);
    fprintf('==================================================\n');
   

end
