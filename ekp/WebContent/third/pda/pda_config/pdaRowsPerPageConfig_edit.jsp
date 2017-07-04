<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<html:form action="/third/pda/pda_rows_per_page_config/pdaRowsPerPageConfig.do">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>" onclick="submint();">
</div>
<p class="txttitle"><bean:message key="pdaGeneralConfig.rowsPerPageConfig" bundle="third-pda"/></p>
<center>
<table class="tb_normal" width=95%>
    <%-- 在线用户:Y,所有用户:A,指定用户:其他任何值(缺省为O表示指定用户) --%>
    <!-- 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="pdaGeneralConfig.broadcastAndriod" bundle="third-pda"/>
		</td>
		<td>
			<xform:radio property="broadcastAndriod">
				<xform:enumsDataSource enumsType="pda_general_config_broadcastAndriod" />
			</xform:radio>
		</td>
	</tr>
	 -->
	<%-- 此三项有固定缺省值，无需配置 故注释掉--%>
	<%-- 1. 安卓消息推送apiKey 缺省值为：1234567890  --%>
	<%-- 2. 安卓消息推送待办URI 缺省值为：/third/pda/third_pda_config/pdaMsgPushInfo.do?method=list  --%>
	<%-- 3. 安卓消息推送服务xmppPort端口 缺省值为：5222  --%>
	<!-- 
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="pdaGeneralConfig.uriAndriod" bundle="third-pda"/>
		</td>
		<td colspan=2>
			<input name="uriAndriod" class="inputsgl" style="width: 50%"  value="${pdaRowsPerPageConfigForm.uriAndriod}"  />
			<span><bean:message key="pdaGeneralConfig.uriAndriod.remark" bundle="third-pda"/></span>
		</td>
	</tr>
	-->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="pdaGeneralConfig.pushMsgServerPortAndriod" bundle="third-pda"/>
		</td>
		<td colspan=2>
			<input name="pushMsgServerPortAndriod" class="inputsgl" style="width: 50%"  value="${pdaRowsPerPageConfigForm.pushMsgServerPortAndriod}"  />
			<span><bean:message key="pdaGeneralConfig.pushMsgServerPortAndriod.remark" bundle="third-pda"/></span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="pdaGeneralConfig.pushMsgServerIpAndriod" bundle="third-pda"/>
		</td>
		<td colspan=2>
			<input name="pushMsgServerIpAndriod" class="inputsgl" style="width: 50%"  value="${pdaRowsPerPageConfigForm.pushMsgServerIpAndriod}"  />
			<span><bean:message key="pdaGeneralConfig.pushMsgServerIpAndriod.remark" bundle="third-pda"/></span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="pdaGeneralConfig.apiKeyAndriod" bundle="third-pda"/>
		</td>
		<td colspan=2>
			<input name="apiKeyAndriod" class="inputsgl" style="width: 50%"  value="${pdaRowsPerPageConfigForm.apiKeyAndriod}"  /> 
			<span><bean:message key="pdaGeneralConfig.apiKeyAndriod.remark" bundle="third-pda"/></span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="pdaGeneralConfig.pushMsgServerUrlAndriod" bundle="third-pda"/>
		</td>
		<td colspan=2>
			<input name="pushMsgServerUrlAndriod" class="inputsgl" style="width: 50%"  value="${pdaRowsPerPageConfigForm.pushMsgServerUrlAndriod}"  />
			<span><bean:message key="pdaGeneralConfig.pushMsgServerUrlAndriod.remark" bundle="third-pda"/></span>
		</td>
	</tr>
	<%-- 消息接收时段 统一由定时任务 条件触发表达式统一配置 这里不用暂注释--%>
	<!-- 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="pdaGeneralConfig.msgRevTimeInterval" bundle="third-pda"/>
		</td><td colspan=2>
			<html:text property="msgRevTimeInterval" size="11"/>
			<span><bean:message key="pdaGeneralConfig.msgRevTimeInterval.remark" bundle="third-pda"/></span>
		</td>
	</tr>
	 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="pdaGeneralConfig.fdRowsNumber" bundle="third-pda"/>
		</td><td colspan=3>
			<html:text property="fdRowsNumber" size="10"/><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="pdaGeneralConfig.fdAttDownLoadEnabled" bundle="third-pda"/>
		</td><td colspan=3>
			<html:checkbox property="fdAttDownLoadEnabled" value="true"/>
			<bean:message key="pdaGeneralConfig.fdIsEnabled" bundle="third-pda"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="pdaGeneralConfig.fdExtendsUrl" bundle="third-pda"/>
		</td><td colspan=3>
			<html:textarea property="fdExtendsUrl" style="width:80%"/><br/>
			<span><bean:message key="pdaGeneralConfig.fdExtends.remark" bundle="third-pda"/></span>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script type="text/javascript">
function submint(){
	var rowsNumber = document.getElementsByName("fdRowsNumber")[0].value;
	if(rowsNumber == null || rowsNumber == ""){
		alert('<bean:message key="pdaGeneralConfig.fdRowsNumber" bundle="third-pda"/><bean:message key="validate.notNull" bundle="third-pda"/>');
		return;
	}
	var   r   =  /^[0-9]*[1-9][0-9]*$/;//正整数     
	if(!r.test(rowsNumber)){
		alert('<bean:message key="pdaGeneralConfig.fdRowsNumber" bundle="third-pda"/><bean:message key="validate.mustBeInteger" bundle="third-pda"/>');
		return;
	}
	Com_Submit(document.pdaRowsPerPageConfigForm, 'update');
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>