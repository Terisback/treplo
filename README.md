# treplo
<p align="center">
Mostly port of 
  <a href="https://github.com/sirupsen/logrus">logrus</a>
logger to V. <br>
<a href="https://gist.github.com/Terisback/8301440412c747ae2fa260891727397e">
  <img src="https://img.shields.io/badge/docs-2F3136?style=flat&logo=v">
</a>
</p>

## Example

```v
import terisback.treplo

mut log := treplo.new()
log.with_fields(
	{key: "animal", val: "walrus"}
).info("A walrus appears")
```
![INFO[0000] A walrus appears animal=walrus](https://user-images.githubusercontent.com/26527529/108199028-7b3d1600-712d-11eb-8710-aceca4778dfe.png)
