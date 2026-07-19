class_name UpgradeContainer extends Control

# keeps track of upgrades and stuff

@export var title:String = "" # title
@export_multiline("Description") var description: String = ""
@export var cost: int = 0
@export var upgrade_string = ""
@export var texture: Texture2D = Texture2D.new()
