//prototype leaderboard
// import data.clues

/*--- variables ---*/
//overall
int width = 1920, height = 1080;

//for leaderboard
PFont MkNotes;
PImage BgLb, BgClues, Trophy;
int index = 0;
int screen = 1;
int titleY = 175, listY = 275, listW = 1000, listSpacing = 80;
String typing = "";
String[] names = {"one", "two", "NEW SCORE", "four", "five", "size", "seven", "eight", "nine", "ten"};
int[] scores = {24, 25, 50, 70, 75, 80, 120, 225, 250, 300};

//for questions
int clueNum = 0;
int clueBoxW = 1500, clueBoxY = 200, clueBoxH = height - clueBoxY - 50;
int imageSize = 300;
int imageX = (width+clueBoxW)/2 - imageSize + 50;
int imageY = clueBoxY+clueBoxH/2 + 50;

//actual question info
String[] clueImagesNames = {"animalOne.jpg", "animalTwo.jpg", "animalThree.jpg"};
PImage[] clueImages = new PImage[clueImagesNames.length];
String[] clueText = {
  "Hard: This clue is animal 1\n\nMedium: This animal is known to be animal 1\n\nEasy: This animal is number 1",
  "Hard: This clue is animal 2\n\nMedium: This animal is known to be animal 2\n\nEasy: This animal is number 2",
  "Hard: This clue is animal 3\n\nMedium: This animal is known to be animal 3\n\nEasy: This animal is number 3"};

/*--- setup ---*/
void setup() {
  size(1920, 1080); //fullscreen for monitor
  BgLb = loadImage("BgLb.jpg"); //background image for leaderboard
  BgClues = loadImage("BgClues.jpg");
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
  if (screen == 1) leaderboard();
  else if (screen ==2) LbEdit();
  else clues();
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
  LbSlots();
}

/*--- leaderboard slots ---*/
void LbSlots() {
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

/*--- mouse clicked ---*/
void mousePressed() {
  if (screen == 1) index = LbCheck();
}

/*--- keybaord input ---*/
void keyPressed() {
  if (screen == 0) {
    if (key == 'a') {
      if(clueNum == 2) clueNum = 0;
      else clueNum++; 
      // clueNum = int[random(0, 2)];
    }
    else screen = 1;
  } else if (screen == 2) {
    if (key == '\n' && typing.length() > 0) {
      names[index] = typing;
      typing = "";
      screen = 1;
    } else if ((key == '\b') && typing.length() > 0) {
      typing = typing.substring(0, typing.length()-1);
    } else typing = typing + key;
  } else screen = 0;
}

/*--- check which leaderboard slot was clicked ---*/
int LbCheck() {
  int indexCheck = 0;
  int nameIndent = (width-listW)/2 + 150;
  int topOfList = listY-(listSpacing-15)/2;
  //determine which name was clicked on
  if ((mouseX > nameIndent) && (mouseX < nameIndent+625) && (mouseY > topOfList)) {
    screen = 2;
    for (int i = 9; i >= 0; i--) {
      if (mouseY < (topOfList + listSpacing*(i+1))) indexCheck = i;
      // rectMode(CORNER); //for debugging
      // rect(width/2, (topOfList + listSpacing*(i)), 40+i*10, (topOfList + listSpacing*(i+1))); //for debugging
    }
  }
  return indexCheck;
}

/*--- edit leaderboard window ---*/
void LbEdit() {
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

  /*--- title ---*/
  fill(255);
  textAlign(CENTER);
  textFont(MkNotes, 100);
  text("Jumbo Ispy", width/2, titleY);

  /*--- clues ---*/
  //background box
  fill(24, 128, 41, 235);
  rectMode(CENTER);
  rect(width/2, clueBoxY+clueBoxH/2, clueBoxW, clueBoxH, 15);
  //titles
  fill(255);
  textSize(75);
  text("Clues", width/2, clueBoxY + 125);
  //text
  textSize(50);
  rectMode(CORNER);
  textAlign(LEFT);
  text(clueText[clueNum], (width-clueBoxW)/2 + 65, clueBoxY + 200, imageX-imageSize - 200, clueBoxY + clueBoxH - 100);
  //image
  textSize(50);
  textAlign(CENTER);
  text("animal closeup", imageX, imageY - imageSize/2 - 65);
  imageMode(CENTER);
  image(clueImages[clueNum], imageX, imageY, imageSize, imageSize);
}
