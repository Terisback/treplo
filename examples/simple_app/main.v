module main

import vweb
import terisback.treplo

const (
	port = 3000
)

struct App {
	vweb.Context
mut:
	log treplo.Logger
	count int
}

fn main() {
	vweb.run<App>(port)
}

pub fn (mut app App) init_once() {
	app.log = treplo.new()
	app.log.set_level(.debug)
	app.log.set_formatter(&treplo.TextFormatter{
		force_quote: true
		force_colors: true
	})
}

fn (mut app App) index() vweb.Result {
	app.count++
	content := "Counter: ${app.count} views"
	app.log.info(content)
	return app.text(content)
}

fn (mut app App) warn() vweb.Result {
	content := "This page warns you"
	app.log.warn(content)
	return app.text(content)
}

fn (mut app App) error() vweb.Result {
	content := "This page feels bad"
	app.log.with_field("error_code", "404").error(content)
	return app.text(content)
}

fn (mut app App) debug() vweb.Result {
	content := "Debug this!"
	app.log.with_fields(
		{key: "content_type", val: app.content_type},
		{key: "status", val: app.status}
	).debug(content)
	return app.text(content)
}