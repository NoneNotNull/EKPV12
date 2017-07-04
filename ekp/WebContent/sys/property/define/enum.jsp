<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.*" %>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
Com_IncludeFile("jquery.js");
</script>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdChild"/>
	</td><td colspan="3" width="85%">
		<xform:text property="fdParentName" showStatus="${sysPropertyDefineForm.method_GET=='add'?'readOnly':'view'}" style="width:85%" />
		<xform:text showStatus="noShow" property="fdParentId"/>
		<c:if test="${sysPropertyDefineForm.method_GET=='add'}">
			<a href="#" onclick="openPropertyList('${sysPropertyDefineForm.fdId}')"><bean:message key="button.select"/></a>
		</c:if>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.dataMapping"/>
	</td><td colspan="3" width="85%">
		 
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdFieldLength"/>
		<xform:text property="param(fd_field_length)" style="width:100px" required="true" subject='<%=ResourceUtil.getString("sys-property:sysPropertyDefine.fdFieldLength")%>' validators="digits" />&nbsp;&nbsp;
		<c:if test="${sysPropertyDefineForm.method_GET=='edit'}">
			<input type="button" class="btnopt" value='<bean:message key="button.edit"/>' onclick="sysPropDataMappingUpdate();" />
		</c:if>
	</td>
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions"/>
	</td><td colspan="3" width="85%">
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source"/>
		<xform:radio property="param(fd_options_source)" onValueChange="sysPropSourceChange" required="true" subject='<%=ResourceUtil.getString("sys-property:sysPropertyDefine.fdOptions.source")%>'>
			<xform:simpleDataSource value="input" ><bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source.input"/></xform:simpleDataSource>
			<xform:simpleDataSource value="sql"><bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source.sql"/></xform:simpleDataSource>
		</xform:radio>
		<div id="div_opt_source0" <c:if test="${sysPropertyDefineForm.fdParamMap['fd_options_source'] != 'input'}">style="display:none"</c:if>>
			<xform:textarea      property="param(fd_options)" style="width:55%;height:250px;" />
			<c:if test="${sysPropertyDefineForm.method_GET!='view'}"><font style="vertical-align:top">图例</font>
				<span style="border:1px dashed black;"><img src="${KMSS_Parameter_ContextPath}sys/property/define/images/enum_sample.jpg" border="0"  align="bottom"/> </span> <br />
				<bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source.input.note"/> 
			</c:if>
		</div>
		<div id="div_opt_source1" <c:if test="${sysPropertyDefineForm.fdParamMap['fd_options_source'] != 'sql'}">style="display:none"</c:if>>
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source.sql.dataSource"/>
			<xform:select property="param(fd_data_source)" showPleaseSelect="false">
				<xform:customizeDataSource className="com.landray.kmss.sys.property.service.spring.SysPropertyDataSource" />
			</xform:select>
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source.sql.statement"/>
			<input name='sqlString' id='sqlString0' type='radio' onclick="setSqlString(this.value)" value='0' /><label class='sqlLabel'>自定义SQL</label>
			<input name='sqlString' id='sqlString1' onclick="setSqlString(this.value)" type='radio' value='1' /><label class='sqlLabel'>分类中配置</label><br />
			<xform:textarea     property="param(fd_sql)" style="width:55%;" /><br />
			<c:if test="${sysPropertyDefineForm.method_GET!='view'}">
			<bean:message bundle="sys-property" key="sysPropertyDefine.fdOptions.source.sql.example"/> 
			</c:if>
		</div>
	</td>
	
</tr>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-property" key="sysPropertyDefine.fdDefaultValue"/>
	</td><td colspan="3" width="85%">
		<xform:text property="param(fd_default_value)" style="width:50%" onValueChange="checkDefaultValue" />
		<span id="ck1" style="display:none">必须取备选项“|”后面的值作为默认值。</span><span id="ck2" style="display:none">多值用半角分号  ;  隔开</span>
	</td>
</tr>
<script>
var method_get="${sysPropertyDefineForm.method_GET}" ;
var sql='select fd_id , fd_property_value  from sys_property_val';
function sysPropSourceChange(val, ele){
	if("input"==val){
		$("#div_opt_source0").show();
		$("#div_opt_source1").hide();
	} else if("sql"==val){
		$("#div_opt_source0").hide();
		$("#div_opt_source1").show();
		$("#sqlString0").click() ;
	}
}
function sysPropDataMappingUpdate() {
	if(!confirm('<bean:message bundle="sys-property" key="sysPropertyDefine.dataMapping.updateAlert"/>')) {
		return;
	}
	$("input[name='fdStructureName']").attr("readOnly", false);
	$("input[name='param(fd_field_length)']").attr("readOnly", false);
	// 标识是否重启hibernate session
	$("input[name='fdIsHbmChange']").attr("value", "true");
}
function  setSqlString(v) {
	//debugger;
	if(v==0){
		if(method_get=='add' || method_get=='edit' ){
			 $("textarea[name='param(fd_sql)']").val('') ;
			 $("textarea[name='param(fd_sql)']").css("display","block");
			 $("textarea[name='param(fd_sql)']").attr("readonly",false);
	    }
	}
	if(v==1){
		if(method_get=='add' || method_get=='edit'){
			 $("textarea[name='param(fd_sql)']").val(sql) ;
			 $("textarea[name='param(fd_sql)']").css("display","none");
	     }
	}
	 
}
$(document).ready(function(){
	//$("input[name='fdStructureName']").attr("readOnly", true);
	if(method_get=='edit'){
		$("input[name='param(fd_field_length)']").attr("readOnly", true);
	}
	 var dt="" ;
	 if(method_get!='view'){
		 $("#ck1").show() ;
	     $("input[name='fdDisplayType']").each(function(){
           if(this.checked){
          	 dt=this.value ;
            }
		 }) ; 
		  if(dt=='checkbox') 
		 	 $("#ck2").show() ; 
		  else
		 	 $("#ck2").hide() ;

		 if( $("textarea[name='param(fd_sql)']").val()==sql){
			 		$("#sqlString1").attr("checked","checked");
			 		$("textarea[name='param(fd_sql)']").css("display","none");
			 } else{
				    $("#sqlString0").attr("checked","checked");
				 }
			 	 
	 }else{
		 $("#ck1").hide() ;
		 $(".sqlLabel").text('') ;
		 $("input[name=sqlString]").hide() ;
	 }
}); 

function openPropertyList(exceptValue){
	var url = 'sysPropertyDefineTreeService&defineId={param.fdid}';
	Dialog_Tree(false, 'fdParentId', 'fdParentName', null,url, "属性定义",null, action, exceptValue, false, false, "属性定义选择");
}

function action(){
	
}
 
</script>