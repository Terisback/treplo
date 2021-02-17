module treplo

import x.json2 as json

// Logging levels
pub enum Level {
	panic = 0
	fatal
	error
	warn
	info
	debug
}

pub struct Field {
	key string
	val json.Any
}

// Type for key sorting function from TextFormatter
type SortingFunc = fn(mut keys []string)

// Type for exit function
type ExitFunc = fn(int)

// Default out implementation
struct StdOut {}

fn (out StdOut) write(data []byte) ?int {
	print(data.bytestr())
	return data.len
}