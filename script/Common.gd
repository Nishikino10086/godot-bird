extends Object


static func gameMaxTimeSeconds() -> float:
	return Main.resourceStorage.commonResources["gameMaxTimeSeconds"].value.to_float()


static func objectCreateMinTimeSeconds() -> float:
	return Main.resourceStorage.commonResources["objectCreateMinTimeSeconds"].value.to_float()
	
static func birdInitHp() -> float:
	return Main.resourceStorage.commonResources["birdInitHp"].value.to_int()