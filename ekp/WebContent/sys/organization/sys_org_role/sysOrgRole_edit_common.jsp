<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<style>
	.chart_td{
		width:30px;
		height:30px;
		text-align:center;
		vertical-align:middle;
	}
</style>
<script type="text/javascript">
//切换为普通模式
function change2CommonModel(fource){
	var success = false;
	var query = "?"+fdParameter.value;
	var type = Com_GetUrlParameter(query, "type");
	var level = parseInt(Com_GetUrlParameter(query, "level"));
	var endlevel = parseInt(Com_GetUrlParameter(query, "endlevel"));
	var groupId = Com_GetUrlParameter(query, "groupId");
	var isMultipleValue = Com_GetUrlParameter(query, "isMultiple");
	
	if("sysOrgPlugin_Leader" == fdPlugin.value){
		fdType.value = 0;
		refreshListbox(fdType.value);
		if("includeme" == type) {
			fdIncludeme.checked = true;
		} else {
			fdIncludeme.checked = false;
		}
		
		if(!isNaN(level) && Math.abs(level)<6 && (isNaN(endlevel) || Math.abs(endlevel)<6)){
		   fdLevel.value = level;
		   if(isNaN(endlevel)) {
			   fdEndLevel.disabled = true;
		   } else {
			   fdEndLevel.value = endlevel;
			   fdType.value = 1;
		   }
	       success = true;
		}
	} else if("sysOrgPlugin_Self" == fdPlugin.value) {
		fdType.value = 2;
		refreshListbox(fdType.value);
		fdLevel.value = 0;
		fdEndLevel.value = 0;
		success = true;	
	} else if("sysOrgPlugin_Member" == fdPlugin.value) {
		fdType.value = 3;
		refreshListbox(fdType.value);
		if(!isNaN(level) && Math.abs(level)<6 && (isNaN(endlevel) || Math.abs(endlevel)<6)){
		   fdLevel.value = level;
		   if(isNaN(endlevel)) {
			   fdEndLevel.value = level;
		   } else {
			   fdEndLevel.value = endlevel;
		   }
	       success = true;
		}
	} else if("sysOrgPlugin_Group" == fdPlugin.value) {
		fdType.value = 4;
		if("true" == isMultipleValue) {
			document.getElementsByName("fdGroupRtnVal")[0].checked = true;
		} else {
			document.getElementsByName("fdGroupRtnVal")[1].checked = true;
		}
		refreshListbox(fdType.value);
	    fdGroupId.value = groupId;
	    fdRange.value = parseInt(type);

	    var url = "sysOrgGroupService&groupId=" + fdGroupId.value;
		var data = new KMSSData().AddBeanData(url).GetHashMapArray();
	    if (data && data[0]) {
	    	if(data[0].key0) {
	    		document.getElementsByName("fdGroupName")[0].value = data[0].key0;
			}
		}
		
	    success = true;
	}

	if(fource || success){
		changeDisplay(0);
		setStyle();
	}else{
		changeDisplay(1);
	}
}

//切换为编程模式
function chenge2CodeModel(){
	var parameter;
    if(0 == fdType.value || 1 == fdType.value) {
    	fdPlugin.value = "sysOrgPlugin_Leader";
    	parameter = "type=";
    	if(fdIncludeme.checked) {
    		parameter += "includeme";
    	} else {
    		parameter += "excludeme";
        }
    	parameter += "&level=" + fdLevel.value; 
    	if(!fdEndLevel.disabled)
            parameter += "&endlevel=" + fdEndLevel.value;
    	fdParameter.value = parameter;	
    } else if(2 == fdType.value) {
    	fdPlugin.value = "sysOrgPlugin_Self";
    	fdParameter.value = "";
    } else if(3 == fdType.value) {
    	fdPlugin.value = "sysOrgPlugin_Member";
    	parameter = "level=" + fdLevel.value;
        parameter += "&endlevel=" + fdEndLevel.value;
    	fdParameter.value = parameter;	    	
    } else if(4 == fdType.value) {
    	fdPlugin.value = "sysOrgPlugin_Group";
    	parameter = "groupId=" + fdGroupId.value;
    	parameter += "&type=" + fdRange.value;

		if(document.getElementsByName("fdGroupRtnVal")[0].checked) {
			parameter += "&isMultiple=true";
		} else {
			parameter += "&isMultiple=false";
		}
    	fdParameter.value = parameter;	  	
    }

	switch(fdType.value){
	case "0":
	case "2":
	case "4":
		fdIsMultiple.checked = false;
		fdOrg.checked = false;
		fdDept.checked = false;
	break;
	case "1":
	case "3":		
		fdIsMultiple.checked = true;
		fdOrg.checked = false;
		fdDept.checked = false;
	}
	fdPost.checked = true;
	fdPerson.checked = true;
	changeDisplay(1);
}

//根据模式显示信息
function changeDisplay(model){
	commonModel.style.display = model==0?"":"none";
	codeModel.style.display = model==0?"none":"";
	document.getElementsByName("fdDefineModel")[model].checked = true;
}

function refreshChart(){	
	var type = fdType.value;
	setStyle();
	refreshListbox(type);

	if("4" == type) {
		if(document.getElementsByName("fdGroupRtnVal")[0].checked) {
			fdIsMultiple.checked = true;
		} else {
			fdIsMultiple.checked = false;
		}
	}
}

function setStyle() {
	var type = fdType.value;
	SPAN_To.style.display = (type=="1" || type=="3")?"":"none";
	SPAN_Param.style.display = (type=="0" || type=="1" || type=="3")?"":"none";
	TR_includeme.style.display = (type=="0" || type=="1")?"":"none";
	TR_range.style.display = type=="4"?"":"none";
	TR_rtnVal.style.display = type=="4"?"none":"";
	TR_group_rtnVal.style.display = type=="4"?"":"none";
	SPAN_Group.style.display = type=="4"?"":"none";
	fdEndLevel.disabled = type=="0"?true:false;	
}

function checkGroup() {
	if("4" == fdType.value && (fdGroupId.value == null || fdGroupId.value == "")) {
        alert('<bean:message  bundle="sys-organization" key="sysOrgRole.common.group.notnull"/>');
        return false;
	}	

	return true;
}

function refreshListbox(type) {
	if("0" == type || "1" == type){
		updateListbox();		
	} else {
		restoreListbox();
	}
}

function updateListbox() {
	if(isExitItem(fdLevel)) {
	    for (var i = 0; i < fdLevel.options.length; i++) {
		    if('<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.me" />' == fdLevel.options[i].text) 
		    	fdLevel.options.remove(i); 
	    	if(fdLevel.options[i].value > 0)               
	    	   fdLevel.options[i].value--;        
	    }
	}
	
	if(isExitItem(fdEndLevel)) {
	    for (var i = 0; i < fdEndLevel.options.length; i++) {  
		    if('<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.me" />' == fdEndLevel.options[i].text) 
		    	fdEndLevel.options.remove(i); 		     
	    	if(fdEndLevel.options[i].value > 0)              
	    	    fdEndLevel.options[i].value--;        
	    }
	}  
}

function restoreListbox() {
    var item1 = new Option('<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.me" />',0);      

	if(!isExitItem(fdLevel)) {
	    fdLevel.options.add(item1, 0);  
	    for (var i = 1; i < fdLevel.options.length; i++) { 
		    if(fdLevel.options[i].value > 0)             
	    	    fdLevel.options[i].value++;        
	    }
	}  
	  
    var item2 = new Option('<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.me" />',0);      
	if(!isExitItem(fdEndLevel)) {
	    fdEndLevel.options.add(item2, 0);  
	    for (var i = 1; i < fdEndLevel.options.length; i++) {    
	    	if(fdEndLevel.options[i].value > 0)          
	    	    fdEndLevel.options[i].value++;        
	    }
	}
}

function isExitItem(objSelect) {        
    var isExist = false;        
    for (var i = 0; i < objSelect.options.length; i++) {        
        if (objSelect.options[i].text == '<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.me" />') {        
            isExist = true;        
            break;        
        }        
    }        

    return isExist;        
}    


function getPosition(level){
	var l = parseInt(level);
	if(l==0)
		return 10;
	if(l<0)
		return l+1;
	return 10 - l;
}
/*
function refreshMark(){
	var tr = TABLE_Chart.rows[2];
	DIV_Mark.style.width = 32;
	DIV_Mark.style.height = TABLE_Chart.clientHeight;
	var top = 0;
	var left = 0;
	for(var obj = TABLE_Chart.rows[0].cells[10]; obj!=null; obj=obj.offsetParent){
		top += obj.offsetTop;
		left += obj.offsetLeft;
	}
	DIV_Mark.style.top = top;
	DIV_Mark.style.left = left;
	DIV_Mark.style.display = "";
}
*/
//提交表单
function submitForm(method){
	if(!validateSysOrgRoleForm(document.sysOrgRoleForm))
		return;
	if(document.getElementsByName("fdDefineModel")[0].checked)
		chenge2CodeModel();
	if(!checkGroup()) {
        return false;
	}	
	var value = 0;
	if(fdOrg.checked)
		value |= 1;
	if(fdDept.checked)
		value |= 2;
	if(fdPost.checked)
		value |= 4;
	if(fdPerson.checked)
		value |= 8;
	fdRtnValue.value = value;
	Com_Submit(document.sysOrgRoleForm, method);
}

window.onload = function (){
	//定义全局变量
	fdLevel = document.getElementsByName("fdLevel")[0];
	fdEndLevel = document.getElementsByName("fdEndLevel")[0];
	fdType = document.getElementsByName("fdType")[0];
	fdIncludeme = document.getElementsByName("fdIncludeme")[0];
	fdGroupId = document.getElementsByName("fdGroupId")[0];	
	fdRange = document.getElementsByName("fdRange")[0];	
	fdPlugin = document.getElementsByName("fdPlugin")[0];
	fdParameter = document.getElementsByName("fdParameter")[0];
	fdRtnValue = document.getElementsByName("fdRtnValue")[0];
	
	fdIsMultiple = document.getElementsByName("fdIsMultiple")[0];
	fdOrg = document.getElementsByName("fdOrg")[0];
	fdDept = document.getElementsByName("fdDept")[0];
	fdPost = document.getElementsByName("fdPost")[0];
	fdPerson = document.getElementsByName("fdPerson")[0];

	//重载复选框的值
	var value = parseInt(fdRtnValue.value);
	fdOrg.checked = (value & 1)>0;
	fdDept.checked = (value & 2)>0;
	fdPost.checked = (value & 4)>0;
	fdPerson.checked = (value & 8)>0;
	
	//将图片下面的字体换成列显示
	/*
	var tr = TABLE_Chart.rows[2];
	for(var i=0; i<tr.cells.length; i++){
		var text = tr.cells[i].innerText;
		var html = "";
		for(var j=0; j<text.length; j++)
			html += "<br>" + text.charAt(j);
		tr.cells[i].innerHTML = html.substring(4);
	}*/

	//尝试转换成普通模式
	change2CommonModel(false);
}
/*
window.onresize = function(){
	refreshMark();
}*/
</script>
<html:form action="/sys/organization/sys_org_role/sysOrgRole.do">
<div id="optBarDiv">
	<c:if test="${sysOrgRoleForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="submitForm('update');">
	</c:if>
	<c:if test="${sysOrgRoleForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="submitForm('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="submitForm('saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-organization" key="table.sysOrgRole"/></p>

<center>
<table class="tb_normal" width="650px">
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message  bundle="sys-organization" key="sysOrgRole.fdName"/>
		</td><td width=80%>
			<html:text property="fdName" style="width:65%"/><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message  bundle="sys-organization" key="sysOrgRole.fdOrder"/>
		</td><td width=80%>
			<html:text property="fdOrder" style="width:65%"/>
		</td>
	</tr>
	<c:if test="${sysOrgRoleForm.method_GET=='edit'}">
		<tr>
			<td class="td_normal_title" width=20%>
				<bean:message  bundle="sys-organization" key="sysOrgRole.fdIsAvailable"/>
			</td><td width=80%>
				<sunbor:enums property="fdIsAvailable" enumsType="common_yesno" elementType="radio" />
			</td>
		</tr>
	</c:if>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message  bundle="sys-organization" key="sysOrgRole.fdDefineModel"/>
		</td><td width=80%>
			<label>
				<input type="radio" name="fdDefineModel" value="0" onclick="change2CommonModel(true);">
				<bean:message  bundle="sys-organization" key="sysOrgRole.fdDefineModel.common"/>
			</label>
			<label>
				<input type="radio" name="fdDefineModel" value="1" onclick="chenge2CodeModel();">
				<bean:message  bundle="sys-organization" key="sysOrgRole.fdDefineModel.code"/>
			</label>
		</td>
	</tr>	
	<!-- 常用模式 -->
	<tbody id="commonModel">
		<tr>
			<td class="td_normal_title" width=20%>
				<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.value"/>
			</td><td width=80%>
				<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.type"/>
				<select name="fdType" onchange="refreshChart();">
					<c:forEach var="i" begin="0" end="4" step="1"> 
						<option value="${i}">
							<bean:message  bundle="sys-organization" key="sysOrgRole.common.post.type${i}" />
						</option>
					</c:forEach>
				</select>			
				<span id="SPAN_Param">					
				<bean:message  bundle="sys-organization" key="sysOrgRole.common.member.position"/>				
				<span id="SPAN_From">
					<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.position.from"/>
				</span>
				<select name="fdLevel" onchange="refreshChart();">
					<option value="0">
						<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.me" />
					</option>
					<c:forEach var="i" begin="1" end="5" step="1"> 
						<option value="${i}">
							<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.up" arg0="${i}"/>
						</option>
					</c:forEach>
					<c:forEach var="i" begin="1" end="5" step="1"> 
						<option value="-${i}">
							<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.down" arg0="${i}"/>
						</option>
					</c:forEach>
				</select>
				<span id="SPAN_To">
					<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.position.to"/>
					<select name="fdEndLevel" onchange="refreshChart();">
						<option value="0">
							<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.me" />
						</option>
						<c:forEach var="i" begin="1" end="5" step="1"> 
							<option value="${i}">
								<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.up" arg0="${i}"/>
							</option>
						</c:forEach>
						<c:forEach var="i" begin="1" end="5" step="1"> 
							<option value="-${i}">
								<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.down" arg0="${i}"/>
							</option>
						</c:forEach>
					</select>
				</span>
				</span>
			</td>
		</tr>
<%-- 		<tr id="TR_Chart">
			<td class="td_normal_title" width=20%>
				<bean:message  bundle="sys-organization" key="sysOrgRole.common.sample"/>
			</td>
			<td width=80%>
				<table id="TABLE_Chart" class="tb_noborder" style="background-image: url(<c:url value="/sys/organization/resource/image/roleline_bg.gif" />);background-repeat: repeat-x;background-position: 16px 16px;">
					<tr>
						<td class="chart_td" style="background-color: #FFFFFF"></td>
						<c:forEach var="i" begin="1" end="12" step="1"> 
							<td class="chart_td"><img id="img_colleague_${i}"></td>
						</c:forEach>
					</tr>
					<tr>
						<c:forEach var="i" begin="0" end="12" step="1"> 
							<td class="chart_td"><img id="img_leader_${i}"></td>
						</c:forEach>
					</tr>
					<tr style="text-align:center;">
						<c:forEach var="i" begin="1" end="5" step="1"> 
							<td>
								<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.down" arg0="${i}"/>
							</td>
						</c:forEach>
						<c:forEach var="i" begin="1" end="5" step="1"> 
							<td>
								<bean:message bundle="sys-organization" key="sysOrgRole.common.calculate.level.up" arg0="${6-i}"/>
							</td>
						</c:forEach>
						<td>
							<bean:message bundle="sys-organization" key="sysOrgRole.common.calculate.level.me"/>
						</td>
						<td colspan="2">
							<bean:message bundle="sys-organization" key="sysOrgRole.common.calculate.level.children"/>
						</td>
					</tr>
				</table><br>
				<bean:message  bundle="sys-organization" key="sysOrgRole.common.note"/>
				<div id="DIV_Mark" class="div_mark" style="display: none;">&nbsp;</div>
			</td>
		</tr>   --%>
		<tr id="TR_includeme">
			<td class="td_normal_title" width=20%>
				<bean:message bundle="sys-organization" key="sysOrgRole.common.calculate.includeme"/>
			</td><td width=80%>
				<label><input type="checkbox" name="fdIncludeme" /><bean:message key="message.yes"/></label>
				<bean:message bundle="sys-organization" key="sysOrgRole.common.calculate.includeme.note"/>
			</td>
		</tr>			
		<tr id="SPAN_Group">
			<td class="td_normal_title" width=20%>
				<bean:message  bundle="sys-organization" key="sysOrgRole.common.group"/>
			</td><td width=80%>
			    <input name="fdGroupId" type="hidden">
				<input name="fdGroupName" type="text" style="width:55%" class="inputsgl" readonly>
			    <a href="#" onclick="Dialog_Address(false, 'fdGroupId', 'fdGroupName', null, ORG_TYPE_GROUP);">
				    <bean:message key="dialog.selectOrg"/>
			    </a>				
			</td>
		</tr>		
		<tr id="TR_range">
			<td class="td_normal_title" width=20%>
				<bean:message bundle="sys-organization" key="sysOrgRole.common.range"/>
			</td><td width=80%>
				<select name="fdRange">
					<c:forEach var="i" begin="0" end="6" step="1"> 
						<option value="${i}">
							<bean:message bundle="sys-organization" key="sysOrgRole.common.range${i}" />
						</option>
					</c:forEach>
				</select>			
			</td>
		</tr>
		<tr id="TR_group_rtnVal">
			<td class="td_normal_title" width=20%>
				<bean:message bundle="sys-organization" key="sysOrgRole.fdRtnValue"/>
			</td><td width=80%>
				<label><input type="radio" name="fdGroupRtnVal" value="0"/><bean:message bundle="sys-organization" key="sysOrgRole.common.group.multi"/></label><br>
				<label><input type="radio" name="fdGroupRtnVal" value="1" checked /><bean:message bundle="sys-organization" key="sysOrgRole.common.group.single"/></label>
			</td>
		</tr>				
	</tbody>
	<!-- 编程模式 -->
	<tbody id="codeModel">
		<tr>
			<td class="td_normal_title" width=20%>
				<bean:message  bundle="sys-organization" key="sysOrgRole.fdPlugin"/>
			</td><td width=80%>
				<html:text property="fdPlugin" style="width:85%"/><span class="txtstrong">*</span>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=20%>
				<bean:message  bundle="sys-organization" key="sysOrgRole.fdParameter"/>
			</td><td width=80%>
				<html:text property="fdParameter" style="width:85%"/><span class="txtstrong">*</span>
			</td>
		</tr>
		<tr id="TR_rtnVal">
			<td class="td_normal_title" width=20%>
				<bean:message  bundle="sys-organization" key="sysOrgRole.fdRtnValue"/>
			</td><td width=80%>
				<html:hidden property="fdRtnValue" />
				<label><html:checkbox property="fdIsMultiple" value="1"/><bean:message  bundle="sys-organization" key="sysOrgRole.fdIsMultiple"/></label>
				<label><input type="checkbox" name="fdOrg" value="1"/><bean:message  bundle="sys-organization" key="sysOrgElement.org"/></label>
				<label><input type="checkbox" name="fdDept" value="2"/><bean:message  bundle="sys-organization" key="sysOrgElement.dept"/></label>
				<label><input type="checkbox" name="fdPost" value="4"/><bean:message  bundle="sys-organization" key="sysOrgElement.post"/></label>
				<label><input type="checkbox" name="fdPerson" value="8"/><bean:message  bundle="sys-organization" key="sysOrgElement.person"/></label>
			</td>
		</tr>
	</tbody>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message  bundle="sys-organization" key="sysOrgRole.fdDescription"/>
		</td><td width=80%>
			<html:textarea style="width:100%" property="fdMemo"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help"/>
		</td><td width=80%>
			<bean:message  bundle="sys-organization" key="sysOrgRole.common.help.text1"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRole.common.help.text2"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRole.common.help.text3"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRole.common.help.text4"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRole.common.help.text5"/>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
<html:hidden property="fdId"/>
</html:form>
<script>Com_IncludeFile("jquery.js|data.js|dialog.js");</script>
<html:javascript formName="sysOrgRoleForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>