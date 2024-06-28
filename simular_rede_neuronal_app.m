function accuracy = simular_rede_neuronal_app(csv, net)

    load(net, "net");

    % Carrega o arquivo CSV
    data = readmatrix(csv, 'Delimiter', ';', 'DecimalSeparator', '.'); 

    inputs = data(:,3:14)'; % inputs: colunas 3 a 14
    target = data(:,2)';    % target: coluna 2
    target_encoded = onehotencode(target, 1, 'ClassNames', 0:4);

    [net, tr] = train(net,inputs,target_encoded);


     %% SIMULAR
    out = sim(net, inputs);     % Aqui os valores vão de 0 a 4 -> possiveis TARGET 

    %% VISUALIZAR DESEMPENHO
    %plotconfusion(target,out_rounded);    % Matriz Confusion
    %plotperf(tr);    % Grafico com o desempenho da rede nos 3 conjuntos 

    %% Cálculos e Prints

    % Calcular o erro
    %erro = perform(net, out, target_encoded);

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

end