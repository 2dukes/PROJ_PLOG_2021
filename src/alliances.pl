:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).
:- consult('board.pl').
:- consult('input.pl').
:- consult('utils.pl').
:- consult('bot.pl').
:- consult('logic.pl').
:- consult('menus.pl').
:- consult('display.pl').

% Mother predicate
play :-
    initial(GameState),
    startGame(GameState).
