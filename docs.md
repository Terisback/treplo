# treplo

## Contents
- [Constants](#Constants)
- [new](#new)
- [new_entry](#new_entry)
- [Formatter](#Formatter)
- [Entry](#Entry)
  - [bytes](#bytes)
  - [str](#str)
  - [with_field](#with_field)
  - [with_fields](#with_fields)
  - [with_fields_map](#with_fields_map)
  - [with_time](#with_time)
  - [log](#log)
  - [debug](#debug)
  - [print](#print)
  - [info](#info)
  - [warn](#warn)
  - [warning](#warning)
  - [error](#error)
  - [fatal](#fatal)
  - [panic](#panic)
  - [logln](#logln)
  - [debugln](#debugln)
  - [println](#println)
  - [infoln](#infoln)
  - [warnln](#warnln)
  - [warningln](#warningln)
  - [errorln](#errorln)
  - [fatalln](#fatalln)
  - [panicln](#panicln)
- [LevelHooks](#LevelHooks)
  - [add](#add)
  - [fire](#fire)
- [Logger](#Logger)
  - [with_field](#with_field)
  - [with_fields](#with_fields)
  - [with_fields_map](#with_fields_map)
  - [with_time](#with_time)
  - [log](#log)
  - [debug](#debug)
  - [info](#info)
  - [print](#print)
  - [warn](#warn)
  - [warning](#warning)
  - [error](#error)
  - [fatal](#fatal)
  - [panic](#panic)
  - [logln](#logln)
  - [debugln](#debugln)
  - [infoln](#infoln)
  - [println](#println)
  - [warnln](#warnln)
  - [warningln](#warningln)
  - [errorln](#errorln)
  - [fatalln](#fatalln)
  - [panicln](#panicln)
  - [set_level](#set_level)
  - [get_level](#get_level)
  - [is_level_enabled](#is_level_enabled)
  - [set_formatter](#set_formatter)
  - [set_output](#set_output)
  - [set_exit_func](#set_exit_func)
  - [add_hook](#add_hook)
  - [replace_hooks](#replace_hooks)
- [Level](#Level)
- [Field](#Field)
- [JSONFormatter](#JSONFormatter)
  - [format](#format)
- [TextFormatter](#TextFormatter)
  - [format](#format)

## Constants
```v
const (
	field_key_msg          = 'msg'
	field_key_level        = 'level'
	field_key_time         = 'time'
	field_key_treplo_error = 'treplo_error'
	field_key_func         = 'func'
	field_key_file         = 'file'
)
```
 Default key names for the default fields 

[[Return to contents]](#Contents)

```v
const (
	all_levels = [Level.panic, .fatal, .error, .warn, .info, .debug]
	err_levels = [Level.panic, .fatal, .error]
)
```
 For hooks 'levels()' 

[[Return to contents]](#Contents)

## new
```v
fn new() Logger
```


[[Return to contents]](#Contents)

## new_entry
```v
fn new_entry(mut logger Logger) Entry
```


[[Return to contents]](#Contents)

## Formatter
```v
interface Formatter {
	format(Entry) ?[]byte
}
```
 Formatter interface is used to implement a custom Formatter.  The Formatter interface is used to implement a custom Formatter. It takes an  `Entry`. It exposes all the fields, including the default ones:   * `entry.data["msg"]`. The message passed from info, warn, error ..  * `entry.data["time"]`. The timestamp.  * `entry.data["level"]. The level the entry was logged at.   Any additional fields added with `with_field` or `with_fields` are also in  `entry.data`. Format is expected to return an array of bytes which are then  logged to `logger.out`. 

[[Return to contents]](#Contents)

## Entry
## bytes
```v
fn (entry Entry) bytes() ?[]byte
```
 Returns the bytes representation of this entry from the formatter 

[[Return to contents]](#Contents)

## str
```v
fn (entry Entry) str() string
```
 Returns the string representation from the reader and ultimately the  formatter. 

[[Return to contents]](#Contents)

## with_field
```v
fn (entry Entry) with_field(key string, value json.Any) Entry
```
 Add a single field (json.Any) to the Entry 

[[Return to contents]](#Contents)

## with_fields
```v
fn (entry Entry) with_fields(fields ...Field) Entry
```
 Add a array of fields to the Entry 

[[Return to contents]](#Contents)

## with_fields_map
```v
fn (entry Entry) with_fields_map(fields map[string]json.Any) Entry
```
 Add a map of fields (json.Any) to the Entry 

[[Return to contents]](#Contents)

## with_time
```v
fn (entry Entry) with_time(t time.Time) Entry
```
 Overrides the time of the Entry 

[[Return to contents]](#Contents)

## log
```v
fn (mut entry Entry) log(level Level, args ...string)
```


[[Return to contents]](#Contents)

## debug
```v
fn (mut entry Entry) debug(args ...string)
```


[[Return to contents]](#Contents)

## print
```v
fn (mut entry Entry) print(args ...string)
```


[[Return to contents]](#Contents)

## info
```v
fn (mut entry Entry) info(args ...string)
```


[[Return to contents]](#Contents)

## warn
```v
fn (mut entry Entry) warn(args ...string)
```


[[Return to contents]](#Contents)

## warning
```v
fn (mut entry Entry) warning(args ...string)
```


[[Return to contents]](#Contents)

## error
```v
fn (mut entry Entry) error(args ...string)
```


[[Return to contents]](#Contents)

## fatal
```v
fn (mut entry Entry) fatal(args ...string)
```


[[Return to contents]](#Contents)

## panic
```v
fn (mut entry Entry) panic(args ...string)
```


[[Return to contents]](#Contents)

## logln
```v
fn (mut entry Entry) logln(level Level, args ...string)
```


[[Return to contents]](#Contents)

## debugln
```v
fn (mut entry Entry) debugln(args ...string)
```


[[Return to contents]](#Contents)

## println
```v
fn (mut entry Entry) println(args ...string)
```


[[Return to contents]](#Contents)

## infoln
```v
fn (mut entry Entry) infoln(args ...string)
```


[[Return to contents]](#Contents)

## warnln
```v
fn (mut entry Entry) warnln(args ...string)
```


[[Return to contents]](#Contents)

## warningln
```v
fn (mut entry Entry) warningln(args ...string)
```


[[Return to contents]](#Contents)

## errorln
```v
fn (mut entry Entry) errorln(args ...string)
```


[[Return to contents]](#Contents)

## fatalln
```v
fn (mut entry Entry) fatalln(args ...string)
```


[[Return to contents]](#Contents)

## panicln
```v
fn (mut entry Entry) panicln(args ...string)
```


[[Return to contents]](#Contents)

## LevelHooks
## add
```v
fn (mut hooks LevelHooks) add(hook Hook)
```
 Add a hook to an instance of logger. This is called with  `log.hooks.Add(new(MyHook))` where `MyHook` implements the `Hook` interface. 

[[Return to contents]](#Contents)

## fire
```v
fn (mut hooks LevelHooks) fire(level Level, entry Entry) ?
```
 Fire all the hooks for the passed level. Used by `entry.log` to fire  appropriate hooks for a log entry. 

[[Return to contents]](#Contents)

## Logger
## with_field
```v
fn (mut l Logger) with_field(key string, value json.Any) Entry
```
 Create Entry with field 

[[Return to contents]](#Contents)

## with_fields
```v
fn (mut l Logger) with_fields(fields ...Field) Entry
```
 Create Entry with fields 

[[Return to contents]](#Contents)

## with_fields_map
```v
fn (mut l Logger) with_fields_map(fields map[string]json.Any) Entry
```
 Create Entry with data map 

[[Return to contents]](#Contents)

## with_time
```v
fn (mut l Logger) with_time(t time.Time) Entry
```
 Create Entry with time 

[[Return to contents]](#Contents)

## log
```v
fn (mut l Logger) log(level Level, args ...string)
```


[[Return to contents]](#Contents)

## debug
```v
fn (mut l Logger) debug(args ...string)
```


[[Return to contents]](#Contents)

## info
```v
fn (mut l Logger) info(args ...string)
```


[[Return to contents]](#Contents)

## print
```v
fn (mut l Logger) print(args ...string)
```


[[Return to contents]](#Contents)

## warn
```v
fn (mut l Logger) warn(args ...string)
```


[[Return to contents]](#Contents)

## warning
```v
fn (mut l Logger) warning(args ...string)
```


[[Return to contents]](#Contents)

## error
```v
fn (mut l Logger) error(args ...string)
```


[[Return to contents]](#Contents)

## fatal
```v
fn (mut l Logger) fatal(args ...string)
```


[[Return to contents]](#Contents)

## panic
```v
fn (mut l Logger) panic(args ...string)
```


[[Return to contents]](#Contents)

## logln
```v
fn (mut l Logger) logln(level Level, args ...string)
```


[[Return to contents]](#Contents)

## debugln
```v
fn (mut l Logger) debugln(args ...string)
```


[[Return to contents]](#Contents)

## infoln
```v
fn (mut l Logger) infoln(args ...string)
```


[[Return to contents]](#Contents)

## println
```v
fn (mut l Logger) println(args ...string)
```


[[Return to contents]](#Contents)

## warnln
```v
fn (mut l Logger) warnln(args ...string)
```


[[Return to contents]](#Contents)

## warningln
```v
fn (mut l Logger) warningln(args ...string)
```


[[Return to contents]](#Contents)

## errorln
```v
fn (mut l Logger) errorln(args ...string)
```


[[Return to contents]](#Contents)

## fatalln
```v
fn (mut l Logger) fatalln(args ...string)
```


[[Return to contents]](#Contents)

## panicln
```v
fn (mut l Logger) panicln(args ...string)
```


[[Return to contents]](#Contents)

## set_level
```v
fn (mut l Logger) set_level(level Level)
```
 Sets the logger level 

[[Return to contents]](#Contents)

## get_level
```v
fn (l Logger) get_level() Level
```
 Returns the logger level 

[[Return to contents]](#Contents)

## is_level_enabled
```v
fn (l Logger) is_level_enabled(level Level) bool
```
 Checks if the log level of the logger is greater than the level param 

[[Return to contents]](#Contents)

## set_formatter
```v
fn (mut l Logger) set_formatter(formatter Formatter)
```
 Sets the logger formatter 

[[Return to contents]](#Contents)

## set_output
```v
fn (mut l Logger) set_output(output io.Writer)
```
 Sets the logger output 

[[Return to contents]](#Contents)

## set_exit_func
```v
fn (mut l Logger) set_exit_func(func ExitFunc)
```
 Sets the logger exit function 

[[Return to contents]](#Contents)

## add_hook
```v
fn (mut l Logger) add_hook(hook Hook)
```
 Adds a hook to the logger hooks 

[[Return to contents]](#Contents)

## replace_hooks
```v
fn (mut l Logger) replace_hooks(hooks LevelHooks) LevelHooks
```
 Replaces the logger hooks and returns the old ones 

[[Return to contents]](#Contents)

## Level
```v
enum Level {
	panic = 0
	fatal
	error
	warn
	info
	debug
}
```
 Logging levels 

[[Return to contents]](#Contents)

## Field
```v
struct Field {
	key string
	val json.Any
}
```
 Field type, used in `with_fields` 

[[Return to contents]](#Contents)

## JSONFormatter
```v
struct JSONFormatter {
pub:
	disable_timestamp bool

	data_key string

	field_map FieldMap
}
```
 JSONFormatter formats logs into parsable json 

[[Return to contents]](#Contents)

## format
```v
fn (f JSONFormatter) format(entry Entry) ?[]byte
```
 Renders a single log entry 

[[Return to contents]](#Contents)

## TextFormatter
```v
struct TextFormatter {
pub:
	disable_colors bool

	force_quote bool

	disable_quote bool

	environment_override_colors bool

	disable_timestamp bool

	full_timestamp bool

	disable_sorting bool

	sorting_func SortingFunc = default_sort

	disable_level_truncation bool = true

	pad_level_text bool

	quote_empty_fields bool

	field_map FieldMap

	level_text_max_length int = 4
}
```


[[Return to contents]](#Contents)

## format
```v
fn (mut f TextFormatter) format(entry Entry) ?[]byte
```


[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 15 Apr 2021 04:12:34
