extends CharacterBody3D

const selected_material = preload("res://shaders/3d_selectcted_outline.tres")

@onready var cube := $MeshInstance3D as MeshInstance3D

var selected := false:
  set(v):
    selected = v
    var material = selected_material if selected else null
    cube.mesh.surface_set_material(0, material)


func _ready():
  # toggle mateiral
  cube.mesh.surface_set_material(0, null)
  add_to_group("selectable")

func toggle_select():
  selected = !selected

func select():
  toggle_select()
  
func get_global_rect() -> Rect2:
  # raycast to camera
  var camera := get_viewport().get_camera_3d()
  var inverse := camera.transform.affine_inverse()
  inverse.xform()
  return Rect2()
