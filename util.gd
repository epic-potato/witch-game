class_name Util

static func is_close(a: float, b: float, similarity: float = 0.1):
	return absf(a - b) < similarity
