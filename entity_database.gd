extends Node

const name = "name"
const type = "type"
const stackable = "stackable"
const value = "value"
const attack_rate = "attack_rate"

var items = {
"default_item":{
"name": "dagger", "type": "weapon", "slot":"main hand", 
"damage":5, "attack_rate": 0.3, "attack_type":"slashing",
"value":1, "enchantments":[]},

"w_bronze_dagger":{
"name": "bronze dagger", "type": "weapon", "slot":"main hand", 
"damage":5, "attack_rate": 0.3, "attack_type":"slashing",
"value":1, "enchantments":[]},

"w_iron_sword":{
"name": "iron sword", "type": "weapon", "slot":"main hand", 
"damage":12, "attack_rate": 0.5, "attack_type":"slashing",
"value":4, "enchantments":[]},

"a_chainmail_vest":{
"name": "chainmail vest", "type":"armor", "slot":"chest",
"armor":3, "weaknesses":[],
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
}

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