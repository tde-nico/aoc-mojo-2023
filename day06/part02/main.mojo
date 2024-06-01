from python import Python


fn part2(inp: String) raises -> Int:
	let lines = inp.split("\n")

	var filteredTimeStr = String()
	var filteredDistanceStr = String()

	let timeStrs = lines[0].split(":")[1].split(" ")
	for i in range(0, len(timeStrs)):
		if len(timeStrs[i]) > 0:
			filteredTimeStr += timeStrs[i]

	let distStrs = lines[1].split(":")[1].split(" ")
	for i in range(0, len(distStrs)):
		if len(distStrs[i]) > 0:
			filteredDistanceStr += distStrs[i]

	var out = 0
	let t = atol(filteredTimeStr)
	let d = atol(filteredDistanceStr)

	for j in range(0, t + 1):
		if (t - j) * j > d:
			out += 1

	return out


fn main() raises:
	let py = Python()
	let sys = py.import_module("sys")

	let inp = sys.stdin.read().__str__()

	print(part2(inp))
