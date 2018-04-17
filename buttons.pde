class Symbol {
  char name;
  int ident;
  int s=100;
  int x, y;
  color clickColor=color(255);
  color staticColor=color(100);
  Symbol(char _name, int _ident) {
    name=_name;
    ident=_ident;
  }

  void run(int _x, int _y) {
    x=_x;
    y=_y;
    display();
  }

  void display() {
    if (selectedSymbol==ident)
      fill(clickColor);
    else
      fill(staticColor);
    rectMode(CENTER);
    if (mouseOver())
      stroke(255);
    else stroke(0);
    rect(x, y, s, s);
    textSize(s/2);
    textAlign(CENTER);
    fill(0);
    text(name, x+2, y+10+2);
    fill(255, 0, 0);
    text(name, x, y+10);
  }

  boolean mouseOver() {
    if (mouseX>x-s/2&&mouseX<x+s/2&&mouseY>y-s/2&&mouseY<y+s/2&&!solverMode)
      return true;
    else
      return false;
  }

  void click() {
    if (mouseOver()&&!displayAnswer) {
      if (selectedSymbol==ident) {
        XthemAll(selectedSymbol);
        selectedSymbol=0;
      } 
      else
        selectedSymbol=ident;
    }
  }
}

boolean mouseOverSymbols() {
  int token=0;
  for (int i=0; i<operation.length; i++)
    if (operation[i].mouseOver())
      token++;

  if (token>0) 
    return true;
  else return false;
}

void XthemAll(int symbol) {
  //Applies math operation to all remaining numbers if double clicked
  FloatList save=new FloatList();
  for (int i=0; i<nums.size(); i++)
    if (nums.get(i).display)
      save.append(nums.get(i).value);

  float result=save.get(0);
  switch(symbol) {

  case 1: 
    {
      println("Add remaining numbers");
      for (int i=1; i<save.size (); i++)
        result+=save.get(i);
      break;
    }
  case 2: 
    {
      println("Subtract remaining numbers");
      for (int i=1; i<save.size (); i++)
        result-=save.get(i);
      break;
    }
  case 3: 
    {
      println("Multiply remaining numbers");
      for (int i=1; i<save.size (); i++)
        result*=save.get(i);
      break;
    }
  case 4: 
    {
      println("Divide remaining numbers");
      int token=0;
      for (int i=0; i<save.size (); i++)
        if (save.get(i)==0)
          token++;

      if (token==0)   
        for (int i=1; i<save.size (); i++)
          result/=save.get(i);
      else result=0;
      break;
    }
  }
  println(result);
  if (result!=0) {
    for (int i=1; i<nums.size(); i++)
      nums.get(i).display=false;
    nums.get(0).value=result;
    checkFor24();
  }
}
//--------------------------------------------------------------

class Button {
  String name;
  int ident;
  int s=50;
  int x, y;
  Button(String _name, int _ident) {
    name=_name;
    ident=_ident;
  }
  void run(int _x, int _y) {
    x=_x;
    y=_y;
    display();
  }

  void display() {
    fill(0, 0, 255);
    if (mouseOver())
      stroke(255);
    else stroke(0);
    ellipseMode(CENTER);
    ellipse(x, y, s, s);
    textAlign(CENTER);
    fill(255);
    if (ident==3) {
      textSize(35);
      text(name, x, y+12);
    } 
    else {
      textSize(20);
      text(name, x, y+5);
    }
  }

  boolean mouseOver() {
    if (sqrt(sq(x-mouseX) + sq(y-mouseY)) < s/2 )
      return true;
    else
      return false;
  }

  void click() {
    if (mouseOver()) {
      selectedNum=-1;
      selectedSymbol=0;
      switch (ident) {
      case 1: //Next Button
        {
          bgColor=0;
          makeRandNums();
          displayAnswer=false;
          scoreSys.prevTime=millis();
          break;
        } 
      case 2: //Mode Button
        {
          solverMode=!solverMode;
          bgColor=0;
          scoreSys.prevTime=millis();
          displayAnswer=false;
          if (solverMode==false) {
            println("Game Mode");
            makeRandNums();
          } 
          else {
            println("Solver Mode");
            resetPermutations();
            for (int i=0; i<nums.size(); i++) {
              nums.get(i).displayValue="_";
              nums.get(i).displayValue2Value();
            }
          }
          break;
        }
      case 3: //Undo Button
        {
          if (!correctAnswer) {
            for (int i=0; i<nums.size(); i++) {
              nums.get(i).value=nums.get(i).origValue;
              nums.get(i).display=true;
            }
          }
          break;
        }
      }
    }
  }
}
//---------------------------------------------------------

