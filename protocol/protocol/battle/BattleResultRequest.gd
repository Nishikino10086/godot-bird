const PROTOCOL_ID = 1006


var score: int

func toString() -> String:
	return "BattleResultRequest"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.score)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.score = result0
	return packet
