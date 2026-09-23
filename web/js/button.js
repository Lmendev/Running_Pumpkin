class Button {
  constructor(defaultImage, overImage, posX, posY, nextScreen) {
    this.defaultImage = defaultImage;
    this.overImage = overImage;
    this.posX = posX;
    this.posY = posY;
    this.limitX = posX + defaultImage.width;
    this.limitY = posY + defaultImage.height;
    this.nextScreen = nextScreen;
    this.target = false;
  }

  isUnder(x, y) {
    return x > this.posX && y > this.posY && x < this.limitX && y < this.limitY;
  }
}
