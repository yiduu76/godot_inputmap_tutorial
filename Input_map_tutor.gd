extends Control
#remaping 代表当前是否处于等待按键绑定的状态
@onready var remaping = false
const remap_sfg_path = "user://remaped_input.cfg"
var remap_to_event

#ready 时执行读取 
func _ready():
	read_saved_input_map()

#读取函数
func read_saved_input_map():
	var p_cfg = ConfigFile.new()
	var err = p_cfg.load(remap_sfg_path)
	if err != OK:
		return
	var p_event = p_cfg.get_value("remap_data","ui_up")
	InputMap.action_erase_events("ui_up")
	InputMap.action_add_event("ui_up",p_event)

#当绑定按钮被按下时
func _on_remap_button_down():
	InputMap.action_erase_events("ui_up")
	remaping = true

#获取键盘输入的 InputEvent 重写 原 action 的 InputEvent
func _input(event):
	if remaping:
		if event is InputEventKey:
			remap_to_event = event
			InputMap.action_add_event("ui_up",remap_to_event)
			remaping = false
			save_change()

#显示绑定的按键
func _process(_delta):
	if remaping == false:
		$".".text=InputMap.action_get_events("ui_up")[0].as_text()

#将重新绑定的按键保存，方便下次进入时读取
func save_change():
	var p_cfg = ConfigFile.new()
	p_cfg.set_value("remap_data", "ui_up", remap_to_event)
	p_cfg.save(remap_sfg_path)

#这里只演示了单个按键的重绑定及保存，实际上按键一多就会复杂一些，这里就不做展示了
