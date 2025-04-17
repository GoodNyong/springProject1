<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctp" value="${pageContext.request.contextPath }" />

<!-- wizardHelper.jsp -->
<img src="${ctp}/resources/img/helper_wizard.png" id="helper_wizard-img" class="img-fluid" alt="입력도우미 마법사">
<div id="wizard-message" class="wizard-message" style="display: none;"></div>
