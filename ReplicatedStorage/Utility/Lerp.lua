-- Number lerp function.
return function(a, b, alpha)
	return (1 - alpha) * a + alpha * b
end