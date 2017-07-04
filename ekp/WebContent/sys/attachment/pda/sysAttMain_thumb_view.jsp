<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.third.pda.model.PdaRowsPerPageConfig"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String formBeanName = request.getParameter("formBeanName");
	String attKey = request.getParameter("fdKey");
	Object formBean = null;
	if(formBeanName != null && formBeanName.trim().length()!= 0){
		formBean = pageContext.getAttribute(formBeanName);
		if(formBean == null)
			formBean = request.getAttribute(formBeanName);
		if(formBean == null)
			formBean = session.getAttribute(formBeanName);
	}
	pageContext.setAttribute("_formBean", formBean);
%>

<c:set var="attForms" value="${_formBean.attachmentForms[param.fdKey]}" />
<c:set var="msgkey" value="${param.msgkey}"/>
<c:if test="${attForms!=null && fn:length(attForms.attachments)>0}">
	<div class="div_attGroup thumbC">
		<div class="thumbDiv" align="center">
			<ul id="thumbUl" >
				<c:forEach var="sysAttMain" items="${attForms.attachments}" varStatus="vsStatus">
					<c:if test="${sysAttMain.fdAttType=='pic'|| fn:indexOf(sysAttMain.fdContentType, 'image')>-1}">
						<li>
							<img onload="autoReset(this)" src='<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=showThumbs&size=s1&fdId=${sysAttMain.fdId}"/>'></img>
						</li>
					</c:if>
				</c:forEach>
				<div class="clear"></div>
			</ul>
		</div>
	</div>
</c:if>


<style>
.div_attGroup.thumbC{
	float: left;
}
.thumbC .thumbDiv{
	float: left;
	width: 100%;
	text-align: center;
	white-space:nowrap;
	overflow:hidden;
	position:relative;
	height:150px;
	padding-left: 0;
}
.thumbC div ul{
	position:absolute;/*left:8px;*/height: 150px;
}

.thumbC div ul li{
	padding: 0 2px;
	display: inline-block;
}

.thumbC div ul.static{
	position: static;
}
</style>
<script type="text/javascript">
	function autoReset(obj) {
		var clientWidth = document.body.clientWidth - 10 * 2 - 2 * 4;
		var w = clientWidth / 2;
		obj.style.height = 150 + "px";
		obj.style.width = w + "px";
	}

	var attTouch = function(context, options) {
		this.context = document.getElementById(context);
		this.options = options;
		this.startX = 0;
		this.endX = 0;
		this.range = 0;
		this.changeX = 0;
		this.clientWidth = document.body.clientWidth;
		this.bind = function(obj, eventType, func) {
			if (typeof window.ActiveXObject != "undefined") {
				obj.attachEvent("on" + eventType, func);
			} else {
				obj.addEventListener(eventType, func, false);
			}
		};
		var that = this;
		this.bindTouchStart = function() {
			this.bind(this.context, 'touchstart', function(e) {
				that.startX = e.touches[0].pageX;
				that.range = that.startX - that.context.style.left.replace('px', '');
			})
		};

		this.bindTouchEnd = function() {
			this.bind(this.context, 'touchend', function(e) {
				that.endX = e.changedTouches[0].pageX;
				that.changeX = that.endX - that.startX;
				var left = that.context.style.left.replace('px', '');
				if (left > 0) {
					that.context.style.left = '8px';
				}
				if (that.context.offsetWidth < -left + that.clientWidth) {
					that.context.style.left = -(that.context.offsetWidth - that.clientWidth) - 8 + "px";
				}
			})
		};

		this.bindTouchMove = function(e) {
			this.bind(this.context, 'touchmove', function(e) {
				e.preventDefault();
				var x = e.touches[0].pageX;
				that.context.style.left = x - that.range + 'px';
			});

		};

		this.resetPosition = function() {

			var nodes = that.context.getElementsByTagName('img');
			if (nodes.length > 1) {
				that.context.style.left = '8px';
				this.bindEvent();
			} else if (nodes.length == 1) {
				that.context.setAttribute('class', 'static');
			}
		};

		this.bindEvent = function(e) {
			this.bindTouchStart();
			this.bindTouchMove();
			this.bindTouchEnd();
		};
		this.resetPosition();
	}
	new attTouch('thumbUl');
</script>