% ============================================================
% Sistema Especialista: Recomendacao de Exercicios Fisicos
% Como executar:
%   swipl exercicios.pl
%   ?- iniciar.
% Responda cada pergunta digitando a opcao seguida de PONTO.
% Exemplo: ar_livre.
% ============================================================

% ------------------------------------------------------------
% BASE DE FATOS E RELACOES
% ------------------------------------------------------------

% atividade(Nome)
atividade(caminhada).
atividade(corrida).
atividade(musculacao).
atividade(ciclismo).
atividade(futebol).

% ao_ar_livre(Atividade): realizada ao ar livre
ao_ar_livre(caminhada).
ao_ar_livre(corrida).
ao_ar_livre(ciclismo).
ao_ar_livre(futebol).

% ambiente_fechado(Atividade): realizada em ambiente fechado
ambiente_fechado(musculacao).

% atividade_em_grupo(Atividade)
atividade_em_grupo(futebol).

% atividade_individual(Atividade)
atividade_individual(caminhada).
atividade_individual(corrida).
atividade_individual(musculacao).
atividade_individual(ciclismo).

% indicada_para(Atividade, Objetivo)
indicada_para(caminhada, lazer).
indicada_para(corrida, condicionamento).
indicada_para(ciclismo, condicionamento).
indicada_para(musculacao, fortalecimento).
indicada_para(futebol, lazer).

% nivel_esforco(Atividade, Nivel)
nivel_esforco(caminhada, leve).
nivel_esforco(corrida, intenso).
nivel_esforco(musculacao, intenso).
nivel_esforco(ciclismo, leve).
nivel_esforco(ciclismo, intenso).
nivel_esforco(futebol, intenso).

% ------------------------------------------------------------
% REGRAS
% recomenda(Atividade, Social, Local, Objetivo, Disponibilidade)
%   Social:          individual | grupo
%   Local:           ar_livre | fechado
%   Objetivo:        condicionamento | lazer | fortalecimento
%   Disponibilidade: leve | intenso
% ------------------------------------------------------------

% Regra 1 (conjuncao): caminhada se ar livre E atividade leve
recomenda(caminhada, _Social, Local, _Objetivo, Disp) :-
    Local = ar_livre,
    Disp = leve,
    ao_ar_livre(caminhada),
    nivel_esforco(caminhada, Disp).

% Regra 2 (conjuncao): corrida se ar livre E objetivo condicionamento
recomenda(corrida, _Social, Local, Objetivo, _Disp) :-
    Local = ar_livre,
    Objetivo = condicionamento,
    ao_ar_livre(corrida),
    indicada_para(corrida, Objetivo).

% Regra 3 (conjuncao): musculacao se ambiente fechado E fortalecimento
recomenda(musculacao, _Social, Local, Objetivo, _Disp) :-
    Local = fechado,
    Objetivo = fortalecimento,
    ambiente_fechado(musculacao),
    indicada_para(musculacao, Objetivo).

% Regra 4 (conjuncao): futebol se atividade em grupo E objetivo lazer
recomenda(futebol, Social, _Local, Objetivo, _Disp) :-
    Social = grupo,
    Objetivo = lazer,
    atividade_em_grupo(futebol),
    indicada_para(futebol, Objetivo).

% Regra 5 (disjuncao): ciclismo se ar livre OU objetivo condicionamento
recomenda(ciclismo, _Social, Local, Objetivo, _Disp) :-
    ( Local = ar_livre ; Objetivo = condicionamento ),
    atividade(ciclismo).

% ------------------------------------------------------------
% ENTRADA DE DADOS (usa read/1)
% ------------------------------------------------------------

ler_opcao(Pergunta, Opcoes, Resposta) :-
    nl,
    writeln(Pergunta),
    write('Opcoes: '), writeln(Opcoes),
    write('> '),
    read(Lida),
    (   Lida == end_of_file
    ->  writeln('Entrada encerrada.'), fail
    ;   memberchk(Lida, Opcoes)
    ->  Resposta = Lida
    ;   writeln('Opcao invalida, tente novamente.'),
        ler_opcao(Pergunta, Opcoes, Resposta)
    ).

% ------------------------------------------------------------
% PROGRAMA PRINCIPAL
% ------------------------------------------------------------

iniciar :-
    writeln('=== Sistema Especialista: Recomendacao de Exercicios ==='),
    ler_opcao('Voce prefere atividade individual ou em grupo?',
              [individual, grupo], Social),
    ler_opcao('Voce prefere atividade ao ar livre ou em ambiente fechado?',
              [ar_livre, fechado], Local),
    ler_opcao('Qual e o seu objetivo principal?',
              [condicionamento, lazer, fortalecimento], Objetivo),
    ler_opcao('Voce tem disponibilidade para atividade leve ou intensa?',
              [leve, intenso], Disp),
    findall(A, recomenda(A, Social, Local, Objetivo, Disp), Lista),
    list_to_set(Lista, Recomendadas),
    mostrar_resultado(Recomendadas).

mostrar_resultado([]) :-
    nl,
    writeln('Nenhuma atividade atende exatamente ao seu perfil.'),
    writeln('Sugestao geral: comece com uma caminhada leve!').
mostrar_resultado([Unica]) :-
    nl,
    write('Atividade recomendada: '), writeln(Unica).
mostrar_resultado([Primeira, Segunda | Resto]) :-
    nl,
    write('Atividades recomendadas para o seu perfil: '),
    nl,
    imprimir_lista([Primeira, Segunda | Resto]).

imprimir_lista([]).
imprimir_lista([A | Resto]) :-
    write(' - '), writeln(A),
    imprimir_lista(Resto).