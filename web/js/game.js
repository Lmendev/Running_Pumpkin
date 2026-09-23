const SCREEN_HOME = 0;
const SCREEN_GAME = 1;
const SCREEN_CREDITS = 2;
const SCREEN_WIN = 3;

const LEVEL_COUNT = 11;
// The desktop sketch initialises mundoAct to 7 while setup() loads level 1, so the
// level order is 1, 7, 8, 9, 10, 11. Set this to 2 to play every level in order.
const NEXT_WORLD_AFTER_FIRST = 7;

const assets = { levels: {} };

let screenId = SCREEN_HOME;
let currentWorld = NEXT_WORLD_AFTER_FIRST;

let world = [];
let tiles = [];
let monsters = [];
let pumpkin;

let playButton;
let creditsButton;
let backButton;

let eventStarted = false;
let eventFinished = false;

let dragging = false;
let respawning = false;
let touching = false;
let colliding = false;
let dragOffset;
let deathFrame = 0;
let audioStarted = false;

function preload() {
  assets.home = loadImage('data/backgrounds/inicio.jpg');
  assets.credits = loadImage('data/backgrounds/fondoCreditos.png');
  assets.win = loadImage('data/backgrounds/Win1.png');
  assets.worldBackground = loadImage('data/backgrounds/fondoMundo.jpg');
  assets.tile = loadImage('data/tiles/tile.jpg');

  assets.pumpkin = loadImage('data/character/calabaza.png');
  assets.pumpkinDead = loadImage('data/character/calabaza1.png');
  assets.deathSheet = loadImage('data/animations/animacion.png');
  assets.cursorSheet = loadImage('data/cursor/cursorsprite.png');

  assets.witch = loadImage('data/monsters/bruja.png');
  assets.mummy = loadImage('data/monsters/momia.png');
  assets.wolf = loadImage('data/monsters/lobo.png');
  assets.skull = loadImage('data/monsters/calabera.png');

  assets.playDefault = loadImage('data/buttons/jugar1.png');
  assets.playOver = loadImage('data/buttons/jugar2.png');
  assets.creditsDefault = loadImage('data/buttons/creditos1.png');
  assets.creditsOver = loadImage('data/buttons/creditos2.png');
  assets.backDefault = loadImage('data/buttons/back.png');
  assets.backOver = loadImage('data/buttons/back1.png');

  for (let i = 1; i <= LEVEL_COUNT; i++) {
    assets.levels[i] = loadStrings(`data/levels/mundo${i}.txt`);
  }

  assets.music = loadSound('data/sounds/musicaInicio.mp3');
  assets.scream = loadSound('data/sounds/scream3.mp3');
}

function setup() {
  const canvas = createCanvas(960, 600);
  canvas.parent('game');
  noCursor();
  noStroke();
  dragOffset = createVector(0, 0);
  createButtons();
  loadLevel(1);
  document.getElementById('loading').remove();
}

function draw() {
  switch (screenId) {
    case SCREEN_HOME:
      image(assets.home, 0, 0);
      drawButton(playButton, false);
      drawButton(creditsButton, true);
      break;

    case SCREEN_GAME:
      image(assets.worldBackground, 0, 0);
      drawButton(backButton, true);
      paintTiles();
      controlPumpkin();
      break;

    case SCREEN_CREDITS:
      image(assets.credits, 0, 0);
      drawButton(backButton, true);
      break;

    case SCREEN_WIN:
      image(assets.win, 0, 0);
      currentWorld = 1;
      break;
  }

  drawCursor();
}

function drawButton(button, lastButton) {
  if (button.isUnder(mouseX, mouseY)) {
    image(button.overImage, button.posX, button.posY);
    if (button.target && eventFinished) {
      screenId = button.nextScreen;
      button.target = false;
      eventFinished = false;
    }
    if (eventStarted) {
      button.target = true;
      eventStarted = false;
    }
  } else {
    image(button.defaultImage, button.posX, button.posY);
    if (button.target && eventFinished) button.target = false;
  }

  if (lastButton) {
    eventFinished = false;
    eventStarted = false;
  }
}

function mousePressed() {
  startAudio();
  eventStarted = true;
}

function mouseReleased() {
  eventFinished = true;
}

function startAudio() {
  if (audioStarted) return;
  userStartAudio();
  assets.music.loop();
  audioStarted = true;
}

function paintTiles() {
  for (const tile of tiles) image(assets.tile, tile.x, tile.y);
  for (const monster of monsters) drawMonster(monster);
}

function controlPumpkin() {
  if (!pumpkin.alive) {
    respawning = false;
    deathAnimation();
    return;
  }

  colliding = false;

  if (pumpkin.isOut(world)) {
    if (pumpkin.isFinish(world)) {
      dragging = false;
      if (currentWorld < 12) {
        loadLevel(currentWorld);
        currentWorld++;
      } else {
        screenId = SCREEN_WIN;
      }
    } else {
      pumpkin.alive = false;
      pumpkin.setImage(assets.pumpkinDead);
      assets.scream.play();
    }
    return;
  }

  if (mouseIsPressed) {
    if (!dragging) {
      if (dist(mouseX, mouseY, pumpkin.location.x, pumpkin.location.y) <= pumpkin.dimension.y / 2) {
        dragging = true;
        dragOffset.set(pumpkin.location.x - mouseX, pumpkin.location.y - mouseY);
      }
    } else if (!respawning) {
      pumpkin.setLocation(int(mouseX + dragOffset.x), int(mouseY + dragOffset.y));
    }
  } else {
    dragging = false;
    respawning = false;
    pumpkin.setImage(assets.pumpkin);
  }

  drawPumpkin();
}

function drawPumpkin() {
  push();
  translate(pumpkin.location.x, pumpkin.location.y);
  rotate(pumpkin.rotation);
  imageMode(CENTER);
  image(pumpkin.image, 0, 0, pumpkin.dimension.x, pumpkin.dimension.y);
  pop();
}

function drawMonster(monster) {
  push();
  switch (monster.animation) {
    case 0:
      translate(monster.x, monster.y);
      rotate(monster.theta);
      image(monster.image, -28, -28);
      if (monster.theta > PI / 4 || monster.theta < -PI / 4) monster.flipDirection();
      monster.theta += (PI / 100) * monster.st;
      break;

    case 1:
      translate(monster.x, monster.y);
      image(monster.image, -20, -26);
      // Float equality, as in the original: these monsters almost never advance.
      if (monster.currentTime === monster.time) {
        monster.y += monster.st;
        monster.currentDistance++;
        if (monster.currentDistance > monster.distance) {
          monster.flipDirection();
          monster.currentDistance = 0;
        }
        monster.currentTime = 0;
      }
      monster.currentTime++;
      break;

    case 2:
      translate(monster.x, monster.y);
      rotate(monster.theta);
      scale(1, monster.scaleY);
      image(monster.image, -28, -28);
      if (monster.scaleY > 1.3 || monster.scaleY < 1) monster.flipDirection();
      monster.scaleY += 0.03 * monster.st;
      break;

    case 3:
      translate(monster.x, monster.y);
      image(monster.image, -20, -26);
      if (monster.currentTime > monster.time) {
        monster.y += 4 * monster.st;
        monster.currentDistance++;
        if (monster.currentDistance > monster.distance) {
          monster.flipDirection();
          monster.currentDistance = 0;
        }
        monster.currentTime = 0;
      }
      monster.currentTime += 2;

      if (dist(monster.x + 10, monster.y, pumpkin.location.x, pumpkin.location.y) < 60 && pumpkin.alive) {
        pumpkin.alive = false;
        if (!colliding) assets.scream.play();
        pumpkin.setImage(assets.pumpkinDead);
        colliding = true;
      }
      break;
  }
  pop();
}

function deathAnimation() {
  const frame = int(deathFrame / 5);
  image(
    assets.deathSheet,
    pumpkin.location.x - 95, pumpkin.location.y - 100, 168, 174,
    frame * 168, 0, 168, 174
  );

  if (frame >= 5) {
    deathFrame = -1;
    pumpkin.resetLocation();
    pumpkin.alive = true;
    respawning = true;
    touching = false;
  }
  deathFrame++;
}

function drawCursor() {
  const pressedFrame = mouseIsPressed;
  let x = mouseX - assets.cursorSheet.width / 4;
  let y = mouseY - assets.cursorSheet.height / 2;

  if (mouseIsPressed) {
    touching = dist(mouseX, mouseY, pumpkin.location.x, pumpkin.location.y) <= pumpkin.dimension.y / 2;
    if (touching) {
      x = pumpkin.location.x - 14;
      y = pumpkin.location.y - 15;
    }
  } else {
    touching = false;
  }

  image(assets.cursorSheet, x, y, 28, 31, pressedFrame ? 28 : 0, 0, 28, 31);
}

function loadLevel(levelNumber) {
  const lines = assets.levels[levelNumber].filter((line) => line.trim().length > 0);

  world = [];
  tiles = [];
  monsters = [];

  for (let i = 0; i < lines.length; i++) {
    const codes = lines[i].trim().split(',').map((value) => parseInt(value, 10));
    world[i] = codes;

    for (let j = 0; j < codes.length; j++) {
      const code = codes[j];
      const x = j * CELL_W;
      const y = i * CELL_H;
      const monsterX = x + 33;
      const monsterY = y + 33;

      if (code === 1 || code === 2 || code === 3) tiles.push({ x, y });
      if (code === 2) pumpkin = new Character(x + 39, y + 39, assets.pumpkin);
      if (code === 3) monsters.push(new Monster(assets.witch, monsterX, monsterY, int(random(3))));
      if (code === 5) monsters.push(new Monster(assets.mummy, monsterX, monsterY, int(random(3))));
      if (code === 6) monsters.push(new Monster(assets.wolf, monsterX, monsterY, int(random(3))));
      if (code === 7) monsters.push(new Monster(assets.skull, monsterX, monsterY, int(random(3))));
      if (code === 10) {
        const monster = new Monster(assets.skull, monsterX, monsterY, 3);
        monster.distance = 22;
        monsters.push(monster);
      }
    }
  }

  dragging = false;
  respawning = false;
  deathFrame = 0;
}

function createButtons() {
  playButton = new Button(assets.playDefault, assets.playOver, 100, 200, SCREEN_GAME);
  creditsButton = new Button(assets.creditsDefault, assets.creditsOver, 100, 300, SCREEN_CREDITS);
  backButton = new Button(assets.backDefault, assets.backOver, 10, 10, SCREEN_HOME);
}
