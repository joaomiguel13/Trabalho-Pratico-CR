function tp_3_3()
    % clear all
    clc

    %% a)
    % Todos os atributos devem ser convertidos em valores numéricos ou booleanos. Veja os
    % tipos de dados dos mesmos atributos do dataset do ficheiro START e faça as alterações
    % necessárias. Mais informações no ficheiro descrição_datasets.pdf
    % Pode executar esta tarefa usando o Excel, ou implementando um script em Matlab que
    % faça a conversão.


    % Carrega o arquivo CSV - readtable porque existem valores que não são
    % números e dá erro com readmatrix: Unable to perform assignment because dot indexing is not supported for variables of this type.
    data = readtable('Dataset1 - Hepatitis/Train.csv', 'Delimiter', '\t');


    % Processar valores de acordo com valores originais
    data.Category(strcmp(data.Category, '0=Blood Donor')) = {'0'};
    data.Category(strcmp(data.Category, '0s=suspect Blood Donor')) = {'1'};
    data.Category(strcmp(data.Category, '1=Hepatitis')) = {'2'};
    data.Category(strcmp(data.Category, '2=Fibrosis')) = {'3'};
    data.Category(strcmp(data.Category, '3=Cirrhosis')) = {'4'};
    data.Category(strcmp(data.Category, 'NA')) = {'-1'};

    data.Sex(strcmp(data.Sex, 'f')) = {'1'};
    data.Sex(strcmp(data.Sex, 'm')) = {'0'};

    % Converter os valores de string para numérico
    data.Category = str2double(data.Category);
    data.Sex = str2double(data.Sex);

    %disp(data)

    %% b) 
    % Identifique qual o atributo que corresponderá à saída desejada (target) da rede neuronal.
    % Esta coluna possui alguns valores em falta identificados com NA. -> feito no ponto a)
    
    inputs = table2array(data(:,3:14))'; % colunas 3 a 14
    target = table2array(data(:,2))';    % coluna 2
    

    %% c)
    % Implemente um sistema de raciocínio baseado em casos para preencher os atributos
    % com valores em falta (NA). Implemente apenas a fase de RETRIEVE para encontrar o
    % caso mais semelhante àquele onde pretende o preenchimento e use os valores desse caso
    % para preencher os valores em falta.
   
    % Valores Category = -1 (NA)
    filtered_NA_rows = data(data.Category == -1, :);
    
    % Outros valores Category
    filtered_non_NA_rows = data(data.Category ~= -1, :);

    %disp(NA_rows)
    %disp(non_NA_rows)
    
    

    similarity_threshold = 0.6;


    for i = 1:size(filtered_NA_rows, 1)

        current_NA_row = filtered_NA_rows(i, :);
        
        % Convert the current row to a new_case structure
        new_case.age = current_NA_row.Age;
        new_case.sex = current_NA_row.Sex;
        new_case.alb = current_NA_row.ALB;
        new_case.alp = current_NA_row.ALP;
        new_case.alt = current_NA_row.ALT;
        new_case.ast = current_NA_row.AST;
        new_case.bil = current_NA_row.BIL;
        new_case.che = current_NA_row.CHE;
        new_case.chol = current_NA_row.CHOL;
        new_case.crea = current_NA_row.CREA;
        new_case.ggt = current_NA_row.GGT;
        new_case.prot = current_NA_row.PROT;
        
        % 
        [retrieved_indexes, similarities, new_case] = retrieve(filtered_non_NA_rows, new_case, similarity_threshold);
        
        % 
        retrieved_cases = filtered_non_NA_rows(retrieved_indexes, :);
        
        % 
        retrieved_cases.Similarity = similarities';
        
        % 
        %disp(retrieved_cases);
        % Find the index of the highest similarity
        [max_similarity, max_index] = max(retrieved_cases.Similarity);
        

        %fprintf("#%d\n",n);
        %disp(current_NA_row);
        %disp(retrieved_cases(max_index, :));


        % Trocar NA pelo valor categoria do resultado mais próximo
        for j = 1:size(data, 1)
            %current_row = data(j, :);

            if (data(j, :).ID == current_NA_row.ID)
                data(j, :).Category = retrieved_cases(max_index, :).Category;
            end

            if (data(j, :).CREA > 999)
                data(j, :).CREA = randi([20, 500]);
            end
            
        end
        
    end

    %disp(data);
    writetable(data, 'Dataset1 - Hepatitis/Filtered_Train.csv', 'Delimiter', ';');
    

end