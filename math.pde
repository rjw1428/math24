//-------------------------------------------------------------
//Create initial combinations of math operations
void combinate(String save, char[] symb) {
  if (save.length() == combLength) {
    break2array(save);
  } else {
    for (int i = 0; i < symb.length; i++) {
      String oldCurr = save;
      save += symb[i];
      combinate(save, symb);
      save = oldCurr;
    }
  }
}

void break2array(String comb) {
  String [] hold= new String [combLength];
  for (int i=0; i<hold.length; i++)
    hold[i]=comb.substring(i, i+1);
  combinations.add(hold);
}

void outputCombinations() {
  for (int i=0; i<combinations.size (); i++) {
    println(combinations.get(i));
  }
}

//--------------------------------------------------------------
//Calculate all math Permutations and check for 24
void compute() {
  int []holdNum=new int[0];
  int []startNum=new int [nums.size()];
  resetPermutations();
  //Get all starting numbers in an array
  for (int i=0; i<nums.size(); i++)
    startNum[i]=(int)nums.get(i).value;

  //Find all permutations
  permutate(holdNum, startNum);

  //Do the math combining the permutations & combinations
  for (int i=0; i<combinations.size (); i++)
    for (int j=0; j<permutations.size (); j++) {
      math(i, j);
    }

  //If there are no solutions, output those values and run again
  if (answers.size()==0&&!solverMode) {
    for (int i=0; i<nums.size(); i++)
      println(nums.get(i).value);
    println("--------------");
    makeRandNums();
  } else {
    println(answers.size());
    ansNum=(int)random(0, answers.size()-1);
    println(ansNum+":"+answers.size());
  }
}

void permutate(int[] save, int[] values) {
  int n = values.length;
  if (n == 0) 
    permutations.add(save);
  else {
    for (int i = 0; i < n; i++)
      permutate(include(save, values[i]), nextArray(values, i));
  }
}

int [] include(int [] y, int addon) {
  int [] store=new int [y.length+1];
  for (int i=0; i<y.length; i++)
    store[i]=y[i];
  store[y.length]=addon;
  return store;
}

int [] nextArray(int[] x, int n) {
  IntList next=new IntList();
  for (int i=0; i<n; i++) {
    next.append(x[i]);
  }
  for (int j=n+1; j<x.length; j++) {
    next.append(x[j]);
  }
  return next.array();
}

void outputPermutations() {
  for (int i=0; i<permutations.size (); i++) {
    for (int j=0; j<4; j++)
      print(permutations.get(i)[j]);
    println("");
  }
}

//------------------------------------------------------
//Finds all possible solutions and saves the good ones
void math(int com, int perm) {
  String outputAnswer="";
  float [] number=new float [nums.size()];
  String [] sign=new String [combLength];
  String [] store=new String [nums.size()];

  for (int i=0; i<nums.size(); i++) {
    number[i]=permutations.get(perm)[i];
    store[i]=str(number[i]);
  }
  for (int i=0; i<combLength; i++)
    sign[i]=combinations.get(com)[i];

  for (int i=0; i<sign.length; i++)
    if (sign[i].equals("+"))
      number[i+1]=number[i]+number[i+1];
    else if (sign[i].equals("-"))
      number[i+1]=number[i]-number[i+1];
    else if (sign[i].equals("x"))
      number[i+1]=number[i]*number[i+1];
    else if (sign[i].equals("÷"))
      if (number[i+1]!=0)
        number[i+1]=number[i]/number[i+1];

  if (number[nums.size()-1]==24.0) {
    for (int i=0; i<sign.length; i++)
      outputAnswer+=store[i]+sign[i];
    answers.append(outputAnswer+store[nums.size()-1]+"="+number[nums.size()-1]);
  }
}
