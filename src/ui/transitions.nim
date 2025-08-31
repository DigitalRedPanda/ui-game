import math

func easeIn*(x: float): float {.inline.} = 1 - cos((x * PI) / 2)

func easeInOut*(x: float): float {.inline.} = -(cos(PI * x) - 1) / 2
