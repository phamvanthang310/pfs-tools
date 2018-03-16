# PFS TOOLS
This is a supporting tools for PFS Localization Project

## Build props from from jsp file
The properties of hard-coded text will be generated under format: `file.name = hard.coded.text` (separated by `.` word by word).

Property files are exported under `/dist` directory. File name format: `{filename}_{target}.properties`). 
* **filename:** is the same as scanned jsp file.
* **target:** is the language tag which used in google API translator.

### Example:
example.jsp:
```jsp
<div class="list-group-item">
    <div class="row">
        <div class="col-sm-4"><label>Should this Entity Type be navigable?:</label></div>
        <div class="col-sm-8"><%=entityType.isNavigable()%></div>
    </div>
</div>
```
result.properties
```properties
entity.type.details.should.this.entity.type.be.navigable = Should this Entity Type be navigable?:
```

result_zh.properties
```properties
entity.type.details.should.this.entity.type.be.navigable = 该实体类型是否可导航？:
```

## Command:
Command is built by using [yargs](http://yargs.js.org).

```bash
node index.js <commands> [args]

Commands:
  scan [src]        Run tool to scan directory/file
  translate [text]  Translate a english text to specify language
                             (default is zh)

Options:
  --version     Show version number                                    [boolean]
  --dist, -d    Exported file destination directory          [default: "./dist"]
  --target, -t  Target language for translation                  [default: "zh"]
  --help        Show help                                              [boolean]

For more information, see https://github.com/phamvanthang310/PFS-tools

```

## Production deployment
1. Build: `npm run build`. Built src is stored in `/lib` directory.
2. Copy `/lib` and index.js file to server.
3. run `node index.js <cmd> [args]`

