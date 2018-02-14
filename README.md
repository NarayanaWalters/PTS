- Set Up -

Visit https://godotengine.org/download and download the Godot engine.
Run the exe and a project list will open.
Click Import on the right and browse to where you downloaded the game folder.
Double click on the project.godot file and press "Import & Edit"
Press F5 or the play button in the top right to run the game.


- Controls -

WASD - movement
Mouse or Q E keys - turn left and right
LMB - attack
Space echolocate
T - open/close inventory

Inventory Controls:
WS - scroll up and down
AD - switch tabs
Q - drop item
E - equip item

- Mechanics -

Audio Compass: your character's heartbeat indicates direction. 
It pitches up and down the more north and south you face 
and pans right and left the more east and west you face.

Echolocation: Echolocating plays syllables of sound. 
There are tiers of distance that correspond to these.
'aa' means something is 0 to 2 meters in front of you,
'ee' means 2 to 8, and 'oo' means 8+. Notice they are in alphabetical order.
These syllables play more rapidly the closer you are to something.
Also, consonants are added if something interesting is in front of you;
'n' for enemy, 'f' for friendly, 'k' for interactable, and 'l' for loot.
So, for example, if an enemy is 3 meters in front of you, echolocating will 
play the sound 'nee' repeatedly.

Side Awareness: an ambient windy sound plays in your ear if there is an opening
that way. E.g. a corridor to your right and a wall to your left will result in the 
sound playing in your right ear.

Footsteps: A footstep sound plays every meter you step.
