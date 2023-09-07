//////////////////////////////////////////////////////////////////////////////////////////////
//Name: Ben Sadeh
//Date: Thursday January 28
//This is my pong game. You need 2 people to play. The first person to score 7 points wins.
//////////////////////////////////////////////////////////////////////////////////////////////

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//declare all variables
int xBall;
int yBall;
int wBall;
int hBall;
int xBallSpeed;
int yBallSpeed;
int xPaddle1;
int yPaddle1;
int wPaddle1;
int hPaddle1;
int xPaddle2;
int yPaddle2;
int wPaddle2;
int hPaddle2;
int score1;
int score2;
Boolean left;
int startDirection;
Boolean firstBall;
Boolean firstRound;
Boolean notFirstRound;
PImage gameOver;
Boolean done;
PImage background;
PImage ballImage;
Minim minim;
AudioPlayer backgroundMusic;
AudioSample ping;
AudioSample lose;
Boolean firstLoss;
AudioSample roundOver;

void introScreen(){ 
  textSize(40);
  text("Player 1: q/a",width/4,50);
  text("Player 2: p/l",(width/4)*3,50);
  textSize(100);
  fill(175,25,25);
  text("GET READY!",width/2,325);
  textSize(40);
  fill(255);
  text("EASY",200,550);
  text("MEDIUM",400,550);
  text("HARD",600,550);
  image(ballImage,200,450,120,120);
  image(ballImage,400,450,120,120);
  image(ballImage,600,450,120,120);
}

void setup(){
  //start the Sound Engine that allows you to play sounds
  minim=new Minim(this);
  //give values to variables
  xBall=width/2;
  yBall=height/2;
  wBall=50;
  hBall=50;
  xBallSpeed=10;
  yBallSpeed=2;
  xPaddle1=10;
  yPaddle1=width/2;
  wPaddle1=20;
  hPaddle1=100;
  xPaddle2=width-30;
  yPaddle2=width/2;
  wPaddle2=20;
  hPaddle2=100;
  score1=0;
  score2=0;
  firstBall=true;
  firstRound=false;
  notFirstRound=false;
  left=true;
  gameOver=loadImage("gameOver.gif");
  done=true;
  background=loadImage("pongbackground.png");
  ballImage=loadImage("Pongball.png");
  backgroundMusic=minim.loadFile("backgroundMusic.wav");
  ping=minim.loadSample("pingEffect.wav");
  lose=minim.loadSample("loseEffect.wav");
  firstLoss=true;
  roundOver=minim.loadSample("roundOverEffect.wav");
  //set the game screen
  size(800,600);
  background(0);
  smooth();
  imageMode(CENTER);
  textAlign(CENTER);
  //draw an introduction screen with instructions
  introScreen();
}

//Procedures
void redrawGameField(){ 
  //draw the borders of the playing field
  stroke(255,255,0);
  noFill();
  rect(0,0,width-1,height-1);
  //draw the two paddles and the ball
  noStroke();
  fill(255);
  image(ballImage,xBall,yBall,wBall,hBall);
  rect(xPaddle1,yPaddle1,wPaddle1,hPaddle1);
  rect(xPaddle2,yPaddle2,wPaddle2,hPaddle2);
  //draw current score
  textSize(100);
  fill(127);
  text(score1,width/2-50,100);
  text(score2,width/2+50,100);
}

void bounceBall(){
  //if the ball hits the left paddle, change horizontal direction to the right
  if((xBall-25<=30)&&(yBall+50>yPaddle1)&&(yBall-50<yPaddle1+100)){ //cheat feature(allows the ball to hit the paddle wider than it should)
    xBallSpeed=xBallSpeed*(-1);
    yBallSpeed=int(random(-4,4));
    ping.trigger();
  }
  //if the ball hits the right paddle, change horizontal direction to the left
  if((xBall+25>=width-30)&&(yBall+40>yPaddle2)&&(yBall-40<yPaddle2+100)){
    xBallSpeed=xBallSpeed*(-1);
    yBallSpeed=int(random(-4,4));
    ping.trigger();
  }
  //if the ball hits top or bottom border, change the vertical direction to opposite
  if((yBall+25>=height)||(yBall-25<=0)){
    yBallSpeed=yBallSpeed*(-1);
  }
}

void playerOne(){ //to Move Paddle
  if(keyPressed){
    //if player one's key for UP is pressed, move the left paddle one step up
    if(key=='q'){
      yPaddle1-=8;
    }
    //if player one's key for DOWN is pressed, move the left paddle one step down
    if(key=='a'){
      yPaddle1+=8;
    }
  }
}
      
void playerTwo(){ //to Move Paddle
  if(keyPressed){
    //if player two's key for UP is pressed, move the right paddle one step up
    if(key=='p'){
      yPaddle2-=8;
    }
    //if player two's key for DOWN is pressed, move the right paddle one step down
    if(key=='l'){
      yPaddle2+=8;
    }
  }
}

void moveBall(){
  //move the ball one step in its horizontal and vertical directions
  xBall=xBall+xBallSpeed;
  yBall=yBall+yBallSpeed;
}

void castNewBall(){
  //first ball in the game should be randomly cast from left or right side
  int startDirection=int(random(1,3));
  if(firstBall){
    firstBall=false;
    if(startDirection==1){
      xBallSpeed=xBallSpeed*(-1);
    }
  }
  //every next new ball should be cast from the side of the player who lost
  if(left){
    xBallSpeed=xBallSpeed*(-1);
    left=false;
  }
  if(left==false){
    xBallSpeed=xBallSpeed*(-1);
    left=true;
  }
}

void gameOver(){ //Screen layout at the end of the game
  background(0);  
  textSize(100);
  fill(175,25,25);
  text(score1+" : "+score2,width/2,150);
  image(gameOver,width/2,height/2);
  backgroundMusic.pause();
  textSize(40);
  fill(255);
  text("REPLAY",400,550);
  image(ballImage,400,450,120,120);
}



//Main program
void draw(){
  if(done){
    //make the easy, medium, and hard buttons
    if(mousePressed){
      if((mouseX>140)&&(mouseX<260)&&(mouseY>390)&&(mouseY<510)){
        xBallSpeed=10;
        firstRound=true;
      }
      if((mouseX>340)&&(mouseX<460)&&(mouseY>390)&&(mouseY<510)){
        xBallSpeed=15;
        firstRound=true;
      }
      if((mouseX>540)&&(mouseX<660)&&(mouseY>390)&&(mouseY<510)){
        xBallSpeed=20;
        firstRound=true;
      }
    }
    //draw the field to start the game
    if(firstRound){
      image(background,width/2,height/2,width,height);
      redrawGameField();
      firstRound=false;
      notFirstRound=true;
    }else if(notFirstRound){
      //play the background music
      backgroundMusic.play();
      //cast a new ball at the beggining of each set
      castNewBall();
      //constantly redraw the field
      image(background,width/2,height/2,width,height);
      redrawGameField();
      //constantly move the paddles (if key action is detected)
      playerOne();
      playerTwo();
      //constantly move the ball in the current direction
      moveBall();
      //bounce the ball when it hits an obstacle
      bounceBall();
      //detect when the ball goes off the screen and score a point
      if(xBall-25<=0){
        score2+=1;
        xBall=width/2;
        yBall=height/2;
        castNewBall();
        roundOver.trigger();
      }
      if(xBall+25>=width){
        score1+=1;
        xBall=width/2;
        yBall=height/2;
        castNewBall();
        roundOver.trigger();
      }
    }
  }
  //exit when one player scores 7 points
  if(score1>=7){
    gameOver();
    score1=7;
    done=false;
    if(firstLoss){
      lose.trigger();
      firstLoss=false;
    }
    if((mousePressed)&&(mouseX>340)&&(mouseX<460)&&(mouseY>390)&&(mouseY<510)){
      background(0);
      introScreen();
      done=true;
      notFirstRound=false;
      score1=0;
      score2=0;
      delay(1000);
      firstLoss=true;
    }
  }
  if(score2>=7){
    gameOver();
    score2=7;
    done=false;
    if(firstLoss){
      lose.trigger();
      firstLoss=false;
    }
    if((mousePressed)&&(mouseX>340)&&(mouseX<460)&&(mouseY>390)&&(mouseY<510)){
      background(0);
      introScreen();
      done=true;
      notFirstRound=false;
      score1=0;
      score2=0;
      delay(1000);
      firstLoss=true;
    }
  }
}
