
pragma solidity 0.6.1;



contract TicTacToe {


    string constant ONLY_TWO_PLAYERS_ALLOWED = "003001";
    string constant NOT_YOUR_TURN = "003002";
    string constant INVALID_PLAYER = "003003";

    string constant GAME_ALREADY_OVER = "003004";
    string constant CELL_NOT_EMPTY = "003005";
    string constant INVALID_CELL_NUMBER = "003006";



    uint[]  board = new uint[](9); 

    address public player1;
    address public player2;
    uint whoseTurn = 1; 
    
    constructor() public {
        player1= msg.sender;
    }
 
    function join() public {
        require (player2 == address(0), ONLY_TWO_PLAYERS_ALLOWED);
        player2 = msg.sender;
    }
    
    modifier validPlayers {
      require(msg.sender == player1 || msg.sender == player2, INVALID_PLAYER);
      _;
    }    
    
    
    modifier isEmptyPlace(uint _place) {
      require(board[_place] == 0, CELL_NOT_EMPTY);
      _;
    }   
    
    modifier validTurn() {
        if (whoseTurn == 1){
            require(msg.sender == player1, NOT_YOUR_TURN);
        }else {
            require(msg.sender == player2, NOT_YOUR_TURN);
        }
        
        _;
    }
    
    modifier isGameOver(){
        require (checkWinner() != 1, GAME_ALREADY_OVER);
        _;
    }
    
    uint[][] tests = [[0,1, 2], [3, 4, 5], 
                        [6, 7, 8], [0, 3, 6], [1, 4, 7], 
                        [2, 5, 8], [0, 4, 8], [2, 4, 6]];
    
    function checkWinner() public view  returns (uint) {
        
        for (uint i=0; i < tests.length; i++){
            uint[] memory b = tests[i];
            
            if (board[b[0]] != 0 && board[b[0]] == board[b[1]] && board[b[0]] == board[b[2]]) {
                return board[b[0]];
            }

            
        }
        return 0;
    }
    
    function doMove(uint _place) public validPlayers validTurn isEmptyPlace(_place)  isGameOver returns (uint) {
        require (_place <=8, INVALID_CELL_NUMBER);
        board[_place] = whoseTurn;
        whoseTurn = 3 - whoseTurn;
        return 0;
        
    }
    
    
    function currentState() public view returns (string memory, string memory){
        string memory text = "No winner yet";
        uint winner = checkWinner();
        
        if (winner == 1) {
            text = "winner is X" ;
        }
        
        if (winner == 2) {
            text = "winner is 0";
        }
        
        
        bytes memory out = new bytes(11);
        byte[] memory signs = new byte[](3);
        
        bytes(out)[3] = "\n";
        bytes(out)[7] = "\n";
        
        signs[0] = "-";
        signs[1] = "X";
        signs[2] = "O";
        
        for (uint i=0; i <9; i++){
          bytes(out)[i] = signs[board[i]];
            
        }
        
        return (text, string(out));
    }
    
}