class Monster {
  constructor(image, x, y, animation) {
    this.image = image;
    this.x = x;
    this.y = y;
    this.st = 1;
    this.theta = 0;
    this.distance = 6;
    this.time = 2;
    this.currentDistance = Math.floor(random(6));
    this.currentTime = random(3);
    this.animation = animation;
    this.scaleY = 1;
  }

  flipDirection() {
    this.st = this.st * -1;
  }
}
