module treplo

import math
import time
import x.json2 as json

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
	return "${level} ${message}\n".bytes()
}

// Like SimpleFormatter but changes all l to w and adds OwO at end of line
struct OwOFormatter {}

fn (f OwOFormatter) format(entry Entry) ?[]byte{
	level := entry.level.str().to_upper()
	mut message := entry.message.trim_suffix("\n")
	message = message.replace("l", "w")
	return "${level} ${message} OwO\n".bytes()
}

fn test_get_set_level() {
	mut llog := new()

	mut out := TestOut{}
	llog.set_output(out)
	
	mut formatter := SimpleFormatter{}
	llog.set_formatter(formatter)

	// Default level should be .info
	assert llog.get_level() == .info

	llog.set_level(.debug)
	assert llog.get_level() == .debug

	// It should print any message at that level
	assert llog.is_level_enabled(.debug)
	assert llog.is_level_enabled(.info)
	assert llog.is_level_enabled(.error)

	llog.set_level(.error)
	assert llog.get_level() == .error

	// It should print only error and below
	assert !llog.is_level_enabled(.warn)
	assert llog.is_level_enabled(.error)
	assert llog.is_level_enabled(.fatal)
}

fn test_set_formatter() {
	mut llog := new() 

	mut out := TestOut{}
	llog.set_output(out)

	mut formatter := SimpleFormatter{}
	llog.set_formatter(formatter)

	llog.println("Hello world!")
	assert out.str()	
		== "INFO Hello world!"
	out.clear()

	mut owomatter := OwOFormatter{}
	llog.set_formatter(owomatter)

	llog.println("Hello world!")
	assert out.str()
		== "INFO Hewwo worwd! OwO"
	out.clear()
}

fn test_set_output() {
	mut llog := new()

	mut formatter := SimpleFormatter{}
	llog.set_formatter(formatter)

	mut to1 := TestOut{}
	llog.set_output(to1)

	llog.println("Foo")
	llog.println("Bar")
	assert to1.str()
		== "INFO Foo\nINFO Bar"
	to1.clear()

	mut to2 := TestOut{}
	llog.set_output(to2)
	llog.println("Bar")
	llog.println("Foo")
	assert to2.str()
		== "INFO Bar\nINFO Foo"
	to2.clear()
}

fn test_simple_log() {
	mut t := time.now()
	mut llog := new() 

	mut out := TestOut{}
	llog.set_output(out)

	llog.with_time(t).println("Hello world!")
	assert out.str()
		== "\e[94mINFO\e[39m[${stime(t)}] Hello world!"
	out.clear()
}

fn test_debug() {
	mut llog := new() 
	llog.set_level(.debug)

	mut out := TestOut{}
	llog.set_output(out)

	mut formatter := SimpleFormatter{}
	llog.set_formatter(formatter)

	llog.debug("Hello world!")
	assert out.str()	
		== "DEBUG Hello world!"
	out.clear()
}

fn test_info() {
	mut llog := new() 

	mut out := TestOut{}
	llog.set_output(out)

	mut formatter := SimpleFormatter{}
	llog.set_formatter(formatter)

	llog.info("Hello world!")
	assert out.str()	
		== "INFO Hello world!"
	out.clear()
}

fn test_print() {
	mut llog := new() 

	mut out := TestOut{}
	llog.set_output(out)

	mut formatter := SimpleFormatter{}
	llog.set_formatter(formatter)

	llog.print("Hello world!")
	assert out.str()	
		== "INFO Hello world!"
	out.clear()
}

fn test_warn() {
	mut llog := new() 

	mut out := TestOut{}
	llog.set_output(out)

	mut formatter := SimpleFormatter{}
	llog.set_formatter(formatter)

	llog.warn("Hello world!")
	assert out.str()	
		== "WARN Hello world!"
	out.clear()
}

fn test_warning() {
	mut llog := new() 

	mut out := TestOut{}
	llog.set_output(out)

	mut formatter := SimpleFormatter{}
	llog.set_formatter(formatter)

	llog.warning("Hello world!")
	assert out.str()	
		== "WARN Hello world!"
	out.clear()
}

fn test_error() {
	mut llog := new() 

	mut out := TestOut{}
	llog.set_output(out)

	mut formatter := SimpleFormatter{}
	llog.set_formatter(formatter)

	llog.error("Hello world!")
	assert out.str()	
		== "ERROR Hello world!"
	out.clear()
}

fn test_fatal() {
	mut llog := new() 

	mut out := TestOut{}
	llog.set_output(out)

	mut formatter := SimpleFormatter{}
	llog.set_formatter(formatter)

	llog.set_exit_func(fn(code int){
		//eprintln("Successful fatal exit with code: ${code}")
		assert true
	})

	llog.fatal("Hello world!")
	assert out.str()	
		== "FATAL Hello world!"
	out.clear()
}

// There is no `restore` like in Go, so panic will be tested by hands
// fn test_panic() {
// 	mut llog := new() 

// 	mut out := TestOut{}
// 	llog.set_output(out)

// 	mut formatter := SimpleFormatter{}
// 	llog.set_formatter(formatter)

// 	llog.panic("Hello world!")
// 	assert out.str()	
// 		== "PANIC Hello world!"
// 	out.clear()
// }

fn test_with_field() {
	mut t := time.now()
	mut llog := new() 

	mut out := TestOut{}
	llog.set_output(out)

	// We'll use TextFormatter here
	mut formatter := TextFormatter{
		disable_colors: true
	}
	llog.set_formatter(formatter)

	// string value test
	llog.with_time(t).with_field("me", "fork").println("Give")
	assert out.str()	
		== "INFO[${stime(t)}] Give me=fork"
	out.clear()
	
	// f64 and bool test
	llog
		.with_time(t)
		.with_field("balance", 1337.228)
		.with_field("millionaire", false)
		.println("Bank account:")
	assert out.str()	
		== "INFO[${stime(t)}] Bank account: balance=1337.228 millionaire=false"
	out.clear()

	// i64 test
	llog
		.with_time(t)
		.with_field("Elon Musk's salary", math.max_i64)
		.println()
	assert out.str()	
		== "INFO[${stime(t)}] Elon Musk's salary=9223372036854775807"
	out.clear()

	// Map test
	// Looks bad, I know, smartcast will be fixed for this
	llog
		.with_time(t)
		.with_field("tile", map{
			"id": json.Any("air")
			"x": json.Any(23)
			"y": json.Any(142)
			"solid": json.Any(false)
		})
		.println()
	assert out.str()	
		== "INFO[${stime(t)}] tile=\"{\"id\":\"air\",\"x\":23,\"y\":142,\"solid\":false}\""
	out.clear()
}

fn test_with_fields() {
	mut t := time.now()
	mut llog := new() 

	mut out := TestOut{}
	llog.set_output(out)

	// We'll use TextFormatter here
	mut formatter := TextFormatter{
		disable_colors: true
	}
	llog.set_formatter(formatter)

	// Map test
	// Looks bad, I know, smartcast will be fixed for this
	llog
		.with_time(t)
		.with_fields_map(map{
			"id": json.Any("air")
			"x": json.Any(23)
			"y": json.Any(142)
			"solid": json.Any(false)
		})
		.println()
	assert out.str()	
		== "INFO[${stime(t)}] id=air solid=false x=23 y=142"
	out.clear()

	// Fields array
	llog
		.with_time(t)
		.with_fields(
			{key: "id", val: "air"},
			{key: "x", val: 23.str()},
			{key: "y", val: 142.str()},
			{key: "solid", val: false.str()}
		)
		.println()
	assert out.str()	
		== "INFO[${stime(t)}] id=air solid=false x=23 y=142"
	out.clear()
}

fn test_with_time() {
	mut t := time.now()
	mut llog := new() 

	mut out := TestOut{}
	llog.set_output(out)

	// We'll use TextFormatter here
	mut formatter := TextFormatter{
		disable_colors: true
	}
	llog.set_formatter(formatter)

	llog
		.with_time(t)
		.println("Test")
	assert out.str()	
		== "INFO[${stime(t)}] Test"
	out.clear()

	t = t.add_seconds(10)

	llog
		.with_time(t)
		.println("Test")
	assert out.str()	
		== "INFO[${stime(t)}] Test"
	out.clear()

	t = t.add_seconds(9 * 999)

	llog
		.with_time(t)
		.println("Test")
	assert out.str()	
		== "INFO[${stime(t)}] Test"
	out.clear()
}

// Utility func that returns seconds in format that TextFormatter uses
fn stime(t time.Time) string{
	return "${(t - base_timestamp)/time.second:04}"
}