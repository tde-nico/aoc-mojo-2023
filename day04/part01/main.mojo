from python import Python


fn part1(line: String) raises -> Int:
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

	var score = 0
	for i in range(0, len(ownNums)):
		for j in range(0, len(winningNums)):
			if ownNums[i] == winningNums[j]:
				if score == 0:
					score = 1
				else:
					score <<= 1

	return score


fn main() raises:
	var py = Python()
	let sys = py.import_module("sys")

	var lines = PythonObject([])

	var cnt = 0
	for line in sys.stdin:
		_ = lines.append(line)
		cnt += 1

	var part1Sum = 0

	for line in lines:
		part1Sum += part1(py.__str__(line))

	print(part1Sum)
