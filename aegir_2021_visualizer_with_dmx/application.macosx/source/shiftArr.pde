//function to shift all elements over by one
void shiftArr() {
  for (int i = 0; i < spectrumArray.length-1; i++) {
    for (int j = 0; j < spectrumArray[0].length; j++) {
      bufferArray[i+1][j] = spectrumArray[i][j]; //move 0 in spectrum to 1 in buffer and so on
    }
  }

  for (int i = 0; i < spectrumArray.length; i++){
    for(int j = 0; j < spectrumArray[0].length; j++){
      spectrumArray[i][j] = bufferArray[i][j]; //set spectrum to buffer array values
    }
  }
}
