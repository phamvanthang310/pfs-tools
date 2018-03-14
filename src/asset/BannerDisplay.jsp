<%@ page import="com.coreinformatics.core.Banner" %>
<%@ include file="include/MainInclude.jsp" %>
<% pageTitle = "Edit Banner Message: "; %>
<%@ include file="/core/include/header.jsp" %>
<%@ include file="/core/include/NavBarTop.jsp" %>

<section class="core-container container-fluid">
    <%@ include file="/core/include/Banner.jsp" %>
    <%@ include file="/core/include/PageTitleHeader.jsp" %>

    <%--INSERT Page Content Here--%>
    <%
        Banner banner = (Banner) request.getAttribute("banner");
    %>

    <br>

    <div class="row">
        <div class="col-xs-12 btn-group-container" style="padding-bottom:15px">
            <div class="btn-group">
                <a class="btn btn-primary" href="<%=servletUrl%>?cmd=create-banner">Create</a>
                <a class="btn btn-primary"
                   href="<%=servletUrl%>?cmd=edit-banner&bannerId=<%=banner.getBannerId() %>&bannerEnum=<%=banner.getBannerEnum() %>&accId=<%=banner.getTenant().getId()%>">Edit</a>
                <a class="btn btn-primary"
                   href="<%=servletUrl%>?cmd=del-banners&checkBanner=<%=banner.getTenant().getId()%>_<%=banner.getBannerId() %>">Delete</a>
                <a class="btn btn-primary" href="<%=servletUrl%>?cmd=list-banner">List All</a>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-xs-12 col-sm-10 col-md-8 col-lg-6" style="padding-bottom:15px">
            <div class="panel panel-primary">
                <div class="panel-heading row">
                    <div class=" col-xs-12"><label>Details</label></div>
                </div>
                <div class="list-group">
                    <div class="list-group-item">
                        <div class="row">
                            <div class="col-xs-5 col-sm-4 col-md-3 col-lg-3"><label>Message:</label></div>
                            <div class="col-xs-7 col-sm-8 col-md-9 col-lg-9"><%=banner.getBannerMessage()%>
                            </div>
                        </div>
                    </div>
                    <div class="list-group-item">
                        <div class="row">
                            <div class="col-xs-5 col-sm-4 col-md-3 col-lg-3">
                                <label>Start Date:</label>
                            </div>
                            <div class="col-xs-7 col-sm-8 col-md-9 col-lg-9">


                            </div>
                        </div>
                    </div>
                    <div class="list-group-item">
                        <div class="row">
                            <div class="col-xs-5 col-sm-4 col-md-3 col-lg-3"><label>End Date:</label></div>
                            <div class="col-xs-7 col-sm-8 col-md-9 col-lg-9"><%=banner.getExpirationDate().format(Banner.DATE_TIME_FORMATTER)%>
                            </div>
                        </div>
                    </div>
                    <div class="list-group-item">
                        <div class="row">
                            <div class="col-xs-5 col-sm-4 col-md-3 col-lg-3">
                                <label>Recipient:</label>
                            </div>
                            <div class="col-xs-7 col-sm-8 col-md-9 col-lg-9">

                                All


                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--END INSERT--%>
</section>
<%@ include file="include/Feedback.jsp" %>
<%@ include file="include/footer.jsp" %>