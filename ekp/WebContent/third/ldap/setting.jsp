<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/config/resource/edit_top.jsp"%>
<%@ page import="com.landray.kmss.third.ldap.LdapUtil" %>

<html>
<head>
<title>LDAP系统配置</title>
<script type="text/javascript" src="${KMSS_Parameter_ResPath}js/util.js"></script>
<script>
<%=LdapUtil.getDefaultValues()%>

var LdapType = {
	"IBM Directory Server(IDS/TDS)":{tp:"yyyyMMddHHmmss.000000",mt:"modifytimestamp",unid:"ibm-entryUUID"},
	"Active Directory":{tp:"yyyyMMddHHmmss.0",mt:"whenchanged",unid:"objectGUID"},
	"SunOne":{tp:"yyyyMMddHHmmss",mt:"modifytimestamp",unid:"nsuniqueId"},
	"Novell eDirectory":{tp:"yyyyMMddHHmmss",mt:"modifytimestamp",unid:"GUID"},
	"Domino Ldap Server":{tp:"yyyyMMddHHmmss",mt:"modifytimestamp",unid:"DominoUnid"},
	"other":{tp:"yyyyMMddHHmmss",mt:"modifytimestamp",unid:"DistinguishedName"}
};

function _show(element){
	element.style.display="";
}
function _hide(element){
	element.style.display="none";
}

function _switchMode(el,ek){
	var elv = Element_GetValue($$(el.name));
	if(elv=="false"){
		_show($$(ek));
	}else{
		_hide($$(ek));
	}
}

function _switchLdapType(el,init){
	if(init){
		return;
	}
	va = Element_GetValue(el);
	Element_SetValue($$("value(kmss.ldap.config.timePattern)"),LdapType[va]["tp"]);
	Element_SetValue($$("value(kmss.ldap.type.common.prop.modifytimestamp)"),LdapType[va]["mt"]);
	Element_SetValue($$("value(kmss.ldap.type.common.prop.unid)"),LdapType[va]["unid"]);
}

function _switchTable(el,tblName){
	var tbl = $$(tblName);
	//_clearTableValues(el,tbl,true);
	for(var i=1; i<tbl.rows.length; i++){
		if(el.checked){
			_show(tbl.rows[i]);
		}else{
			_hide(tbl.rows[i]);
		}
	}
}

function _clearTableValues(el,tbl,def){
	if(!el.checked){
		var els = tbl.getElementsByTagName("INPUT");
		for(var i=0;i<els.length;i++){
			if(def){
				if(typeof _default[els[i].name]!="undefined"){
					Element_SetValue(els[i],_default[els[i].name]);
				}else{
					Element_SetValue(els[i],"");
				}
			}else{
				Element_SetValue(els[i],"");
			}
		}
	}
}

function _load(){
	_switchTable($$("value(kmss.ldap.config.auth.check)"),"authZone");
	_switchTable($$("value(kmss.ldap.config.dept.check)"),"deptZone");
	_switchTable($$("value(kmss.ldap.config.person.check)"),"personZone");
	_switchTable($$("value(kmss.ldap.config.post.check)"),"postZone");
	_switchTable($$("value(kmss.ldap.config.group.check)"),"groupZone");
	_init();
	_switchLdapType($$("value(kmss.ldap.config.ldap.type)"),true);
	_switchMode($$("value(kmss.ldap.type.dept.prop.parent.byParentDN)"),"deptObjKey");
	_switchMode($$("value(kmss.ldap.type.person.prop.dept.byParentDN)"),"personObjKey");
	_switchMode($$("value(kmss.ldap.type.post.prop.dept.byParentDN)"),"postObjKey");

	<%
	if("auth".equals(request.getParameter("type"))){
		out.println("setTimeout('_setTimeOut()',100);");;	
	}
	%>
}

function _setTimeOut(){
	Doc_SetCurrentLabel("Label_Tabel","6");
	$$("value(kmss.ldap.config.auth.check)").checked=true;
}

Com_AddEventListener(window, "load", _load);

function _init(){
	Element_SetValue($$("value(kmss.ldap.config.ldap.type)"),"${ldapSettingForm.map['kmss.ldap.config.ldap.type']}");
	Element_SetValue($$("value(kmss.ldap.type.dept.prop.parent.byParentDN)"),"${ldapSettingForm.map['kmss.ldap.type.dept.prop.parent.byParentDN']}");
	Element_SetValue($$("value(kmss.ldap.type.person.prop.dept.byParentDN)"),"${ldapSettingForm.map['kmss.ldap.type.person.prop.dept.byParentDN']}");
	Element_SetValue($$("value(kmss.ldap.type.post.prop.dept.byParentDN)"),"${ldapSettingForm.map['kmss.ldap.type.post.prop.dept.byParentDN']}");
}

function _submitForm(){
	if(_check()){
		_clearTableValues($$("value(kmss.ldap.config.auth.check)"),$$("authZone"));
		_clearTableValues($$("value(kmss.ldap.config.dept.check)"),$$("deptZone"));
		_clearTableValues($$("value(kmss.ldap.config.person.check)"),$$("personZone"));
		_clearTableValues($$("value(kmss.ldap.config.post.check)"),$$("postZone"));
		_clearTableValues($$("value(kmss.ldap.config.group.check)"),$$("groupZone"));

		$$("ldapSettingForm").submit();
	}
}

var LdapCheck={
	"setting":{
	"index":1,
	"value(kmss.ldap.config.url)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.config.url'/>"},
	"value(kmss.ldap.config.managerDN)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.config.managerDN'/>"},
	"value(kmss.ldap.config.password)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.config.password'/>"},
	"value(kmss.ldap.config.ldap.type)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.config.ldap.type'/>"},
	"value(kmss.ldap.config.timePattern)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.config.timePattern'/>"},
	"value(kmss.ldap.config.timeZone)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.config.timeZone'/>"},
	"value(kmss.ldap.type.common.prop.modifytimestamp)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.common.prop.modifytimestamp'/>"}
	},
	"value(kmss.ldap.config.dept.check)":{
		"index":2,
		"value(kmss.ldap.type.dept.baseDN)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.dept.baseDN'/>"},
		"value(kmss.ldap.type.dept.prop.name)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.name'/>"},
		"value(kmss.ldap.type.dept.prop.unid)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.unid'/>"}
	},
	"value(kmss.ldap.config.person.check)":{
		"index":3,
		"value(kmss.ldap.type.person.baseDN)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.person.baseDN'/>"},
		"value(kmss.ldap.type.person.prop.name)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.name'/>"},
		"value(kmss.ldap.type.person.prop.loginName)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.loginName'/>"},
		"value(kmss.ldap.type.person.prop.unid)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.unid'/>"}
		//,"value(kmss.ldap.type.person.prop.sex)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.sex'/>"}
	},
	"value(kmss.ldap.config.post.check)":{
		"index":4,
		"value(kmss.ldap.type.post.baseDN)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.post.baseDN'/>"},
		"value(kmss.ldap.type.post.prop.name)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.name'/>"},
		"value(kmss.ldap.type.post.prop.unid)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.unid'/>"}
	},
	"value(kmss.ldap.config.group.check)":{
		"index":5,
		"value(kmss.ldap.type.group.baseDN)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.group.baseDN'/>"},
		"value(kmss.ldap.type.group.prop.name)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.name'/>"},
		"value(kmss.ldap.type.group.prop.unid)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.unid'/>"}
	},
	"value(kmss.ldap.config.auth.check)":{
		"index":6,
		"value(kmss.ldap.type.auth.baseDN)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.config.auth.baseDN'/>"},
		"value(kmss.ldap.type.auth.prop.login)":{label:"<bean:message bundle='third-ldap' key='kmss.ldap.config.auth.login'/>"}
	}
}

function _checkUnid(name){
	if(name.indexOf(".unid")>0 && Element_GetValue($$("value(kmss.ldap.type.common.prop.unid)"))!=""){
		return true;
	}
	return false;
}

function _check(){
	for(var p in LdapCheck){
		if(p=="setting"){
			for(var pp in LdapCheck[p]){
				if(pp=="index"){
					continue;
				}
				if(Element_GetValue($$(pp))==""){
					alert(_replace("<bean:message key='errors.required'/>",LdapCheck[p][pp]["label"]));
					Doc_SetCurrentLabel("Label_Tabel",LdapCheck[p]["index"]);
					$$(pp).focus();
					return false;
				}
			}
		}else{
			if($$(p).checked){
				for(var pp in LdapCheck[p]){
					if(pp=="index"){
						continue;
					}
					if(Element_GetValue($$(pp))==""){
						if(_checkUnid(pp)){
							continue;
						}
						alert(_replace("<bean:message key='errors.required'/>",LdapCheck[p][pp]["label"]));
						Doc_SetCurrentLabel("Label_Tabel",LdapCheck[p]["index"]);
						$$(pp).focus();
						return false;
					}
				}
			}
		}
	}
	return true;
}

function _replace(msg, param1, param2, param3){
	var re;
	if(param1!=null){
		re = /\{0\}/gi;
		msg = msg.replace(re, param1);
	}
	if(param2!=null){
		re = /\{1\}/gi;
		msg = msg.replace(re, param2);
	}
	if(param3!=null){
		re = /\{2\}/gi;
		msg = msg.replace(re, param3);
	}
	return msg;
}; 

function _showSample(){
	if(confirm("<bean:message bundle='third-ldap' key='kmss.ldap.saveshow.confirm'/>")){
		$$("ldapSettingForm").action="<c:url value="/third/ldap/setting.do"/>?method=show";
		_submitForm();
	}
}

function _getPInfo(){
	var s =["value(kmss.ldap.type.person.baseDN)","value(kmss.ldap.type.person.filter)","value(kmss.ldap.type.person.prop.loginName)"]; 
	var o =["value(kmss.ldap.type.auth.baseDN)","value(kmss.ldap.type.auth.filter)","value(kmss.ldap.type.auth.prop.login)"];
	for(var i = 0;i<s.length;i++){
		Element_SetValue($$(o[i]),Element_GetValue($$(s[i])));
	}
	
}

function expandMethod(imgSrc,divSrc) {
	var imgSrcObj = document.getElementById(imgSrc);
	var divSrcObj = document.getElementById(divSrc);
	if(divSrcObj.style.display!=null && divSrcObj.style.display!="") {
		divSrcObj.style.display = "";
		imgSrcObj.src = "${KMSS_Parameter_StylePath}icons/collapse.gif";
	}else{
		divSrcObj.style.display = "none";
		imgSrcObj.src = "${KMSS_Parameter_StylePath}icons/expand.gif";		
	}
}

function _person_post_check(obj){
	var elem1 = document.getElementsByName("value(kmss.ldap.type.person.prop.post)")[0];
	var elem2 = document.getElementsByName("value(kmss.ldap.type.person.prop.post.objKey)")[0];
	if(obj.checked){
		elem1.value = "";
		elem1.readOnly = true;
		elem2.selectedIndex=0;
	}else{
		elem1.readOnly = false;
	}
}
function _post_member_check(obj){
	var elem1 = document.getElementsByName("value(kmss.ldap.type.post.prop.member)")[0];
	var elem2 = document.getElementsByName("value(kmss.ldap.type.post.prop.member.objKey)")[0];
	if(obj.checked){
		elem1.value = "";
		elem1.readOnly = true;
		elem2.selectedIndex=0;
	}else{
		elem1.readOnly = false;
	}
}
</script>

	<div id="optBarDiv">
		<input type="button" class="btnopt" value="保存" onclick="_submitForm();"/>
		<input type="button" class="btnopt" value="样本采集" onclick="_showSample();"/>
		<input type="button" class="btnopt" value="关闭" onclick="window.close();"/>
	</div>

</head>
<body>
<html:form action="/third/ldap/setting.do?method=save">
<p class="txttitle">LDAP系统配置</p>
	<center>
	<table id="Label_Tabel" width=95%>

		<!-- 基本配置 -->
		<tr
			LKS_LabelName="<bean:message bundle='third-ldap' key='kmss.ldap.config.basesetting'/>">
			<td>
			<table class="tb_normal" width=100%>
				<!--基本配置 -->
				<tr><td>
					<table class="tb_normal" width=100%>
						<tr>
							<td class="td_normal_title" colspan=2><b><bean:message bundle='third-ldap' key='kmss.ldap.config.basesetting'/></b></td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.config.url'/></td>
							<td>
								<html:text property="value(kmss.ldap.config.url)" style="width:85%"/>
								<span class="txtstrong">*</span>
								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.config.url.note'/></span>
				
								<img id="urlSrc" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('urlSrc','urlNote')" style="cursor:hand"><br>
								<div id="urlNote"  style="display:none">
									当主服务器地址不能访问的时候，系统将自动采用备选服务器地址进行连接，主服务器地址与备选服务器地址之间用;号分隔
								</div>
								
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.config.managerDN'/></td>
							<td>
								<html:text property="value(kmss.ldap.config.managerDN)" style="width:85%"/>
								<span class="txtstrong">*</span>

								<img id="managerDNImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('managerDNImg','managerDNNote')" style="cursor:hand"><br>
								<div id="managerDNNote"  style="display:none">
									管理员帐号，如：cn=root
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.config.password'/></td>
							<td>
								<html:password property="value(kmss.ldap.config.password)" styleClass="inputsgl" style="width:85%"/>
								<span class="txtstrong">*</span>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.config.ldap.type'/></td>
							<td>
								<script>
									var typeHTML = "";
									for(var p in LdapType){
										typeHTML+="<div><input type='radio' name='value(kmss.ldap.config.ldap.type)' value='"+p+"' onclick='_switchLdapType(this);'>"+p+"</div>";
									}
									document.write(typeHTML);
								</script>
								<span class="txtstrong">*</span>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.config.timePattern'/></td>
							<td>
								<html:text property="value(kmss.ldap.config.timePattern)" style="width:85%"/>
								<span class="txtstrong">*</span>

								<img id="timePatternImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('timePatternImg','timePatternNote')" style="cursor:hand"><br>
								<div id="timePatternNote"  style="display:none">
									该值一般由LDAP类型决定，选择LDAP类型的时候自动填充
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.config.timeZone'/></td>
							<td>
								<html:text property="value(kmss.ldap.config.timeZone)" style="width:85%"/>
								<span class="txtstrong">*</span>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.config.showCount'/></td>
							<td>
								<html:text property="value(kmss.ldap.config.showCount)" style="width:85%"/>

								<img id="showCountImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('showCountImg','showCountNote')" style="cursor:hand"><br>
								<div id="showCountNote"  style="display:none">
									用于样板采集操作，获取多少条样板数据
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.config.batchReadCount'/></td>
							<td>
								<html:text property="value(kmss.ldap.config.fetchsize)" style="width:85%"/>

								<img id="fetchCountImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('fetchCountImg','fetchCountNote')" style="cursor:hand"><br>
								<div id="fetchCountNote"  style="display:none">
									批次读取数据每批数量（不设置则按全部）
								</div>

							</td>
						</tr>
					</table>
					<p>				
				
					<!--全局属性 -->
					<table class="tb_normal" width=100%>
						<tr>
							<td class="td_normal_title" colspan=2><b><bean:message bundle='third-ldap' key='kmss.ldap.config.global'/></b></td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.common.prop.modifytimestamp'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.common.prop.modifytimestamp)" style="width:85%"/>
								<span class="txtstrong">*</span>

								<img id="modifytimestampImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('modifytimestampImg','modifytimestampNote')" style="cursor:hand"><br>
								<div id="modifytimestampNote"  style="display:none">
									该属性用于增量同步，一般由LDAP类型决定，选择LDAP类型的时候自动填充
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.common.prop.unid'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.common.prop.unid)" style="width:85%"/>

								<img id="unidImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('unidImg','unidNote')" style="cursor:hand"><br>
								<div id="unidNote"  style="display:none">
									该属性用于同步被删除的记录，一般由LDAP类型决定，选择LDAP类型的时候自动填充
								</div>

							</td>
						</tr>
					</table>

				</td></tr>
			</table>
			</td>
		</tr>


		<!--  部门信息 -->
		<tr
			LKS_LabelName="<bean:message bundle='third-ldap' key='kmss.ldap.config.dept'/>">
			<td>
			<table class="tb_normal" width=100%>
				<!--基本配置 -->
				<tr><td>
					<table id="deptZone" class="tb_normal" width=100%>
						<tr>
							<td class="td_normal_title" colspan=2><b>
							<label>
								<html:checkbox property="value(kmss.ldap.config.dept.check)" value="true" onclick="_switchTable(this,'deptZone');"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.config.dept.check'/>
							</label>
							</b></td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.baseDN'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.dept.baseDN)" style="width:85%"/>
								<span class="txtstrong">*</span>

								<img id="deptImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('deptImg','deptNote')" style="cursor:hand"><br>
								<div id="deptNote"  style="display:none">
									如：dc=landray,dc=com,dc=cn
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.basednisroot'/></td>
							<td>
								<html:checkbox property="value(kmss.ldap.type.dept.basednisroot)" value="true" /> 
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.filter'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.dept.filter)" style="width:85%"/>

								<img id="deptfilterImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('deptfilterImg','deptfilterNote')" style="cursor:hand"><br>
								<div id="deptfilterNote"  style="display:none">
									当基准DN下还包含其它不需要的信息的时候，可以通过筛选条件进行数据过滤，默认值为"(objectclass=*)"，不过滤数据
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.name'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.dept.prop.name)" style="width:85%"/>
								<span class="txtstrong">*</span>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.number'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.dept.prop.number)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.order'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.dept.prop.order)" style="width:85%"/>
								<br>
									<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.order.note'/></span>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.keyword'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.dept.prop.keyword)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.memo'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.dept.prop.memo)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.parent'/></td>
							<td>
								<html:hidden property="value(kmss.ldap.type.dept.prop.parent.type)"/>
								<input type="radio" name="value(kmss.ldap.type.dept.prop.parent.byParentDN)" value="true" onclick="_switchMode(this,'deptObjKey');"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.parent.type.dn'/>
								<input type="radio" name="value(kmss.ldap.type.dept.prop.parent.byParentDN)" value="false" onclick="_switchMode(this,'deptObjKey');"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.parent.type.key'/>
								<input type="radio" name="value(kmss.ldap.type.dept.prop.parent.byParentDN)" value="" onclick="_switchMode(this,'deptObjKey');">不设置
								<div id="deptObjKey">
								<bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.parent.propName'/>
								<html:text property="value(kmss.ldap.type.dept.prop.parent)" style="width:30%"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.parent.objKey'/>
								<sunbor:enums property="value(kmss.ldap.type.dept.prop.parent.objKey)" enumsType="ldap_objKey" elementType="select" bundle="third-ldap" isEmptyAllow="true"/>
								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.parent.note'/></span>
								</div>


								<img id="deptparentImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('deptparentImg','deptparentNote')" style="cursor:hand"><br>
								<div id="deptparentNote"  style="display:none">
									通过上级DN获取：用于树形结构的目录（AD目录的常用方式），如"ou=产品中心,ou=深圳蓝凌,dc=landray,dc=com,dc=cn"的上级部门的DN为"ou=深圳蓝凌,dc=landray,dc=com,dc=cn"通过关联属性获取：用于平面结构的目录，在这种情况下，子部门信息中会存储父部门的编号或其它信息，如："产品中心"的记录中，采用了departmentNumber属性，保存了"深圳蓝凌"的部门编号，此时，属性名设置为"departmentNumber"，下拉框设置为"编号
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.thisleader'/></td>
							<td>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.thisleader.propName'/>
								<html:text property="value(kmss.ldap.type.dept.prop.thisleader)" style="width:30%"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.thisleader.objKey'/>
								<sunbor:enums property="value(kmss.ldap.type.dept.prop.thisleader.objKey)" enumsType="ldap_objKey" elementType="select" bundle="third-ldap" isEmptyAllow="true"/>

								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.thisleader.note'/></span>

								<img id="deptthisleaderImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('deptthisleaderImg','deptthisleaderNote')" style="cursor:hand"><br>
								<div id="deptthisleaderNote"  style="display:none">
									用于平面结构的目录，在这种情况下，子部门信息中会存储父部门的编号或其它信息，如："产品中心"的记录中，采用了departmentNumber属性，保存了"深圳蓝凌"的部门编号，此时，属性名设置为"departmentNumber"，下拉框设置为"编号
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.superleader'/></td>
							<td>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.superleader.propName'/>
								<html:text property="value(kmss.ldap.type.dept.prop.superleader)" style="width:30%"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.superleader.objKey'/>
								<sunbor:enums property="value(kmss.ldap.type.dept.prop.superleader.objKey)" enumsType="ldap_objKey" elementType="select" bundle="third-ldap" isEmptyAllow="true"/>

								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.superleader.note'/></span>

								<img id="deptsuperleaderImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('deptsuperleaderImg','deptsuperleaderNote')" style="cursor:hand"><br>
								<div id="deptsuperleaderNote"  style="display:none">
									用于平面结构的目录，在这种情况下，子部门信息中会存储父部门的编号或其它信息，如："产品中心"的记录中，采用了departmentNumber属性，保存了"深圳蓝凌"的部门编号，此时，属性名设置为"departmentNumber"，下拉框设置为"编号"
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.unid'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.dept.prop.unid)" style="width:85%"/>
								
								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.dept.prop.unid.note'/></span>
								
								<img id="deptunidImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('deptunidImg','deptunidNote')" style="cursor:hand"><br>
								<div id="deptunidNote"  style="display:none">
									该属性用于同步被删除的记录，一般由LDAP类型决定，选择LDAP类型的时候自动填充
								</div>
								
							</td>
						</tr>
					</table>

				</td></tr>
			</table>
			</td>
		</tr>

		<!--  员工信息 -->
		<tr
			LKS_LabelName="<bean:message bundle='third-ldap' key='kmss.ldap.config.person'/>">
			<td>
			<table class="tb_normal" width=100%>
				<!--基本配置 -->
				<tr><td>
					<table id="personZone" class="tb_normal" width=100%>
						<tr>
							<td class="td_normal_title" colspan=2><b>
							<label>
								<html:checkbox property="value(kmss.ldap.config.person.check)" value="true" onclick="_switchTable(this,'personZone');"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.config.person.check'/>
							</label>
							</b></td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.baseDN'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.baseDN)" style="width:85%"/>
								<span class="txtstrong">*</span>

								<img id="personbaseDNImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('personbaseDNImg','personbaseDNNote')" style="cursor:hand"><br>
								<div id="personbaseDNNote"  style="display:none">
									如：dc=landray,dc=com,dc=cn
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.filter'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.filter)" style="width:85%"/>

								<img id="personfilterImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('personfilterImg','personfilterNote')" style="cursor:hand"><br>
								<div id="personfilterNote"  style="display:none">
									当基准DN下还包含其它不需要的信息的时候，可以通过筛选条件进行数据过滤，默认值为"(objectclass=*)"，不过滤数据"
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.name'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.name)" style="width:85%"/>
								<span class="txtstrong">*</span>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.number'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.number)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.order'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.order)" style="width:85%"/>
								<br>
									<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.order.note'/></span>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.mail'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.mail)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.mobileNo'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.mobileNo)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.workPhone'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.workPhone)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.loginName'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.loginName)" style="width:85%"/>
								<span class="txtstrong">*</span>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.password'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.password)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.lang'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.lang)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.keyword'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.keyword)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.rtx'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.rtx)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.scard'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.scard)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.memo'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.memo)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.sex'/></td>
							<td>
								<div><html:text property="value(kmss.ldap.type.person.prop.sex)" style="width:85%"/></div>
								<div>男：<html:text property="value(kmss.ldap.config.sex.m)" style="width:50%"/>(默认为：M)</div>
								<div>女：<html:text property="value(kmss.ldap.config.sex.f)" style="width:50%"/>(默认为：F)</div>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.dept'/></td>
							<td>
								<html:hidden property="value(kmss.ldap.type.person.prop.dept.type)"/>
								<input type="radio" name="value(kmss.ldap.type.person.prop.dept.byParentDN)" value="true" onclick="_switchMode(this,'personObjKey');"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.dept.type.dn'/>
								<input type="radio" name="value(kmss.ldap.type.person.prop.dept.byParentDN)" value="false" onclick="_switchMode(this,'personObjKey');"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.dept.type.key'/>
								<input type="radio" name="value(kmss.ldap.type.person.prop.dept.byParentDN)" value="" onclick="_switchMode(this,'personObjKey');">不设置
								<div id="personObjKey">
								<bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.dept.propName'/>
								<html:text property="value(kmss.ldap.type.person.prop.dept)" style="width:30%"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.dept.objKey'/>
								<sunbor:enums property="value(kmss.ldap.type.person.prop.dept.objKey)" enumsType="ldap_objKey" elementType="select" bundle="third-ldap" isEmptyAllow="true"/>
								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.dept.note'/></span>

								<img id="persondeptImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('persondeptImg','persondeptNote')" style="cursor:hand"><br>
								<div id="persondeptNote"  style="display:none">
									通过上级DN获取：用于树形结构的目录（AD目录的常用方式），如"ou=产品中心,ou=深圳蓝凌,dc=landray,dc=com,dc=cn"的上级部门的DN为"ou=深圳蓝凌,dc=landray,dc=com,dc=cn"通过关联属性获取：用于平面结构的目录，在这种情况下，子部门信息中会存储父部门的编号或其它信息，如："产品中心"的记录中，采用了departmentNumber属性，保存了"深圳蓝凌"的部门编号，此时，属性名设置为"departmentNumber"，下拉框设置为"编号"
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.post'/></td>
							<td>
								<html:checkbox property="value(kmss.ldap.type.person.prop.post.check)" onclick="_person_post_check(this)" /><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.post.check'/>
								<br>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.post.propName'/>
								<html:text property="value(kmss.ldap.type.person.prop.post)" style="width:30%"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.post.objKey'/>
								<sunbor:enums property="value(kmss.ldap.type.person.prop.post.objKey)" enumsType="ldap_objKey" elementType="select" bundle="third-ldap" isEmptyAllow="true"/>

								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.post.note'/></span>

								<img id="personpostImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('personpostImg','personpostNote')" style="cursor:hand"><br>
								<div id="personpostNote"  style="display:none">
									用于平面结构的目录，在这种情况下，子部门信息中会存储父部门的编号或其它信息，如："产品中心"的记录中，采用了departmentNumber属性，保存了"深圳蓝凌"的部门编号，此时，属性名设置为"departmentNumber"，下拉框设置为"编号"
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.unid'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.person.prop.unid)" style="width:85%"/>
								
								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.person.prop.unid.note'/></span>

								<img id="personunidImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('personunidImg','personunidNote')" style="cursor:hand"><br>
								<div id="personunidNote"  style="display:none">
									该属性用于同步被删除的记录，一般由LDAP类型决定，选择LDAP类型的时候自动填充
								</div>

							</td>
						</tr>
					</table>

				</td></tr>
			</table>
			</td>
		</tr>

		<!--  岗位信息 -->
		<tr
			LKS_LabelName="<bean:message bundle='third-ldap' key='kmss.ldap.config.post'/>">
			<td>
			<table class="tb_normal" width=100%>
				<tr><td>
					<table id="postZone" class="tb_normal" width=100%>
						<tr>
							<td class="td_normal_title" colspan=2><b>
							<label>
								<html:checkbox property="value(kmss.ldap.config.post.check)" value="true" onclick="_switchTable(this,'postZone');"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.config.post.check'/>
							</label>
							</b></td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.baseDN'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.post.baseDN)" style="width:85%"/>
								<span class="txtstrong">*</span>
								
								<img id="postbaseDNImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('postbaseDNImg','postbaseDNNote')" style="cursor:hand"><br>
								<div id="postbaseDNNote"  style="display:none">
									如：dc=landray,dc=com,dc=cn
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.filter'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.post.filter)" style="width:85%"/>

								<img id="postfilterImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('postfilterImg','postfilterNote')" style="cursor:hand"><br>
								<div id="postfilterNote"  style="display:none">
									当基准DN下还包含其它不需要的信息的时候，可以通过筛选条件进行数据过滤，默认值为"(objectclass=*)"，不过滤数据
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.name'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.post.prop.name)" style="width:85%"/>
								<span class="txtstrong">*</span>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.number'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.post.prop.number)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.order'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.post.prop.order)" style="width:85%"/>
								<br>
									<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.order.note'/></span>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.keyword'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.post.prop.keyword)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.memo'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.post.prop.memo)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.dept'/></td>
							<td>
								<html:hidden property="value(kmss.ldap.type.post.prop.dept.type)"/>
								<input type="radio" name="value(kmss.ldap.type.post.prop.dept.byParentDN)" value="true" onclick="_switchMode(this,'postObjKey');"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.dept.type.dn'/>
								<input type="radio" name="value(kmss.ldap.type.post.prop.dept.byParentDN)" value="false" onclick="_switchMode(this,'postObjKey');"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.dept.type.key'/>
								<input type="radio" name="value(kmss.ldap.type.post.prop.dept.byParentDN)" value="" onclick="_switchMode(this,'postObjKey');">不设置
								<div id="postObjKey">
								<bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.dept.propName'/>
								<html:text property="value(kmss.ldap.type.post.prop.dept)" style="width:30%"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.dept.objKey'/>
								<sunbor:enums property="value(kmss.ldap.type.post.prop.dept.objKey)" enumsType="ldap_objKey" elementType="select" bundle="third-ldap" isEmptyAllow="true"/>

								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.dept.note'/></span>
								</div>

								<img id="postdeptImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('postdeptImg','postdeptNote')" style="cursor:hand"><br>
								<div id="postdeptNote"  style="display:none">
									通过上级DN获取：用于树形结构的目录（AD目录的常用方式），如"ou=产品中心,ou=深圳蓝凌,dc=landray,dc=com,dc=cn"的上级部门的DN为"ou=深圳蓝凌,dc=landray,dc=com,dc=cn"通过关联属性获取：用于平面结构的目录，在这种情况下，子部门信息中会存储父部门的编号或其它信息，如："产品中心"的记录中，采用了departmentNumber属性，保存了"深圳蓝凌"的部门编号，此时，属性名设置为"departmentNumber"，下拉框设置为"编号"
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.member'/></td>
							<td>
								<html:checkbox property="value(kmss.ldap.type.post.prop.member.check)" onclick="_post_member_check(this)" /><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.member.check'/>
								<br>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.member.propName'/>
								<html:text property="value(kmss.ldap.type.post.prop.member)" style="width:30%"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.member.objKey'/>
								<sunbor:enums property="value(kmss.ldap.type.post.prop.member.objKey)" enumsType="ldap_objKey" elementType="select" bundle="third-ldap" isEmptyAllow="true"/>

								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.member.note'/></span>

								<img id="postmemberImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('postmemberImg','postmemberNote')" style="cursor:hand"><br>
								<div id="postmemberNote"  style="display:none">
									'用于平面结构的目录，在这种情况下，子部门信息中会存储父部门的编号或其它信息，如："产品中心"的记录中，采用了departmentNumber属性，保存了"深圳蓝凌"的部门编号，此时，属性名设置为"departmentNumber"，下拉框设置为"编号"
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.thisleader'/></td>
							<td>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.thisleader.propName'/>
								<html:text property="value(kmss.ldap.type.post.prop.thisleader)" style="width:30%"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.thisleader.objKey'/>
								<sunbor:enums property="value(kmss.ldap.type.post.prop.thisleader.objKey)" enumsType="ldap_objKey" elementType="select" bundle="third-ldap" isEmptyAllow="true"/>

								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.thisleader.note'/></span>

								<img id="postthisleaderImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('postthisleaderImg','postthisleaderNote')" style="cursor:hand"><br>
								<div id="postthisleaderNote"  style="display:none">
									用于平面结构的目录，在这种情况下，子部门信息中会存储父部门的编号或其它信息，如："产品中心"的记录中，采用了departmentNumber属性，保存了"深圳蓝凌"的部门编号，此时，属性名设置为"departmentNumber"，下拉框设置为"编号
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.unid'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.post.prop.unid)" style="width:85%"/>
								
								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.post.prop.unid.note'/></span>
								
								<img id="postunidImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('postunidImg','postunidNote')" style="cursor:hand"><br>
								<div id="postunidNote"  style="display:none">
									该属性用于同步被删除的记录，一般由LDAP类型决定，选择LDAP类型的时候自动填充
								</div>
								
							</td>
						</tr>
					</table>

				</td></tr>
			</table>
			</td>
		</tr>

		<!--  常用群组信息 -->
		<tr
			LKS_LabelName="<bean:message bundle='third-ldap' key='kmss.ldap.config.group'/>">
			<td>
			<table class="tb_normal" width=100%>
				<tr><td>
					<table id="groupZone" class="tb_normal" width=100%>
						<tr>
							<td class="td_normal_title" colspan=2><b>
							<label>
								<html:checkbox property="value(kmss.ldap.config.group.check)" value="true" onclick="_switchTable(this,'groupZone');"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.config.group.check'/>
							</label>
							</b></td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.group.baseDN'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.group.baseDN)" style="width:85%"/>
								<span class="txtstrong">*</span>

								<img id="groupbaseDNImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('groupbaseDNImg','groupbaseDNNote')" style="cursor:hand"><br>
								<div id="groupbaseDNNote"  style="display:none">
									如：dc=landray,dc=com,dc=cn
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.group.filter'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.group.filter)" style="width:85%"/>

								<img id="groupfilterImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('groupfilterImg','groupfilterNote')" style="cursor:hand"><br>
								<div id="groupfilterNote"  style="display:none">
									当基准DN下还包含其它不需要的信息的时候，可以通过筛选条件进行数据过滤，默认值为"(objectclass=*)"，不过滤数据
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.name'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.group.prop.name)" style="width:85%"/>
								<span class="txtstrong">*</span>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.number'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.group.prop.number)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.order'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.group.prop.order)" style="width:85%"/>
								<br>
									<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.order.note'/></span>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.keyword'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.group.prop.keyword)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.memo'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.group.prop.memo)" style="width:85%"/>
							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.member'/></td>
							<td>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.member.propName'/>
								<html:text property="value(kmss.ldap.type.group.prop.member)" style="width:30%"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.member.objKey'/>
								<sunbor:enums property="value(kmss.ldap.type.group.prop.member.objKey)" enumsType="ldap_objKey" elementType="select" bundle="third-ldap" isEmptyAllow="true"/>

								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.member.note'/></span>

								<img id="groupmemberImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('groupmemberImg','groupmemberNote')" style="cursor:hand"><br>
								<div id="groupmemberNote"  style="display:none">
									用于平面结构的目录，在这种情况下，子部门信息中会存储父部门的编号或其它信息，如："产品中心"的记录中，采用了departmentNumber属性，保存了"深圳蓝凌"的部门编号，此时，属性名设置为"departmentNumber"，下拉框设置为"编号
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.unid'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.group.prop.unid)" style="width:85%"/>
								
								<br>
								<span class="txtstrong"><bean:message bundle='third-ldap' key='kmss.ldap.type.group.prop.unid.note'/></span>

								<img id="groupunidImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('groupunidImg','groupunidNote')" style="cursor:hand"><br>
								<div id="groupunidNote"  style="display:none">
									该属性用于同步被删除的记录，一般由LDAP类型决定，选择LDAP类型的时候自动填充
								</div>

							</td>
						</tr>
					</table>

				</td></tr>
			</table>
			</td>
		</tr>

		<!--  LDAP登录验证 -->
		<tr
			LKS_LabelName="<bean:message bundle='third-ldap' key='kmss.ldap.config.auth.label'/>">
			<td>
			<table class="tb_normal" width=100%>
				<tr><td>
					<!--员工信息 -->
					<table id="authZone" class="tb_normal" width=100%>
						<tr>
							<td class="td_normal_title" colspan=2><b>
							<label>
								<html:checkbox property="value(kmss.ldap.config.auth.check)" value="true" onclick="_switchTable(this,'authZone');"/>
								<bean:message bundle='third-ldap' key='kmss.ldap.config.auth.label'/>
							</label>
							</b>
							<span>(<bean:message bundle='third-ldap' key='kmss.ldap.config.auth.label.note'/>)</span>
							<a href="#"
						onclick="_getPInfo();">【<bean:message bundle='third-ldap' key='kmss.ldap.config.auth.button.get'/>】</a>
							</td>
						</tr>

						<!--tr>
							<td class="td_normal_title" colspan=2><b><bean:message bundle='third-ldap' key='kmss.ldap.config.person'/></b></td>
						</tr-->
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.config.auth.baseDN'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.auth.baseDN)" style="width:85%"/>
								<span class="txtstrong">*</span>

								<img id="authbaseDNImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('authbaseDNImg','authbaseDNNote')" style="cursor:hand"><br>
								<div id="authbaseDNNote"  style="display:none">
									如：dc=landray,dc=com,dc=cn
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.config.auth.filter'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.auth.filter)" style="width:85%"/>

								<img id="authfilterImg" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
									onclick="expandMethod('authfilterImg','authfilterNote')" style="cursor:hand"><br>
								<div id="authfilterNote"  style="display:none">
									当基准DN下还包含其它不需要的信息的时候，可以通过筛选条件进行数据过滤，默认值为"(objectclass=*)"，不过滤数据
								</div>

							</td>
						</tr>
						<tr>
							<td class="td_normal_title" width="15%"><bean:message bundle='third-ldap' key='kmss.ldap.config.auth.login'/></td>
							<td>
								<html:text property="value(kmss.ldap.type.auth.prop.login)" style="width:85%"/>
								<span class="txtstrong">*</span>
							</td>
						</tr>
					</table>

				</td></tr>
			</table>
			</td>
		</tr>

	</table>
	</center>
</html:form>
</body>
</html>
