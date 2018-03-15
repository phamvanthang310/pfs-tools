# PFS TOOLS
This is a supporting tools for PFS Localization Project

### Build props from from jsp file
The properties of hard-coded text will be generated under format: file.name = hard.coded.text (separated by `.` word by word).

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


#### Run command:

* Jsp file: `npm start [path/to/jsp/file]`
* All jsp file in directory: `npm start [path/to/directory]`
