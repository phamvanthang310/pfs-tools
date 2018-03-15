# PFS TOOLS
This is a supporting tools for PFS Localization Project

### Build props from from jsp file
The properties of hard-coded text will be generated under format: `file.name = hard.coded.text` (separated by `.` word by word).

Property files are exported under `/dist` directory (format: `filename.properties`).

#### Example:
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
entity.type.details.should.this.entity.type.be.navigable = Should this Entity Type be navigable
```

#### Command:
* Process 1 jsp file: `npm start [path/to/jsp/file]`
* Process all jsp file in directory: `npm start [path/to/directory]`

#### Production deployment
1. Build: `npm run build`. Built src is stored in `/lib` directory.
2. Copy `/lib` and index.js file to server.
3. run `node index.js [arguments]`