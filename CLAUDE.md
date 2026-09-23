# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Running Pumpkin — an open-source game written in Processing (originally 2012, later updated to the Processing 3.5.3 `sound` library). The existing code, comments and identifiers are in Spanish, but the repo is being migrated to English; write new code, comments and docs in English.

## Running the sketch

There is no build system, test suite, or linter. The repo *is* a Processing sketch folder: the folder name (`Running_Pumpkin`) must match the main tab (`Running_Pumpkin.pde`), and all `.pde` files in the folder are concatenated into one class at compile time.

- Normal workflow: open `Running_Pumpkin.pde` in the Processing IDE (`/Applications/Processing.app`) and press Run.
- Requires the `processing.sound` library installed via Contribution Manager (`import processing.sound.*` in `Running_Pumpkin.pde`).
- CLI runs need `processing-java`, which is not on PATH here; install it from the Processing IDE (Tools → Install "processing-java") before trying `processing-java --sketch=. --run`.

## Architecture

Because Processing merges the tabs, everything shares one namespace: globals declared at the top of `Running_Pumpkin.pde` (`pantalla`, `mundo`, `pumpkin`, `monsters`, `posBaldosas`, `cantB`, `cantM`, the `sw`/`sw2`/`tocado` flags) are read and written freely from `libreria.pde`. Adding state means adding a global there.

- **`Running_Pumpkin.pde`** — globals, `setup()` (a sequence of `load*()` calls), and `draw()`, which is a `switch(pantalla)` over four screens: `0` start menu, `1` gameplay, `2` credits, `3` win.
- **`libreria.pde`** — all the logic: asset loaders, the button/mouse event controller, `loadLevel()`, `controlCalabaza()` (the gameplay state machine), the death `animacion()`, and the two `drawBody()` overloads.
- **`character.pde`** — the pumpkin: position, rotation, texture, plus SAT collision helpers (`getVertex`/`getInterval`/`getFaceDir`/`intersects`) and the grid queries `celda()`, `isOut()`, `isFinish()`.
- **`monster.pde`** — a pure data/accessor class; all movement lives in `drawBody(monster)`, switched on `getAnimacion()` (0 rotate, 1 slow vertical patrol, 2 vertical scale pulse, 3 fast patrol — the only one that tests collision with the pumpkin).
- **`button.pde`** — image pair, hit rectangle, and the screen index to switch to.

### Screen and input flow

`mousePressed()`/`mouseReleased()` only set the module-level `eventoActivado`/`eventoFinalizado` flags in `libreria.pde`. `drawButton()` consumes them during drawing, so every screen must call `drawButton(..., true)` on its **last** button — that `ultimoButton` argument is what clears the flags for the frame. Forgetting it leaves clicks latched.

### Levels

`data/levels/mundoN.txt` are 8-row CSV grids (12 columns used; `mundo` is declared `int[8][13]`). Cells are 80×75 px, so grid `(i,j)` maps to pixel `(j*80, i*75)`, with entities centred via `+39` (pumpkin) or `+33` (monsters).

Tile codes, as parsed by `loadLevel()`:

| code | meaning |
|------|---------|
| `0` | void — the pumpkin dies if it leaves the path |
| `1` | walkable tile |
| `2` | walkable tile + pumpkin spawn |
| `3` | walkable tile + goal + a `bruja` monster |
| `5` | `momia`, random animation 0–2 |
| `6` | `lobo`, random animation 0–2 |
| `7` | `calabera`, random animation 0–2 |
| `10` | `calabera`, animation 3 (patrols and kills on contact), patrol distance 22 |

`loadLevel()` walks the file twice: first to count tiles/monsters, then to allocate and fill `posBaldosas` and `monsters`. Any new tile code must be added to **both** passes.

### Gameplay loop quirks to be aware of

- The pumpkin is dragged with the mouse; `controlCalabaza()` grabs it only if the press starts within `dimension.y/2` of its centre, then follows the mouse via the stored `mouseDistance` offset.
- Leaving the path (`isOut`) is death unless the cell is the goal (`isFinish`), which advances to `levels/mundo<mundoAct>.txt` and increments `mundoAct`; past 12 it jumps to `pantalla = 3`.
- `mundoAct` is initialised to `7`, not `1`, while `setup()` loads `mundo1.txt` — so finishing level 1 jumps to level 7. Change the initialiser to `1` if you want the full sequence.
- Death replays via `animacion()`, which steps the global `ani` counter through a 6-frame strip in `data/animations/animacion.png` and respawns at `xInicial`/`yInicial`.
- Assets are loaded by path relative to `data/`; `loadImage("character/calabaza1.png")` is called every frame on death rather than cached.

## Git commit conventions

- Do not add a `Co-Authored-By` trailer or any Claude attribution footer to commit messages.
- Follow [Conventional Commits](https://www.conventionalcommits.org/) (`type: subject`, e.g. `docs: translate README to English`).

## Renderer

`size(960, 600, P3D)` — P3D is required: `drawBody(character)` draws the pumpkin as a textured quad (`beginShape()`/`texture()`/`vertex()` with UVs), which the default renderer does not support. The system cursor is hidden (`noCursor()`) and replaced by sprite frames cut from `data/cursor/cursorsprite.png` in `controlAnimacionMouse()`.
