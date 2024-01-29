extends Control
@onready var remaping=false
@onready var remap_events=[]
#当绑定按钮被按下时

func _on_remap_button_down():
#第一步，备份原 action---"ui_up" 的 InputEvent 到 remap_events 数组
	remap_events=InputMap.action_get_events("ui_up")
#第二步，擦除原 action---"ui_up"的 InputEvent
	InputMap.action_erase_events("ui_up")
#设置状态为 remaping=true也就是正在绑定 并记录action "ui_up"
	remaping=true

#获取键盘输入的 InputEvent 重写 原 action 的 InputEvent
func _input(event):
	if remaping:
		if event is InputEventKey:
			remap_events[0]=event
			for i in remap_events:
				InputMap.action_add_event("ui_up",i)
			remaping=false

#显示绑定的按键
func _process(_delta):
	if remaping==false:
		$".".text=InputMap.action_get_events("ui_up")[0].as_text()
