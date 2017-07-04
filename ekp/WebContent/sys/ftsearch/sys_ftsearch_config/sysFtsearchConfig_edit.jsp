<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<script type="text/javascript"> 
//Com_SetWindowTitle('<bean:message bundle="sys-ftsearch-db" key="search.moduleName" />');
    //全选
	function selectAll(){		
		var entriesCount = parseInt(document.getElementsByName("entriesCount")[0].value);
		var checkAll = document.getElementById("checkBoxAll");
		if(checkAll.getAttribute("value")=="<bean:message bundle='sys-ftsearch-db' key='search.moduleSelect.selectAll'/>"){
			for(var i=0;i<entriesCount;i++){
				document.getElementsByName("element"+i)[0].checked='checked';
			}
			checkAll.setAttribute("value","<bean:message bundle='sys-ftsearch-db' key='search.moduleSelect.disSelect'/>");
		}
		else {
			for(var i=0;i<entriesCount;i++){
				document.getElementsByName("element"+i)[0].checked='';
			}
			//checkAll.innerHTML="<bean:message bundle='sys-ftsearch-db' key='search.moduleSelect.selectAll'/>";
			checkAll.setAttribute("value","<bean:message bundle='sys-ftsearch-db' key='search.moduleSelect.selectAll'/>");
			}
	}
	//单个的选择
	function selectElement(element){
		var checkAll=document.getElementById("checkBoxAll");
		var flag=true;
		var entriesCount=parseInt(document.getElementsByName("entriesCount")[0].value);
		if(!element.checked){
			//checkAll.innerHTML='<bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.selectAll"/>';
			checkAll.setAttribute("value",'<bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.selectAll"/>');
			document.getElementsByName("checkAllElement")[0].checked=false;
			}
		else if(element.checked){			
			for(var i=0;i<entriesCount;i++){
				if(!document.getElementsByName("element"+i)[0].checked){
					flag=false;
				}
			}
			if(flag){
				//checkAll.innerHTML='<bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.disSelect"/>';
				checkAll.setAttribute("value",'<bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.disSelect"/>');
				document.getElementsByName("checkAllElement")[0].checked=true;
			}
		} 
	}
	function MySubmit(){
		var  ftSearchName="";
		var entriesCount=parseInt(document.getElementsByName("entriesCount")[0].value);
		for(var i=0;i<entriesCount;i++){
			if(document.getElementsByName("element"+i)[0].checked){
				ftSearchName+=document.getElementsByName("element"+i)[0].value;
				ftSearchName+=";";
			}
		}
		ftSearchName = ftSearchName.substring(0,ftSearchName.length-1);
		document.getElementsByName('ftSearchModelName')[0].value=ftSearchName;
		 
		var   myForm=document.forms['sysFtsearchConfigForm'];		 		
		myForm.action='<c:url value="/sys/ftsearch/sys_ftsearch_config/sysFtsearchConfig.do" />'+'?method=update ';
  		myForm.method='POST';   
  		myForm.submit(); 		
	}
</script>
<html:form action="/sys/ftsearch/sys_ftsearch_config/sysFtsearchConfig.do" >

<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
		onclick="MySubmit()">
</div>
<p class="txttitle"><bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.set"/></p>
<center>
<table width=80% border=0>
	 <tr>			 
		<td>		
			<label>
				<input type="checkbox"  onclick="selectAll()" name='checkAllElement'>
				<span id='checkBoxAll' value='<bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.selectAll"/>'  style="color: red" >
				<bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.selectAll"/>
				</span>
			</label>
		</td>
	</tr>
</table>
<table class="tb_normal" width=80%>
	<input type='hidden'  name ='ftSearchModelName'  />	 
	<input type='hidden'  name ='entriesCount'  value='${entriesCount}' />
	<c:forEach items="${ftsearchModelName}" var="element" varStatus="status">
		<c:choose>
			<c:when test="${status.first}">
				<tr>
				<td width=25%>
					<label>
						<input name='element${status.index}' type="checkbox" ${element['flag']?"checked":""} 
						 onclick="selectElement(this)"  value='${element['modelName']}'> 
						${element['title']}
					</label>
				 </td>
			</c:when>
			<c:otherwise>
				<td width=25%>
				<label>
					<input name='element${status.index}' type="checkbox" ${element['flag']?"checked":""} 
					 onclick="selectElement(this)" value='${element['modelName']}'> 
					${element['title']} 
				</label>
				</td>
			</c:otherwise>
		</c:choose>
		<c:if test="${(status.index + 1) % 4 eq 0}">
			</tr>
			<c:if test="${(entriesCount-1-status.index) ne 0}">
			<tr>
			</c:if>					
		</c:if>
		</c:forEach>			
		<c:if test="${entriesCount % 4 ne 0}">
			<c:if test="${entriesCount %  4  eq 1}">
				<td width=25%>&nbsp;</td><td width=25%>&nbsp;</td><td width=25%>&nbsp;</td>
			</c:if>  
			<c:if test="${entriesCount%  4  eq 2}">
				<td width=25%>&nbsp;</td><td width=25%>&nbsp;</td>
			</c:if>
			<c:if test="${entriesCount%  4  eq 3}">
				<td width=25%>&nbsp;</td>
			</c:if>
			</tr>
		</c:if>
</table> 
<table width=80%>
<tr>
	<td>
		<span style="color: red">
			<bean:message bundle="sys-ftsearch-db" key="ftsearch.conditionToLong.configNote" />
		</span>
	</td>
</tr>
</table>	
</center>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>