<%@ include file="include/MainInclude.jsp" %>
<% pageTitle = "Aggregate Assay Report"; %>
<% fullWidth = true; %>
<%@ include file="include/header.jsp" %>
<%@ include file="include/NavBarTop.jsp" %>

<section class="core-container container-fluid">
    <%@ include file="include/Banner.jsp" %>
    <%@ include file="include/PageTitleHeader.jsp" %>

    <%
        Entity assay = (Entity) request.getAttribute("entity");

        EntityType assayType = (EntityType) request.getAttribute("assayType");
        EntityType lotType = (EntityType) request.getAttribute("lotType");

        String formName = "form1";
        String aggregateType = "averages";
        try {
            if (request.getParameter("aggregateType") != null && request.getParameter("aggregateType").length() > 0) {
                aggregateType = request.getParameter("aggregateType");
            }
        } catch (Exception e) {
            aggregateType = "averages";
        }

    %>

    <%@ include file="include/EntityFunctions.jsp" %>


    <%
        String jsonModel = "";
        String gridType = "";
        if (aggregateType.equals("averages")) {
            jsonModel = GridUtilAssayAggregateReport.toJsonAverageFromAssayAggregateReport(assay, employee, lotType, tenant).toString();
            gridType = "assay-average-report";
        } else {
            jsonModel = GridUtilAssayAggregateReport.toJsonAggregateFromAssayAggregateReport(assay, employee, lotType, tenant).toString();
            gridType = "assay-aggregate-report";
        }
    %>

    <div class="row">
        <div class="col-xs-12">

            <form name="<%=formName%>" id="<%=formName%>" action="<%=servletUrl%>" method="post">
                <input type="hidden" name="cmd" value="list-functions">
                <input type="hidden" name="entityId" value="">
                <input type="hidden" name="queryToken" value="">
                <input type="hidden" name="nextPage" value="">
                <input type="hidden" name="assayListId" value="">
                <input type="hidden" name="dataTablePage" value="">
                <input type="hidden" name="allSelectedEntityBarcodeCheckboxes" value="">
                <input type="hidden" name="setSize" value="<%=assayType.getQueryPageSize()%>">

                <%
                    EntityType entityType = assayType;
                    String listTypeName = lotType.getEntityTypeName();
                %>

                <input type="hidden" name="entityType" value="<%=listTypeName %>">
                <input type="hidden" name="listType" value="<%=listTypeName %>">

                <%
                    String[] theseKeys = (String[]) request.getAttribute("keys");
                    if (theseKeys == null) theseKeys = new String[0];
                %>
                <% if (theseKeys != null && theseKeys.length > 0) {%>
                <div id="mydiv"></div>
                <% } else {%>

                <div class="alert alert-warning">No data has been collected for this assay.</div>

                <%}%>

            </form>

            <% if (theseKeys != null && theseKeys.length > 0) {%>
            <%@ include file="include/QueryFooterNavigatorExt.jsp" %>
            <%} %>

        </div>
    </div>

</section>
<%@ include file="include/Feedback.jsp" %>
<%@ include file="include/footer.jsp" %>