<%@ page language="java" contentType="text/json; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImissiveAttTrack" list="${queryPage.list }">
		<%--ID--%> 
		<list:data-column property="fdId"></list:data-column>
		<%--名称--%>
		<list:data-column col="fdNodeName" title="节点名称"  escape="false">
		    <c:out value="${kmImissiveAttTrack.fdNodeName}"/>
		</list:data-column>
		<list:data-column headerStyle="width:40px" col="docCreator.fdName" title="执行人" escape="false">
		   <ui:person personId="${kmImissiveAttTrack.docCreator.fdId}" personName="${kmImissiveAttTrack.docCreator.fdName}"></ui:person> 
		</list:data-column>
		<list:data-column headerStyle="width:150px"  col="docCreateTime" title="执行时间">
		    <kmss:showDate value="${kmImissiveAttTrack.docCreateTime}" type="datetime" />
		</list:data-column>
		<list:data-column col="fileType" headerStyle="width:150px" title="文件类型"  escape="false">
			<sunbor:enumsShow value="${kmImissiveAttTrack.fileType}" enumsType="kmImissiveAttTrack_fileType" bundle="km-imissive" />
		</list:data-column>
		<list:data-column col="fileName"  title="文件名称"  escape="false">
		    <a class="com_btn_link"  href="javascript:void(0)" onclick="openfile('${kmImissiveAttTrack.fileId}')">
		       <c:out value="${kmImissiveAttTrack.fileName}"/>
		    </a>
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>