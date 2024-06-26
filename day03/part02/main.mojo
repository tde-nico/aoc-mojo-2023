from python import Python

@value
@register_passable
struct Number:
	var line: Int
	var begin: Int
	var end: Int
	var val: Int


@value
@register_passable
struct Symbol:
	var row: Int
	var col: Int


fn part1() raises:
	var symbols = DynamicVector[Symbol]()
	var numbers = DynamicVector[Number]()
	var li = 0
	
	let py = Python.import_module('builtins')
	try:
		while True:
			let line = py.input()
			var ci = 0
			let lineLen = len(line.to_string())
			while ci < lineLen:
				if isdigit(ord(line[ci].to_string())):
					let b = ci
					while ci < lineLen and isdigit(ord(line[ci].to_string())):
						ci += 1

					let val = atol(line.to_string()[b:ci])
					numbers.push_back(Number(li, b, ci - 1, val))
					continue

				let tok = line[ci]
				if tok != "." and tok != "\n":
					symbols.push_back(Symbol(li, ci))

				ci += 1
			li += 1
	except:
		pass

	var out = 0

	var ni = 0
	while ni < len(numbers):
		var si = 0
		while si < len(symbols):
			if (
				symbols[si].row >= numbers[ni].line - 1
				and symbols[si].row <= numbers[ni].line + 1
				and symbols[si].col >= numbers[ni].begin - 1
				and symbols[si].col <= numbers[ni].end + 1
			):
				out += numbers[ni].val

			si += 1

		ni += 1

	
	print(out)



fn part2() raises:
	var symbols = DynamicVector[Symbol]()
	var numbers = DynamicVector[Number]()

	var li = 0
	let py = Python.import_module('builtins')
	try:
		while True:
			let line = py.input()
			var ci = 0
			let lineLen = len(line.to_string())
			while ci < lineLen:
				if isdigit(ord(line[ci].to_string())):
					let b = ci
					while ci < lineLen and isdigit(ord(line[ci].to_string())):
						ci += 1

					let val = atol(line.to_string()[b:ci])
					numbers.push_back(Number(li, b, ci - 1, val))
					continue

				let tok = line[ci]
				if tok == "*" and tok != "\n":
					symbols.push_back(Symbol(li, ci))

				ci += 1
			li += 1
	except:
		pass

	var out = 0

	var si = 0
	while si < len(symbols):
		var adjNums = DynamicVector[Int]()
		var ni = 0
		while ni < len(numbers):
			if (
				symbols[si].row >= numbers[ni].line - 1
				and symbols[si].row <= numbers[ni].line + 1
				and symbols[si].col >= numbers[ni].begin - 1
				and symbols[si].col <= numbers[ni].end + 1
			):
				adjNums.push_back(numbers[ni].val)

			ni += 1

		if len(adjNums) == 2:
			out += adjNums[0] * adjNums[1]

		si += 1

	print(out)


fn main() raises:
	part2()

