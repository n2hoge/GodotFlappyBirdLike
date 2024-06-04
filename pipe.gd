extends StaticBody2D

# 移動速度
var velocity = Vector2(-150, 0)

# 開始処理
func start(pos, speed_rate):
	position = pos
	velocity *= speed_rate

func _process(delta):
	# 位置に速度を足しこむ
	position += velocity * delta
	if position.x < -128:
		# 画面外に出たら消える
		queue_free()
