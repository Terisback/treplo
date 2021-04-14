module treplo 

import io

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
	message := entry.message.trim_suffix("\n")
	return "${message}".bytes()
}

struct CoolHook {
mut:
	out io.Writer
}

fn (hook CoolHook) levels() []Level {
	return [.debug, .info, .fatal, .panic]
}

fn (hook CoolHook) fire(entry Entry) ? {
	hook.out.write("Nice".bytes()) ?
}

fn test_hooks() {
	mut llog := new()

	mut out := TestOut{}
	llog.set_output(out)
	
	mut formatter := SimpleFormatter{}
	llog.set_formatter(formatter)

	mut hooks := LevelHooks{}
	hooks.add(&CoolHook{out})
	
	llog.replace_hooks(hooks)

	llog.println()

	assert out.str() == "Nice"
}