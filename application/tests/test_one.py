

import pytest
from brownie import TicTacToe, accounts, reverts
import random

STATE = [0]*9


@pytest.fixture(scope="module")
def contract(TicTacToe):
    return accounts[0].deploy(TicTacToe)


def test_player1(contract, accounts):
    assert contract.player1() == accounts[0]


def test_join(contract, accounts):
    contract.join({"from": accounts[1]})
    assert contract.player2() == accounts[1]

def test_join_failed(contract, accounts):
    """
    This should ideally fail because the tictactoe already has two players
    """
    with reverts("003001"):
        contract.join({"from": accounts[2]})

def test_domove_player_one(contract, accounts):
    """
    Player 1 which is accounts[0] can not doMove at any index from 0 to 8
    We have chosed index 0 to make the move
    """
    STATE[0] = "X"
    contract.doMove(0, {"from": accounts[0]})



def test_move_on_invalid_cell(contract, accounts):
    """
    Players cant move beyong cell number 8, starting from 0
    """

    with reverts("003006"):
        contract.doMove(10, {"from": accounts[1]})

def test_domove_player_one_fail(contract, accounts):
    """
    This should ideally fail because player1 has already made a move and 
    now its player2 turn, So Player1 cannot make a second move until and unless 
    player2 makes a move
    """
    with reverts("003002"):
        contract.doMove(0, {"from": accounts[0]})


def test_current_state(contract, accounts):

    assert contract.currentState()[1] ==  "X--\n---\n---"


def test_domove_player_two(contract, accounts):
    """
    Player 1 which is accounts[0] can not doMove at any index from 0 to 8
    We have chosed index 0 to make the move
    """

    STATE[1] = "O"
    contract.doMove(1, {"from": accounts[1]})


def test_current_state_2(contract, accounts):

    assert contract.currentState()[1] ==  "XO-\n---\n---"



def test_play(contract, accounts):
    """
    Players play at their chane alternatively and will play till 
    the Tictactoe is completed

    Also, Players are playing randomly, so the outcome will be different in every execution
    """
    move = "X"
    moves = list(range(2, 9))
    account = accounts[0]
    for i in range(1, 8): 
        next_move = random.choice(moves) 
        print (f"The next move is {next_move} {STATE}") 
        contract.doMove(next_move, {"from": account})
        moves.remove(next_move) 

        STATE[next_move] = move

        if i%2 == 0: 
            account, move = accounts[0], "X" 
        else: 
            account, move = accounts[1], "O"

    STATE.insert(3, "\n")
    STATE.insert(7, "\n")  
    assert contract.currentState()[1] == "".join(STATE)




def test_game_over(contract, accounts):
    """
    Player 1 which is accounts[0] can not doMove at any index from 0 to 8
    We have chosed index 0 to make the move
    """

    assert contract.isGameOver() == True

    