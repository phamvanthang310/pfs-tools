<%@ include file="include/MainInclude.jsp" %>
<% pageTitle = typeLabel + " Member Details"; %>
<%@ include file="/core/include/header.jsp" %>
<%@ include file="/core/include/NavBarTop.jsp" %>

<section class="core-container container-fluid">
    <%@ include file="/core/include/Banner.jsp" %>
    <%@ include file="/core/include/PageTitleHeader.jsp" %>

    <%--INSERT Page Content Here--%>

    <%
        Map assayTypeIdToAssayList = (Map) request.getAttribute("assayTypeIdToAssayList");
        EntityType[] assayTypes = (EntityType[]) request.getAttribute("assayTypes");
        assayTypes = (EntityType[]) SecurityHandler.getInstance(tenant).getViewableEntityTypes(employee, assayTypes);

        Map<String, AssayGrouping[]> assayIdToAssayGroupingMap = (Map<String, AssayGrouping[]>) request.getAttribute("assayIdToAssayGroupingMap");
        if (assayIdToAssayGroupingMap == null) assayIdToAssayGroupingMap = new HashMap<String, AssayGrouping[]>();

        Map<String, Entity[]> assayIdToProtocolsMap = (Map<String, Entity[]>) request.getAttribute("assayIdToProtocolsMap");
        if (assayIdToProtocolsMap == null) assayIdToProtocolsMap = new HashMap<String, Entity[]>();

        Entity[] assays = (Entity[]) request.getAttribute("assays");
        assays = SecurityHandler.getViewableEntities(employee, assays);

        Attribute reportFormatProjectAssociationAttribute = (Attribute) request.getAttribute("reportFormatProjectAssociationAttribute");
        Attribute reportFormatEntityNameAttribute = (Attribute) request.getAttribute("reportFormatEntityNameAttribute");
        Attribute reportFormatEntityBarcodeAttribute = (Attribute) request.getAttribute("reportFormatEntityBarcodeAttribute");
        Attribute reportFormatEntityCreationDateAttribute = (Attribute) request.getAttribute("reportFormatEntityCreationDateAttribute");

        Map typeAssocIdToEntityType = (Map) request.getAttribute("typeAssocIdToEntityType");
        EntityType listEntityType = (EntityType) request.getAttribute("listEntityType");

        EntityType listEntityTypeLot = (EntityType) request.getAttribute("listEntityTypeLot");
        List<TypeAssociation> allTypeAssociationsList = (List<TypeAssociation>) request.getAttribute("allTypeAssociations");
        TypeAssociation[] allTypeAssociations = allTypeAssociationsList.toArray(new TypeAssociation[0]);

        LinkedHashMap<String, String> aggFunctionValueToOptionMap = new LinkedHashMap<String, String>();
        aggFunctionValueToOptionMap.put("average", "Average");
        aggFunctionValueToOptionMap.put("num_set", "Set");
        aggFunctionValueToOptionMap.put("cv", "%CV");
        aggFunctionValueToOptionMap.put("max", "Max");
        aggFunctionValueToOptionMap.put("min", "Min");
        aggFunctionValueToOptionMap.put("N", "N");
        aggFunctionValueToOptionMap.put("stdev", "Stdev");
        aggFunctionValueToOptionMap.put("sum", "Sum");
        aggFunctionValueToOptionMap.put("string_set", "String Set");
        aggFunctionValueToOptionMap.put("time_set", "Time Set");

    %>

    <script type="text/javascript">

      function updateAssayAndTypeAttribute(assayTypeSelEl, count) {
        updateAssay(assayTypeSelEl, 'assaySelect' + count);
        updateTypeAttribute(assayTypeSelEl, 'typeAttributeId' + count, false);

        groupingSelBox = document.getElementById('groupingSelect');
        removeAllOptions(groupingSelBox);
        addOption(groupingSelBox, '----select----', '0');
      }


      function updateListEntityTypeAssocAttribute(listEntityTypeAssocSelEl, count) {
        updateTypeAttribute(listEntityTypeAssocSelEl, 'listEntityTypeAssocTypeAttributeId' + count, true);
      }


      function updateAssay(assayTypeSelEl, assaySelElId) {
        assaySelBox = document.getElementById(assaySelElId);
        removeAllOptions(assaySelBox);

        var aIds = assayTypeIdToAssayIdsJS.get(assayTypeSelEl.value);

        // add this as default
        addOption(assaySelBox, '----select----', '0');

        if (aIds != null) {
          for (var i = 0; i < aIds.length; i++) {
            var display = assayIdToAssayDisplayJS.get(aIds[i]);
            //    alert(aIds[i] + ' : ' + display);
            addOption(assaySelBox, display, aIds[i]);
          }
        }
      }

      function updateTypeAttribute(assayTypeSelEl, typeAttributeSelElId, isTypeAssocAttr) {
        typeAttributeSelBox = document.getElementById(typeAttributeSelElId);
        removeAllOptions(typeAttributeSelBox);

        var taIds = assayTypeIdToTypeAttributeIdsJS.get(assayTypeSelEl.value);

        // add this as default
        addOption(typeAttributeSelBox, '----select----', '0');

        if (taIds != null) {
          for (var i = 0; i < taIds.length; i++) {
            var display = typeAttributeIdToTypeAttributeDisplayJS.get(taIds[i]);
            //     alert(taIds[i] + ' : ' + display);
            addOption(typeAttributeSelBox, display, taIds[i]);
          }
        }
        <% if (reportFormatEntityNameAttribute!=null) { %>
        if (isTypeAssocAttr) {
          addOption(typeAttributeSelBox, 'Name', '<%=reportFormatEntityNameAttribute.getId()%>');
        }
        <% } %>

        <% if (reportFormatEntityBarcodeAttribute!=null) { %>
        if (isTypeAssocAttr) {
          addOption(typeAttributeSelBox, 'Barcode', '<%=reportFormatEntityBarcodeAttribute.getId()%>');
        }
        <% } %>

        <% if (reportFormatEntityCreationDateAttribute!=null) { %>
        //  if (isTypeAssocAttr) {
        addOption(typeAttributeSelBox, 'CreationEvent', '<%=reportFormatEntityCreationDateAttribute.getId()%>');
        //  }
        <% } %>
      }

      function updateGrouping(assaySelectBox) {
        groupingSelBox = document.getElementById('groupingSelect');
        removeAllOptions(groupingSelBox);
        // add this as default
        addOption(groupingSelBox, '----select----', '0');


        var assayGroupings = assayIdToGroupingsValuesJS.get(assaySelectBox.value);
        if (assayGroupings != null) {
          for (var i = 0; i < assayGroupings.length; i++) {
            var key = assaySelectBox.value + '|' + assayGroupings[i];
            var display = assayIdPipeGroupingDisplayJS.get(key);
            if (display != null) {
              addOption(groupingSelBox, display, assayGroupings[i]);
            }
          }
        }
        updateProtocol(assaySelectBox);
      }

      function updateProtocol(assaySelectBox) {
        protocolSelBox = document.getElementById('protocolSelect');
        removeAllOptions(protocolSelBox);
        // add this as default
        addOption(protocolSelBox, '----select----', '0');


        var protocolIds = assayIdToProtocolIdsValuesJS.get(assaySelectBox.value);
        if (protocolIds != null) {
          for (var i = 0; i < protocolIds.length; i++) {
            var display = protocolIdToProtocolDisplayJS.get(protocolIds[i]);
            if (display != null) {
              addOption(protocolSelBox, display, protocolIds[i]);
            }
          }
        }

      }

      function updateAggregateFunction(dataTypeSelect) {
        aggFunctionSelBox = document.getElementById('aggregateFunction');

        var dataCode = typeAttributeIdToDataTypeCodeJS.get(dataTypeSelect.value);

        if (dataCode ==<%= TypeAttribute.TIMESTAMP_DATA %>) aggFunctionSelBox.value = 'time_set';
        else
          aggFunctionSelBox.value = 'average';

      }


      function removeAllOptions(selectbox) {
        var i;
        for (i = selectbox.options.length - 1; i >= 0; i--) {
          selectbox.remove(i);
        }
      }


      function addOption(selectbox, text, value) {
        var optn = document.createElement("OPTION");
        optn.text = text;
        optn.value = value;
        selectbox.options.add(optn);
      }


      window.onload = function load() {
        //   alert('in onload');
        assayTypeIdToAssayIdsJS = new Ext.util.HashMap();
        assayIdToAssayDisplayJS = new Ext.util.HashMap();

        <% for (int a = 0; a < assayTypes.length; a++) { %>
        <% ArrayList assayList = ((ArrayList)assayTypeIdToAssayList.get(String.valueOf(assayTypes[a].getEntityTypeId()))); %>
        <% if (assayList == null) { %>
        <% } else { %>
        var assayIdsJS = new Array();
        <% for (int b = 0; b < assayList.size(); b++) { %>
        <% String assayDisplay = ((Entity)assayList.get(b)).getName(); %>
        assayIdsJS[<%=b%>] = '<%= String.valueOf(((Entity)assayList.get(b)).getId()) %>';
        assayIdToAssayDisplayJS.add('<%= String.valueOf(((Entity)assayList.get(b)).getId()) %>', '<%= assayDisplay %>');
        //     alert('assayId: <%= ((Entity)assayList.get(b)).getId() %> display: <%= assayDisplay %>');
        <% } %>
        assayTypeIdToAssayIdsJS.add('<%= String.valueOf(assayTypes[a].getEntityTypeId())%>', assayIdsJS);
        <% } %>
        <% } %>


        assayTypeIdToTypeAttributeIdsJS = new Ext.util.HashMap();
        typeAttributeIdToTypeAttributeDisplayJS = new Ext.util.HashMap();
        typeAttributeIdToDataTypeCodeJS = new Ext.util.HashMap();


        <% for (int a = 0; a < assayTypes.length; a++) { %>
        <% //ArrayList typeAttributeList = ((ArrayList)assayTypeIdToTypeAttributeList.get(assayTypes[a].getEntityTypeId())); %>
        <% TypeAttribute[] typeAttributes = assayTypes[a].getTypeAttributes(); %>
        <% if (typeAttributes == null) { %>
        <% } else { %>
        var typeAttributeIdsJS = new Array();
        <% for (int b = 0; b < typeAttributes.length; b++) { %>
        <% String typeAttributeDisplay = typeAttributes[b].getAttributeName(); %>
        typeAttributeIdsJS[<%=b%>] = '<%= String.valueOf(typeAttributes[b].getId()) %>';
        typeAttributeIdToTypeAttributeDisplayJS.add('<%= String.valueOf(typeAttributes[b].getId()) %>', '<%= typeAttributeDisplay %>');
        typeAttributeIdToDataTypeCodeJS.add('<%= String.valueOf(typeAttributes[b].getId()) %>', '<%= typeAttributes[b].getDataType() %>');
        //   alert('entityId: <%//= typeAttributes[b].getId() %> display: <%//= typeAttributeDisplay %>');
        <% } %>
        assayTypeIdToTypeAttributeIdsJS.add('<%= String.valueOf(assayTypes[a].getEntityTypeId())%>', typeAttributeIdsJS);
        <% } %>
        <% } %>

        <% for (int a = 0; a < allTypeAssociations.length; a++) {%>
        <% TypeAssociation ltTa = allTypeAssociations[a]; %>
        <% EntityType taEntityType = (EntityType)typeAssocIdToEntityType.get(String.valueOf(ltTa.getId())); %>
        <% //ArrayList typeAttributeList = ((ArrayList)assayTypeIdToTypeAttributeList.get(taEntityType.getEntityTypeId())); %>
        <% TypeAttribute[] typeAttributes = taEntityType.getTypeAttributes(); %>
        <% if (typeAttributes == null) { %>
        <% } else { %>
        var typeAttributeIdsJS = new Array();
        <% for (int b = 0; b < typeAttributes.length; b++) { %>
        <% String typeAttributeDisplay = typeAttributes[b].getAttributeName(); %>
        typeAttributeIdsJS[<%=b%>] = '<%= String.valueOf(typeAttributes[b].getId()) %>';
        typeAttributeIdToTypeAttributeDisplayJS.add('<%= String.valueOf(typeAttributes[b].getId()) %>', '<%= typeAttributeDisplay %>');
        typeAttributeIdToDataTypeCodeJS.add('<%= String.valueOf(typeAttributes[b].getId()) %>', '<%= typeAttributes[b].getDataType() %>');
        //   alert('entityId: <%//= typeAttributes[b].getId() %> display: <%//= typeAttributeDisplay %>');
        <% } %>
        assayTypeIdToTypeAttributeIdsJS.add('<%= String.valueOf(taEntityType.getEntityTypeId())%>', typeAttributeIdsJS);
        <% } %>
        <% } %>

        assayIdToGroupingsValuesJS = new Ext.util.HashMap();
        assayIdPipeGroupingDisplayJS = new Ext.util.HashMap();

        <% for (int a=0; a < assays.length; a++) {
              String currentAssayId = String.valueOf(assays[a].getId());
              AssayGrouping[] ag = assayIdToAssayGroupingMap.get(currentAssayId); %>
        var assayGroupingsJS = new Array();
        <% if (ag==null) {
           } else { %>
        <% for (int b=0; b<ag.length; b++) {
              try {
                 String groupingDisplay = Formatter.formatAssayGrouping(ag[b]); %>
        assayGroupingsJS[<%=b%>] = '<%=ag[b].getGrouping()%>';
        assayIdPipeGroupingDisplayJS.add('<%=currentAssayId+"|"+ag[b].getGrouping()%>', '<%=groupingDisplay%>');
        <%    } catch (Exception e) {} %>
        <% } %>
        assayIdToGroupingsValuesJS.add('<%=currentAssayId%>', assayGroupingsJS);
        <% } %>
        <% } %>

        assayIdToProtocolIdsValuesJS = new Ext.util.HashMap();
        protocolIdToProtocolDisplayJS = new Ext.util.HashMap();

        <% for (int a=0; a < assays.length; a++) {
              String currentAssayId = String.valueOf(assays[a].getId());
              Entity[] protocols = assayIdToProtocolsMap.get(currentAssayId); %>
        var protocolIsJS = new Array();
        <% if (protocols==null) {
           } else { %>
        <% for (int b=0; b<protocols.length; b++) {
              String protocolDisplay = protocols[b].getName(); %>
        protocolIsJS[<%=b%>] = '<%=protocols[b].getId()%>';
        protocolIdToProtocolDisplayJS.add('<%=protocols[b].getId()%>', '<%=protocolDisplay%>');
        <% } %>
        assayIdToProtocolIdsValuesJS.add('<%=currentAssayId%>', protocolIsJS);
        <% } %>
        <% } %>

      };

    </script>

    <%
        EntityList list = (EntityList) request.getAttribute("list");
        Entity[] currentAssays = (Entity[]) request.getAttribute("currentAssays");
        Attribute[] attributes = (Attribute[]) request.getAttribute("attributes");
        Attribute[] sampleLotAttributes = (Attribute[]) request.getAttribute("sampleLotAttributes");
        Attribute[] sampleAttributes = (Attribute[]) request.getAttribute("sampleAttributes");
        AssayListMember[] listMembers = (AssayListMember[]) request.getAttribute("listMembers");
        int nextSequence = 0;

    %>

    <%@ include file="include/EntityFunctions.jsp" %>
    <form name="form1" action="<%=servletUrl%>?cmd=remove-from-list" method="post">
        <input type="hidden" name="entityType" value="<%= list.getEntityTypeName() %>">
        <input type="hidden" name="listId" value="<%=list.getId() %>">
        <input type="hidden" name="listEntityTypeName" value="<%=listEntityType.getEntityTypeName() %>">

        <div class="row">
            <div class="col-xs-12">
                <input type="button" value="Select All" onClick="checkAll(event, document.form1.memberId)"/>
                <input type="submit" value="Update List" class="btn btn-default"/>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-10 col-md-8 col-lg-6">
                <div class="panel panel-primary table-responsive">
                    <table class="table table-hover table-condensed">
                        <thead>
                        <tr class="panel-heading">
                            <th>Remove</th>
                            <th>Entity Type</th>
                            <th>Attributes or Associations</th>
                            <% if (list.getSuperTypeName().equals("CHART FORMAT")) { %>
                            <th>Context</th>
                            <% } else { %>
                            <th>Alias</th>
                            <th>Sequence</th>
                            <% } %>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (currentAssays.length > 0) { %>
                        <% for (int i = 0; i < currentAssays.length; i++) { %>
                        <tr>
                            <% if (currentAssays[i].getId() == 0) { %>
                            <td><input type="checkbox" name="memberId" value="<%=listMembers[i].getId()%>"></td>
                            <td>
                                <%= listMembers[i].getEntityTypeName() %>
                                <% if (listMembers[i].isOnAssociation()) { %>(Associated)<% } %>
                                <% if (listMembers[i].isUserEquationData()) { %>
                                <a href="<%=servletUrl %>?cmd=get&entityType=USER EQUATION&entityId=<%=listMembers[i].getAttribute().getDataTypeId() %>">Edit</a>
                                <% } %>
                            </td>

                            <% } else { %>
                            <td><input type="checkbox" name="memberId" value="<%=listMembers[i].getId()%>"></td>
                            <td>
                                <a href="<%=servletUrl%><%=currentAssays[i].getLink() %>"><%= currentAssays[i].getName() %>
                                </a><br></br>
                                Grouping: <%= Formatter.formatAssayGrouping(listMembers[i].getAssayGrouping()) %><br>
                                Protocol: <%= listMembers[i].getProtocolName() %><br>
                                Aggregate
                                Function: <%= aggFunctionValueToOptionMap.get(listMembers[i].getAggregateFunction()) %>
                            </td>
                            <% } %>
                            <td>
                                <%=attributes[i].getName()%>
                                <% if (listMembers[i].getAssay() != null) {
                                    if (listMembers[i].isSampleCentric()) {
                                        out.println("(Sample Centric" + ")");
                                    } %>
                                <% } %>
                                &nbsp;(<%=attributes[i].getDataTypeString() %>)
                            </td>
                            <td><input type="text" name="memberAlias" value="<%= listMembers[i].getAlias() %>" size="20"
                                       maxlength="20"></td>
                            <% if (!list.getSuperTypeName().equals("CHART FORMAT")) { %>
                            <td><%= i + 1 %>
                            </td>
                            <%} %>
                        </tr>
                        <% nextSequence = i + 1; %>
                        <% } %>
                        <% } else { %>
                        <tr>
                            <td colspan="5">There are no members of this list yet.</td>
                        </tr>
                        <% } %>

                        </tbody>
                    </table>
                    <br>
                    <div class="panel-heading"><label>ADD</label></div>
                    <% if (listEntityType.getEntityTypeName().equalsIgnoreCase("ASSAY") || listEntityType.getSuperTypeName().equalsIgnoreCase("SAMPLE")) { %>
                    <div class="col-xs-12 col-sm-5 remove-padding">
                        <div class="form-group">
                            <label>Sample Data:</label>
                            <select class="form-control" name="sampleSelect" multiple size=7>
                                <option value="0">------ SAMPLE DATA -------
                                        <% if (reportFormatProjectAssociationAttribute!=null) { %>
                                <option value="<%=reportFormatProjectAssociationAttribute.getId()%>">Project
                                        <% } %>
                                        <% if (reportFormatEntityCreationDateAttribute!=null) { %>
                                <option value="<%=reportFormatEntityCreationDateAttribute.getId()%>">CreationEvent
                                        <% } %>
                                        <% for (int j=0; j < sampleAttributes.length; j++) {
                           if (j>0){
                             if (sampleAttributes[j].getId()!=sampleAttributes[j-1].getId()){ %>
                                <option value="<%=sampleAttributes[j].getId()%>"><%=sampleAttributes[j].getName()%>
                                        <% } %>
                                        <% } else {  %>
                                <option value="<%=sampleAttributes[j].getId()%>"><%=sampleAttributes[j].getName()%>
                                        <%} %>
                                        <% } %>
                            </select>
                        </div>
                    </div>
                    <div class="col-xs-12 col-sm-2" style="text-align:center">
                        <label>AND/OR</label>
                    </div>
                    <div class="col-xs-12 col-sm-5 remove-padding">
                        <div class="form-group">
                            <label>Lot Data:</label>
                            <select class="form-control" name="lotSelect" multiple size=7>
                                <option value="0">------ LOT DATA -------
                                        <% if (reportFormatProjectAssociationAttribute!=null) { %>
                                <option value="<%=reportFormatProjectAssociationAttribute.getId()%>">Project
                                        <% } %>
                                        <% if (reportFormatEntityCreationDateAttribute!=null) { %>
                                <option value="<%=reportFormatEntityCreationDateAttribute.getId()%>">CreationEvent
                                        <% } %>
                                        <% for (int j=0; j < sampleLotAttributes.length; j++) {
                                   if (j>0){
                                     if (sampleLotAttributes[j].getId()!=sampleLotAttributes[j-1].getId()){ %>
                                <option value="<%=sampleLotAttributes[j].getId()%>"><%=sampleLotAttributes[j].getName()%>
                                        <% } %>
                                        <% } else {  %>
                                <option value="<%=sampleLotAttributes[j].getId()%>"><%=sampleLotAttributes[j].getName()%>
                                        <%} %>
                                        <% } %>
                            </select>
                        </div>
                    </div>
                    <div class="col-xs-12" style="text-align:center">
                        <label>AND/OR</label>
                        <br/>
                        <label>Assay Data:</label>
                    </div>
                    <div class="form-group">
                        <br><br>
                        <table class="table table-condensed">
                            <tr>
                                <td>Assay Type:</td>

                                <td>
                                    <select class="form-control" name="assayTypeSelect"
                                            onchange="updateAssayAndTypeAttribute(this, '')">
                                        <option value="0" selected>------ ASSAY TYPE DATA ------
                                                <% for (int j = 0; j < assayTypes.length; j++) { %>
                                        <option value="<%= assayTypes[j].getEntityTypeId() %>"><%=assayTypes[j].getEntityTypeName() %>
                                        </option>
                                        <% } %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Assay:<br>

                                    <select class="form-control" name="assaySelect" id="assaySelect" multiple size=10
                                            onchange="updateGrouping(this)">
                                        <option value="0">----select----</option>
                                    </select>
                                </td>
                                <td>Data Type:<br>

                                    <select class="form-control" name="typeAttributeId" id="typeAttributeId" multiple
                                            size=10 onchange="updateAggregateFunction(this)">
                                        <option value="0" selected>----select----
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Sample Centric:</td>
                                <td>
                                    <input type="checkbox" name="sampleCentric">
                                </td>
                            </tr>
                            <tr>
                                <td>Grouping:</td>
                                <td>
                                    <select class="form-control" name="groupingSelect" id="groupingSelect">
                                        <option value="0" selected>----select----
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Protocol:</td>
                                <td>
                                    <select class="form-control" name="protocolSelect" id="protocolSelect">
                                        <option value="0" selected>----select----
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>Aggregate Function:</td>
                                <td>
                                    <select class="form-control" name="aggregateFunction" id="aggregateFunction">
                                        <% for (String key : aggFunctionValueToOptionMap.keySet()) { %>
                                        <option value="<%= key %>" <%if (key.equals("average"))
                                            out.print("selected"); %>><%= aggFunctionValueToOptionMap.get(key) %>
                                        </option>
                                        <% } %>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="col-xs-12" style="text-align:center">
                        <label>OR</label>
                    </div>
                    <div class="form-group">
                        <label>User Defined Equation:</label> <input type="checkbox" name="userEquation">
                    </div>
                    <% }%>
                    <% if (!listEntityType.getEntityTypeName().equalsIgnoreCase("ASSAY") && !listEntityType.getSuperTypeName().equalsIgnoreCase("SAMPLE")) { %>
                    <div class="form-group">
                        <label>Attributes:</label>
                        <select name="listEntityTypeAttributeSelect">
                            <option value="0">------ <%=listEntityType.getEntityTypeName() %> DATA -------</option>
                            <% for (int j = 0; j < listEntityType.getTypeAttributes().length; j++) { %>
                            <option value="<%=listEntityType.getTypeAttributes()[j].getId()%>"><%=listEntityType.getTypeAttributes()[j].getAttributeName()%>
                                    <%} %>
                        </select>
                    </div>
                    <% } %>
                    <% if (allTypeAssociations.length > 0) {%>
                    <label>OR</label>
                    <div class="form-group">
                        <label>Associations:</label>
                        <select id="listEntityTypeAssocSelect" name="listEntityTypeAssocSelect"
                                onchange="updateListEntityTypeAssocAttribute(this, '')">
                            <option value="0">------ DATA -------</option>
                            <% for (int a = 0; a < allTypeAssociations.length; a++) {%>
                            <% TypeAssociation ltTa = allTypeAssociations[a]; %>
                            <%
                                EntityType taEntityType = (EntityType) typeAssocIdToEntityType.get(String.valueOf(ltTa.getId())); %>
                            <option value="<%=taEntityType.getEntityTypeId()%>"><%=taEntityType.getEntityTypeName()%>
                            </option>
                            <% } %>
                        </select>
                        <select id="listEntityTypeAssocTypeAttributeId" name="listEntityTypeAssocTypeAttributeId">
                            <option value="0">------ DATA -------</option>
                        </select>

                    </div>
                    <% } %>
                    <div class="form-group" style="padding-bottom: 10px">
                        <% if (list.getSuperTypeName().equals("CHART FORMAT")) { %>
                        <% String[] contextMembers = list.getValue("Context Members").split(","); %>
                        <select name="alias">
                            <option value="none">--select--</option>
                            <% for (String member : contextMembers) { %>
                            <option value="<%=member%>"><%=member%>
                            </option>
                            <% } %>
                        </select>
                        <% } else { %>
                        <label>Alias:</label>
                        <input type="text" name="alias" size="20" maxlength="20"/>
                        <% } %>
                    </div>
                </div>
                <input type="submit" value="Update List" class="btn btn-default"/>
            </div>
        </div>
    </form>
    <%--END INSERT--%>
</section>
<br>
<%@ include file="include/Feedback.jsp" %>
<%@ include file="include/footer.jsp" %>