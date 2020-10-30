# ***Alliances* - Relatório** 

- **Jogo**: Alliances
- **Grupo**: Alliances_1



| Turma  | Nome          | Número    |
| -------|---------------| ----------|
| 3      | Davide Castro | 201806512 |
| 3      | Rui Pinto     | 201806441 |

<br />


# O Jogo: *Alliances*
<p align="justify"> 
    O <i>Alliances</i> é um jogo de tabuleiro para dois jogadores. O objetivo do jogo consiste em conectar lados opostos do tabuleiro, que partilhem a mesma cor. Para fazer essa ligação, os jogadores terão de usar a cor respeitante aos lados que estão a conectar, podendo também ter a ajuda da sua cor aliada.
</p>

<p align="center">
    <img src="https://nestorgames.com/gameimages/alliances.jpg" /> <br />
    <i>Tabuleiro de Jogo</i>
</p>

<br />

<p align="justify"> 
    O material necessário para o jogo é um tabuleiro hexagonal, 42 discos verdes, 42 discos laranjas, 42 discos roxos e 2 discos prateados.
</p>

<br />

## Preparação e regras
<p align="justify"> 
    Inicialmente, o tabuleiro está vazio. O jogador um inicia a sua jogada, pegando num disco e colocando-o num lugar vazio. O jogador dois executa o mesmo procedimento. Durante o decorrer do jogo, caso um jogador consiga conectar dois lados oposto do tabuleiro (mesma cor), podendo utilizar cores aliadas (como indica a imagem a seguir), o mesmo deverá pegar num disco da cor que completou e colocá-lo sobre a célula correspondente do seu gráfico, enquanto que o adversário deverá pegar num disco prateado e colocá-lo igualmente no        respetivo lugar do seu gráfico (indicando que perdeu essa cor). 
</p>

<p align="center">
    <img src="images/allied_colours.png" /> <br />
    <i>Cores Aliadas</i><br /><br />
    <img src="images/colour_won.png" /> <br />
    <i>Cor roxa completada pelo jogador de baixo (cor aliada verde)</i> <br /><br />
</p>


<p align="justify"> 
    Se um movimento torna impossível para o outro jogador conectar uma cor particular (cercando-a), então o jogador que fez o bloqueio ganha a cor bloqueada. 
</p>

<p align="center">
    <img src="images/fence.png" /><br />
     <i>Cerco à cor laranja permite ao jogador de baixo ganhar a mesma, pois o de cima, com as cores verde e laranja, não consegue completá-la</i>
</p>

<br />
<p align="justify"> 
    Cada cor só poderá ser ganha por um jogador; aquele que alcança a mesma primeiro. No caso de um jogador formar uma conexão para ambos os jogadores, durante uma jogada, a primeira cor completada pertencerá ao jogador que efetuou a jogada.
</p>

Link para a página de regras do jogo: https://nestorgames.com/rulebooks/ALLIANCES_EN.pdf

## Objetivo

Um jogador sagra-se vencedor assim que conseguir completar uma segunda cor. <br /><br />

# Representação do Estado do Jogo

### Átomos 
**nodef** - Espaço fora do tabuleiro\
**space** - Meio espaço fora do tabuleiro\
**orange** - Peça laranja\
**green** - Peça verde\
**purple** - Peça roxa\
**empty** - Espaço do tabuleiro sem peça
**orangeEnd** - Espaço no limite da extremidade laranja
**greenEnd** - Espaço no limite da extremidade verde
**purpleeEnd** - Espaço no limite da extremidade roxa
**orangeEndSpace** - Meio espaço no limite da extremidade laranja
**greenEndSpace** - Meio espaço no limite da extremidade verde
**purpleEndSpace** - Meio espaço no limite da extremidade roxa

<br />

### Player Atual
```
:- dynamic player/1.
player(1). % First Player.
```

<br />

### Peças por jogar
```
:- dynamic green/1.
:- dynamic orange/1.
:- dynamic purple/1.

orange(42).
purple(42).
green(42).
```

<br />

### Tabuleiro
#### Estado Inicial
>**initial**([\
    [nodef, nodef, nodef, nodef, space, purpleEnd, purpleEnd, purpleEnd, purpleEnd, purpleEnd      ],\
    [nodef, nodef, nodef, nodef, space,                          empty, empty, empty, empty, empty                 ],\
    [nodef, nodef, orangeEnd,                          empty, empty, empty, empty, empty, empty, empty, empty,          greenEndSpace],\
    [nodef, nodef, orangeEndSpace,                empty, empty, empty, empty, empty, empty, empty, empty, empty,          greenEndSpace],\
    [nodef, orangeEnd,                          empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,          greenEndSpace],\
    [nodef, orangeEndSpace,                  empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,           greenEndSpace],\
    [orangeEnd,                          empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,           greenEndSpace],\
    [nodef, space,                          empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty                          ],\
    [greenEnd,                           empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,           orangeEndSpace],\
    [nodef, greenEndSpace,                   empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,           orangeEndSpace],\
    [nodef, greenEnd,                           empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,           orangeEndSpace],\
    [nodef, nodef, greenEndSpace,                 empty, empty, empty, empty, empty, empty, empty, empty, empty,          orangeEndSpace],\
    [nodef, nodef, greenEnd,                           empty, empty, empty, empty, empty, empty, empty, empty,           orangeEndSpace],\
    [nodef, nodef, nodef, nodef, space,                          empty, empty, empty, empty, empty                                     ],\
    [nodef, nodef, nodef, nodef, space, purpleEnd, purpleEnd, purpleEnd, purpleEnd, purpleEnd]\
]).

<br />

#### Estado Intermédio
>**mid**([\
    [nodef, nodef, nodef, nodef, space, purpleEnd, purpleEnd, purpleEnd, purpleEnd, purpleEnd      ],\
    [nodef, nodef, nodef, nodef, space,                          empty, purple, empty, empty, empty                 ],\
    [nodef, nodef, orangeEnd,                          empty, empty, purple, empty, empty, empty, empty, empty,          greenEndSpace],\
    [nodef, nodef, orangeEndSpace,                empty, empty, empty, empty, empty, empty, empty, empty, empty,          greenEndSpace],\
    [nodef, orangeEnd,                          empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,          greenEndSpace],\
    [nodef, orangeEndSpace,                  empty, empty, green, empty, empty, empty, empty, empty, empty, empty, empty,           greenEndSpace],\
    [orangeEnd,                          empty, empty, empty, empty, empty, empty, orange, empty, empty, empty, empty, empty,           greenEndSpace],\
    [nodef, space,                          empty, empty, empty, empty, empty, empty, green, empty, empty, empty, empty                          ],\
    [greenEnd,                           empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,            orangeEndSpace],\
    [nodef, greenEndSpace,                   empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,           orangeEndSpace],\
    [nodef, greenEnd,                           empty, empty, empty, empty, orange, empty, empty, empty, empty, empty,         orangeEndSpace],\
    [nodef, nodef, greenEndSpace,                 empty, empty, empty, empty, empty\, empty, empty, empty, empty,          orangeEndSpace],\
    [nodef, nodef, greenEnd,                           empty, empty, empty, empty, empty, empty, empty, empty,           orangeEndSpace],\
    [nodef, nodef, nodef, nodef, space,                          empty, empty, empty, empty, empty                                     ],\
    [nodef, nodef, nodef, nodef, space, purpleEnd, purpleEnd, purpleEnd, purpleEnd, purpleEnd]\
]).

<br />

#### Estado Final
>**final**([\
    [nodef, nodef, nodef, nodef, space, purpleEnd, purpleEnd, purpleEnd, purpleEnd, purpleEnd      ],\
    [nodef, nodef, nodef, nodef, space,                          empty, purple, empty, empty, empty                 ],\
    [nodef, nodef, orangeEnd,                          empty, empty, purple, empty, empty, empty, empty, empty,          greenEndSpace],\
    [nodef, nodef, orangeEndSpace,                empty, empty, purple, empty, empty, empty, empty, empty, green,          greenEndSpace],\
    [nodef, orangeEnd,                          empty, empty, empty, purple, empty, empty, empty, empty, green, empty,          greenEndSpace],\
    [nodef, orangeEndSpace,                  empty, empty, green, purple, empty, empty, empty, empty, green, empty, empty,           greenEndSpace],\
    [orangeEnd,                          empty, empty, empty, empty, purple, green, orange, empty, green, empty, empty, empty,           greenEndSpace],\
    [nodef, space,                          empty, empty, empty, purple, empty, empty, green, green, empty, empty, empty                          ],\
    [greenEnd,                           empty, empty, empty, empty, purple, empty, green, green, empty, empty, empty, empty,            orangeEndSpace],\
    [nodef, greenEndSpace,                   empty, empty, empty, purple, empty, green, empty, empty, empty, empty, empty,           orangeEndSpace],\
    [nodef, greenEnd,                           empty, empty, empty, purple, green, orange, empty, empty, empty, empty,         orangeEndSpace],\
    [nodef, nodef, greenEndSpace,                 empty, green, purple, green, empty, empty, empty, empty, empty,           orangeEndSpace],\
    [nodef, nodef, greenEnd,                           green, green, purple, empty, empty, empty, empty, empty,           orangeEndSpace],\
    [nodef, nodef, nodef, nodef, space,                          purple, empty, empty, empty, empty                                     ],\
    [nodef, nodef, nodef, nodef, space, purpleEnd, purpleEnd, purpleEnd, purpleEnd, purpleEnd]\
]).

<br /><br />
<p align="center">
    <img src="images/InitialBoard.png" /><br />
    <i>Tabuleiro no Estado Inicial</i><br /> <br /><br />
    <img src="images/MidBoard.png" /><br />
    <i>Tabuleiro no Estado Intermédio</i><br /> <br /><br />
    <img src="images/FinalBoard.png" /><br />
    <i>Tabuleiro no Estado Final</i><br /> <br />
</p>

# Visualização do estado de jogo ##
<p align="justify"> 
    Para visualizar o tabuleiro usamos o predicado display_game/2 que imprime uma linha do tabuleiro (print_line/1) e continua recursivamente até imprimir todas as linhas. Através do predicado print_line/1 imprimimos no ecrã cada linha dividida por três partes(print_top, print_mid, print_bot), para conseguirmos as formas dos hexágonos com a letra da cor correspondente no centro.
</p>

```
display_game([], Player) :- % Switch Player every time we end printing the board.
    NewPlayer is (Player + 1) mod 2,
    updatePlayer(NewPlayer),
    display_discs,
    display_player(Player).

display_game([L | T], Player) :- % Displays the current Board.
    print_line(L),
    display_game(T, Player).

display_discs :-
    orange(O), green(G), purple(P),
    write('Orange discs: '), write(O), nl,
    write('Green discs: '), write(G), nl,
    write('Purple discs: '), write(P), nl.

display_player(Player) :-
    write('Player '), 
    write(Player),
    write(' is next').

print_top([]).
print_top([C | L]) :- % Displays the top part of a line of the board.
    (
        (
            C \= nodef,
            C \= space,
            \+ end(C),
            write(' ____ ')
        );
        (
            code(C, P),
            write(P)
        )
    ), 
    print_top(L).

print_mid([]).
print_mid([C | L]) :- % Displays the middle part of a line of the board.
    (
        (
            C \= nodef,
            C \= space,
            \+ end(C),
            put_code(9585), write('  '), 
            code(C, P), write(P),
            write(' '), put_code(9586)
        );
        (
            code(C, P),
            write(P)
        )
    ),
    print_mid(L).

print_bot([]).
print_bot([C | L]) :- % Displays the bottom part of a line of the board.
    (
        (
            C \= nodef,
            C \= space,
            \+ end(C),
            put_code(9586), write('____'), put_code(9585)
        );
        (
            code(C, P),
            write(P)
        )
    ),
    print_bot(L).

print_line([]).
print_line(L) :- % Displays a full line of the board.
    print_top(L), nl,
    print_mid(L), nl,
    print_bot(L), nl.

```

>Nota: Para uma correta visualização do jogo as fontes recomendadas a utilizar são a DejaVu Sans Mono ou Consolas.