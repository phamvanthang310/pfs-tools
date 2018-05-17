# PFS TOOLS
This is a supporting tools for PFS Localization Project

## Build props from from jsp file
The properties of hard-coded text will be generated under format: `file.name = hard.coded.text` (separated by `.` word by word).

Property files are exported under `/dist` directory. File name format: `{filename}_{target}.properties`). 
* **filename:** is the same as scanned jsp file.
* **target:** is the language tag which used in google API translator.

### Example:
#### Input
EntityTypeDetails.jsp:
```jsp
<div class="list-group-item">
    <div class="row">
        <div class="col-sm-4"><label>Should this Entity Type be navigable?:</label></div>
        <div class="col-sm-8"><%=entityType.isNavigable()%></div>
    </div>
</div>
```

#### Output
EntityTypeDetails.jsp
```jsp
<div class="list-group-item">
    <div class="row">
        <div class="col-sm-4"><label><fmt:message key="entityTypeDetails.text.shouldThisEntityTypeBeNavigable" /></label></div>
        <div class="col-sm-8"><%=entityType.isNavigable()%></div>
    </div>
</div>
```

result.properties
```properties
entityTypeDetails.text.shouldThisEntityTypeBeNavigable = Should this Entity Type be navigable?:
```

result_zh.properties
```properties
entityTypeDetails.text.shouldThisEntityTypeBeNavigable = 该实体类型是否可导航？:
```

## Command:
Command is built by using [yargs](http://yargs.js.org).

```bash
node index.js <commands> [args]

Commands:
  index.js scan [src]              Run tool to scan directory/file
  index.js translate [text]        Translate a english text to specify language
                                   (default is zh)
  index.js export [path1] [path2]  export to .csv file

Options:
  --version        Show version number                                 [boolean]
  --dist, -d       Exported file destination directory       [default: "./dist"]
  --target, -t     Target language for translation               [default: "zh"]
  --overwrite, -o  overwrite file if exist                      [default: false]
  --export, --exp  export to .csv file                          [default: false]
  --basename, -n   set basename of properties file
                                                [default: "ApplicationMessages"]
  --help           Show help                                           [boolean]

For more information, see https://github.com/phamvanthang310/PFS-tools

```

## Production deployment
1. Build: `npm run build`. Built src is stored in `/lib` directory.
2. Copy `/lib` and index.js file to server.
3. run `node index.js <cmd> [args]`

