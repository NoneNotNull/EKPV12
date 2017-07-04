<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp" %>
<style type="text/css"> 
ul, li{list-style-type: none;} 
ul{padding:1px;margin:0px 0px 0px 0px;height: 100px;width: 100%;}
li { float:left;width: 50%;}
.clear {clear:both; height: 0px;}
</style>
<center>
<table width="95%">
	<tr>	
		<td style="border-bottom: 1px solid #000 ;height: 40px;">
			<bean:message bundle="sys-relation" key="sysRelationMain.staticPage.searchDilog1" />
			<select name="modelName">
				<option value="entireSystem"><bean:message bundle="sys-relation" key="sysRelationEntry.ftsearch.entireSystem" /></option>
				<c:forEach items="${modelList}" var="element" varStatus="status">
					<option value="${element['modelName']}" <c:if test="${currModelName eq element['modelName']}"> selected="selected" </c:if>>${element['title']}</option>
				</c:forEach>
			</select>
			<bean:message bundle="sys-relation" key="sysRelationMain.staticPage.searchDilog2" /><input type="text" class="inputSgl" size="35" name="queryString"/>
			<input type="button" class="btnopt" value="<bean:message key="button.search"/>" onclick="CommitSearch();"/>
		</td>
	</tr>
	<tr>	
		<td>
			<iframe name="searchResultPage" src="<c:url value='/sys/relation/otherurl/ftsearch/searchBuilder.do?method=search&rowsize=20&forward=searchResultPage'/>" height="350px;" width="100%" scrolling="no" frameborder="0" border="0"></iframe>
		</td>
	</tr>
	<tr>	
		<td align="center">
			<input type="button" class="btnopt" value="<bean:message key="button.ok"/>" onclick="saveSelect();"/>&nbsp;&nbsp;
			<input type="reset" class="btnopt" value="<bean:message key="button.cancel" />" onclick="Com_CloseWindow();" />
		</td>
	</tr>
</table>
</center>
<script>
var dialogObject = null;
if(window.showModalDialog){
	dialogObject = window.dialogArguments;
}else{
	dialogObject = opener._static_dialog;
}
function Map(){
	 this.elements = new Array();
	 this.size=function(){
	 	return this.elements.length;
	 };
	 this.put=function(_key,_value){
	 	this.elements.push({key:_key,value:_value});
	 };

	 this.remove=function(_key){
	 var bln=false;
	 try{ 
		for(i=0;i<this.elements.length;i++){ 
			if(this.elements[i].key==_key){
	 			this.elements.splice(i,1);
	 			return true;
	 		}
		 }
	 }catch(e){
	 	bln=false; 
	 }
	 	return bln;
	 };

	 this.containsKey=function(_key){
	 	var bln=false;
	 try{ 
		for(i=0;i<this.elements.length;i++){
			if(this.elements[i].key==_key){
	 			bln=true;
	 		}
	 	}
	 }catch(e){
	 		bln=false; 
		}
	 	return bln;
	 };

	 this.get=function(_key){ 
	 	try{ 
			for(i=0;i<this.elements.length;i++){ 
				if(this.elements[i].key==_key){
	 				return this.elements[i]; 
				}
		 	}
	 	}catch(e){
	 		return null; 
		}
	 };
} 
var selectedMap = new Map();
//搜索提交
function CommitSearch(){	
	var url ='<c:url value="/sys/relation/otherurl/ftsearch/searchBuilder.do?method=search"/>';	 
	
	var queryString = document.getElementsByName("queryString")[0].value;
	if( queryString.value==''){
		alert('<bean:message bundle="sys-ftsearch-db" key="ftsearch.select.queryString" />');//请填写搜索内容
		queryString.focus();
		return false;
	}
	url = Com_SetUrlParameter(url, "queryString",queryString );
	var modelName = document.getElementsByName("modelName")[0].value;
	//如果选择了全系统，则按全系统搜索，否则按模块
	if("entireSystem" == modelName){
		url = Com_SetUrlParameter(url, "type", "1");
		url = Com_SetUrlParameter(url, "flag", "1");
	}else{
		url = Com_SetUrlParameter(url, "modelName", modelName);	
	}
	url = Com_SetUrlParameter(url, "forward", "searchResultPage");
	url = Com_SetUrlParameter(url, "rowsize", 20);
	document.getElementsByName("searchResultPage")[0].src = url;
}
//保存选择项
function saveSelect(){	
	if(selectedMap.elements.length == 0){
		window.close();
		return null;
	}
	window.dialogObject.rtnStaticData ={elements:selectedMap.elements};
	window.dialogObject.AfterShow();
	window.close();
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp" %>