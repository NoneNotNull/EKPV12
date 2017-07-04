<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/mobile/mui.tld" prefix="mui"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.list">
	<template:replace name="title">
		<c:if test="${param.moduleName!=null && param.moduleName!=''}">
			<c:out value="${param.moduleName}"></c:out>
		</c:if>
		<c:if test="${param.moduleName==null || param.moduleName==''}">
			<c:out value="${lfn:message('km-forum:module.km.forum')}"></c:out>
		</c:if>
	</template:replace>
	<template:replace name="head">
		<mui:min-file name="mui-forum.js"/>
		<script type="text/javascript">
			require(["mui/form/editor/EditorUtil", "mui/device/device", "mui/dialog/Tip",
						"dojo/topic", "dojo/query", "dojo/_base/array", "dojo/request", "dojo/dom-construct","dijit/registry"],
				function(EditorUtil, device, Tip, topic, query, array, request, domConstruct, registry){
					window.refreshList = function(){
						var widgt = registry.byId('scroll');
						var view = widgt;
						if(widgt.currView){
							view = widgt.currView;
						}
						if(view.getChildren){
							array.forEach(view.getChildren(),function(tmpObj){
								if(tmpObj.scrollTo){
									tmpObj.scrollTo({y:0});
								}
								if(tmpObj.reload){
									tmpObj.reload();
								}
							});
						}
					};
					<%@ include file="/km/forum/mobile/view/checkword_script.jsp"%>
					window.validateCreateTopic = function(popup){
						var areaDom = popup.textClaz.domNode;
						var subject = "";
						array.forEach(query(".muiForumSubject",areaDom),function(dom){
							var wgt = registry.byNode(dom);
							if(wgt){
								subject = subject + wgt.get("value");
							}
						});
						if(subject == ""){
							Tip.fail({text:'发帖标题不能为空!'});
							return false;
						}
						var content = popup.textClaz.get("value");
						var tmpDom = domConstruct.create("div",{'innerHTML':content});
						content = tmpDom.innerText;
						if(content==null || content.trim()==""){
							Tip.fail({text:'发帖内容不能为空!'});
							return false;
						}
						return forum_wordCheck(subject+" "+content,"<bean:message  bundle='km-forum' key='kmForumConfig.mobile.word.warn'/>");
					};
				});
		</script>
	</template:replace>
	<template:replace name="content">
		<c:choose>
			<c:when test="${ param.filter == '1' }">
				<c:import url="/km/forum/mobile/list/filter.jsp" charEncoding="UTF-8">
				</c:import>
			</c:when>
			<c:otherwise>
				<c:import url="/km/forum/mobile/list/listview.jsp" charEncoding="UTF-8">
				</c:import>
			</c:otherwise>
		</c:choose>
	</template:replace>
</template:include>
