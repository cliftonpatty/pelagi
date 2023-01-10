extends Resource

const fDataBase : Dictionary = {
	"armoured_chub" : {
		"ref" : "res://scenes/drillables/fish/armoured_swimmers/armoured_chub.tscn",
		"value" : 300,
		"depthTier" : 3,
		"rarity" : 30,
		"swimSpeed" : 150,
		"lootMeat" : [
				{
				"type" : "knight",
				"amount" : 2
				}
			],
		"lootGems" : [
				{
				"type" : "blue",
				"amount" : 1
				}
			]
		},
	"cuddle" : {
		"ref" : "res://scenes/drillables/fish/directional_swimmer/cuddle.tscn",
		"value" : 100,
		"depthTier" : 1,
		"rarity" : 90,
		"swimSpeed" : 250,
		"lootMeat" : [
				{
				"type" : "diag",
				"amount" : 1
				},
				{
				"type" : "line",
				"amount" : 1
				}
			],
		"lootGems" : null
		},
	"pig" : {
		"ref" : "res://scenes/drillables/fish/directional_swimmer/pig.tscn",
		"value" : 50,
		"depthTier" : 1,
		"rarity" : 100,
		"swimSpeed" : 50,
		"lootMeat" : [
				{
				"type" : "square",
				"amount" : 1
				}
			],
		"lootGems" : null
		},
	"spear" : {
		"ref" : "res://scenes/drillables/fish/directional_swimmer/spear.tscn",
		"value" : 150,
		"depthTier" : 2,
		"rarity" : 80,
		"swimSpeed" : 50,
		"lootMeat" : [
				{
				"type" : "line",
				"amount" : 1
				}
			],
		"lootGems" : null
		}
	}
