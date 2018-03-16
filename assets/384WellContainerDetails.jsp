<%@ include file="include/MainInclude.jsp" %>


<script language="JavaScript">
  function submitForm(entityId) {
    document.getElementById('entityId').value = entityId;
    document.getElementById('entityType').value = 'CELL';
    document.getElementById('cmd').value = 'get';
    document.cellDetailForm.submit();
  }

  function submitFormToAddContents(cellId) {
    document.getElementById('entityId').value = cellId;
    document.getElementById('entityType').value = 'CELL';
    document.getElementById('cmd').value = 'add-cell-contents';
    document.cellDetailForm.submit();
  }
</script>


<%
    Entity container = (Entity) request.getAttribute("container");
    Cell[] cells = (Cell[]) request.getAttribute("cells");
    ContainerFormat containerFormat = (ContainerFormat) request.getAttribute("containerFormat");
    int thisShadeCell = -1;
    try {
        Cell thisCell = (Cell) request.getAttribute("cell");
        thisShadeCell = thisCell.getCell() - 1;
    } catch (Exception e) {
    }
    int cellCount = 0;
    Cell cell = null;
%>


<table class="container1">
    <tr height="20">
        <td width="20">
            &nbsp;
        </td>
        <% for (int headerCount = 1; headerCount <= 24; headerCount++) {%>
        <th width="30">
            <a href="<%=servletUrl%>?cmd=fill-container&col=<%=headerCount%>&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>"><%=headerCount%>
            </a>
        </th>
        <%}%>
    </tr>

    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=A&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">A</a>
        </th>
        <% for (cellCount = 0; cellCount < 24; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        } %>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=B&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">B</a>
        </th>
        <% for (cellCount = 24; cellCount < 48; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=C&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">C</a>
        </th>
        <% for (cellCount = 48; cellCount < 72; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=D&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">D</a>
        </th>
        <% for (cellCount = 72; cellCount < 96; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=E&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">E</a>
        </th>
        <% for (cellCount = 96; cellCount < 120; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=F&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">F</a>
        </th>
        <% for (cellCount = 120; cellCount < 144; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=G&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">G</a>
        </th>
        <% for (cellCount = 144; cellCount < 168; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=H&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">H</a>
        </th>
        <% for (cellCount = 168; cellCount < 192; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=I&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">I</a>
        </th>
        <% for (cellCount = 192; cellCount < 216; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=J&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">J</a>
        </th>
        <% for (cellCount = 216; cellCount < 240; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=K&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">K</a>
        </th>
        <% for (cellCount = 240; cellCount < 264; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=L&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">L</a>
        </th>
        <% for (cellCount = 264; cellCount < 288; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=M&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">M</a>
        </th>
        <% for (cellCount = 288; cellCount < 312; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=N&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">N</a>
        </th>
        <% for (cellCount = 312; cellCount < 336; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=O&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">O</a>
        </th>
        <% for (cellCount = 336; cellCount < 360; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
    <tr height="30">
        <th>
            <a href="<%=servletUrl%>?cmd=fill-container&row=P&entityType=<%=container.getEntityType()%>&entityId=<%=container.getId()%>">P</a>
        </th>
        <% for (cellCount = 360; cellCount < 384; cellCount++) {
            cell = cells[cellCount];
            if (cellCount == thisShadeCell) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" style=\"background-color:yellow\">");
                out.println(cell.getCellDetails());
                out.println("</td>");
            } else if (!cell.hasAmountZero()) {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellFull\">");
                out.println(cell.getCell());
                out.println("</td>");
            } else {
                out.println("<td onClick=\"submitForm(" + cell.getId() + ")\" class=\"containerCellEmpty\">");
                out.println(cell.getCell());
                out.println("</td>");
            }
        }%>
    </tr>
</table>