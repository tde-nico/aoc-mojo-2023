from python import Python


fn part1(inp: String) raises -> Int:
	let lines = inp.split("\n")

	var times = DynamicVector[Int]()
	var distances = DynamicVector[Int]()

	let timeStrs = lines[0].split(":")[1].split(" ")
	for i in range(0, len(timeStrs)):
		if len(timeStrs[i]) > 0:
			times.append(atol(timeStrs[i]))

	let distStrs = lines[1].split(":")[1].split(" ")
	for i in range(0, len(distStrs)):
		if len(distStrs[i]) > 0:
			distances.append(atol(distStrs[i]))

	var out = 1
	for i in range(0, len(times)):
		var cnt = 0
		let t = times[i]
		let d = distances[i]

		for j in range(0, t + 1):
			if (t - j) * j > d:
				cnt += 1

		out *= cnt

	return out


fn main() raises:
	let py = Python()
	let sys = py.import_module("sys")

	let inp = sys.stdin.read().__str__()

	print(part1(inp))
