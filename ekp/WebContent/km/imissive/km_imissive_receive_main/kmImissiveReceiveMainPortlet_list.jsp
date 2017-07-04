<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImissiveReceiveMain" list="${queryPage.list }"> 
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="docSubject" title="${ lfn:message('km-imissive:kmImissiveReceiveMain.docSubject') }" style="text-align:left" escape="false">
		   <a class="com_subject" title="${kmImissiveReceiveMain.docSubject}" href="${LUI_ContextPath}/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=view&fdId=kmImissiveReceiveMainin.fdId}" target="_blank">
			   <c:out value="${kmImissiveReceiveMain.docSubject}"/>
			</a>
		</list:data-column>
	      <list:data-column headerClass="width80" styleClass="width80" col="fdReceiveTime" title="${ lfn:message('km-imissive:kmImissiveReceiveMain.fdReceiveTime') }">
	         <kmss:showDate value="${kmImissiveReceiveMain.fdReceiveTime}" type="date" />
		  </list:data-column>
		  <list:data-column headerClass="width60" styleClass="width60" col="fdSendtoUnit.fdName" title="${ lfn:message('km-imissive:kmImissiveReceiveMain.fdSendtoDept') }">
		   <c:out value="${kmImissiveReceiveMain.fdSendtoUnit.fdName}" /><c:out value="${kmImissiveReceiveMain.fdOutSendto}" />
		  </list:data-column>
		  <list:data-column headerClass="width120" styleClass="width120" property="fdReceiveNum" title="${ lfn:message('km-imissive:kmImissiveReceiveMain.fdReceiveNum') }">
		  </list:data-column>
		<list:data-column headerClass="width60" styleClass="width60" col="docStatus" title="${ lfn:message('km-imissive:kmImissiveReceiveMain.docStatus') }">
			<sunbor:enumsShow
				value="${kmImissiveReceiveMain.docStatus}"
				enumsType="common_status" />
		</list:data-column> 
	</list:data-columns>
</list:data>

