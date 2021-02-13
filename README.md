# treplo
<p align="center">
Logging library written in V. <br>
<a href="https://gist.github.com/Terisback/8301440412c747ae2fa260891727397e">
  <img src="https://img.shields.io/badge/docs-2F3136?style=flat&logo=v">
</a>
</p>

## Example

```v
import terisback.treplo

mut log := treplo.new()
log.println("Hello world!")
```

Outputs: `INFO[0000] Hello world!`
> Number represents seconds since program start