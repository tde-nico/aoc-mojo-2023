from python import Python
from math import min, max


@value
@register_passable
struct Range(CollectionElement):
	var s: Int
	var e: Int


fn part2(inp: String) raises -> Int:
	var lines = inp.split("\n")

	lines.append("placeholder")

	let seedsStr = lines[0].split(": ")[1].split(" ")

	var seeds = DynamicVector[Range]()
	for i in range(0, seedsStr.size, 2):
		let s = atol(seedsStr[i])
		let l = atol(seedsStr[i + 1])
		seeds.append(Range(s, s + l))

	var map = DynamicVector[Int]()
	for i in range(3, lines.size):
		if len(lines[i]) == 0:
			continue

		let splitStr = lines[i].split(" ")
		if splitStr.size != 3:

			var newSeeds = DynamicVector[Range]()
			while seeds.size != 0:
				let r = seeds.pop_back()

				for k in range(0, map.size, 3):
					let dst = map[k]
					let mb = map[k + 1]
					let me = mb + map[k + 2]

					let ib = max(r.s, mb)
					let ie = min(r.e, me)

					if ib >= ie:
						continue

					newSeeds.append(Range(ib + dst - mb, ie + dst - mb))
					if r.s < ib:
						seeds.append(Range(r.s, ib))
					if r.e > ie:
						seeds.append(Range(ie, r.e))

					break
				else:
					newSeeds.append(r)
			seeds = newSeeds
			map.clear()
			continue

		map.append(atol(splitStr[0]))
		map.append(atol(splitStr[1]))
		map.append(atol(splitStr[2]))

	var m = seeds[0].s
	for i in range(1, seeds.size):
		m = min(m, seeds[i].s)

	return m


fn main() raises:
	let py = Python()
	let sys = py.import_module("sys")

	let inp = sys.stdin.read().__str__()

	print(part2(inp))
