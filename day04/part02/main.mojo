from python import Python


fn part2(line: String, inout cache: InlinedFixedVector[Int]) raises -> Int:
	var py = Python()

	let headerSplit = PythonObject(line).split(":")

	let nums = headerSplit[1].split("|")
	var winningStr = nums[0].split(" ")
	var ownStr = nums[1].split("\n")[0].split(" ")

	var winningNums = DynamicVector[Int]()
	var ownNums = DynamicVector[Int]()

	for w in winningStr:
		let s = py.__str__(w)
		if len(s) > 0:
			winningNums.push_back(atol(s))

	for o in ownStr:
		let s = py.__str__(o)
		if len(s) > 0:
			ownNums.push_back(atol(s))

	let id = atol(py.__str__(headerSplit[0].split(" ")[-1]))
	cache[id] += 1

	var cnt = 1
	for i in range(0, len(ownNums)):
		for j in range(0, len(winningNums)):
			if ownNums[i] == winningNums[j] and id + cnt < len(cache):
				cache[id + cnt] += cache[id]
				cnt += 1

	return cache[id]


fn main() raises:
	var py = Python()
	let sys = py.import_module("sys")

	var lines = PythonObject([])

	var cnt = 0
	for line in sys.stdin:
		_ = lines.append(line)
		cnt += 1

	var part2Sum = 0

	var cache = InlinedFixedVector[Int](cnt + 1)
	for i in range(0, cnt + 1):
		cache.append(0)

	for line in lines:
		part2Sum += part2(py.__str__(line), cache)

	print(part2Sum)
