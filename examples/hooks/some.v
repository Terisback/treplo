module main

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
		"verystrongpassword",
		"1230"
		]
)

fn random_level() treplo.Level {
	return treplo.Level(int(treplo.Level.error) + rand.intn(3))
}

fn some_map() map[string]json.Any {
	mut data := map[string]json.Any{}
	for _ in 0..2 {
		data[useless_array[rand.intn(useless_array.len)]] = useless_array[rand.intn(useless_array.len)]
	}
	return data
}