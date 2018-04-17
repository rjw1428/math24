void mousePressed() {
  //Run click function for number objects and operations buttons
  for (int i=0; i<operation.length; i++)
    operation[i].click();
  for (int i=0; i<nums.size(); i++)
    nums.get(i).click();

  //Run click functions for all control buttons
  next.click();
  mode.click();
  undo.click();

  //If nothing is clicked clear selection
  if (!mouseOverNums()&&!mouseOverSymbols()) {
    if (solverMode)
      if (testForCompleteSolver()) {
        displayAnswer=true;
        compute();
      } 
      else {
        resetPermutations();
        displayAnswer=false;
      }
    selectedSymbol=0;
    selectedNum=0;
  }
  //if(gameOver)
  // restart();
}

void keyPressed() {
  String hold="";
  if (solverMode&&selectedNum>0) {
    switch(key) {
    case '0':
      hold="0";
      break;
    case '1':
      hold="1";
      break;
    case '2':
      hold="2";
      break;
    case '3':
      hold="3";
      break;
    case '4':
      hold="4";
      break;
    case '5':
      hold="5";
      break;
    case '6':
      hold="6";
      break;
    case '7':
      hold="7";
      break;
    case '8':
      hold="8";
      break;
    case '9':
      hold="9";
      break;
    case BACKSPACE:
      if (nums.get(selectedNum-1).displayValue.length()>0)
        nums.get(selectedNum-1).displayValue=nums.get(selectedNum-1).displayValue.substring(0, nums.get(selectedNum-1).displayValue.length()-1);
      break;
    case TAB:
      selectedNum+=1;
      if (selectedNum>nums.size()) {
        if (testForCompleteSolver()) {
          displayAnswer=true;
          compute();
        }
      }
      break;
    case ENTER:
      selectedNum=0;
      if (testForCompleteSolver()) {
        compute();
        displayAnswer=true;
      } 
      else {
        displayAnswer=false;
        resetPermutations();
      }
      break;
    case CODED:
      switch(keyCode) {
      case LEFT:
        selectedNum-=1;
        break;
      case RIGHT:
        selectedNum+=1;
        break;
      case UP:
        nums.get(selectedNum-1).value+=1;
        nums.get(selectedNum-1).value2displayValue();
        break;
      case DOWN:
        nums.get(selectedNum-1).value-=1;
        nums.get(selectedNum-1).value2displayValue();
        break;
      }
      break;
    default:
      nums.get(selectedNum-1).displayValue="_";
      selectedNum=0;
      break;
    }

    if (selectedNum>0&&selectedNum<=nums.size()) {
      if (nums.get(selectedNum-1).displayValue.indexOf("_")>=0)
        nums.get(selectedNum-1).displayValue=hold;
      else
        nums.get(selectedNum-1).displayValue+=hold;
    }
  }
}

