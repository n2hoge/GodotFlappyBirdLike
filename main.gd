extends Node2D

# 土管オブジェクト
var Pipe = preload("res://pipe.tscn")

# 出現間隔（最初は3秒）
var interval = 3

# 生成タイマー
var timer = interval

# 土管出現回数
var pipe_cnt = 0

# キャプション
@onready var caption = $CanvasLayer/Caption

# プレイヤー
@onready var player = $Player

func _ready():
	# 乱数を初期化
	randomize()
	
	# キャプションは初期状態では非表示にしておく
	caption.visible = false 

func _process(delta):
	timer += delta
	if timer > interval:
		# インターバルを超えたら土管を出現させる
		_add_pipe()
		# 再度インターバル計測のために減算
		timer -= interval
		
	if is_instance_valid(player) == false:
		# プレイヤーが消滅した
		# キャプションを更新
		caption.visible = true
		caption.text = "GAME OVER\n\n RETRY: DOWN KEY"
		
		# 下キーが押されたらリトライ
		if Input.is_action_just_pressed("ui_down"):
			# Mainシーンを読み込み直してリトライする
			get_tree().change_scene_to_file("res://main.tscn")
		
func _add_pipe():
	# 出現回数をカウントアップ
	pipe_cnt += 1
	
	# 右画面外の出現位置横軸を指定
	var xbase = 800 + 120
	# 出現位置縦軸（高さ）を乱数から決定
	var ybase = randf_range(32, 320 - 32)
	
	# 土管を上下に生成
	for i in range(2):
		var pipe = Pipe.instantiate()
		var py = ybase
		if i == 0:
			# 上の土管
			py += -320
		else:
			# 下の土管
			py += 320 + 160
			
		# 土管の出現回数が増えるとスピードアップ
		var speed_rate = 1 + 0.5 * pipe_cnt
		pipe.start(Vector2(xbase, py), speed_rate)
		add_child(pipe)
		
	# インターバルを減らす
	interval = max(0.5, interval - 0.2)
