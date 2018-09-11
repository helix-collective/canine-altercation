# Dogfight

An arena style dogfight between multiple ships

## Collision

 - With bullet (death)
 - With Astroid/Other Ship/Arena Edge (slide)

## Weapons
 - Straight shot (Alive until first collision)
 - Homing shot (Slower, has a max deviation per tick, Alive until first collision or timeout)
 - Shotgun  (3 bullets, spread out on fire, Alive until first collision or timeout). That is, has a max range
 - Mines (Get's dropped behind, alive until first collision or timeout)

All weapons have a max number, and re-charge at some rate
