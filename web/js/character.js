const CELL_W = 80;
const CELL_H = 75;

class Character {
  constructor(x, y, image) {
    this.location = createVector(x, y);
    this.initialX = x;
    this.initialY = y;
    this.rotation = 0;
    this.alive = true;
    this.setImage(image);
  }

  setImage(image) {
    this.image = image;
    this.dimension = createVector(image.width, image.height);
  }

  setLocation(x, y) {
    this.location.x = x;
    this.location.y = y;
  }

  resetLocation() {
    this.setLocation(this.initialX, this.initialY);
  }

  // The four edge midpoints of the sprite, in grid coordinates.
  cells() {
    const { x, y } = this.location;
    const halfW = this.image.width / 2;
    const halfH = this.image.height / 2;
    return [
      [int((y - halfH + 3) / CELL_H), int(x / CELL_W)],
      [int(y / CELL_H), int((x + halfW - 3) / CELL_W)],
      [int((y + halfH - 3) / CELL_H), int(x / CELL_W)],
      [int(y / CELL_H), int((x - halfW + 3) / CELL_W)],
    ];
  }

  isOut(grid) {
    return this.cells().some(([row, col]) => {
      const tile = tileAt(grid, row, col);
      return tile !== 1 && tile !== 2;
    });
  }

  isFinish(grid) {
    return this.cells().some(([row, col]) => tileAt(grid, row, col) === 3);
  }
}

// Anything off the grid counts as void, so dragging the pumpkin off-canvas kills it
// instead of throwing the way the Java version did.
function tileAt(grid, row, col) {
  const line = grid[row];
  if (!line) return 0;
  const tile = line[col];
  return tile === undefined ? 0 : tile;
}
