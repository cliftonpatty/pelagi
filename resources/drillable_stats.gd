extends Resource

#Export Variables---------------------------------------------------------------
@export_category("Generic Stats")
##ID, as string, for non-unique reference
@export var myID: String
##How much is the fish worth if drilled?
@export var value: int
##Depth tier, a parent of rarity, controlling at what depth we see this fish, starts at 1, has no set end
@export var depthTier : int = 1
##Rarity of the fish, lower number = more rare (rarer?)
@export_range(0,1.0) var rarity : float = 1.0
##Is this a fish that only spawns once?
@export var solo: bool = false
