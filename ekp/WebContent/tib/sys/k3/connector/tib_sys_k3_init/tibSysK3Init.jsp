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
		var easBackJson = "${k3BackJson}";
		if (easBackJson != "") {
			var jsonObj = eval("("+ easBackJson +")");
			for (var field in jsonObj) {
				$("input[name="+ field +"]").val(jsonObj[field]);
			}
		}
	});
</script>
<table class="tb_normal" width="100%" style="display:none;" id="k3">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="initK3.k3DnsIp"/>
		</td><td width="35%">
			<input type="text" class="inputsgl" name="k3DnsIp" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="initK3.k3Port"/>
		</td><td width="35%">
			<input type="text" class="inputsgl" name="k3Port" style="width:85%" value="9999"  />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="initK3.k3IaisId"/>
		</td><td width="35%">
			<input type="text" class="inputsgl" name="k3IAisID" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="initK3.k3UserName"/>
		</td><td width="35%">
			<input type="text" class="inputsgl" name="k3UserName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="initK3.k3Password"/>
		</td><td width="35%">
			<input type="text" class="inputsgl" name="k3Password" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>&nbsp;</td><td width=35%>&nbsp;</td>
	</tr>
</table>