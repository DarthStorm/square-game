class_name CoinDisplay
extends Control

@onready var coindisplay_label:Label = $Label

func init(coins=0):
	update(coins) # something tells me that they are better off seperated

func update(coins):
	coindisplay_label.text = str(coins)
