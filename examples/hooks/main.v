module main

import term
import time
import rand
import strings
import terisback.treplo

struct CounterHook {
mut:
	levels map[int]int = map[int]int{}
}

fn (hook CounterHook) levels() []treplo.Level {
	return treplo.all_levels
}

// The main thing why we have hooks
fn (mut hook CounterHook) fire(entry treplo.Entry) ? {
	hook.levels[int(entry.level)]++
	println(term.bright_yellow('Current $entry.level count = ${hook.levels[int(entry.level)]}'))
}

fn (hook CounterHook) str() string {
	mut b := strings.new_builder(64)
	b.write_b(`\n`)
	for level, count in hook.levels {
		tl := treplo.Level(level)
		l := term.bright_green('.$tl'[..5])
		c := term.bright_green('$count')
		b.write_string('Level $l called $c times\n')
	}
	return b.str()
}

fn main () {
	mut log := treplo.new()

	// For later use
	my_hook := CounterHook{}

	log.add_hook(my_hook)
	
	// JSONFormatter example
	log.set_formatter(&treplo.TextFormatter{})
	for _ in 0..rand.intn(20) + 5 {
		// It will not count .debug level because logger log level is .info
		log.with_fields_map(some_map()).log(random_level(), "Whoa") 
		time.sleep(250 * time.millisecond)
	}

	// "Later use"
	println(my_hook)
}