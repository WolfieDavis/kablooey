//prototype leaderboard
// import data.clues

/*--- variables ---*/
//overall
final int width = 1920, height = 1080;
final int lvlNum = 0, cdNum = 1, clNum = 2, lbNum = 3, lbEditNum = 4; //screen numbers
int screen = 0; //screen index

//for level select
public final int boxWidth = 850, boxHeight = 550;
public final int cirlceY = 250, circleSpacing = 265;
public final int descY = 430;
public final String[][] desc = {{"Easy", "Images"}, {"Meduim", "Text Clues"}, {"Hard", "Text Clues"}};

//for leaderboard
PFont MkNotes;
PImage BgLb, BgClues, Trophy;
int index = 0;
public final int titleY = 175, listY = 275, listW = 1000, listSpacing = 80;
String typing = "";
String[] names = {"one", "two", "three", "four", "five", "size", "seven", "eight", "nine", "ten"};
int[] scores = {24, 25, 50, 70, 75, 80, 120, 225, 250, 300};

//for clues
int clueNum = 0;
int clueLevel = 0;
public final int clueBoxW = 1250, clueBoxY = 100, clueBoxH = height - clueBoxY - 50;
public final int imageSize = 300;
public final int imageX = (width+clueBoxW)/2 - imageSize + 50;
public final int imageY = clueBoxY+clueBoxH/2 + 100;
//for timer for clues
long startTime;
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
  size(1920, 1080); //fullscreen for monitor
  BgLb = loadImage("BgLbBlur.jpg"); //background for leaderboard
  BgClues = loadImage("BgCluesBlur.jpg");
  Trophy = loadImage("trophy.png");
  MkNotes = createFont("MarkerNotes.ttf", 10);

  //initialize array of images for clues
  for (int i = 0; i < clueImagesNames.length; i++) {
    String imageName = clueImagesNames[i];
    clueImages[i] = loadImage(imageName);
  }
}

/*--- main loop ---*/
void draw() {
  if (screen == lvlNum) levelSelect();
  else if (screen == cdNum) countdownScreen();
  else if (screen == clNum) clues();
  else if (screen == lbNum) leaderboard();
  else if (screen == lbEditNum) lbEdit();
}

/*--- keybaord input and game logic ---*/
// void keyPressed() {
//   if (screen == 0) {
//     if (key == '1') clueLevel=0;
//     else if (key == '2') clueLevel=1;
//     else if (key == '3') clueLevel=2;
//     else screen = 1; //go to clues
//   } else if (screen == 1) {
//     if (key == 'a') {
//       if (clueNum == 14) clueNum = 0;
//       else clueNum++;
//       // clueNum = int[random(0, 2)];
//     } else screen = 2; //go to leaderboard
//   } else if (screen == 2) {
//     screen = 0; //go back to level select
//   } else if (screen == 3) {
//     if (key == '\n' && typing.length() > 0) {
//       names[index] = typing;
//       typing = "";
//       screen = 2;
//     } else if ((key == '\b') && typing.length() > 0) {
//       typing = typing.substring(0, typing.length()-1);
//     } else typing = typing + key;
//   }
// }
void keyPressed() {
  if (screen == lvlNum) levelSelectLogic();
  else if (screen == clNum) cluesLogic();
  else if (screen == lbNum) lbLogic();
  else if (screen == lbEditNum) lbEditLogic();
}

/*-- individual logic for each screen ---*/
//level select
void levelSelectLogic() {
  if (key == '1') clueLevel=0;
  else if (key == '2') clueLevel=1;
  else if (key == '3') clueLevel=2;
  else {
    startTimer();
    screen = cdNum; //go to countdown
  }
}
// clues
void cluesLogic() {
  if (key == 'a') {
    if (clueNum == 14) clueNum = 0;
    else clueNum++;
    // clueNum = int[random(0, 2)];
  } else screen = lbNum; //go to leaderboard
}
//leaderboard
void lbLogic() {
  screen = lvlNum; //go back to level select
  // clueLevel = 0; //reset clue level
}
//leaderboard
void lbEditLogic() {
  if (key == '\n' && typing.length() > 0) {
    names[index] = typing;
    typing = "";
    screen = lbNum;
  } else if ((key == '\b') && typing.length() > 0) {
    typing = typing.substring(0, typing.length()-1);
  } else typing = typing + key;
}

/*--- if mouse clicked ---*/
void mousePressed() {
  if (screen == lbNum) index = lbCheck();
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
  textFont(MkNotes, 100);
  text("Jumbo Ispy", width/2, titleY);
  /*--- box ---*/
  fill(5, 99, 19, 255);
  rect(width/2, height/2, boxWidth, boxHeight, 15);
  /*--- box title ---*/
  fill(255);
  textAlign(CENTER);
  textFont(MkNotes, 65);
  text("Select Level", width/2, (height-boxHeight)/2 + 100);
  /*--- level circles ---*/
  ellipseMode(CENTER);
  for (int i = 0; i <= 2; i++) {
    if (clueLevel == i) fill(136, 236, 39);
    else fill(255);
    //circles
    circle(width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + cirlceY, 175);
    fill(5, 99, 19);
    //circle labels
    textSize(100);
    text(i+1, width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + cirlceY + 38);
    //descriptions
    fill(255);
    textSize(55);
    text(desc[i][0], width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + descY);
    textSize(35);
    text(desc[i][1], width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + descY + 50);
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
  text("Leaderboard", width/2, titleY);

  imageMode(CENTER);
  image(Trophy, width/2-450, titleY-35, 100, 100);
  image(Trophy, width/2+450, titleY-35, 100, 100);

  /*--- slots ---*/
  lbSlots();
}

/*--- leaderboard slots ---*/
void lbSlots() {
  rectMode(CENTER);
  textFont(MkNotes, 50);

  for (int i = 0; i < 10; i++) {
    //rectangles
    fill(24, 128, 41, 235);
    rect(width/2, listY+listSpacing*i, listW, listSpacing-15, 15);
    //text
    fill(255);
    textAlign(LEFT, CENTER);
    text("#" + (i+1), (width-listW)/2 + 15, listY+listSpacing*i -5);
    text(names[i], (width-listW)/2 + 150, listY+listSpacing*i -5);
    textAlign(RIGHT, CENTER);
    text(scores[i], (width+listW)/2 - 15, listY+listSpacing*i -5);
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
      // rectMode(CORNER); //for debugging
      // rect(width/2, (topOfList + listSpacing*(i)), 40+i*10, (topOfList + listSpacing*(i+1))); //for debugging
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
  textSize(100);
  text("Clue " + (clueNum+1), width/2, clueBoxY + 125);
  textSize(35);
  text(desc[clueLevel][0] + " - " + desc[clueLevel][1], width/2, clueBoxY + 185);

  /*--- clues ---*/
  if (clueLevel == 0) {
    //image
    textSize(50);
    textAlign(CENTER);
    text("animal closeup", width/2, imageY - imageSize/2 - 65);
    imageMode(CENTER);
    image(clueImages[clueNum], width/2, imageY, imageSize, imageSize);
  } else {
    int clueIndex = clueLevel-1; //converts 1-2 to 0-1 for the array index
    //text
    textSize(50);
    rectMode(CORNER);
    textAlign(LEFT);
    text(clueText[clueNum][clueIndex], (width-clueBoxW)/2 + 100, clueBoxY + 250, (width+clueBoxW)/2 - 100, clueBoxY + clueBoxH - 100);
  }

  /*--- timer ---*/
}

/*--- start timer ---*/
void startTimer() {
  startTime = millis();
}

/*-- countdown screen ---*/
void countdownScreen() {
  if (int(millis() - startTime) < 6000) { //6 second timer, counts up from start
    int currentTime = int(5-(millis() - startTime)/1000); //counts down from 5 to 1 visually
    /*--- box ---*/
    rectMode(CENTER);
    fill(5, 99, 19, 255);
    rect(width/2, height/2, boxWidth, boxHeight, 15);
    /*--- box title ---*/
    fill(255);
    textAlign(CENTER);
    textFont(MkNotes, 65);
    text("Get Ready!", width/2, (height-boxHeight)/2 + 100);
    textFont(MkNotes, 150);
    if (currentTime != 0) text(currentTime, width/2, (height-boxHeight)/2 + 350); //from 5 to 1 numbers
    else text("GO!", width/2, (height-boxHeight)/2 + 350); //for 0 it says GO!
  } else {
    screen = clNum; //go to clues screen
    startTimer(); //reset timer
  }
}

/*-- timer ---*/
void timerDisplay() {
  // currentTime = (millis() - startTime)/1000;
}


// /*-- countdown code ---*/
// int countdown() {
//   long currentTime = (millis() - startTime)/1000;

//   // public final int lightOffsetX = 280, lightStartY = 100, lightOffsetY = 75, lightSize = 50;

//   /*--- box ---*/
//   rectMode(CENTER);
//   fill(5, 99, 19, 255);
//   rect(width/2, height/2, boxWidth, boxHeight, 15);
//   /*--- box title ---*/
//   fill(255);
//   textAlign(CENTER);
//   textFont(MkNotes, 65);
//   text("Get Ready!", width/2, (height-boxHeight)/2 + 100);

//   text(currentTime, width/2, (height-boxHeight)/2 + 200);

//   if (currentTime > 5) return(0);
//   else return(1);
//   /*--- level circles ---*/
//   // ellipseMode(CENTER);
//   // for (int i = 0; i <= 2; i++) {
//   //   if (clueLevel == i) fill(136, 236, 39);
//   //   else fill(255);
//   //   //circles
//   //   circle(width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + cirlceY, 175);
//   //   fill(5, 99, 19);
//   //   //circle labels
//   //   textSize(100);
//   //   text(i+1, width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + cirlceY + 38);
//   //   //descriptions
//   //   fill(255);
//   //   textSize(55);
//   //   text(desc[i][0], width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + descY);
//   //   textSize(35);
//   //   text(desc[i][1], width/2 - circleSpacing + circleSpacing*i, (height-boxHeight)/2 + descY + 50);
//   // }
// }



// class Timer {

//   long startTime ; // time in msecs that timer started
//   long timeSoFar ; // use to hold total time of run so far, useful in
//   // conjunction with pause and continueRunning
//   boolean running ;
//   int x, y, textHeight; // location of timer output

//   Timer(int inX, int inY, int textSize2){
//     x = inX ;
//     y = inY ;
//     textHeight = textSize2;
//     running = false ;
//     timeSoFar = 0 ;
//   }


//   int currentTime(){
//     if ( running )
//       return ( (int) ( (millis() - startTime) / 1000.0) ) ;
//     else
//       return ( (int) (timeSoFar / 1000.0) ) ;
//   }

//   void start(){
//     running = true ;
//     startTime = millis() ;
//   }

//   void restart() { // reset the timer to zero and restart, identical to start
//     start() ;
//   }

//   void pause(){
//     if (running){
//       timeSoFar = millis() - startTime ;
//       running = false ;
//     }// else do nothing, pause already called
//   }

//   void continueRunning()  {
//         // called after stop to restart the timer running
//     // no effect if already running
//     if (!running)  {
//       startTime = millis() - timeSoFar ;
//       running = true ;
//     }
//   }

//   void DisplayTime() {
//     int theTime ;
//     String output = "";

//     theTime = currentTime() ;
//     output = output + theTime ;

//     // println("output = " + output) ;
//     fill(150, 0, 200) ;
//     // PFont font ;
//     // font = loadFont("Arial-Black-48.vlw") ;
//     textFont(MarkerNotes,textHeight);
//     text(output, x, y) ;
//   }
// }