import java.util.Random;

int WIDTH = 600;
int HEIGHT = 600;
int SILLY_OFFSET = 40;

public static enum PLAYER {
      ONE() {
        @Override
        public PLAYER handleClick(int col, int row) {
          if (board[row][col] != 0){ //Spot Taken
            println("This spot is chosen already! Try again!");
            return PLAYER.ONE;
          }else{
            board[row][col] = 1;
            if (checkWinner()) {
              println("PLAYER ONE IS VICTORIOUS! CLICK ANYWHERE TO PLAY AGAIN. THIS TIME PLAYER 2 WILL GO FIRST!");
              return PLAYER.ONE_WINNER;
            } else if (turn >= 9) {
              println("DRAW!, CLICK ANYWHERE TO PLAY AGAIN. I WILL RANDOMLY SELECT A PLAYER TO GO FIRST");
              return PLAYER.DRAW;
            } else {
              turn++;
              println("Player 2's turn!");
              return PLAYER.TWO;
            }
          }
        }
      }, 
      TWO() {
        @Override
        public PLAYER handleClick(int col, int row) {
          if (board[row][col] != 0){ //Spot Taken
            return PLAYER.TWO;
          }else{
            board[row][col] = 2;
            if (checkWinner()) {
              println("PLAYER TWO IS VICTORIOUS! CLICK ANYWHERE TO PLAY AGAIN. THIS TIME PLAYER 1 WILL GO FIRST!");
              return PLAYER.TWO_WINNER;
            } else if (turn >= 9) {
              println("DRAW!, CLICK ANYWHERE TO PLAY AGAIN. I WILL RANDOMLY SELECT A PLAYER TO GO FIRST");
              return PLAYER.DRAW;
            } else {
              turn++;
              println("Player 1's turn!");
              return PLAYER.ONE;
            }
          }
        }
      }, 
      DRAW() {
        @Override
        public PLAYER handleClick(int col, int row) {
          clearBoard();
          turn = 0;
          Random rand = new Random();
          float rand_num = rand.nextFloat();
          if (rand_num < .5) {
            println("Player 1 goes first!");
            return PLAYER.ONE;
          }
          println("Player 2 goes first!");
          return PLAYER.TWO;
        }
      },
      ONE_WINNER() {
        @Override
        public PLAYER handleClick(int col, int row) {
          clearBoard();
          turn = 1;
          println("Player 2's turn!");
          return PLAYER.TWO;
        }
      },
      TWO_WINNER() {
        @Override
        public PLAYER handleClick(int col, int row) {
          clearBoard();
          turn = 1;
          println("Player 1's turn!");
          return PLAYER.ONE;
        }  
      };
      
      static int turn = 1;
      
      public PLAYER handleClick(int c, int r) {
        return null;  
      }
      
      boolean checkWinner() {
        //checking columns
        for (int x = 0; x < 3; x++) {
          int score_counter = 0;
          for (int y = 0; y < 3; y++) {
            if(board[y][x] == 0){
              score_counter = 0;
              break;
            }
            score_counter += board[y][x];
          }
          if(score_counter == 6 || score_counter == 3) return true;
        }
        //Checking rows
        for (int y = 0; y < 3; y++) {
          int score_counter = 0;
          for (int x = 0; x < 3; x++) {
            if(board[y][x] == 0){
              score_counter = 0;
              break;
            }
            score_counter += board[y][x];
          }
          if(score_counter == 6 || score_counter == 3) return true;
        }
        //checking diagonals
        int score_counter = 0;
        for(int i = 0; i < 3; i++) {
          if(board[i][i] == 0){
              score_counter = 0;
              break;
          }
          score_counter += board[i][i];
        }
        if(score_counter == 6 || score_counter == 3) return true;
        //check inverse diagonal
        score_counter = board[0][2] + board[1][1] + board[2][0];
        if((score_counter == 6 || score_counter == 3) &&
            board[0][2] != 0 && board[1][1] != 0 && board[2][0] != 0) return true;
        return false;
      }
    };

PLAYER player;

void drawBoard() {
  background(0);
  stroke(255);
  strokeWeight(10);
  line(WIDTH/3, 0, WIDTH/3, HEIGHT);
  line(2 * WIDTH/3, 0, 2 * WIDTH/3, HEIGHT);
  line(0, HEIGHT/3, WIDTH, HEIGHT/3);
  line(0, 2 * HEIGHT/3, WIDTH, 2*HEIGHT/3);
}

static int[][] board = {
     {0, 0, 0},
     {0, 0, 0},
     {0, 0, 0}
}; 

void setup() {
  size(600, 600);
  textSize(200);
  background(0);
  textAlign(CENTER, CENTER);
  drawBoard();
  println("Welcome to Tic Tac Toe! Player 1 is X and Player 2 is O");
  println("Player 1's turn!");
  player = PLAYER.ONE;
}

PVector findBox(float x, float y) {
  int col = floor(map(x, 0, WIDTH, 0, 3));
  int row = floor(map(y, 0, HEIGHT, 0, 3));
  return new PVector(col, row);
}

void mouseClicked() {
  PVector boxClicked = findBox(mouseX, mouseY);
  player = player.handleClick(floor(boxClicked.x), floor(boxClicked.y));
}

void updateBoard(){
  drawBoard();
  for(int row = 0; row < 3; row++) {
    for(int col = 0; col < 3; col++) {
      int centerX = col*200+100;
      int centerY = row*200+100 - SILLY_OFFSET;
      if(board[row][col] == 1) {
        text("X", centerX, centerY);
      }else if(board[row][col] == 2) {
        text("O", centerX, centerY);
      }
    }
  }
}

static void clearBoard() {
  for(int row = 0; row < 3; row++) {
    for(int col = 0; col < 3; col++) {
      board[row][col] = 0;
    }
  }
}


void draw() {
  updateBoard();
}
