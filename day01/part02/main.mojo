from python import Python
from memory import memcmp


fn to_vec(line: String) -> DynamicVector[UInt32]:
	let length = len(line)
	var res = DynamicVector[UInt32](length)
	for i in range(length):
		res.push_back(line._buffer[i].to_int())
	return res


fn eval_line(sline: String) -> UInt32:
	let line: DynamicVector[UInt32] = to_vec(sline)
	let length = len(line)
	var left: UInt32
	var right: UInt32

	var digits = DynamicVector[StringLiteral](9)
	digits.push_back("one")
	digits.push_back("two")
	digits.push_back("three")
	digits.push_back("four")
	digits.push_back("five")
	digits.push_back("six")
	digits.push_back("seven")
	digits.push_back("eight")
	digits.push_back("nine")

	left = 0
	for i in range(length):
		for k in range(len(digits)):
			let digit: String = digits[k]
			if sline[i:i+len(digit)] == digit:
				left = k + 1
				break
		if left != 0:
			break

		if line[i] >= 0x30 and line[i] <= 0x39:
			left = line[i] - 0x30
			break
	
	right = 0
	for j in range(length-1, -1, -1):
		for k in range(len(digits)):
			let digit: String = digits[k]
			if sline[j:j+len(digit)] == digit:
				right = k + 1
				break
		if right != 0:
			break

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
			final += eval_line(line)
		except:
			break
	
	print(final)
