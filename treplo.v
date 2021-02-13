module treplo

// Logging levels
pub enum Level {
	panic = 0
	fatal
	error
	warn
	info
	debug
}

// Formatter interface is used to implement a custom Formatter.
pub interface Formatter {
	format(entry Entry) ?[]byte
}

// Type for key sorting function from TextFormatter
type SortingFunc = fn(mut keys []string)

// Type for exit function
type ExitFunc = fn(int)

// Default out implementation
struct StdOut {}

fn (out StdOut) write(data []byte) ?int {
	println(data.bytestr())
	return data.len
}