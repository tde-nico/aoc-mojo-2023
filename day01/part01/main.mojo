from python import Python

fn to_vec(line: String) -> DynamicVector[UInt32]:
	let length = len(line)
	var res = DynamicVector[UInt32](length)
	for i in range(length):
		res.push_back(line._buffer[i].to_int())
	return res

fn eval_line(line: DynamicVector[UInt32]) -> UInt32:
	let length = len(line)
	var left: UInt32
	var right: UInt32

	left = 0
	for i in range(length):
		if line[i] >= 0x30 and line[i] <= 0x39:
			left = line[i] - 0x30
			break
	
	right = 0
	for j in range(length-1, -1, -1):
		if line[j] >= 0x30 and line[j] <= 0x39:
			right = line[j] - 0x30
			break

	return left * 10 + right


fn main() raises:
	let py = Python.import_module('builtins')
	let line: String
	var final: UInt32 = 0

	while True:
		try:
			line = py.input().to_string()
			final += eval_line(to_vec(line))
		except:
			break
	
	print(final)
