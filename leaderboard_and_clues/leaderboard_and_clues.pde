//prototype leaderboard
// import data.clues
import processing.serial.*; //import serial library

/*--- variables ---*/
// Serial port; //import serial port

//overall
final int width = 1920, height = 1080;
final int lvlNum = 0, cdNum = 1, clNum = 2, scNum = 3, lbNum = 4, scNumLock = 5; //screen numbers
int screen = 0; //screen index

//for level select
public final int boxWidth = 1500, boxHeight = 750;
public final int cirlceY = 475, circleR = 300, circleSpacing = 475 ;
public final int descY = 765;
public final String[] desc = {"images", "text", "sound"};

//for leaderboard
PFont MkNotes;
PImage BgLb, BgClues, Trophy;
int index = 0;
public final int titleY = 200, listY = 225, listW = 1000, listSpacing = 87;
String typing = "";
int nameOption = 0;
String[] nameOptions = {"Beamer", 	"Buck", 	"Buckley", 	"Buster", 	"Captain", 	"Casper", 	"Chip", 	"Derby", 	"Droopy", 	"Eddie", 	"Ghost", 	"Hershey", 	"Hollywood", 	"Holyfield", 	"Ivan", 	"Lucky", 	"Marvin", 	"Maximus", 	"Oscar", 	"Prince", 	"Roscoe", 	"Tex", 	"Thor", 	"Tyrone", 	"Velvet", 	"Whitey", 	"Zeus", 	"Canyon", 	"Frost", 	"Tundra", 	"Lucky", 	"Romulus", 	"Aragorn", 	"Lobo", 	"Aztec", 	"Silver", 	"Dakota", 	"Timber", 	"Lance", 	"Winter", 	"Sabre", 	"Peter", 	"Asher", 	"Kiba"};
String[] names= {"one"};//, "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"};
// String[] names= {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"};
float[] scores = {999999};//24.00, 25.00, 50.00, 70.00, 75.00, 80.00};//, 120, 225, 250, 300};
String[] levelOfScore = {"Easy"};

//for clues
int clueNum = 0;
int clueLevel = 0;
public final int clueBoxW = 1250, clueBoxY = 100, clueBoxH = height - clueBoxY - 50, progBarH = 50;
public final int imageSize = 300;
public final int imageX = (width+clueBoxW)/2 - imageSize + 50;
public final int imageY = clueBoxY+clueBoxH/2 + 100;
//for timer for clues
long startTime;
float currentScore;
int lbPosition;
// long currentTime;

//actual question info
public final String[] clueImagesNames = {"a1.jpg", "a2.jpg", "a3.jpg", "a4.jpg", "a5.jpg", "a6.jpg", "a7.jpg", "a8.jpg", "a9.jpg", "a10.jpg", "a11.jpg", "a12.jpg", "a13.jpg", "a14.jpg", "a15.jpg"};
PImage[] clueImages = new PImage[clueImagesNames.length];
public final String[][] clueText = {{"Has a holiday (February 2nd) named after it", "Also called woodchuck"},
  {"Love to eat acorns", "Some species can fly/glide (but they don’t have wings)"},
  {"Can turn their heads almost 360 degrees", "They have asymmetrical ears"},
  {"Can deliver mail for humans over long distances", "Feed crop milk to their young"},
  {"Hang upside down", "Use echolocation"},
  {"Have large internal cheek pouches for food", "Eat foods like nuts, bird eggs, and mushrooms"},
  {"The biggest animal on the floor", "Can run fast and swim"},
  {"Bushy black and white striped tail", "Nocturnal with very good night vision"},
  {"Insect with black spots", "Believed to bring good luck"},
  {"Have webbed feet", "Create a ribbit/croak sound from a large throat"},
  {"Covered in sharp spines", "Small rodent found on every continent (except Antarctica)"},
  {"Have short limbs but long body and tail", "Move from water to land as they grow up (metamorphosis)"},
  {"Older males have antlers", "Youth have white spots"},
  {"Same family as dogs and wolves", "Common breed known for red fur"},
  {"Bright red color", "Bird that prioritizes defending its territory"}};

/*--- setup ---*/
void setup() {
  fullScreen(2);
  // size(1920, 1080); //fullscreen for monitor

  BgLb = loadImage("BgLbBlur.jpg"); //background for leaderboard
  BgClues = loadImage("BgCluesBlur.jpg");
  Trophy = loadImage("trophy.png");
  MkNotes = createFont("MarkerNotes.ttf", 10);

  // printArray(Serial.list());
  // port = new Serial(this, Serial.list()[1], 9600); //COM7
  //recievedNum = port.read(); //5 or 11 or /dev/tty.usbserial-1420 also /dev/tty.usbserial-14xx or /dev/cu.usbserial-14xx

  //initialize array of images for clues
  for (int i = 0; i < clueImagesNames.length; i++) {
    String imageName = clueImagesNames[i];
    clueImages[i] = loadImage(imageName);
  }
}

/*--- main loop ---*/
void draw() {
  //while (port.available () > 0) hardwareInput(); //read in values from arduino

  //draw screen based on logic from hardwareInput
  if (screen == lvlNum) levelSelect();
  else if (screen == cdNum) countdownScreen();
  else if (screen == clNum) clues();
  else if (screen == scNum) scoreScreen();
  else if (screen == scNumLock) scoreScreenLocked();
  else if (screen == lbNum) leaderboard();
}

/*--- game logic hardware input ---*/
// void hardwareInput() {
//   int value = port.read();

//   if (screen == lvlNum) {
//     if (value == 1) clueLevel=0;
//     else if (value == 2) clueLevel=1;
//     else if (value == 3) clueLevel=2;
//     else if (value == 0) {
//       startTimer();
//       screen = cdNum; //go to countdown
//     }
//   } else if (screen == cdNum) {
//     // if (value == 0) screen = clNum; //go to clues
//   } else if (screen == clNum) {
//     if (value == clueNum) {
//       // if (clueNum == 14) {
//       // clueNum = 20;
//       // screen = scNum;
//       // } else
//       clueNum++;
//     } //else if (value == 0) screen = lbNum; //go to leaderboard
//   } else if (screen == scNum) {
//     startTimer();
//   } else if (screen == lbNum) {
//     if (value == 0) screen = lvlNum;
//   }
// }

/*--- game logic keyboard input ---*/
void keyPressed() {
  if (screen == lvlNum) levelSelectLogic();
  else if (screen == cdNum) countdownLogic();
  else if (screen == clNum) cluesLogic();
  else if (screen == lbNum) lbLogic();
}

/*-- individual logic for each screen ---*/
//level select
void levelSelectLogic() {
  if (key == '1') clueLevel=0;
  else if (key == '2') clueLevel=1;
  else if (key == '3') clueLevel=2;
  else if (key == '4') screen = clNum; //dev
  else if (key == '5') screen = scNum; //dev
  else if (key == '6') screen = lbNum; //dev
  else {
    startTimer();
    screen = cdNum; //go to countdown
  }
}
//countdown
void countdownLogic() {
  // screen = clNum; //go to clues
}
// clues
void cluesLogic() {
  // if (key == 'a') {
  // if (clueNum == 14) {
  //   clueNum = 20;
  //   // screen = scNum;
  // } else
  clueNum++;
  // clueNum = int[random(0, 2)];
  // } //else screen = lbNum; //go to leaderboard
}
//leaderboard
void lbLogic() {
  screen = lvlNum; //go back to level select
  if (key == '1') screen = scNumLock;
  // clueLevel = 0; //reset clue level
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
  textFont(MkNotes, 85);
  text("Select Level", width/2, (height+275-boxHeight)/2 + 100);
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
    text(desc[i], width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + descY);
  }
}

/*-- countdown screen ---*/
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
      text(levelOfScore[i], (width-listW)/2 + 425, listY+listSpacing*i -5);
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
      text("---", (width-listW)/2 + 425, listY+listSpacing*i -5);
    }
  }
}

/*--- clues screen ---*/
void clues() {
  imageMode(CORNER);
  background(0);
  image(BgClues, 0, 0, width, height);

  /*--- background box ---*/
  fill(24, 128, 41, 185);
  rectMode(CENTER);
  rect(width/2, clueBoxY+clueBoxH/2, clueBoxW, clueBoxH, 15);

  /*--- title ---*/
  textAlign(CENTER);
  fill(255);
  textSize(125);
  text("Clue " + (clueNum+1), width/2, clueBoxY + 125);
  textSize(50);
  if (clueLevel != 0) text(desc[clueLevel], width/2, clueBoxY + 200);

  /*--- clues ---*/
  if (clueLevel == 0) { //image
    textSize(50);
    textAlign(CENTER);
    text("image closeup", width/2, clueBoxY + 200);
    imageMode(CENTER);
    if (clueNum != 15) image(clueImages[clueNum], width/2, imageY, imageSize, imageSize);
  } else {
    int clueIndex = clueLevel-1; //converts 1-2 to 0-1 for the array index
    //text
    textSize(50);
    rectMode(CORNER);
    textAlign(LEFT);
    if (clueNum != 15) text(clueText[clueNum][clueIndex], (width-clueBoxW)/2 + 100, clueBoxY + 250, (width+clueBoxW)/2 - 500, clueBoxY + clueBoxH - 100);
  }

  /*--- progress bar ---*/
  rectMode(CORNER);
  // fill(136, 236, 39);
  fill(255);
  float progress = ((clueNum < clueImagesNames.length) ? (clueBoxW*(clueNum+1))/(clueImagesNames.length) : clueBoxW);
  rect((width-clueBoxW)/2, clueBoxY+clueBoxH-progBarH, progress, progBarH, 15);

  /*--- timer ---*/
  clueStopwatch();
}

void clueStopwatch() {
  int currentSec = int((millis() - startTime)/1000);
  int currentFracSec = int((millis() - startTime)/10 - currentSec*100);

  fill(255);
  textAlign(CENTER);
  textFont(MkNotes, 65);

  if (clueNum == 15) {
    saveScore(currentSec, currentFracSec);
    // int currentFracSec = int((millis() - startTime)/10 - currentSec*100);
    // String currentScore = currentSec + "." + currentFracSec;
    // text(currentScore, width/2 + 100, clueBoxY+clueBoxH-progBarH-65);
  }

  text(currentSec, width/2, clueBoxY+clueBoxH-progBarH-65);
}

void saveScore(int currentSec2, int currentFracSec2) {
  currentScore = Float.valueOf(currentSec2 + "." + currentFracSec2); //set current score
  /*--- code adding score to leaderboard ---*/

  // int lengthOld = scores.length;
  int keepRunning = 1;
  int i = 0;
  // for (int i = 0; i < scores.length; i++) {
  // scores[i] = scores[i]+1.00;
  String thisName = nameOptions[nameOption];
  // nameOptions = shorten(nameOptions);


  if (scores[i] != 999999) {
    do {
      if (currentScore < scores[i]) {
        names = expand(names, names.length + 1);
        scores = expand(scores, scores.length + 1);
        levelOfScore = expand(levelOfScore, scores.length + 1);
        for (int j = (scores.length-1); j > i; j--) {
          scores[j] = scores[j-1];
          levelOfScore[j] = levelOfScore[j-1];
          names[j] = names[j-1];
        }
        scores[i] = currentScore;

        if (clueLevel == 0) levelOfScore[i] = desc[0];
        else if (clueLevel == 1) levelOfScore[i] = desc[1];
        else levelOfScore[i] = desc[2];

        names[i] = thisName;
        lbPosition = i+1;
        keepRunning = 0;
      } else if (i < scores.length - 1) {
        i++;
      } else {
        scores = expand(scores, scores.length + 1);
        levelOfScore = expand(levelOfScore, scores.length + 1);
        scores[i+1] = currentScore;

        if (clueLevel == 0) levelOfScore[i+1] = desc[0];
        else if (clueLevel == 1) levelOfScore[i+1] = desc[1];
        else levelOfScore[i+1] = desc[2];

        lbPosition = i+2;
        keepRunning = 0;
        names = expand(names, names.length + 1);
        names[i] = thisName;
      }
    } while (keepRunning == 1);
  } else {
    scores[0] = currentScore;

    if (clueLevel == 0) levelOfScore[i] = desc[0];
    else if (clueLevel == 1) levelOfScore[i] = desc[1];
    else levelOfScore[i] = desc[2];
    names[0] = thisName;
    lbPosition = 1;
  }

  //last couple things
  clueNum = 0; //reset clues
  startTimer(); //reset timer
  screen = scNum; //change screen to score display
  
  if (nameOption < nameOptions.length) nameOption++; //go to the next name in the list
  else nameOption = 0; //back to beginning
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
