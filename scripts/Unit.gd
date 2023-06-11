extends CharacterBody2D

const selected_material = preload("res://shaders/selected_outline.tres")

@onready var sprite := $Sprite2D as Sprite2D

var selected := false:
  set(v):
    selected = v
    sprite.material = selected_material if selected else null


func _ready():
  # toggle mateiral
  sprite.material = null
  sprite.get_rect()

func toggle_select():
  selected = !selected

func select():
  toggle_select()
  
func get_global_rect() -> Rect2:
  
  var rect := sprite.get_rect()
  rect.position = global_position - rect.size / 2
  return rect
