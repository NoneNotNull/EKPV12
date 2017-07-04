<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
	Com_IncludeFile("dialog.js", null, "js");
	function checkChg(){
		var tabObj = document.getElementById("deletingTab");
		var count=tabObj.rows.length;
		if(count<=1){
			alert('<bean:message bundle="sys-attachment" key="sysAttCatalog.delete.alert1"/>');
			return false;
		}
		for(var i=0;i < count-1 ;i++){
			var valObj =  document.getElementById("changeIds["+i+"]");
			if(valObj!=null && valObj.value==""){
				alert('<bean:message bundle="sys-attachment" key="sysAttCatalog.delete.alert2"/>'.replace('{0}',(i+1)));
				return false;
			}
		}
		return true;
	}
</script>
	<center>
		<p class="txttitle"><bean:message bundle="sys-attachment" key="sysAttCatalog.delete.title"/></p>
		<div><bean:message bundle="sys-attachment" key="sysAttCatalog.delete.prompt"/></div>
		<br/>
		<html:form action="/sys/attachment/sys_att_catalog/sysAttCatalog.do?method=updateCataFile" onsubmit="return checkChg();">
			<table class="tb_normal" style="width:80%" id="deletingTab">
				<tr class="tr_normal_title">
					<td width="40%"><bean:message bundle="sys-attachment" key="sysAttCatalog.delete.tab1"/></td>
					<td width="20%"><bean:message bundle="sys-attachment" key="sysAttCatalog.delete.tab2"/></td>
					<td width="40%"><bean:message bundle="sys-attachment" key="sysAttCatalog.delete.tab3"/></td>
				</tr>
				<c:forEach var="catalogObj" items="${deletingList}" varStatus="vstatus">
					<tr style="text-align: center;">
						<td>
							${catalogObj[1]}
							<input type="hidden" name="checkIds[${vstatus.index}]" value="${catalogObj[0]}"/>
						</td>
						<td>${catalogObj[2]}</td>
						<td>
							<input type="hidden" name="changeIds[${vstatus.index}]"/>
							<input class="inputsgl" type="text" style="width: 75%" 
								name="changeNames[${vstatus.index}]" readonly="readonly"/>
							<a href="#" onclick="Dialog_Tree(false,'changeIds[${vstatus.index}]','changeNames[${vstatus.index}]',null,'sysAttCatalogService&fdCurrentIds=${currentIds}','<bean:message bundle="sys-attachment" key="sysAttCatalog.delete.select"/>', false, null);">
								<bean:message key="button.select"/></a>
						</td>
					</tr>
				</c:forEach>
			</table>
			<br/>
			<div>
				<input type="submit" class="btnopt"  value='<bean:message bundle="sys-attachment" key="sysAttCatalog.delete.submit"/>' />&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" class="btnopt" value='<bean:message key="button.back"/>' onclick="window.history.go(-1);"/>									
			</div>
		</html:form>
		<br/>
		<div class="txtstrong"><bean:message bundle="sys-attachment" key="sysAttCatalog.delete.warn"/></div>
	</center>
	
<%@ include file="/resource/jsp/edit_down.jsp"%>