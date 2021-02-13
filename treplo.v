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

// Type for exit function
type ExitFunc = fn(int)

// Default out implementation
struct StdErrOut {}

fn (out StdErrOut) write(data []byte) ?int {
	eprintln(data.bytestr())
	return data.len
}