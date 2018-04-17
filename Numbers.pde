class Object {
  int x;
  int y;
  int s=70;
  int xSpacing=(width-300)/amtNumbers;
  int ident;
  boolean display=true;
  int origValue;
  float value;
  String displayValue="_";
  Object(int _ident) {
    ident=_ident;
  }

  void run(int _x, int _y) {
    x=_x;
    y=_y;
    if (display) {
      if (!solverMode) {
        value2displayValue();
        display();
      } 
      else {
        displayValue2Value();
        display();
      }
    }
  }  

  void display() {
    if (selectedNum==ident)
      fill(255);
    else
      noFill();
    rectMode(CENTER);
    if (mouseOver())
      stroke(255);
    else noStroke();
    rect(x, y-s/4, s, s);
    if (selectedNum==ident)
      fill(0);
    else
      fill(255);
    textSize(s-10);
    text(displayValue, x, y);
  }

  void value2displayValue() {
    if (value%1==0) {
      String hold=str(value);
      if (hold.indexOf(".")<0)
        displayValue=hold;
      else displayValue=hold.substring(0, hold.indexOf("."));
    } 
    else {
      if (value%.5==0)
        displayValue=nf(value, 1, 1);
      else displayValue=nf(value, 1, 2);
    }
  }

  void displayValue2Value() {
    if (!displayValue.equals("_")&&displayValue.length()>0)
      value=Float.parseFloat(displayValue);

    if (selectedNum!=ident&&displayValue.length()==0)
      displayValue="_";
  }

  boolean mouseOver() {
    if (mouseX>x-s/2&&mouseX<x+s/2&&mouseY>y-s/2-10&&mouseY<y+s/2-10&&display)
      return true;
    else
      return false;
  }

  void click() {
    if (mouseOver()&&selectedNum!=ident) {
      if (solverMode) {
        selectedNum=ident;
        displayValue="";
      } 
      else {
        if (selectedNum>0&&selectedSymbol>0) {
          doMath(ident, value);
        } 
        else
          selectedNum=ident;
        checkFor24();
      }
    }
  }
}

boolean mouseOverNums() {
  int token=0;
  for (int i=0; i<nums.size(); i++)
    if (nums.get(i).mouseOver())
      token++;

  if (token>0)
    return true;
  else return false;
}

void doMath(int n, float numberValue) {
  //Computes individual operation. Sends to applyMathResult() to save new values
  FloatList pass=new FloatList();
  float ans=0;
  int x=0;
  for (int i=0; i<nums.size(); i++) {
    if (nums.get(i).display) {
      pass.append(nums.get(x).value);
      x++;
    }
  }
  if (selectedSymbol==1) {
    ans=nums.get(selectedNum-1).value+numberValue;
  } 
  else if (selectedSymbol==2) {
    ans=nums.get(selectedNum-1).value-numberValue;
  } 
  else if (selectedSymbol==3) {
    ans=nums.get(selectedNum-1).value*numberValue;
  } 
  else if (selectedSymbol==4) {
    if (numberValue!=0) {
      ans=nums.get(selectedNum-1).value/numberValue;
    } 
    else println("Cannot Divide By 0");
  }
  pass.set(n-1, ans);
  pass.remove(selectedNum-1);
  println(nums.get(selectedNum-1).value+" "+operation[selectedSymbol-1].name+" "+numberValue+" = "+ans);
  applyMathResult(pass.array());

  selectedNum=0;
  selectedSymbol=0;
}


void applyMathResult(float [] newValue) {
  //Applies new values for the calculated math results in doMath()
  for (int i=0; i<newValue.length; i++)
    nums.get(i).value=newValue[i];

  for (int i=newValue.length; i<nums.size(); i++)
    nums.get(i).display=false;
}

boolean testForCompleteSolver() {
  //Tests that no blank spaces exist in solver mode
  int token=0;
  for (int i=0; i<nums.size(); i++)
    if (nums.get(i).displayValue.equals("_")||nums.get(i).displayValue.equals(""))
      token++;

  if (token==0) {
    return true;
  } 
  else
    return false;
}

void checkFor24() {
  //Check that there is 1 number object turned on and that it is indeed 24
  //If 24, display correct answer screen, record times, add score
  int token=0;
  for (int i=0; i<nums.size(); i++)
    if (nums.get(i).display)
      token++;

  if (token==1&&nums.get(0).value==24&&!correctAnswer&&!displayAnswer) {
    correctAnswer=true;
    scoreSys.holdTime=maxTime-(millis()-scoreSys.prevTime)/1000;
    scoreSys.prevTime=millis()-scoreSys.prevTime;
    scoreSys.score+=scoreSys.holdTime*scoreSys.multiplier;
  }
  else if (displayAnswer&&!correctAnswer)
    lives.remove(lives.size()-1);
}

