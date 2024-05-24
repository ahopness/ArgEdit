tool
extends EditorPlugin

var ln_edit :LineEdit
var chkbox_active :CheckBox

func _enter_tree():
	ln_edit = LineEdit.new()
	ln_edit.name = "ln_cmdargs"
	ln_edit.placeholder_text = "args"
	
	chkbox_active = CheckBox.new()
	
	ln_edit.text = ProjectSettings.get("editor/main_run_args")
	can_change = not ln_edit.text.empty()
	chkbox_active.set_pressed_no_signal(can_change)
	_ln_arg_changed(ln_edit.text)
	
	ln_edit.connect("text_changed", self, "_ln_arg_changed")
	chkbox_active.connect("toggled", self, "_chkbox_active_toggled")
	
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, ln_edit)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, chkbox_active)
	
	ln_edit.get_parent().move_child(ln_edit, ln_edit.get_index() - 2)
	chkbox_active.get_parent().move_child(chkbox_active, chkbox_active.get_index() - 2)

var can_change :bool = true
func _ln_arg_changed(text :String):
	ln_edit.editable = can_change
	
	if can_change:
		ProjectSettings.set("editor/main_run_args", text)
	else:
		ProjectSettings.set("editor/main_run_args", "")
func _chkbox_active_toggled(toggle :bool):
	can_change = toggle
	_ln_arg_changed(ln_edit.text)

func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, ln_edit)
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, chkbox_active)
	
	ln_edit.queue_free()
	chkbox_active.queue_free()
