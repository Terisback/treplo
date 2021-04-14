# 📝 treplo
<p align="center">
Mostly port of 
  <a href="https://github.com/sirupsen/logrus">logrus</a>
logger to V. <br>
<a href="https://github.com/Terisback/treplo/blob/master/docs.md">
  <img src="https://img.shields.io/badge/docs-2F3136?style=flat&logo=v">
</a>
</p>

### Install via git

```bash
git clone https://github.com/Terisback/treplo.git ~/.vmodules/terisback/treplo
```

## ✨ Example

```v
import terisback.treplo

mut log := treplo.new()
log.with_field("animal","walrus")
   .info("A walrus appears")
```
![INFO[0000] A walrus appears animal=walrus](https://user-images.githubusercontent.com/26527529/114792802-73eb5f00-9da2-11eb-8749-3165fb764fad.gif)

## 🎣 Hooks

```v
import terisback.treplo

mut log := treplo.new()
log.add_hook(MyHook{})
log.info("Some")
```
![treplo_hooks](https://user-images.githubusercontent.com/26527529/114793006-e3f9e500-9da2-11eb-8847-9db54fba6ab0.gif)

## 📰 Custom formatters

```v
import terisback.treplo

mut log := treplo.new()
log.set_formatter(&MyFormatter{})
log.with_field("author", "Dungeon Master")
   .info("Deep Dark Fantasy")
```
![treplo_dungeon_master](https://user-images.githubusercontent.com/26527529/114793128-20c5dc00-9da3-11eb-9775-bd3e827ad8d2.gif)

### 📚 [Documentation](https://github.com/Terisback/treplo/blob/master/docs.md)

### [Examples](https://github.com/Terisback/treplo/tree/master/examples)

Feel free to contribute ;)  
You can contact me at discord: TERISBACK#9125