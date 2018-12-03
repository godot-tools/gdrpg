class_name MathUtil

const FLOAT_EPSILON = 0.001

const IDENTITY_VECTOR = Vector2()

static func compare(a, b, epsilon : float = FLOAT_EPSILON):
	if typeof(a) == TYPE_REAL and typeof(b) == TYPE_REAL:
		return abs(a - b) <= epsilon
	if typeof(a) == TYPE_VECTOR2 and typeof(b) == TYPE_VECTOR2:
		return abs(a.length() - b.length()) <= epsilon
	return false
	
static func logistic(l : float, x : float, k : float, x0 : float) -> float:
	return l / (1 + exp(-k * (x - x0)))