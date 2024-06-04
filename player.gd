extends CharacterBody2D

# 重力
const GRAVITY_POWER := 1000

# ジャンプ力
const JUMP_POWER := -400

# 移動速度
#var velocity := Vector2()

# ジャンプできるかどうか
var can_jump := true

# スプライト
@onready var sprite := $sprite

func _process(delta):
	# 移動処理を行う
	_update_moving(delta)
	
	# 衝突処理を行う
	_update_collision(delta)
		
	# アニメーションの更新
	_update_anim(delta)
	
	if position.x < 0 or position.y > 480:
		# 画面外に出たら消滅する
		queue_free()

# 移動処理を行う
func _update_moving(delta):
	# 重力を加算
	velocity.y += GRAVITY_POWER * delta
	
	if can_jump and Input.is_action_just_pressed("ui_accept"):
		# Spaceキーでジャンプ処理
		velocity.y = JUMP_POWER
		
	if position.y < 0:
		# 画面上にはみ出さないようにする
		velocity.y = 100
		
	if position.y > 600-64:
		# 画面下に落ちないようにオートジャンプ
		velocity.y = JUMP_POWER

# 衝突処理
func _update_collision(delta):
	# 移動と衝突処理を行う
	var collision = move_and_collide(velocity * delta)
	if collision:
		# 衝突したのでジャンプできなくする
		can_jump = false
		# 左方向に吹き飛ばす
		velocity.x -= 300
		if position.y < collision.get_position().y:
			# 土管より上にプレイヤーがいる
			velocity.y = -300
		else:
			# 土管より下にプレイヤーがいる
			velocity.y = 300
		# さらに移動量を加える
		move_and_collide(velocity * delta)
		
# アニメーションの更新
func _update_anim(delta):
	# 基本
	sprite.frame = 0
	if velocity.y < 0:
		#上昇中
		sprite.frame = 1
	if can_jump == false:
		# 吹っ飛び中は回転する
		sprite.rotation -= 10 * delta
		# ダメージ画像にする
		sprite.frame = 2
