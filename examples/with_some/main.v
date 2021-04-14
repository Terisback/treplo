module main

import time
import terisback.treplo

fn main() {
	mut log := treplo.new()
	log.set_formatter(&treplo.TextFormatter{
		disable_sorting: true
		disable_level_truncation: false
	})

	log.with_fields(
		{key: "status", val: 404},
		{key: "text", val: "Something went bad"}
	).error("Unable to get info about smth")

	log.with_time(time.now().add_seconds(-999))
		.info("BACK IN TIME!! WHUAAAHAHAHAH")

	log.debug("this will be ignored")

	// it can be empty 
	log.info()

	log.set_level(.debug)

	log.warn("1.5 seconds of logs")

	for i in 0..15 {
		log.with_time(time.now().add_seconds(7+i*12))
			.with_field("protocol", "http")
			.with_field("service", "puppy")
			.with_field("request count", 228 + i * 12)
			.log(treplo.Level(2 + i%4))
		time.sleep(100 * time.millisecond)
	}

	log.fatal("Welp")
}