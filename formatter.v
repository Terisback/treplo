module treplo 
pub interface Formatter {
	format(Entry) ?[]byte
}
