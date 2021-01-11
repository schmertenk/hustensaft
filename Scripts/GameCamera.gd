extends Camera2D
#Godot uses pixels, so this is a percentage 4 = 4%
export var PaddingPercent = 50
export (float) var min_zoom = 2
export (float) var max_zoom = 4.5
onready var game = get_node("/root/Game")

func _ready():
	smoothing_speed = 5

func CalculateBox(InScreenSize):
	#infinity for the min max formulas to work
	var MinX = INF
	var MaxX = -INF
	var MinY = INF
	var MaxY = -INF
	#The way this works is it keeps the data from the nodes with the lowest -x,-y and highest x,y
	for eachChild in game.get_node("Players").get_children():
		#Will only work with 2D, 3D needs transform.origin
		var pos = eachChild.position

		MinX = min(MinX,pos.x) # if pos.x is less than infinty keep it
		MaxX = max(MaxX,pos.x) # if pos.x is more than negative infinty keep it

		MinY = min(MinY,pos.y) # the next pass it compares the old kept value with the new
		MaxY = max(MaxY,pos.y) # keeping the most relavent number for that corner

	#Because Godot uses pixels we have to correct it
	var CorrectPixel =(InScreenSize /100) * PaddingPercent

	#Godot doesn't have a MinMaxRect but we can use a list
	var FourPointList = [
	MinX - CorrectPixel.y , 
	MaxX + CorrectPixel.y , 
	MinY - CorrectPixel.y , 
	MaxY + CorrectPixel.y ]
	#This will return a Rect2
	return Rect2From4PointList(FourPointList)


#Special function for making a rect2 from the list
func Rect2From4PointList(InList):
	#Formula AX+BX/2 AY+BY/2 
	var Center = Vector2( ((InList[0] + InList[1]) /2), ((InList[3] + InList[2]) /2) )
	#Formula BX-AX BY-AY 
	var Size = Vector2( (InList[1] -InList[0]), (InList[3] - InList[2]) )
	return Rect2(Center,Size)


func _process(delta):
	#You must have a camera 2D for this to work
	var ScreenSize = self.get_viewport().size

	#This function will have to update every frame
	var CustomRect2 = CalculateBox(ScreenSize)

	var z = max(CustomRect2.size.x/ ScreenSize.x ,\
	 CustomRect2.size.y/ ScreenSize.y)

	position = CustomRect2.position
	#ZoomRatio is a scalar so we need to turn it into a vector
	z = clamp(z, min_zoom, max_zoom)
	zoom = zoom.linear_interpolate( (Vector2(z,z)), 0.05)

	
func get_size_covered_by_camera():
	return get_viewport().size * zoom
	
	
	
