extends Node

const type = "type"
const stackable = "stackable"
const value = "value"
const attack_rate = "attack_rate"

const npc_audio_path = "res://audio/npc/"
const wep_audio_path = "res://audio/weapons/"
const arm_audio_path = "res://audio/armor/"

const sword_sounds = {
"id": wep_audio_path + "sword.wav",
"unsheathe": wep_audio_path + "sword_unsheathe.wav",
"hit": wep_audio_path + "sword_hit.wav",
"swing": wep_audio_path + "sword_swish.wav",
"prep": ""
}

const bow_sounds = {
"id": wep_audio_path + "bow.wav",
"unsheathe": wep_audio_path + "bow_fire.wav",
"hit": wep_audio_path + "bow_hit.wav",
"swing": wep_audio_path + "bow_fire.wav",
"prep": wep_audio_path + "bow_draw.wav"
}

const leather_sounds = {
	"id": arm_audio_path + "armor.wav",
	"equip": arm_audio_path + "chainmail2.wav"
}

const chainmail_sounds = {
	"id": arm_audio_path + "armor.wav",
	"equip": arm_audio_path + "chainmail2.wav"
}

var items = {
"default_item":{
"name": "dagger", "type": "weapon", "slot":"main hand", 
"damage":5, "attack_rate": 3, "attack_type":"slashing",
"sounds":sword_sounds,
"value":1, "enchantments":[]},

"w_bow":{
"name": "bow", "type": "weapon", "slot":"main hand", 
"damage":7, "attack_rate": 8, "attack_type":"range",
"sounds":bow_sounds,
"value":1, "enchantments":[]},

"w_fireball":{
"name": "fireball", "type": "weapon", "slot":"main hand", 
"damage":20, "attack_rate": 15, "attack_type":"magic",
"attack_radius":2,
"sounds":bow_sounds},

"w_bronze_dagger":{
"name": "bronze dagger", "type": "weapon", "slot":"main hand", 
"damage":5, "attack_rate": 3, "attack_type":"slashing",
"sounds":sword_sounds,
"value":1, "enchantments":[]},

"w_iron_sword":{
"name": "iron sword", "type": "weapon", "slot":"main hand", 
"damage":12, "attack_rate": 5, "attack_type":"slashing",
"sounds":sword_sounds,
"value":4, "enchantments":[]},

"a_chainmail_vest":{
"name": "chainmail vest", "type":"armor", "slot":"chest",
"protection":2, "weaknesses":[],
"sounds":chainmail_sounds,
"value":5, "stackable":false, "enchantments":["p_fire_protection"]},

"a_leather_vest":{
"name": "leather vest", "type":"armor", "slot":"chest",
"protection":1, "weaknesses":[],
"sounds":leather_sounds,
"value":5, "stackable":false, "enchantments":["p_fire_protection"]}
}

var spells = {
# offensive
"fireball": {
"name" : "fireball", "type": "range",
"effect": "damage","damage": 15, "aoe": 10, "cast time": 0.6, 
"magic_type": "fire"},

# enchantments
"p_fire_protection": {
"name" : "fire protection", "type": "enchantment", 
"effect": "protection", "resistance": 5,
"magic_type": "fire", "duration" : 300}

}

var npcs = {
"default_npc": {
"name" : "Def Ault", "attitude": "friendly",
"health": 100, "move_speed":1.3, "attack_rate":2.0, "base_damage": 10,
"attributes":["human"],
"equipped":{},
"inventory":[]
},

#friendly
"f_minotaur_merchant": {
"name" : "Merchant Minotaur", "attitude": "friendly",
"health": 100, "move_speed":1.4, "attack_rate":2.0, "base_damage": 10,
"attributes":["minotaur", "merchant"],
"equipped":{"main hand": "w_iron_sword"},
"inventory":[]
},

#hostile
"h_zombie_minotaur": {
"name" : "Zombie Minotaur", "attitude": "hostile",
"health": 80, "move_speed":1, "attack_rate":2.0, "base_damage": 10,
"attributes":["minotaur", "undead"],
"equipped":{},
"inventory":[]
},

"h_zombie": {
"name" : "Zombie", "attitude": "hostile",
"health": 23, "move_speed":20, "attack_rate":2.0, "base_damage": 10,
"attributes":["undead"],
"equipped":{},
"inventory":[],
"sounds" : {
	"path" : npc_audio_path + "zombie/zombie",
	"idle":6,
	"chase":2,
	"alert":5,
	"attack":4,
	"hurt":7}
}

}

var dbs = {
	"items" : items,
	"spells" : spells,
	"npcs" : npcs
}

func get_item(var id):
	if items.has(id):
		return items[id]
	return items["default_item"]

func get_spell(var id):
	if spells.has(id):
		return spells[id]
	return spells["fireball"]

func get_npc(var id):
	if npcs.has(id):
		return npcs[id]
	return npcs["default_npc"]