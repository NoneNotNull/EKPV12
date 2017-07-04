<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<style>
	.chart_td{
		width:30px;
		height:30px;
		text-align:center;
		vertical-align:middle;
	}
	.div_mark {
		border: 1px solid #FF0000;
		position: absolute;
	}
</style>
<script type="text/javascript">
//切换为普通模式
function change2CommonModel(fource){
	var success = false;
	if(fdPlugin.value == "sysOrgRolePluginService"){
		var query = "?"+fdParameter.value;
		var type = parseInt(Com_GetUrlParameter(query, "type"));
		var level = parseInt(Com_GetUrlParameter(query, "level"));
		var end = parseInt(Com_GetUrlParameter(query, "end"));
		var includeme = Com_GetUrlParameter(query, "includeme");
		var location = Com_GetUrlParameter(query, "location");
		if(!isNaN(type) && type>=0 && type<=3 && !isNaN(level) && Math.abs(level)<6 && 
				(type!=1 || type==1 && !isNaN(end) && Math.abs(end)<6)
				){
			fdType.value = type;
			fdLevel.value = level;
			if(type==1)
				fdEndLevel.value = end;
			if("true"==includeme) {
				fdIncludeme.checked = true;
			} else {
				fdIncludeme.checked = false;
			}
			if(location=="1"){
				fdLocation[1].checked = true;
			}else{
				fdLocation[0].checked = true;
			}
			success = true;
		}
	}
	if(fource || success){
		changeDisplay(0);
		refreshChart();
	}else{
		changeDisplay(1);
	}
}

//切换为编程模式
function chenge2CodeModel(){
	fdPlugin.value = "sysOrgRolePluginService";
	var parameter = "type=" + fdType.value;
	parameter += "&level=" + fdLevel.value;
	if(fdType.value=="1")
		parameter += "&end=" + fdEndLevel.value;
	if(fdIncludeme.checked) {
		parameter += "&includeme=true";
	}
	if(fdLocation[1].checked){
		parameter += "&location=1";
	}else{
		parameter += "&location=0";
	}
	fdParameter.value = parameter;

	switch(fdType.value){
	case "0":
		fdIsMultiple.checked = false;
		fdOrg.checked = false;
		fdDept.checked = false;
	break;
	case "1":
		fdIsMultiple.checked = true;
		fdOrg.checked = false;
		fdDept.checked = false;
	break;
	case "2":
	case "3":
		fdIsMultiple.checked = true;
		fdOrg.checked = true;
		fdDept.checked = true;
	break;
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
	var img_path_select = "<c:url value="/sys/organization/resource/image/person_1.gif" />";
	var img_path_normal = "<c:url value="/sys/organization/resource/image/person_2.gif" />";
	var type = fdType.value;
	SPAN_From.style.display = type=="1"?"":"none";
	SPAN_To.style.display = type=="1"?"":"none";
	
	var s_level = getPosition(fdLevel.value);
	var e_level = s_level;
	switch(type){
	case "1":
		e_level = getPosition(fdEndLevel.value);
	break;
	case "2":
		s_level++;
		e_level = s_level;
	break;
	case "3":
		s_level++;
		e_level = 12;
	break;
	}

	if(s_level>e_level){
		var tmp = s_level;
		s_level = e_level;
		e_level = tmp;
	}
	for(var i=0; i<13; i++){
		var img = document.getElementById("img_leader_"+i);
		img.src = i>=s_level && i<=e_level?img_path_select:img_path_normal;
		if(i>0){
			img = document.getElementById("img_colleague_"+i);
			img.src = i>=s_level && i<=e_level && (type=="2" || type=="3")?img_path_select:img_path_normal;
		}
	}
	setTimeout("refreshMark()", 100);
}

function getPosition(level){
	var l = parseInt(level);
	if(l==0)
		return 10;
	if(l>0)
		return l-1;
	return 10 + l;
}

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

//提交表单
function submitForm(method){
	if(!validateSysOrgRoleForm(document.sysOrgRoleForm))
		return;
	if(document.getElementsByName("fdDefineModel")[0].checked)
		chenge2CodeModel();
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
	fdLocation = document.getElementsByName("fdLocation");
	
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
	var tr = TABLE_Chart.rows[2];
	for(var i=0; i<tr.cells.length; i++){
		var text = tr.cells[i].innerText||tr.cells[i].textContent;
		var html = "";
		for(var j=0; j<text.length; j++)
			html += "<br>" + text.charAt(j);
		tr.cells[i].innerHTML = html.substring(4);
	}

	//尝试转换成普通模式
	change2CommonModel(false);
}
window.onresize = function(){
	refreshMark();
}
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
			<bean:message  bundle="sys-organization" key="table.sysOrgRoleLine"/>
		</td><td width=80%>
			<html:hidden property="fdConfId"/>
			<html:hidden property="fdConfName"/>
			<c:out value="${sysOrgRoleForm.fdConfName}" />
		</td>
	</tr>
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
					<c:forEach var="i" begin="0" end="3" step="1"> 
						<option value="${i}">
							<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.type${i}" />
						</option>
					</c:forEach>
				</select>
				<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.position"/>
				<span id="SPAN_From">
					<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.position.from"/>
				</span>
				<select name="fdLevel" onchange="refreshChart();">
					<option value="0">
						<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.me" />
					</option>
					<c:forEach var="i" begin="1" end="5" step="1"> 
						<option value="-${i}">
							<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.up" arg0="${i}"/>
						</option>
					</c:forEach>
					<c:forEach var="i" begin="1" end="5" step="1"> 
						<option value="${i}">
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
							<option value="-${i}">
								<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.up" arg0="${i}"/>
							</option>
						</c:forEach>
						<c:forEach var="i" begin="1" end="5" step="1"> 
							<option value="${i}">
								<bean:message  bundle="sys-organization" key="sysOrgRole.common.calculate.level.down" arg0="${i}"/>
							</option>
						</c:forEach>
					</select>
				</span>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=20%>
				<bean:message bundle="sys-organization" key="sysOrgRole.common.location"/>
			</td><td width=80%>
				<label><input type="radio" name="fdLocation" value="0"/><bean:message bundle="sys-organization" key="sysOrgRole.common.location.person"/></label><br>
				<label><input type="radio" name="fdLocation" value="1"/><bean:message bundle="sys-organization" key="sysOrgRole.common.location.dept"/></label>
			</td>
		</tr>
		<tr>
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
		</tr>
		<tr>
			<td class="td_normal_title" width=20%>
				<bean:message bundle="sys-organization" key="sysOrgRole.common.calculate.includeme"/>
			</td><td width=80%>
				<label><input type="checkbox" name="fdIncludeme" /><bean:message key="message.yes"/></label>
				<bean:message bundle="sys-organization" key="sysOrgRole.common.calculate.includeme.note"/>
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
		<tr>
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
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text1"/><br><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text2"/><br><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text3"/><br>
			1）<bean:message bundle="sys-organization" key="sysOrgRole.common.location.person"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text4"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text5"/><br>
			2）<bean:message bundle="sys-organization" key="sysOrgRole.common.location.dept"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text6"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text7"/><br>
			<bean:message  bundle="sys-organization" key="sysOrgRoleConf.simulator.help.text8"/>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
<html:hidden property="fdId"/>
</html:form>
<html:javascript formName="sysOrgRoleForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>