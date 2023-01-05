extends Resource

#Export Variables---------------------------------------------------------------
@export_category("Generic Stats")
##ID, as string, for non-unique reference
@export var myID: String
##How much is the fish worth if drilled?
@export var value: int
##Depth tier, a parent of rarity, controlling at what depth we see this fish, starts at 1, has no set end
@export var depthTier : int
##Rarity of the fish, lower number = more rare (rarer?)
@export var rarity : float
##Speed, defaults to zero
@export var swimSpeed : int = 0
##What is 'dropped' by this item in the icebox phase
@export var lootMeat : Dictionary
@export var lootGems : Dictionary
