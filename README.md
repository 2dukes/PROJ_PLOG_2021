# ***Alliances* - Relatório** 

- **Jogo**: Alliances
- **Grupo**: Alliances_1



| Turma  | Nome          | Número    |
| -------|---------------| ----------|
| 3      | Davide Castro | 201806512 |
| 3      | Rui Pinto     | 201806441 |

<br />


# O Jogo: *Alliances*
<p style='text-align: justify;'> 
    O *Alliances* é um jogo de tabuleiro para dois jogadores. O objetivo do jogo consiste em conectar lados opostos do tabuleiro, que partilhem a mesma cor. Para fazer essa ligação, os jogadores terão de usar a cor respeitante aos lados que estão a conectar, podendo também ter a ajuda da sua cor aliada.
</p>

<p align="center">
    <img src="https://nestorgames.com/gameimages/alliances.jpg" /> <br />
    <i>Tabuleiro de Jogo</i>
</p>

<br />

<p style='text-align: justify;'> 
    O material necessário para o jogo é um tabuleiro hexagonal, 42 discos verdes, 42 discos laranjas, 42 discos roxos e 2 discos prateados.
</p>

<br />

## Preparação e regras
<p style='text-align: justify;'> 
    Inicialmente, o tabuleiro está vazio. O jogador um inicia a sua jogada, pegando num disco e colocando-o num lugar vazio. O jogador dois executa o mesmo procedimento. Durante o decorrer do jogo, caso um jogador consiga conectar dois lados oposto do tabuleiro (mesma cor), podendo utilizar cores aliadas (como indica a imagem a seguir), o mesmo deverá pegar num disco da cor que completou e colocá-lo sobre a célula correspondente do seu gráfico, enquanto que o adversário deverá pegar num disco prateado e colocá-lo igualmente no        respetivo lugar do seu gráfico (indicando que perdeu essa cor). 
</p>

<p align="center">
    <img src="images/allied_colours.png" /> <br />
    <i>Cores Aliadas</i><br /><br />
    <img src="images/colour_won.png" /> <br />
    <i>Cor roxa completada pelo jogador de baixo (cor aliada verde)</i> <br /><br />
</p>


<p style='text-align: justify;'> 
    Se um movimento torna impossível para qualquer jogador conectar uma cor particular (cercando-a), então o jogador adversário bloqueado ganha essa cor.
</p>

<p align="center">
    <img src="images/fence.png" /><br />
    <i>Cerco à cor laranja</i>
</p>

<br />
<p style='text-align: justify;'> 
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

<br />

### Estado Inicial
>**initial**([\
    [nodef, nodef, nodef, space, empty, empty, empty, empty, empty, nodef, nodef, nodef],\
    [nodef, nodef, empty, empty, empty, empty, empty, empty, empty, empty, nodef, nodef],\
    [nodef, space, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],\
    [nodef, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],\
    [space, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],\
    [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],\
    [space, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],\
    [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],\
    [space, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],\
    [nodef, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],\
    [nodef, space, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],\
    [nodef, nodef, empty, empty, empty, empty, empty, empty, empty, empty, nodef, nodef],\
    [nodef, nodef, nodef, space, empty, empty, empty, empty, empty, nodef, nodef, nodef]\
]).

<br />

### Estado Intermédio
>**mid**([\
    [nodef, nodef, nodef, space, empty, purple, empty, empty, empty, nodef, nodef, nodef],\
    [nodef, nodef, empty, empty, purple, empty, empty, empty, empty, empty, nodef, nodef],\
    [nodef, space, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],\
    [nodef, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],\
    [space, empty, empty, green, empty, empty, empty, empty, empty, empty, empty, empty],\
    [empty, empty, empty, empty, empty, empty, orange, empty, empty, empty, empty, empty],\
    [space, empty, empty, empty, empty, empty, empty, green, empty, empty, empty, empty],\
    [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],\
    [space, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],\
    [nodef, empty, empty, empty, empty, empty, orange, empty, empty, empty, empty, nodef],\
    [nodef, space, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],\
    [nodef, nodef, empty, empty, empty, empty, empty, empty, empty, empty, nodef, nodef],\
    [nodef, nodef, nodef, space, empty, empty, empty, empty, empty, nodef, nodef, nodef]\
]).

<br />

### Estado Final
>**final**([\
    [nodef, nodef, nodef, space, empty, purple, empty, empty, empty, nodef, nodef, nodef],\
    [nodef, nodef, empty, empty, purple, empty, empty, empty, empty, empty, nodef, nodef],\
    [nodef, space, empty, empty, purple, empty, empty, empty, empty, empty, empty, nodef],\
    [nodef, empty, empty, empty, purple, empty, empty, empty, empty, empty, empty, nodef],\
    [space, empty, empty, green, purple, empty, empty, empty, empty, empty, empty, empty],\
    [empty, empty, empty, empty, purple, empty, orange, empty, empty, empty, empty, empty],\
    [space, empty, empty, empty, purple, empty, empty, green, empty, empty, empty, empty],\
    [empty, empty, empty, empty, purple, empty, empty, empty, empty, empty, empty, empty],\
    [space, empty, empty, empty, purple, empty, empty, empty, empty, empty, empty, empty],\
    [nodef, empty, empty, empty, purple, empty, orange, empty, empty, empty, empty, nodef],\
    [nodef, space, empty, empty, purple, empty, empty, empty, empty, empty, empty, nodef],\
    [nodef, nodef, empty, empty, purple, empty, empty, empty, empty, empty, nodef, nodef],\
    [nodef, nodef, nodef, space, purple, empty, empty, empty, empty, nodef, nodef, nodef]\
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
display_game([L | T], Player) :-
    print_line(L),
    display_game(T, Player).

display_game([], Player) :- % Switch Player every time we end printing the board.
    NewPlayer is (Player + 1) mod 2,
    updatePlayer(NewPlayer).

print_top([]).
print_top([C | L]) :- 
    (
        (
            C \= nodef,
            C \= space,
            write(' ____ ')
        );
        (
            code(C, P),
            write(P)
        )
    ), 
    print_top(L).

print_mid([]).
print_mid([C | L]) :-
    (
        (
            C \= nodef,
            C \= space,
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
print_bot([C | L]) :-
    (
        (
            C \= nodef,
            C \= space,
            put_code(9586), write('____'), put_code(9585)
        );
        (
            code(C, P),
            write(P)
        )
    ),
    print_bot(L).

print_line([]).
print_line(L) :-
    print_top(L), nl,
    print_mid(L), nl,
    print_bot(L), nl.

```

>Nota: Para uma correta visualização do jogo as fontes recomendadas a utilizar são a DejaVu Sans Mono ou Consolas.