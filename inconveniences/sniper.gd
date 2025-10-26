extends Inconvenience

@export var highlight_time: float = 5.0

var target_block: RigidBody2D
var timer: float = 0.0
var cross: Sprite2D
var icon_image = preload("res://graphics/cross.png")

func _on_start():
	var blocks = get_blocks()
	target_block = blocks.pick_random()
	target_block.modulate = Color(1, 0, 0, .5)
	timer = 0.0
	
	cross = Sprite2D.new()
	cross.texture = icon_image
	cross.modulate = Color(1, .8, .8, 1)
	cross.centered = true
	cross.global_position = target_block.global_position
	cross.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(cross)
	

func _on_update(delta):
	timer += delta
	if not target_block or not target_block.is_inside_tree():
		active = false
		return
	if timer >= highlight_time:
		# Remove the block
		print("Deleting block:", target_block.name)
		target_block.queue_free()
		await get_tree().process_frame
		# Wake up other blocks
		for block in get_blocks():
			block.apply_impulse(Vector2(0.01, 0))
		active = false

func get_blocks() -> Array:
	var children = main.get_node("Blocks").get_children()
	if children.is_empty():
		print("No blocks found!")
		active = false
		return []

	children = children.duplicate()
	if main.current_block:
		children.erase(main.current_block)
	return children

func get_text() -> String:
	return "Destruction"

func clean():
	super.clean()
	cross.queue_free()
