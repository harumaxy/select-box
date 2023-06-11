extends Node2D
class_name SelectManager

@export var boader_width = 10
@export var boader_color = Color.DEEP_SKY_BLUE
@export var fill_rect_color = Color(Color.DEEP_SKY_BLUE, 0.3)

var is_selecting: bool = false:
  set(v):
    var prev = is_selecting
    is_selecting = v
    queue_redraw()
    if prev == true and v == false:
      execute_select()
    
var start := Vector2()
var end := Vector2()

### override virtual methods ###

func _draw():
  if not is_selecting:
    return
  var rect = selected_rect()
  if rect.size.length() < 3:
    return
  draw_rect(rect, boader_color, false, boader_width)
  draw_rect(rect, fill_rect_color, true, 0)

func _unhandled_input(event):
  if event is InputEventMouseButton:
    if event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            is_selecting = true
            start = get_viewport().get_mouse_position()
        else:
            is_selecting = false

func _process(_delta):
  if is_selecting:
    end = get_viewport().get_mouse_position()
    queue_redraw()

### methods ###

func selected_rect() -> Rect2:
  var begin = Vector2(min(start.x, end.x), min(start.y, end.y))
  var size = Vector2(abs(start.x - end.x), abs(start.y - end.y))
  return Rect2(begin, size)


func detect_selected_nodes():
  var rect = selected_rect()
  var selected_nodes = get_tree().get_nodes_in_group("selectable").filter(func(n: Node2D):
    var sprite_rect = n.get_global_rect()
    return rect.intersects(sprite_rect)
  )
  return selected_nodes


func execute_select():
  var selected_nodes = detect_selected_nodes()
  print(selected_nodes)
  for node in selected_nodes:
    if node.has_method("select"):
      node.select()
