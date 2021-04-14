module main

import time
import rand
import x.json2 as json
import terisback.treplo

const (
	useless_array = [
		"Ara ara", 
		"OwO", 
		"Dungeon Master", 
		"Three hundred bucks", 
		"I warn you",
		"Be gentle", 
		"Oof",
		]
)

fn some_map() map[string]json.Any {
	mut data := map[string]json.Any{}
	for _ in 0..28 {
		data[useless_array[rand.intn(useless_array.len)]] = useless_array[rand.intn(useless_array.len)]
	}
	return data
}

fn main () {
	mut log := treplo.new()
	log.set_formatter(&treplo.JSONFormatter{})
	
	// Right now there is no way to pretty print so, it is what it is (～￣▽￣)～
	for _ in 0..rand.intn(3) + 2 {
		log.with_fields_map(some_map()).info("Whoa") 
		time.sleep(100 * time.millisecond)
	}
}