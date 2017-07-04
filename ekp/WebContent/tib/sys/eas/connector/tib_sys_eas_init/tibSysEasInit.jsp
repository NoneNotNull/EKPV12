<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<script type="text/javascript" src="${KMSS_Parameter_ResPath}js/common.js"></script>
<script type="text/javascript">
	Com_IncludeFile("jquery.js");
</script>
<script type="text/javascript">
	$(function(){
		var easBackJson = "${easBackJson}";
		if (easBackJson != "") {
			var jsonObj = eval("("+ easBackJson +")");
			for (var field in jsonObj) {
				var fieldFirst = field.substring(0, 1);
				var fieldLast = field.substring(1);
				var name = "eas"+ fieldFirst.toUpperCase() + fieldLast;
				$("input[name="+ name +"]").val(jsonObj[field]);
			}
		}
	});
</script>
<table class="tb_normal" width="100%" style="display:none;" id="eas">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-eas-connector" key="initEas.easDnsIp"/>
		</td><td width="35%">
			<input type="text" class="inputsgl" name="easDnsIp" style="width:85%" value="" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-eas-connector" key="initEas.easPort"/>
		</td><td width="35%">
			<input type="text" class="inputsgl" name="easPort" style="width:85%" value="6888"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-eas-connector" key="initEas.easUserName"/>
		</td><td width="35%">
			<input type="text" class="inputsgl" name="easUserName" style="width:85%" value="" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-eas-connector" key="initEas.easPassword"/>
		</td><td width="35%">
			<input type="password" class="inputsgl" name="easPassword" style="width:85%" value="" />
		</td>
	</tr>
	<!-- eas,数据中心 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-eas-connector" key="initEas.easSlnName"/>
		</td><td width="35%">
			<input type="text" class="inputsgl" name="easSlnName" style="width:85%" value="eas" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-eas-connector" key="initEas.easDcName"/>
		</td><td width="35%">
			<input type="text" class="inputsgl" name="easDcName" style="width:85%" value="" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-eas-connector" key="initEas.easLanguage"/>
		</td><td width="35%">
			<input type="text" class="inputsgl" name="easLanguage" style="width:85%" value="L2" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-eas-connector" key="initEas.easDbType"/>
		</td><td width="35%">
			<input type="text" class="inputsgl" name="easDbType" style="width:85%" value="" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-eas-connector" key="initEas.easAuthPattern"/>
		</td><td width="35%">
			<input type="text" class="inputsgl" name="easAuthPattern" style="width:85%" value="BaseDB" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>
