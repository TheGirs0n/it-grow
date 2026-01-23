extends Resource
class_name PlantResource

@export_multiline var plant_name : String
@export_multiline var plant_description : String
@export var plant_grow_stage_textures : Array[CompressedTexture2D]
@export var plant_smell : GlobalEnums.PLANT_SMELL
@export var plant_leaf : GlobalEnums.PLANT_LEAF
@export var plant_juice_density : GlobalEnums.PLANT_JUICE_DENSITY
@export var plant_juice_color : GlobalEnums.PLANT_JUICE_COLOR
@export var plant_care_stages : Array[GlobalEnums.PLANT_CARE_TYPE]
