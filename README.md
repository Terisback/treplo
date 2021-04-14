# 📝 treplo
<p align="center">
Mostly port of 
  <a href="https://github.com/sirupsen/logrus">logrus</a>
logger to V. <br>
<a href="https://github.com/Terisback/treplo/blob/master/docs.md">
  <img src="https://img.shields.io/badge/docs-2F3136?style=flat&logo=v">
</a>
</p>

### Install via vpm

```bash
git clone https://github.com/Terisback/treplo.git ~/.vmodules/terisback/treplo
```

## Example

```v
import terisback.treplo

mut log := treplo.new()
log.with_field("animal","walrus")
   .info("A walrus appears")
```
![INFO[0000] A walrus appears animal=walrus](https://user-images.githubusercontent.com/26527529/114785479-35e83e00-9d96-11eb-8f6c-d7061d73d9fe.gif)

## Hooks

```v
import terisback.treplo

mut log := treplo.new()
log.add_hook(MyHook{})
log.info("Some")
```
![treplo_hooks](https://user-images.githubusercontent.com/26527529/114785870-b73fd080-9d96-11eb-854c-d64e31204e82.gif)

## Custom formatters

```v
import terisback.treplo

mut log := treplo.new()
log.set_formatter(&MyFormatter{})
log.with_field("author", "Dungeon Master")
   .info("Deep Dark Fantasy")
```
![treplo_dungeon_master](https://user-images.githubusercontent.com/26527529/114790793-cb87cb80-9d9e-11eb-8334-8244403245b8.gif)

### [Documentation](https://github.com/Terisback/treplo/blob/master/docs.md)

### [Examples](https://github.com/Terisback/treplo/tree/master/examples)

Feel free to contribute ;)  
You can contact me at discord: TERISBACK#9125