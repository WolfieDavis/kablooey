//prototype leaderboard
import processing.serial.*; //import serial library
import processing.sound.*; //import sound library

/*--- variables ---*/
Serial port; //import serial port

//overall
final int width = 1920, height = 1080;
final int lvlNum = 0, cdNum = 1, clNum = 2, scNum = 3, lbNum = 4, lbEditNum = 5, scNumLock = 6; //screen numbers
int screen = 0; //screen index

//for level select
public final int boxWidth = 1500, boxHeight = 750;
public final int cirlceY = 445, circleR = 300, circleSpacing = 475 ;
public final int descY = 725, descY2 = descY + 85;
public final String[][] desc = {{"images", "ladybug"}, {"text", "gopher"}, {"sound", "bear"}};

//for leaderboard
PFont MkNotes;
PImage BgLb, BgClues, Trophy;
int index = 0;
final int titleY = 200, listY = 225, listW = 1000, listSpacing = 82;
String typing = "";
int nameOption = 0;
String[] nameOptions = {"Beamer", 	"Buck", 	"Buster", 	"Captain", 	"Casper", 	"Chip", 	"Derby", 	"Droopy", 	"Eddie", 	"Ghost", 	"Hershey", 	"Hollywood", 	"Holyfield", 	"Ivan", 	"Lucky", 	"Marvin", 	"Maximus", 	"Oscar", 	"Prince", 	"Roscoe", 	"Tex", 	"Thor", 	"Tyrone", 	"Velvet", 	"Whitey", 	"Zeus", 	"Canyon", 	"Frost", 	"Tundra", 	"Lucky", 	"Romulus", 	"Aragorn", 	"Lobo", 	"Aztec", 	"Silver", 	"Dakota", 	"Timber", 	"Lance", 	"Winter", 	"Sabre", 	"Peter", 	"Asher", 	"Kiba"};
String[] names= {"one"};//, "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"};
float[] scores = {999999};
String[] levelOfScore = {"level"};

//for clues
int clueNum = 0, prevClueNum = -1;
int clueLevel = 0;
public final int progBarY = 100, progBarW = 1600, progBarH = 50;
public final int imageSize = 850, imageX = 375, imageY = -35, textBoxW = 1050, textBoxX = imageX - (textBoxW-imageSize)/2;
public final int clockBoxW = 500, clockOffset = (width-progBarW)/2+clockBoxW/2;
//for timer for clues
long startTime;
float currentScore;
int lbPosition;

//actual question info
int[] clueOrder = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
public final String[] clueImagesNames = {"a1.jpg", "a2.jpg", "a3.jpg", "a4.jpg", "a5.jpg", "a6.jpg", "a7.jpg", "a8.jpg", "a9.jpg", "a10.jpg", "a11.jpg", "a12.jpg", "a13.jpg", "a14.jpg", "a15.jpg"};
PImage[] clueImages = new PImage[clueImagesNames.length];
public final String[] clueTextNames = {"t1.png", "t2.png", "t3.png", "t4.png", "t5.png", "t6.png", "t7.png", "t8.png", "t9.png", "t10.png", "t11.png", "t12.png", "t13.png", "t14.png", "t15.png"};
PImage[] clueText = new PImage[clueTextNames.length];
public final String[] clueSoundNames = {"a1.mp3", "a2.mp3", "a3.mp3", "a4.mp3", "a5.mp3", "a6.mp3", "a7.mp3", "a8.mp3", "a9.mp3", "a10.mp3", "a11.mp3", "a12.mp3", "a13.mp3", "a14.mp3", "a15.mp3"};
SoundFile[] clueSounds = new SoundFile[clueSoundNames.length];
Waveform waveform;
public final int waveNum = 150;

/*--- setup ---*/
void setup() {
  fullScreen(2);
  // size(1920, 1080); //fullscreen for monitor

  //load resoruces
  BgLb = loadImage("BgLbBlur.jpg"); //background for leaderboard
  BgClues = loadImage("BgCluesBlur.jpg");
  Trophy = loadImage("trophy.png");
  MkNotes = createFont("MarkerNotes.ttf", 10);

  //serial input setup
  printArray(Serial.list());
  port = new Serial(this, Serial.list()[2], 9600); //COM9
  //recievedNum = port.read(); //5 or 11 or /dev/tty.usbserial-1420 also /dev/tty.usbserial-14xx or /dev/cu.usbserial-14xx

  //initialize clue arrays
  for (int i = 0; i < clueImagesNames.length; i++) {
    String imageName = clueImagesNames[i];
    String textName = clueTextNames[i];
    String soundName = clueSoundNames[i];
    clueImages[i] = loadImage(imageName);
    clueText[i] = loadImage(textName);
    clueSounds[i] = new SoundFile(this, soundName);
  }
  
  //sound
  waveform = new Waveform(this, waveNum);

  //shuffle clues
  shuffleClues();
  shuffleString(nameOptions);

  //load leaderboard
  resetLeaderboard(); //only first time to create new file
  importLeaderboard();
}

/*--- main loop ---*/
void draw() {
  while (port.available () > 0) hardwareInput(); //read in values from arduino

  //draw screen based on logic from hardwareInput
  if (screen == lvlNum) levelSelect();
  else if (screen == cdNum) countdownScreen();
  else if (screen == clNum) clues();
  else if (screen == scNum) scoreScreen();
  else if (screen == scNumLock) scoreScreenLocked();
  else if (screen == lbNum) leaderboard();
  else if (screen == lbEditNum) lbEdit();
}

/*--- game logic hardware input ---*/
void hardwareInput() {
  int value = port.read();

  if (screen == lvlNum) {
    if (value == 9) clueLevel=0;
    else if (value == 1) clueLevel=1;
    else if (value == 7) clueLevel=2;
    else if (value == 0){// || value == 12) { //button or salamander
      startTimer();
      screen = cdNum; //go to countdown
      shuffleClues();
    }
  } else if (screen == cdNum) {
    // if (value == 0) screen = clNum; //go to clues
  } else if (screen == clNum) {
    if (value == clueOrder[clueNum]) { 
      clueSounds[clueNum].stop();
      clueNum++;
    }
  } else if (screen == scNum) {
    // startTimer();
  } else if (screen == lbNum) {
    if (value == 0) screen = lvlNum;
  }
}

/*--- game logic keyboard input ---*/
void keyPressed() {
  if (screen == lvlNum) {
    if (key == '1') clueLevel=0;
    else if (key == '2') clueLevel=1;
    else if (key == '3') clueLevel=2;
    // else if (key == '4') screen = clNum; //dev
    // else if (key == '5') screen = scNum; //dev
    else if (key == '6') screen = lbNum; //dev
    else {
      startTimer();
      screen = cdNum; //go to countdown
      shuffleClues();
    }
  } else if (screen == cdNum) {
      // screen = clNum; //go to clues
  } else if (screen == clNum) {
    if (key == 'a') {
    // if (clueNum == 14) {
    //   clueNum = 20;
    //   // screen = scNum;
    // } else
    clueSounds[clueNum].stop();
    clueNum++;
    // clueNum = int[random(0, 2)];
    } //else screen = lbNum; //go to leaderboard
  } else if (screen == lbNum) {
    screen = lvlNum; //go back to level select
    if (key == '1') screen = scNumLock;
    clueLevel = 0; //reset clue level
  } else if (screen == lbEditNum){
      if (key == '\n' && typing.length() > 0) {
      names[index] = typing;
      typing = "";
      screen = lbNum;
    } else if ((key == '\b') && typing.length() > 0) {
      typing = typing.substring(0, typing.length()-1);
    } else if (keyCode == 27) {
      key = 0;
      screen = lbNum;
    } else typing = typing + key;  

  } else if (screen == scNumLock) {
    if (key == '1') screen = lbNum;
  }
}

/*--- if mouse clicked ---*/
void mousePressed() {
  if (screen == lbNum) index = lbCheck();
}

/*-- shuffles an array --*/
void shuffleString(String[] arr){
   String temp;
   int pick;
   for(int i=0; i < arr.length; i++){
       pick = int(random(arr.length)); // picks a random position in the array
       temp = arr[i]; // stores value of current position
       arr[i] = arr[pick]; // copies picked value into current position
       arr[pick]= temp; // store original value in picked position
    }
}

/*-- shuffles the arrays of clues --*/
void shuffleClues(){
   PImage tempImg, tempText;
   SoundFile tempSound;
   int pick, tempNum;

   for(int i=0; i < clueOrder.length; i++){
    //pick random number
    pick = int(random(clueOrder.length));
    //save current element to temp
    tempNum = clueOrder[i];
    tempImg = clueImages[i];
    tempText = clueText[i];
    //insert randomly chosen element into current index
    clueOrder[i] = clueOrder[pick];
    clueImages[i] = clueImages[pick];
    clueText[i] = clueText[pick];
    //insert original element into the random index
    clueOrder[pick]= tempNum;
    clueImages[pick]= tempImg;
    clueText[pick]= tempText;
  }
}

/*--- level selection window ---*/
void levelSelect() {
  /*--- background ---*/
  imageMode(CORNER);
  background(0);
  image(BgClues, 0, 0, width, height);
  rectMode(CENTER);
  /*--- title ---*/
  fill(255);
  textAlign(CENTER);
  textFont(MkNotes, 150);
  text("Jumbo Ispy", width/2, titleY);
  /*--- box ---*/
  fill(5, 99, 19, 255);
  rect(width/2, height/2+110, boxWidth, boxHeight, 35);
  /*--- box title ---*/
  fill(255);
  textAlign(CENTER);
  textSize(85);
  text("Select Clue Type", width/2, (height+275-boxHeight)/2 + 85);

  /*--- level circles ---*/
  ellipseMode(CENTER);
  for (int i = 0; i <= 2; i++) {
    // if (clueLevel == i) fill(136, 236, 39);
    // else fill(255);
    if (clueLevel == i) {
      fill(255);
      circle(width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + cirlceY, circleR + 35);
      // fill(136, 236, 39);
    }
    //circles
    if (i == 0) fill(51, 149, 26);//fill(136, 236, 39);
    else if (i==1) fill(222, 191, 39);
    else fill(216, 83, 66);
    circle(width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + cirlceY, circleR);
    //circle labels
    if (clueLevel == i) fill(255);
    else fill(5, 99, 19);
    textSize(150);
    text(i+1, width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + cirlceY + 58);
    //descriptions
    fill(255);
    textSize(75);
    text(desc[i][0], width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + descY);
    textSize(55);
    text(desc[i][1], width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + descY2);
  }
}

/*--- countdown screen ---*/
void countdownScreen() {
  if (int(millis() - startTime) < 6000) { //6 second timer, counts up from start
    int currentTime = int(5-(millis() - startTime)/1000); //counts down from 5 to 1 visually
    /*--- box ---*/
    rectMode(CENTER);
    fill(5, 99, 19, 255);
    rect(width/2, height/2+110, boxWidth, boxHeight, 35);
    /*--- box title ---*/
    fill(255);
    textAlign(CENTER);
    textFont(MkNotes, 150);
    text("Get Ready!", width/2, height/2 - 50);
    textFont(MkNotes, 300);
    if (currentTime != 0) text(currentTime, width/2, height/2 + 335); //from 5 to 1 numbers
    else text("GO!", width/2, height/2 + 335); //for 0 it says GO!
  } else {
    startTimer(); //reset timer
    screen = clNum; //go to clues screen
  }
}

/*--- clues screen ---*/
void clues() {
  imageMode(CORNER);
  background(0);
  image(BgClues, 0, 0, width, height);

  /*--- title ---*/
  fill(255);
  textAlign(LEFT);
  textSize(135);
  text("Clue " + (clueNum+1), 150, height/2-350);
  textSize(75);
  if (clueLevel == 0) text("image closeup", 150, height/2-250);
  else text(desc[clueLevel][0], 150, height/2-250); 

  /*--- clues ---*/
  if (clueNum != 15){
    if (clueLevel == 0) { //image
      imageMode(CENTER);
      image(clueImages[clueNum], width/2+imageX, height/2+imageY, imageSize, imageSize);

    } else if (clueLevel == 1) { //text
      fill(5, 99, 19, 255);
      rectMode(CENTER);    
      // fill(24, 128, 41, 185);
      rect(width/2+textBoxX, height/2+imageY, textBoxW, imageSize, 30);
      imageMode(CENTER);
      image(clueText[clueNum], width/2+textBoxX, height/2+imageY, textBoxW, imageSize);

    } else { //sound
      fill(5, 99, 19, 255);
      // fill(24, 128, 41, 185);
      rectMode(CENTER);    
      rect(width/2+textBoxX, height/2+imageY, textBoxW, imageSize, 30);
      //audio start (audio stop is in game logic)
      if (clueNum != prevClueNum) {
        clueSounds[clueNum].loop();
        waveform.input(clueSounds[clueNum]);
      }
      waveformVisual();

      prevClueNum = clueNum;
    }
  }

  /*--- progress bar ---*/
  rectMode(CORNER);
  //background bar
    // fill(24, 128, 41, 185);
  fill(5, 99, 19, 255);
  rect((width-progBarW)/2, height - progBarY, progBarW, progBarH, 15);
  //progress bar
  fill(255);
  float progress = ((clueNum < clueImagesNames.length) ? (progBarW*(clueNum+1))/(clueImagesNames.length) : progBarW);
  rect((width-progBarW)/2, height - progBarY, progress, progBarH, 15);

  /*--- timer ---*/
  clueStopwatch();
}

/*--- waveform for audio ---*/
void waveformVisual(){
  final int offsetX = 50, offsetY = 100;
  //settings
  stroke(255);
  strokeWeight(10);
  noFill();
  //analyze
  waveform.analyze();
  //visual
  beginShape();
    for(int i = 0; i < waveNum; i++){
    // Draw current data of the waveform
    // Each sample in the data array is between -1 and +1 
    vertex(
      map(i, 0, waveNum, width/2+textBoxX-textBoxW/2+offsetX, width/2+textBoxX+textBoxW/2-offsetX),
      map(waveform.data[i], -1, 1, height/2+imageY-imageSize/2+offsetY, height/2+imageY+imageSize/2-offsetY)
    );
  }
  endShape();
  //reset
  stroke(0);
  strokeWeight(1);
}

/*--- countdown ---*/
void clueStopwatch() {
  int currentSec = int((millis() - startTime)/1000);
  int currentFracSec = int((millis() - startTime)/10 - currentSec*100);
  // int clockOffset = ((clueLevel == 0) ? 410 : 410);

  //box
  rectMode(CENTER);
  fill(5, 99, 19, 255);
  rect(clockOffset, height/2+65, clockBoxW, 400, 30);
  //title
  fill(255);
  textAlign(CENTER);
  textFont(MkNotes, 85);
  text("Time:", clockOffset, height/2);
  textFont(MkNotes, 150);
  text(currentSec, clockOffset, height/2+185);

  //save the score to scoreboard
  if (clueNum == 15) saveScore(currentSec, currentFracSec);
}

/*--- saves scores ---*/
void saveScore(int currentSec2, int currentFracSec2) {
  currentScore = Float.valueOf(currentSec2 + "." + currentFracSec2); //set current score

  int keepRunning = 1;
  int i = 0;
  String thisName = nameOptions[nameOption];

  if (scores[i] != 999999) {
    do {
      if (currentScore < scores[i]) {
        //expand
        scores = expand(scores, scores.length + 1);
        names = expand(names, scores.length + 1);
        levelOfScore = expand(levelOfScore, scores.length + 1);
        //move all scores down 1
        for (int j = (scores.length-1); j > i; j--) {
          scores[j] = scores[j-1];
          names[j] = names[j-1];
          levelOfScore[j] = levelOfScore[j-1];
        }
        //add current score and name
        scores[i] = currentScore;
        names[i] = thisName;
        //add clue type
        if (clueLevel == 0) levelOfScore[i] = desc[0][0];
        else if (clueLevel == 1) levelOfScore[i] = desc[1][0];
        else levelOfScore[i] = desc[2][0];
        
        //rank display and end saving
        lbPosition = i+1;
        keepRunning = 0;
      } else if (i < scores.length - 1) {
        i++;
      } else {
        //expand
        scores = expand(scores, scores.length + 1);
        names = expand(names, scores.length + 1);
        levelOfScore = expand(levelOfScore, scores.length + 1);
        //add current score and name to end
        scores[i+1] = currentScore;
        names[i+1] = thisName;
        //add clue type
        if (clueLevel == 0) levelOfScore[i+1] = desc[0][0];
        else if (clueLevel == 1) levelOfScore[i+1] = desc[1][0];
        else levelOfScore[i+1] = desc[2][0];
        
        //rank display and end saving
        lbPosition = i+2;
        keepRunning = 0;
      }
    } while (keepRunning == 1);

  } else { //first run
    //add current score and name
    scores[0] = currentScore;
    names[0] = thisName;
    //add clue type
    if (clueLevel == 0) levelOfScore[i] = desc[0][0];
    else if (clueLevel == 1) levelOfScore[i] = desc[1][0];
    else levelOfScore[i] = desc[2][0];
    //rank display
    lbPosition = 1;
  }

  //last couple things
  clueNum = 0; //reset clues
  startTimer(); //reset timer
  screen = scNum; //change screen to score display
  exportLeaderboard();
  
  if (nameOption < nameOptions.length) nameOption++; //go to the next name in the list
  else nameOption = 0; //back to beginning
}

/*--- output leaderboard to txt file ---*/
void exportLeaderboard() {
  //initialize output array
  String[] lbOut = new String[scores.length];
  //add leaderboard data to output array
  for (int i = 0; i < scores.length; i++) {
    lbOut[i] = names[i] + ";" + levelOfScore[i] + ";" + str(scores[i]);
  }
  //save file
  saveStrings("leaderboard.txt", lbOut);
  saveStrings("leaderboardBackup.txt", lbOut);
}

/*--- input leaderboard from txt file ---*/
void importLeaderboard() {
  //initialize input array
  String[] lbIn = loadStrings("leaderboard.txt");;
  //add data from leaderboard file to arrays
  for (int i = 0; i < lbIn.length; i++) {
    //split into columns
    String[] columns = split(lbIn[i], ';');
    //load arrays
    names[i] = columns[0];
    levelOfScore[i] = columns[1];
    scores[i] = float(columns[2]);    
  }
}

/*--- initialize leaderboard file ---*/
void resetLeaderboard() {
  String[] initialValues = {names[0] + ";" + levelOfScore[0] + ";" + str(scores[0])};
  saveStrings("leaderboard.txt", initialValues);
}

/*--- start timer ---*/
void startTimer() {
  startTime = millis();
}

/*-- score display screen ---*/
void scoreScreen() {
  imageMode(CORNER);
  background(0);
  image(BgClues, 0, 0, width, height);
  if (int(millis() - startTime) < 4500) { //6.5 second timer
    /*--- box ---*/
    rectMode(CENTER);
    fill(5, 99, 19, 255);
    rect(width/2, height/2, boxWidth, boxHeight, 35);
    /*--- box title ---*/
    fill(255);
    textAlign(CENTER);
    textSize(100);
    text("Your score:", width/2, height/2 - 250);
    textSize(275);
    text(currentScore + " s", width/2, height/2 + 100); //for 0 it says GO!
    textSize(85);
    text("Rank: #" + lbPosition + "!", width/2, height/2 + 315);
  } else {
    // startTimer(); //reset timer
    screen = lbNum; //go to leaderboard screen
  }
}

/*-- score display screen but stationary ---*/
void scoreScreenLocked() {
  imageMode(CORNER);
  background(0);
  image(BgClues, 0, 0, width, height);
  /*--- box ---*/
  rectMode(CENTER);
  fill(5, 99, 19, 255);
  rect(width/2, height/2, boxWidth, boxHeight, 15);
  /*--- box title ---*/
  fill(255);
  textAlign(CENTER);
  textSize(100);
  text("Your score:", width/2, height/2 - 250);
  textSize(275);
  text(currentScore + " s", width/2, height/2 + 100); //for 0 it says GO!
  textSize(85);
  text("Rank: #" + lbPosition + "!", width/2, height/2 + 315);
}

/*--- leaderboard ---*/
void leaderboard() {
  imageMode(CORNER);
  background(0);
  image(BgLb, 0, 0, width, height);

  /*--- title ---*/
  fill(255);
  textAlign(CENTER);
  textFont(MkNotes, 100);
  text("Leaderboard", width/2, titleY - 50);

  imageMode(CENTER);
  image(Trophy, width/2-450, titleY-35-50, 100, 100);
  image(Trophy, width/2+450, titleY-35-50, 100, 100);

  /*--- slots ---*/
  lbSlots();

  //bottom instructions
  textAlign(CENTER);
  fill(255);
  textSize(45);
  text("press start to continue", width/2, height - 35);
}

/*--- leaderboard slots ---*/
void lbSlots() {
  rectMode(CENTER);
  textFont(MkNotes, 50);

  for (int i = 0; i < 10; i++) {
    textAlign(LEFT, CENTER);
    if (i < scores.length) {
    //rectangles
      fill(24, 128, 41, 235);
      rect(width/2, listY+listSpacing*i, listW, listSpacing-18, 15);
    //text
      fill(255);
      text("#" + (i+1), (width-listW)/2 + 15, listY+listSpacing*i -5);
      text(names[i], (width-listW)/2 + 150, listY+listSpacing*i -5);
      textAlign(RIGHT, CENTER);
      text(String.valueOf(scores[i]) + " s", (width+listW)/2 - 15, listY+listSpacing*i -5);
      textAlign(LEFT, CENTER);
      text(levelOfScore[i], (width-listW)/2 + 455, listY+listSpacing*i -5);
    } else {
    //rectangles
      fill(24, 128, 41, 125);
      rect(width/2, listY+listSpacing*i, listW, listSpacing-18, 15);
    //text
      fill(255, 255, 255, 35);
      text("#" + (i+1), (width-listW)/2 + 15, listY+listSpacing*i -5);
      text("name", (width-listW)/2 + 150, listY+listSpacing*i -5);
      textAlign(RIGHT, CENTER);
      text("---", (width+listW)/2 - 15, listY+listSpacing*i -5);
      textAlign(LEFT, CENTER);
      text("---", (width-listW)/2 + 455, listY+listSpacing*i -5);
    }
  }
}

/*--- check which leaderboard slot was clicked ---*/
int lbCheck() {
  int indexCheck = 0;
  int nameIndent = (width-listW)/2 + 150;
  int topOfList = listY-(listSpacing-15)/2;
  //determine which name was clicked on
  if ((mouseX > nameIndent) && (mouseX < nameIndent+625) && (mouseY > topOfList)) {
    screen = lbEditNum;
    for (int i = 9; i >= 0; i--) {
      if (mouseY < (topOfList + listSpacing*(i+1))) indexCheck = i;
    }
  }
  return indexCheck;
}

/*--- edit leaderboard window ---*/
void lbEdit() {
  //window
  rectMode(CENTER);
  fill(5, 99, 19, 255);
  rect(width/2, height/2, 500, 300, 15);
  //title
  fill(255);
  textAlign(CENTER);
  textFont(MkNotes, 50);
  text("EDIT NAME", width/2, (height-300)/2 + 75);
  //input display
  textAlign(LEFT);
  textSize(25);
  text("Input: " + typing, (width-500)/2 + 20, (height-300)/2 + 150);
  //bottom note
  textAlign(CENTER);
  textSize(15);
  text("press enter to set", width/2, (height+300)/2 - 35);
  // text(mouseY + " index: " + index, width/2, (height+300)/2 - 75); //for debugging
}
