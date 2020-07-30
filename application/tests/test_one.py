

import pytest
from brownie import TicTacToe, accounts, reverts

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
    contract.doMove(0, {"from": accounts[0]})







def test_domove_player_one_fail(contract, accounts):
    """
    This should ideally fail because player1 has already made a move and 
    now its player2 turn, So Player1 cannot make a second move until and unless 
    player2 makes a move
    """
    with reverts("003002"):
        contract.doMove(0, {"from": accounts[0]})




# def test_transfer(token, accounts):
#     token.transfer(accounts[1], 100, {'from': accounts[0]})
#     assert token.balanceOf(accounts[0]) == 900