/*------------------------
 MATH 24 Challenge Game
 By: Ryan Wilk
 Last Update: 6/9/15
 
 Notes:
 -fix lives
 -add main menu
 --move mode to home screen (call it solver)
 --back to main menu button
 --options button
 --single player button
 --high score button
 -add graphics
 -----------------------*/
import java.io.File;

//Game Parameters
int maxRand=0;
int amtNumbers=0;
int midPoint=6;
int highPoint=12;
int maxTime=0;
int screenW=800;
int screenH=600;
color bgColor=color(0, 0, 0);

//Control Variables
int combLength=0;
int selectedSymbol=0;
int selectedNum=0;
int ansNum=0;
int numLives=0;
boolean solverMode=false;
boolean displayAnswer=false;
boolean gameOver=false;
boolean correctAnswer=false;

//Mass storage Variables
ArrayList<String[]> combinations=new ArrayList<String[]>();
ArrayList<int[]> permutations=new ArrayList<int[]>();
StringList answers=new StringList();

//Game Controls
ArrayList <Object>nums=new ArrayList<Object>();
ArrayList <Life>lives=new ArrayList<Life>();
Symbol [] operation=new Symbol[4];
Button next, mode, undo;
Score scoreSys;

void setup() {
  importSettings();
  frame.setTitle("24 Challenge");
  frame.setResizable(true);
  size(screenW, screenH);
  for (int i=0; i<amtNumbers; i++)
    nums.add(new Object(i+1));
  char[] symb = new char[] {
    '+', '-', 'x', '÷'
  };
  combinate("", symb);
  for (int i=0; i<operation.length; i++)
    operation[i]=new Symbol(symb[i], i+1);
  for (int i=0; i<numLives;i++)
    lives.add(new Life(i+1));
  makeRandNums();
  next=new Button("Next", 1);
  mode=new Button("Mode", 2);
  undo=new Button("\u21BA", 3);
  scoreSys=new Score();
}

void draw() {
  if (correctAnswer)
    bgColor=color(0, 255, 0);
  background(bgColor);
  if (!gameOver) {
    if (!solverMode) {
      drawSymbols();
      drawLives();
      scoreSys.run();
    }
    if (displayAnswer&&!correctAnswer)
      drawAnswer();
    drawNums();
    drawButtons();
  }
  else text("GAME OVER", width/2, height/2);
}

void importSettings() {
  //Get saved settings from settings.ini
  File settingsLoc=new File(sketchPath("settings.ini"));
  String settings="";

  if (settingsLoc.exists()) {
    String input[]=loadStrings("settings.ini");
    for (int i=0;i<input.length;i++)
      settings+=input[i];
    maxRand=Integer.parseInt(settings.substring(settings.indexOf("maxRand=")+8, settings.indexOf("amtNumbers")));
    amtNumbers=Integer.parseInt(settings.substring(settings.indexOf("amtNumbers=")+11, settings.indexOf("maxTime")));
    maxTime=Integer.parseInt(settings.substring(settings.indexOf("maxTime=")+8, settings.indexOf("numLives")));
    numLives=Integer.parseInt(settings.substring(settings.indexOf("numLives=")+9));
    if (amtNumbers>6)
      amtNumbers=6;

    combLength=amtNumbers-1;
  }
  else println("ERROR: missing settings.ini file");
}

void drawSymbols() {
  //Draw all the math operation buttons
  fill(255, 200);
  noStroke();
  ellipse(width/2, 4*height/6, operation[3].x-operation[2].x, operation[1].y-operation[0].y);
  operation[0].run(width/2, 3*height/6);
  operation[1].run(width/2, 5*height/6);
  operation[2].run(width/2-operation[2].s, 4*height/6);
  operation[3].run(width/2+operation[2].s, 4*height/6);
}

void drawButtons() {
  //Draw game control buttons
  mode.run(width-75, height-50);
  if (!solverMode) {
    next.run(75, height-50);
    undo.run(width-75, 50);
  }
}

void drawLives() {
  textSize(18);
  fill(255);
  text("Lives:", 50, 125);
  if (lives.size()==0)
    gameOver=true;
  else {
    for (int i=0;i<lives.size();i++)
      lives.get(i).run(50, 150+65*i);
  }
}

void makeRandNums() {
  //Create random numbers, then do math to check for 24
  for (int i=0; i<nums.size(); i++) {
    nums.get(i).origValue=(int)random(0, maxRand);
    nums.get(i).value=nums.get(i).origValue;
  }
  compute();
}

void drawNums() {
  //Draw the number objects
  for (int i=0; i<nums.size(); i++)
    nums.get(i).run(nums.get(i).xSpacing*(i+1), nums.get(i).s);
}

void drawAnswer() {
  //Display answer when displayAnswer=true
  //n sets the location of where to display the answer vertically
  int n=0;
  if (solverMode) {
    n=2;
  } 
  else {
    n=3;
  }
  textAlign(CENTER);
  fill(255);
  textSize(18);
  text("ANSWER:", 100, 100);
  if (answers.size()>0)
    text(answers.get(ansNum), width/2, height/n);
  else text("No Possible Solution", width/2, height/n);
}

void resetPermutations() {
  //clears all saved information from previous number set
  //Runs at the begining of compute() and therefore anytime random numbers are made
  for (int i=0; i<nums.size(); i++)
    nums.get(i).display=true;
  answers.clear();
  permutations.clear();
  correctAnswer=false;
}

void restart() {
  scoreSys.score=0;
  gameOver=false; 
  for (int i=0; i<numLives;i++)
    lives.add(new Life(i+1));
}

