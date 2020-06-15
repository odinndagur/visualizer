int[][] lala = new int[3][10]; //array for audio samples
int[][] buff = new int[3][10]; //buffer array for shifting

void setup(){
  for(int x = 0; x < lala.length; x++){
    for(int y = 0; y < lala[0].length; y++){
      lala[x][y] = x*y; //random values to start with
    }
  }
  shiftArr(); //call function to shift array
  for(int x = 0; x < lala.length; x++){
      println(lala[x]); //print to console to view the arrays
  }
}

void shiftArr(){
    for(int x = 0; x < lala.length-1; x++){
      buff[x+1] = lala[x]; //move every element over one spot in the buffer
    }
          lala = buff; //set the original array to the values of the buffer array
      for(int y = 0; y < lala[0].length; y++){
        lala[0][y] = 100; //do what you need to do to the first one
      }
}
