module main

import strings
import term
import time
import terisback.treplo

const (
	base_timestamp = time.now()
)

struct SkepticalFormatter {
	be_more_sceptical bool
}

fn (f SkepticalFormatter) format(entry treplo.Entry) ?[]byte {
	mut b := strings.new_builder(256)
	if "author" in entry.data {
		b.write_string(entry.data["author"].str())
	} else {
		b.write_string("Someone")
	}
	b.write_string(" says ")
	message := "\"${entry.message.trim_space().trim_suffix("\n")}\""
	b.write_string(term.dim(message))
	if f.be_more_sceptical && int(entry.level) < int(treplo.Level.info) {
		b.write_string(" but I don't believe him")
		b.write_string(" because I at ")	
		b.write_string("${term.bg_red(term.white(entry.level.str()))}")
		b.write_string(" level rn")
	} else {
		b.write_string(" like ")
		b.write_string("${(time.now() - base_timestamp)/time.second}")
		b.write_string(" seconds ago")
	}
	b.write_b(`.`)
	b.write_b(`\n`)
	return b.str().bytes()
}

fn main() {
	mut log := treplo.new()
	log.set_formatter(&SkepticalFormatter{})

	log
		.with_field("author", "Terisback")
		.info("I've made cool logging lib Treplo!")

	log.set_formatter(&SkepticalFormatter{
		be_more_sceptical: true
	})
	
	log
		.with_field("author", "Big dude")
		.info("We in deep dark fantasy rn")

	log
		.with_field("author", "smol dude")
		.error("Everything will be fine")
}