from python import Python
from math import min, max


fn part1(inp: String) raises -> Int:
	var lines = inp.split("\n")
	lines.append("placeholder")

	let seedsStr = lines[0].split(": ")[1].split(" ")

	var seeds = DynamicVector[Int]()
	for i in range(0, seedsStr.size):
		seeds.append(atol(seedsStr[i]))

	var map = DynamicVector[Int]()
	for i in range(3, lines.size):
		if len(lines[i]) == 0:
			continue

		let splitStr = lines[i].split(" ")
		if splitStr.size != 3:

			var newSeeds = DynamicVector[Int]()
			for j in range(0, seeds.size):
				for k in range(0, map.size, 3):
					let dst = map[k]
					let src = map[k + 1]
					let l = map[k + 2]

					if seeds[j] >= src and seeds[j] < src + l:
						newSeeds.append(dst + seeds[j] - src)
						break
				else:
					newSeeds.append(seeds[j])
			seeds = newSeeds
			map.clear()
			continue

		map.append(atol(splitStr[0]))
		map.append(atol(splitStr[1]))
		map.append(atol(splitStr[2]))

	var m: Int = seeds[0]
	for i in range(1, seeds.size):
		m = min(m, seeds[i])

	return m


fn main() raises:
	let py = Python()
	let sys = py.import_module("sys")

	let inp = sys.stdin.read().__str__()

	print(part1(inp))
