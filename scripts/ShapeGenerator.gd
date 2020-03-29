tool
extends Resource

class_name ShapeGenerator

var planet
var terrainMinMax = MinMax.new()   # Stores minimum and maximum elevation values.
export(Array) var noiseGenerators: Array


func init(var _planet):
	self.planet = _planet
	for ng in noiseGenerators:
		ng.init(planet)

func getUnscaledElevation(var pointOnUnitSphere: Vector3) -> float:
	var elevation: float
	var firstLayerValue: float
	if noiseGenerators.size() > 0:
		firstLayerValue = noiseGenerators[0].evaluate(pointOnUnitSphere)
		if noiseGenerators[0].enabled:
			elevation = firstLayerValue;
	
	for i in range(1, noiseGenerators.size()):
		if noiseGenerators[i].enabled:
			var mask: float = firstLayerValue if noiseGenerators[i].useFirstAsMask else 1.0
			elevation += noiseGenerators[i].evaluate(pointOnUnitSphere) * mask
	terrainMinMax.addValue(elevation)
	return elevation

func getScaledElevation(var elevation: float) -> Vector3:
	return planet.settings.radius * (1+elevation)