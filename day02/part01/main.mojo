from python import Python
from memory import memcpy
import math

alias strtype = DTypePointer[DType.int8]

struct StringVector:
	var size: Int
	var capacity: Int
	var storage: Pointer[strtype]

	fn __init__(inout self):
		self.size = 0
		self.capacity = 32
		self.storage = Pointer[strtype].alloc(self.capacity)

	fn __init__[*Ts: AnyType](inout self, owned literal: ListLiteral[Ts]):
		self.size = 0
		self.capacity = len(literal)
		self.storage = Pointer[strtype].alloc(self.capacity)
		self.extend(literal^)

	fn push_back(inout self, value: String):
		if self.size == self.capacity:
			self.grow()
		let data = strtype.alloc(len(value) + 1)
		memcpy(data, value._buffer.data, len(value) + 1)
		self.storage.store(self.size, data)
		self.size += 1

	fn grow(inout self):
		self.resize(2*self.capacity)

	fn extend[*Ts: AnyType](inout self, owned literal: ListLiteral[Ts]):
		let src = Pointer.address_of(literal).bitcast[StringLiteral]()
		for i in range(len(literal)):
			let s = String(src.load(i))
			self.push_back(s)

	fn resize(inout self, newsize: Int):
		let storage_old = self.storage
		self.storage = Pointer[strtype].alloc(newsize)
		memcpy(self.storage, storage_old, math.min(newsize, self.capacity))

		for i in range(newsize, self.capacity):
			storage_old[i].free()

		storage_old.free()
		self.size = math.min(newsize, self.capacity)
		self.capacity = newsize
		
	fn __getitem__(inout self, index: Int) -> String:
		let d: strtype = self.storage.load(index)
		return String(d)

	fn __setitem__(inout self, i: Int, value: String):
		self.storage.load(i).free()
		let data = strtype.alloc(len(value))
		memcpy(data, value._buffer.data, len(value))
		self.storage.store(i, data)

	fn __iter__(self) -> StringListIterator:
		return StringListIterator(self.storage, self.size)

	fn __moveinit__(inout self, owned previous: Self):
		self.size = previous.size
		self.capacity = previous.capacity
		self.storage = previous.storage

	fn len(inout self) -> Int:
		return self.size

	fn clear(inout self):
		self.size = 0
		self.resize(0)

	fn reverse(inout self):
		var left: Int = 0
		var right: Int = self.size - 1
		let temp: strtype
		while left <= right:
			temp = self.storage.load(left)
			self.storage.store(left, self.storage.load(right))
			self.storage.store(right, temp)
			left += 1
			right -= 1

struct StringListIterator:
	var offset: Int
	var max_idx: Int
	var storage: Pointer[strtype]

	fn __init__(inout self, storage: Pointer[strtype], max_idx: Int):
		self.offset = 0
		self.max_idx = max_idx
		self.storage = storage

	fn __len__(self) -> Int:
		return self.max_idx - self.offset

	fn __next__(inout self) -> String:
		let ret = self.storage.load(self.offset)
		self.offset += 1
		return String(ret)

# Matches python's string.split
fn split(source: String, target: String) -> StringVector:
	var ranges = DynamicVector[Tuple[Int, Int]]()

	var i = 0
	while True:
		let offs = source.find(target, i)
		if offs == -1:
			ranges.push_back((i, len(source)))
			break
		else:
			ranges.push_back((i, i+offs))
			i += len(target) + offs

	var parts = StringVector()
	for i in range(len(ranges)):
		let i1 = ranges[i].get[0, Int]()
		let i2 = ranges[i].get[1, Int]()
		parts.push_back(source[i1:i2])

	return parts^



struct Turn:
	var red: UInt32
	var green: UInt32
	var blue: UInt32

	fn __init__(inout self) -> None:
		self.red = 0
		self.green = 0
		self.blue = 0

	fn is_valid(self) -> Bool:
		return self.red <= 12 and self.green <= 13 and self.blue <= 14


struct Runner:
	fn __init__(inout self) -> None:
		pass

	fn part1(self) raises -> None:
		let py = Python.import_module('builtins')
		var valid_games = 0
		var i = 0
		try:
			while True:
				let line = py.input().to_string()
				var game = split(line, ": ")
				var flag = True

				for t in split(game[1], "; "):
					var turn: Turn = Turn()

					for c in split(t, ", "):
						var parts = split(c, " ")
						let amount = atol(parts[0])
						let color = parts[1]
						if color[0] == 'r':
							turn.red = amount
						elif color[0] == 'g':
							turn.green = amount
						elif color[0] == 'b':
							turn.blue = amount

					if not turn.is_valid():
						flag = False
						break

				if flag:
					valid_games += i + 1
				i += 1

		except:
			print(valid_games)
			return



fn main() raises:
	let r = Runner()
	r.part1()

