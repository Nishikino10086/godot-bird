extends Node2D

const TimeUtils = preload("res://zfoo/TimeUtils.gd")
const StringUtils = preload("res://zfoo/StringUtils.gd")
const ScoreRankRequest =preload("res://protocol/protocol/cache/ScoreRankRequest.gd")
const ScoreRankResponse =preload("res://protocol/protocol/cache/ScoreRankResponse.gd")
const RankInfo = preload("res://protocol/protocol/common/RankInfo.gd")


@onready var rankList: ItemList = $Control/RankList

var ranks: Array[RankInfo] = []

func _ready():
	$Control/Start.connect("pressed", Callable(self, "startGame"))
	$Control/RankButton.connect("pressed", Callable(self, "showRank"))
	# 每次到home场景都随机一个背景
	Main.randomBackground()
	$Background/Background.texture = Main.currentBackground
	$UI/Bird.animation = Main.currentAnimation
	pass

func _process(delta):
	var packet = Main.tcpClient.peekReceivePacket()
	if packet == null:
		return
	if packet is ScoreRankResponse:
		Main.tcpClient.popReceivePacket()
		ranks = packet.ranks
		updateRankList()
		print(StringUtils.format("收到排行榜信息ranks:[{}]", [packet.ranks.size()]))
	pass

func startGame():
	Main.changeScene(Main.SCENE.Game)
	pass

func _input(event):
	if event is InputEventScreenDrag:
		print(event)
		rankList.ensure_current_is_visible() # Auto scroll to show currently selected item.
		var scroll_bar: VScrollBar = rankList.get_v_scroll_bar()
		var scroll_by: float = -event.velocity.y / 100
		scroll_bar.value += scroll_by

func showRank():
	if (rankList.visible):
		rankList.visible = false
	else:
		rankList.visible = true
		Main.tcpClient.send(ScoreRankRequest.new())
	pass

func updateRankList():
	rankList.clear()
	var count = 1
	for rank in ranks:
		var score = rank.score
		var name = rank.playerInfo.name
		var time = rank.time
		var rankMessage = StringUtils.format("{} [{}] {} ", [TimeUtils.timeToDateString(time), score, name])
		if count == 1:
			rankList.add_item(rankMessage, preload("res://image/medals_3.png"))
		elif count == 2:
			rankList.add_item(rankMessage, preload("res://image/medals_2.png"))
		elif count == 3:
			rankList.add_item(rankMessage, preload("res://image/medals_1.png"))
		else:
			rankList.add_item(rankMessage, preload("res://image/medals_0.png"))
		count = count + 1
	pass
