extends Resource

#Not Yet in Use

const decoPath : String = "res://scenes/meat/tetro/"

const dropTable : Dictionary = {
	"cuddle" : {
			"tetro" : [ 
					{
						"path" : decoPath + "knight.tscn",
						"quantity" : 1
					}
				],
			"gems" : []
		},
	"pig" : {
			"tetro" : [ 
					{
						"path" : decoPath + "small_diag.tscn",
						"quantity" : 1
					}
				],
		"gems" : []
	},
	"armoured_chub" : {
			"tetro" : [ 
					{
						"path" : decoPath + "knight.tscn",
						"quantity" : 2
					}
				],
		"gems" : []
	}
}
