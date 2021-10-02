## Description
The source code of [Vinteuneon](https://wilkinsondarolt.itch.io/vinteuneon) made for [1JAM Rolling](https://itch.io/jam/1jam-rolling).

This is a game inspired by [Mass Effect's Quasar](https://masseffect.fandom.com/wiki/Quasar) but rather than giving the player two option of range values, we are giving them 6 dices to do so. The player can stop at any time and receive payment for the current score.

### Difficulty
Difficulty scales by making increments of 50 credits each 10 turns to your bet.

| Turn | Bet |
| :---: | :---: |
| 1  | 50 |
| 2  | 50 |
| 3  | 50 |
| 4  | 50 |
| 5  | 50 |
| 6  | 50 |
| 7  | 50 |
| 8  | 50 |
| 9  | 50 |
| 10  | 100 |
| 20  | 150 |
| 30  | 200 |

### Payment
Payment is based on how close you are to 21 and your bet.

| Score | Payment |
| :---: | :---: |
| 18  | 0.5x |
| 19  | 1.0x |
| 20  | 1.5x |
| 21  | 2.0x |

Example: If you bet 50 and stop at 20, you get 75 credits.

## Setup
**Important** This game was built using [DragonRuby](https://dragonruby.itch.io/) and you need a copy of it to run this game.

Clone the game locally on you DragonRuby folder

```bash
git clone https://github.com/wilkinsondarolt/1jam-rolling.git
```

##  Running the game
Use the dragon ruby binary to run the game

```bash
./dragonruby games/1jamrolling
```

## Credits
Art and UI: [Nayara Lara](https://twitter.com/nayara_lara)
SFX and Music: [Euler Moisés](https://twitter.com/EulerMoises)
