class Score {
  float prevTime=0;
  float holdTime=0;
  int score=0;
  int multiplier=1;
  Score() {
  }

  void run() {
    if (!displayAnswer)
      drawCountdown();

    drawScore();
    drawCardPoints();
  }

  void drawCountdown() {
    //Draw countdown bar
    float time=(millis()-prevTime)/1000;
    float x=0;
    setColor(time);
    stroke(0);
    rectMode(CORNER);
    if (correctAnswer) {
      time=maxTime-holdTime;
      x=map(holdTime, 0, maxTime, 0, width);
      rect(0, 0, x, 10);
    } 
    else {
      x=map(maxTime-time, 0, maxTime, 0, width);
      rect(0, 0, x, 10);
    }
    if (time>=maxTime) {
      prevTime=millis();
      displayAnswer=true;
      lives.remove(lives.size()-1);
    }

    textSize(12);
    textAlign(CENTER);
    fill(255);
    text(maxTime-time, width-40, 10);
  }

  void setColor(float t) {
    //Set color of count down bar
    float green=0;
    float red=0;
    if (correctAnswer)
      t=maxTime-holdTime;
    if (maxTime-t<maxTime/2) {
      green=map(t, maxTime/2, maxTime, 255, 0);
      red=255;
    } 
    else {
      green=255;
      red=map(t, 0, maxTime/2, 0, 255);
    }
    fill(red, green, 0);
  }

  void drawScore() {
    //Display score
    textSize(16);
    fill(255);
    textAlign(CENTER);
    text("SCORE: "+score, width/2, height-20);
  }

  void drawCardPoints() {
    //Draw point dots based on midPoint cutoff and highPoint cutoff
    fill(255, 255, 0);
    stroke(0);
    if (answers.size()<=midPoint)
      scoreSys.multiplier=3;
    else if (answers.size()<=highPoint)
      scoreSys.multiplier=2;
    else  scoreSys.multiplier=1;

    for (int i=0; i<scoreSys.multiplier; i++)
      ellipse(width-20, 30+20*i, 10, 10);
  }
}

//-------------------------------------------------------------------

class Life {
  int s=50;
  int x;
  int y;
  int ident=0;
  boolean display=true;
  Life(int _ident) {
    ident=_ident;
  }

  void run(int _x, int _y) {
    x=_x;
    y=_y;
    display();
  }

  void display() {
    stroke(0);
    fill(0, 175, 225);
    rect(x, y, s, s);
  }

  void loseLive(int i) {
    if (i==ident)
      display=false;
  }
}

