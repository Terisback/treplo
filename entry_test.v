module treplo

// Output for tests
struct TestOut {
mut:
	output string
}

fn (mut to TestOut) write(data []byte) ?int {
	to.output += data.bytestr()
	return data.len
}

fn (mut to TestOut) clear() {
	to.output = ""
}

fn (mut to TestOut) str() string {
	return to.output.trim_space()
}

// Test formatter, outputs "$level $message" with newline byte at end
struct SimpleFormatter {}

fn (f SimpleFormatter) format(entry Entry) ?[]byte{
	level := entry.level.str().to_upper()
	message := entry.message.trim_suffix("\n")
	return "${level} ${message}".bytes()
}

fn test_entry() {
	mut llog := new()

	mut out := TestOut{}
	llog.set_output(out)
	
	mut formatter := SimpleFormatter{}
	llog.set_formatter(formatter)

	mut en := new_entry(mut llog)
	assert en.level == .info
	en.message = "test"
	result := en.bytes() or {
		assert false
		return
	}
	assert result.bytestr() == "INFO test"
	out.clear()

	en.println("Pretty tested already")
	assert en.str() 
		== "INFO Pretty tested already" // ghost newline byte
	out.clear()

	en.print("Pretty tested already")
	assert en.str() 
		== "INFO Pretty tested already"
	out.clear()
}