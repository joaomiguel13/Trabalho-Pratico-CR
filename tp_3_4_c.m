function tp_3_4_c()
    clc

    % Carrega o arquivo CSV
    data = readmatrix('Dataset1 - Hepatitis/Test.csv', 'Delimiter', ';', 'DecimalSeparator', '.'); 

    inputs = data(:,3:14)'; % inputs: colunas 3 a 14
    target = data(:,2)';    % target: coluna 2
    target_encoded = onehotencode(target, 1, 'ClassNames', 0:4);

    user_input = input('Nome da rede: ', 's');

    load(user_input, 'net');

    %% SIMULAR
    out = sim(net, inputs);     % Aqui os valores vão de 0 a 4 -> possiveis TARGET
    
    %% VISUALIZAR DESEMPENHO
    
    plotconfusion(target_encoded,out);    % Matriz Confusion

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
    
    disp 'OUT';
    disp(round(out));
    disp 'TARGET'
    disp(target_encoded)

    fprintf('Precisão total (nos %d exemplos): %.4f%%\n', length(target), accuracy);
    fprintf('Erro: %.4f\n', erro);
end