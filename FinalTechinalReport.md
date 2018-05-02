# Ptolem’s Singing Catacombs Final Technical Report
## Narayana Walters
## 5/1/2018

### Abstract
The goal of this project was to make a fully functional first-person role-playing game (rpg) for blind or visually impaired players. The game was to be entirely audio-based and require no special technology beyond a computer, keyboard, headphones and, optionally, a mouse. The methods used to design and create the game was to follow the skateboard agile design philosophy to have a playable demo at every stage, adding features and making design decisions to solve new problems that arose. I used the open-source game engine Godot to rapidly prototype demos that could be playtested by volunteers. Sound effects were pulled from sources such as OpenGameArt, SoundBible, and Freesound and edited with open-source software Audacity. Design involved creating a fully immersive and intuitive first person character controller that uses only audio for gameplay feedback. The results were a game that has received positive feedback from the community of visually impaired gamers on the AudioGames.net forums. It is a fully-featured dungeon crawler complete with stats, weapons, armor, potions, leveling, magic, a journal, enemies, a boss, puzzles, and chests.

### Keywords
Audio game, audiogame, role playing game, rpg, audio based, blind gamers, visually impaired

### Table of contents
- Overview
- Features
- Design and Creation
- Results
- Conclusions

### Overview
Audiogames are computer games designed to be playable by visually impaired or blind gamers. The problem is that these games are extremely niche and hard to find. For example, on Steam there is only one audiogame: The Blind Legend, a high-quality linear action-adventure game with about four hours of gameplay. There was also Papa Sangre, a puzzle game for IOS that was removed from the app store due to faulty audoi-spatial software. Most other audiogames are small, experimental games; there are very few full-length games with high quality production.

My goal with this project was to create a game that could be used as a solid foundation to build rpgs for visually impaired gamers that can have plenty of content and high-quality design. 

The main design problem with audiogames is conveying a world using audio only. I knew I needed to represent several things: which way the player was facing, what’s in front of them, what’s to their sides, how far they’ve travelled, and roughly where they are currently in the world. I also needed a way to output descriptions of objects found and navigation of an inventory system. 

Most navigation issues were completely addressed; the only ones not fully addressed are easy travel through large open spaces and a way to obtain precise world location coordinates of the player.

### Features:

#### Echolocation 
Echolocating plays syllables. There are tiers of distance that correspond to these. 'aa' means something is 0 to 2 meters in front of you, 'ee' means 2 to 8, and 'oo' means 8+. Notice they are in alphabetical order. These syllables play more rapidly the closer you are to something. Also, consonants are added if something interesting is in front of you; 'n' for enemy, 'f' for friendly, 'k' for interactable, and 'l' for loot. So, for example, if an enemy is 3 meters in front of you, echolocating will play the sound 'nee' repeatedly. If a chest is 1 meter from you, ‘laa’ will play.

#### Side Awareness 
An ambient windy sound plays in your ear if there is an opening that way. E.g. a corridor to your right and a wall to your left will result in the sound playing in your right ear.

#### Movement
A footstep sound plays every meter you step. listen to the echo of your steps to tell when you're at an intersection or in a large room. Movement is grid-based, meaning you always move one tile in the nearest cardinal direction when you take a step.

#### Turning
Your character's heartbeat indicates direction. It pitches up and down the more north and south you face and pans right and left the more east and west you face. There is a freelook mode that is accessed by holding shift. In this mode moving the mouse left or right or holding the q or e keys will turn the character left or right.
Out of freelook mode, tapping the q or e keys will turn the player 90 degrees to the next cardinal direction. Holding the keys or moving the mouse will also snap turn. When a snap turn is completed, audio outputs the the direction the player is now facing, e.g. “north” or “west”.

#### Combat
Combat is performed by holding Left Control or the Left Mouse Button to auto-attack. If the player is wielding a melee weapon, they will hit any enemy 2 meters in front of them. If they are wielding a ranged or magic weapon they will hit any enemy any distance in front of them. A magic weapon also does damage in a radius, harming the player if they are too close. The player’s health can be outputted by pressing the ‘H’ key, when it reaches zero the game restarts. It can be restored by leveling up or drinking healing potions.

#### Inventory
The player’s inventory has four tabs: Equipped Items, Backpack, Stats, and Journal.
Equipped Items include one weapon and one piece of armor, though there is partial support for multiple armor slots. Armor increases protection, which reduces damage taken. Current protection level can be outputted by pressing ‘B’.
Backpack contains unequipped items and healing potions. Items can be equipped by pressing ‘E’.
Stats has three stats: magic, melee, and ranged. These affect damage done with those types of weapons. Inventory also displays current experience and experience required to level up. Current experience increases as enemies are killed, and leveling up grants the player a skill point which can be spent to increase a stat.
Journal is a collection of audio files that can be played by scrolling through them, I have them currently set to descriptions of the game’s controls.


### Design and Creation

I used the Godot game engine for development. It is a high-quality open-source game engine that has a great 2d physics system and audio engine, both of which were critical for this project. I started development with Godot 2.1, then converted the project over Godot 3.0 when it was released.

I tried implementing the Festival text-to-speech library, as the Godot engine has support for adding custom components built with c++, but the lack of proper documentation for festival led to many wasted hours and ultimately unreliable text-to-speech in Godot, so I dropped it and recorded all text myself.

I started work on Ptolem’s Singing Catacombs by creating the character controller. A character controller determines how a player interacts with a game’s world, and having a properly designed one was especially critical for this project. I was designing it to solve problems that never come up in typical games, and there are no resources or advice online for covering them, due to how niche these games are. My philosophy was always that feedback must be precise and rapid, and as immersive as possible.
 I didn’t want text constantly reading out what you did or where you were, I wanted it to feel as approachable as a standard game. However, later on, I would sacrifice immersion for the sake of intuitivity. 

The first problems I addressed were navigation. I iterated through different designs for the echolocation system, coming up with systems that were rapid, or precise, but not both, until I finally created the system in place today.
Then I made the audio compass, using a heartbeat sound and pitching and panning it to represent sound.
The more I worked, the more issues I would find needed solving. For example, if the player travels down a corridor, an opening appears to their side, how could the player know it was there without turning to check? They would have to constantly spin as they walked around to make sure they didn’t miss anything. This led to the creation of the side awareness feature, where an ambient sound is played in an ear if there is an opening that way.

Once I had a working character controller I started work on the rest of the world. I had created a simple maze for testing navigation, so I built some basic enemy npc zombies to fight. They had simple state machines and corresponding audio profiles that indicated what actions they were taking: idle, spotted player, chasing, attacking, hurt, dying. They also have a basic navigation system where they would chase the player by moving towards them, and if the player was not visible, moving to the last spot the player was spotted. 

The next system was the full inventory system; I created the basic structure and overall design early on, the main issue was how to output it through audio. I went  through many iterations for this, such as having sounds effects and an invented language for numbers, before settling on full text output, as it was the most approachable for new players. This was the start of when I started sacrificing immersion for the sake of intuitiveness.

To go with the inventory system, I added interactable chests around the dungeon that contained loot that would be added to the backpack when picked up.

Then I revisited the character controller with the idea to make it more approachable. I made movement grid-based and turning snap-based with text output of the direction faced. This was a lot easier to understand for new players and myself, making the game much more playable.

Puzzles are important for an rpg. I wanted to have at least one in the game so I used an old design idea I had: A musical note combination puzzle. A sequence of notes would play quietly in an area with pressure plates. When the player steps on a pressure plate, a note is sounded out. If the player steps on the plates in the right combination to get the sequence playing quietly, a door is opened.

I finally added a custom tile system that affects footstep sound audio when the player steps on certain tiles, which can be used to convey large open areas by adding echo and reverb.

All items and npcs were described in a database singleton, allowing easy creation of new ones for loading into a level.

Testing was reserved for subsystems that had many edge cases I needed to make sure functioned correctly. 
I made my own number to speech synthesis system for outputting stats and this needed comprehensive testing to make sure all numbers outputted correctly. This would have taken too long to verify manually so I built a test to cover it.
I also made tests for the inventory system which was especially prone to breaking, so  whenever I added new code I could verify edge cases still worked and wouldn’t crash the game.


### Results
The game is fully playable and has been playtested by the Audiogames.net community. There are bugs, but it is stable and stands out there as a complete, original rpg system.

The feedback on mechanics is somewhat mixed, mostly with the echolocation system. Some players said single syllables are confusing and there should be full text feedback on everything e.g. “an enemy is five meters away” instead of “nee”, others say the system is great and doesn’t need to be changed. In the future I will likely add an option to toggle between a ‘full info’ mode that allows for both methods of feedback.

Also, navigation of large areas is still confusing, especially because of the grid-based movement system. I feel it would be better if I had made the project more like old-school dungeon crawler rpgs that are just corridors. But to make a proper rpg would require large areas, so this will need to be explored and studied more.

### Final Features:
- Echolocation: Solid, but not perfect. Could use full info alternative.
- Audio Compass: Takes a moment to interpret, but works as intended, though not very precise.
- Side Awareness: Works great, but can get overwhelmed by other sounds.
- Grid-Based Movement: Works perfectly
- Inventory System: Intuitive and easy to navigate and use
- Leveling and Stats System: Intuitive and easy to navigate and use
- Basic Combat: Works and is easy to understand, but pretty boring
- NPC enemies: Easy to create and use, and for players to understand what the npc is doing, but don’t offer too exciting gameplay.
- NPC basic navigation: Works well enough for the goals of this project
- Music Combination Puzzle: Fun, original puzzle, but needs better sound design.
- Gameplay: The current demo offers about 15 minutes of gameplay and could be easily expanded for more.

The game runs fine, with no lag or frame rate issues. Sometimes the audio has quality issues but is clear the majority of the time.


### Conclusions
Making audiogames is very difficult, it is a very unexplored area of game design that needs a lot more research. Especially as someone with no visual impairments, it was very challenging for me to design what seemed to be very unintuitive mechanics.


### References:
- Godot Engine: https://godotengine.org/
- AudioGames Community: http://forum.audiogames.net/


