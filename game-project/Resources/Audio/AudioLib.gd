extends Node

const MUSIC = {
	"main_city" = preload("res://Resources/Audio/Songs/CozyGameDigSiteVersionMaybe.mp3"),
	"house" = preload("res://Resources/Audio/Songs/CozyGameRoughSketch01.mp3"),
	"suspense" =preload("res://Resources/Audio/Songs/MYSTERIOUS.mp3")
}

const AMBIANCE = {
	"camp_1" = preload("res://Resources/Audio/Ambiance/GameProject2_DigSiteAmbience.mp3"),
	"camp_2" = preload("res://Resources/Audio/Ambiance/GameProject2_DesertAmbience.mp3"),
	"house" = preload("res://Resources/Audio/Ambiance/HOMEfireplace.mp3"),
}

const SFX = {
	"BrushSound" = preload("res://Resources/Audio/SoundEffects/GameProject2_BRUSHSOUNDS.wav"),
	"DigSound" = preload("res://Resources/Audio/SoundEffects/GameProject2_DiggingSoundz2.wav"),
	"DoorExit" = preload("res://Resources/Audio/SoundEffects/GameProject2_DOORsound1(exitRoom).wav"),
	"DoorEnter" = preload("res://Resources/Audio/SoundEffects/GameProject2_DOORsound2(enterNewArea).wav"),
	"MenuClick" = preload("res://Resources/Audio/SoundEffects/GameProject2_MENU_CLICK.wav"),
	"MenuNotif" = preload("res://Resources/Audio/SoundEffects/GameProject2_MENU_NOTIFICATION.wav"),
	"WalkConcrete" = preload("res://Resources/Audio/SoundEffects/GameProject2_WalkingOnConcreteNWood.wav"),
	"WalkDirt" = preload("res://Resources/Audio/SoundEffects/GameProject2_WalkingOnGRASSnDIRT.wav"),
	"WalkGeneral" = preload("res://Resources/Audio/SoundEffects/GameProject2_WalkingSoundz.wav"),
	
}

const VOICES = {
	"Inez": [#coworker
		preload("res://Resources/Audio/NPC voices/coworker/02-coworker2.wav"),
		preload("res://Resources/Audio/NPC voices/coworker/03-coworker3.wav"),
		preload("res://Resources/Audio/NPC voices/coworker/04-coworker4.wav"),
		preload("res://Resources/Audio/NPC voices/coworker/05-coworker5.wav"),
		preload("res://Resources/Audio/NPC voices/coworker/06-coworker 6.wav"),
		preload("res://Resources/Audio/NPC voices/coworker/07-coworker7.wav"),
		preload("res://Resources/Audio/NPC voices/coworker/08-coworker 8.wav"),
		preload("res://Resources/Audio/NPC voices/coworker/09-coworker 9.wav"),
	],
	"Boss": [
		preload("res://Resources/Audio/NPC voices/coworker_boss/01-boss1.wav"),
		preload("res://Resources/Audio/NPC voices/coworker_boss/02-boss2.wav"),
		preload("res://Resources/Audio/NPC voices/coworker_boss/03-boss3.wav"),
		preload("res://Resources/Audio/NPC voices/coworker_boss/04-boss4.wav"),
		preload("res://Resources/Audio/NPC voices/coworker_boss/05-boss5.wav"),
		preload("res://Resources/Audio/NPC voices/coworker_boss/06-boss6.wav"),
		preload("res://Resources/Audio/NPC voices/coworker_boss/07-boss7.wav"),	
	],
	"Poppy": [#hobo
		preload("res://Resources/Audio/NPC voices/hobo/01-hobo1.wav"),
		preload("res://Resources/Audio/NPC voices/hobo/02-hobo2.wav"),
		preload("res://Resources/Audio/NPC voices/hobo/03-hobo3.wav"),
		preload("res://Resources/Audio/NPC voices/hobo/04-hobo4.wav"),
		preload("res://Resources/Audio/NPC voices/hobo/05-hobo5.wav"),
		preload("res://Resources/Audio/NPC voices/hobo/06-hobo6.wav"),
		preload("res://Resources/Audio/NPC voices/hobo/07-hobo7.wav"),
		preload("res://Resources/Audio/NPC voices/hobo/08-hobo8.wav"),
	],
	"Camila": [#museumclerk
		preload("res://Resources/Audio/NPC voices/museum clerk/01-museum.wav"),
		preload("res://Resources/Audio/NPC voices/museum clerk/02-museum.wav"),
		preload("res://Resources/Audio/NPC voices/museum clerk/03-museum.wav"),
		preload("res://Resources/Audio/NPC voices/museum clerk/04-museum.wav"),
		preload("res://Resources/Audio/NPC voices/museum clerk/05-museum.wav"),
		preload("res://Resources/Audio/NPC voices/museum clerk/06-museum.wav"),
	],
	"Oran": [#timeTraveler
		preload("res://Resources/Audio/NPC voices/Time traveler 1/01-tt1.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 1/02-tt1.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 1/03-tt1.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 1/04-tt1.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 1/05-tt1.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 1/06-tt1.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 1/07-tt1.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 1/08-tt1.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 1/09-tt1.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 1/10-tt1.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 1/11-tt1.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 1/12-tt1.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 1/13-tt1.wav"),
	],
	"Florence": [#timeTraveler
		preload("res://Resources/Audio/NPC voices/Time traveler 2/01-tt2.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 2/02-tt2.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 2/03-tt2.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 2/04-tt2.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 2/05-tt2.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 2/06-tt2.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 2/07-tt2.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 2/08-tt2.wav"),
	],
	"Thea": [#timeTraveler
		preload("res://Resources/Audio/NPC voices/Time traveler 3/01-tt3.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 3/02-tt3.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 3/03-tt3.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 3/04-tt3.wav"),
		preload("res://Resources/Audio/NPC voices/Time traveler 3/05-tt3.wav"),
	],
	"Aiden": [ #shop clerk (same as default voice)
		preload("res://Resources/Audio/NPC voices/random civilian/01-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/02-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/03-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/04-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/05-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/06-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/07-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/08-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/09-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/10-civ.wav"),
	],
	"Default": [ #random civilian folder
		preload("res://Resources/Audio/NPC voices/random civilian/01-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/02-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/03-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/04-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/05-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/06-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/07-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/08-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/09-civ.wav"),
		preload("res://Resources/Audio/NPC voices/random civilian/10-civ.wav"),
	]
}
