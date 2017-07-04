<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<c:set var="_fdKey" value="${param.fdKey}"/>
 
 <c:if test="${param.formName!=null && param.formName!=''}">
 	<c:set var="_formBean" value="${requestScope[param.formName]}"/>
 	<c:set var="attForms" value="${_formBean.attachmentForms[_fdKey]}" />
 </c:if>
 
 <c:set var="_fdModelName" value="${param.fdModelName}"/>
 <c:if test="${_fdModelName==null || _fdModelName == ''}">
 	<c:if test="${_formBean!=null}">
 		<c:set var="_fdModelName" value="${_formBean.modelClass.name}"/>
 	</c:if>
 </c:if>
 
 <c:set var="_fdModelId" value="${param.fdModelId}"/>
 <c:if test="${_fdModelId==null || _fdModelId == ''}">
 	<c:if test="${_formBean!=null}">
 		<c:set var="_fdModelId" value="${_formBean.fdId}"/>
 	</c:if>
 </c:if>

<c:set var="_fdMulti" value="false"/>
<c:if test="${param.fdMulti!=null}">
	<c:set var="_fdMulti" value="${param.fdMulti}"/>
</c:if>

<%-- fdAttType: byte/pic--%>
<c:set var="_fdAttType" value="byte"/>
<c:if test="${param.fdAttType!=null}">
	<c:set var="_fdAttType" value="${param.fdAttType}"/>
</c:if>

<c:set var="_fdRequired" value="false"></c:set>
<c:if test="${param.fdRequired==true || param.fdRequired=='true'}">
	<c:set var="_fdRequired" value="true"/>
</c:if>

<%-- fdViewType: normal/simple--%>
<c:set var="_fdViewType" value="normal"></c:set>
<c:if test="${param.fdViewType!=null}">
	<c:set var="_fdViewType" value="${param.fdViewType}"/>
</c:if>

<c:set var="_extParam" value=""></c:set>
<c:if test="${param.extParam!=null}">
	<c:set var="_extParam" value="${param.extParam}"/>
</c:if>

<script type="text/javascript">
	require(["dojo/topic",
	     	"dijit/registry",
	     	"sys/attachment/mobile/js/AttachmentEditListItem"], 
	     	function(topic , registry , AttachmentListItem){
				topic.subscribe("attachmentObject_${_fdKey}_addItem",function(srcObj,evt){
					var tmpFile = evt.file;
					var attList = registry.byId('_attlist_${_fdKey}');
					var childLen = attList.getChildren().length;
					if(childLen>0){	
						attList.addChild(new AttachmentListItem(tmpFile),childLen-1);
					}else{
						attList.addChild(new AttachmentListItem(tmpFile));
					}
					topic.publish("/mui/list/resize");
				});
		});
	if(!window._attachment_extParam)
		window._attachment_extParam = {};
	window._attachment_extParam['${_fdKey}'] = "${_extParam}";
</script>

	<div id="_attlist_${_fdKey}"
		data-dojo-type="sys/attachment/mobile/js/AttachmentList"
		data-dojo-props="fdKey:'${_fdKey}',fdModelName:'${_fdModelName}',fdModelId:'${_fdModelId}',viewType:'${_fdViewType}',required:${_fdRequired},editMode:'edit',extParam:_attachment_extParam['${_fdKey }']">
		<c:forEach var="sysAttMain" items="${attForms.attachments}" varStatus="vsStatus">
			<c:set var="downLoadUrl" value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}" />
			<c:if test="${_downLoadNoRight==true || _downLoadNoRight=='true'}">
				<c:set var="downLoadUrl" value="/third/pda/attdownload.jsp?fdId=${sysAttMain.fdId}" />
			</c:if>
			<div data-dojo-type="sys/attachment/mobile/js/AttachmentEditListItem" 
				data-dojo-props="name:'${sysAttMain.fdFileName}',
					size:'${sysAttMain.fdSize}',
					href:'${downLoadUrl}',
					fdId:'${sysAttMain.fdId}',
					type:'${sysAttMain.fdContentType}'">
			</div>
		</c:forEach>
		<div data-dojo-type="sys/attachment/mobile/js/AttachmentOptListItem">
		</div>
	</div>