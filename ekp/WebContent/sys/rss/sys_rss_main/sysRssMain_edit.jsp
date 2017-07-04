<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
Com_IncludeFile("dialog.js");
function showCategoryTreeDialog() {
	var dialog = new KMSSDialog(false, false);
	var node = dialog.CreateTree('<bean:message key="dialog.tree.title" bundle="sys-rss"/>');
	node.AppendBeanData("sysRssCategoryTreeService&selectdId=!{value}");
	dialog.winTitle = '<bean:message key="dialog.title" bundle="sys-rss"/>';
	dialog.BindingField('docCategoryId', 'docCategoryName');
	dialog.Show();
	return false;
}
</script>

<html:form action="/sys/rss/sys_rss_main/sysRssMain.do" onsubmit="return validateSysRssMainForm(this);">
<div id="optBarDiv">
	<c:if test="${sysRssMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysRssMainForm, 'update');">
	</c:if>
	<c:if test="${sysRssMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysRssMainForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysRssMainForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" 
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-rss" key="table.sysRssMain"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	<%-- 频道名 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.docSubject"/>
		</td>
		<td colspan="3">
			<html:text style="width:85%" property="docSubject"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<%-- RSS链接 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.fdLink"/>
		</td>
		<td colspan="3">
			<html:text style="width:85%" property="fdLink"/>
			<span class="txtstrong">*</span> 
			<%--添加链接样例 modify by zhouchao 20090525--%>
			<br>			
		 <font color="red"><bean:message bundle="sys-rss" key="sysRssMain.rss.linkExample"/></font>
		</td> 
	</tr>
	
	<tr>
		<%-- 分类 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.docCategoryId"/>
		</td>
		<td width=35%>
			<html:hidden property="docCategoryId" />
			<html:text property="docCategoryName" readonly="true" 
				style="width:85%" styleClass="inputsgl" />
			<a href="#" onclick="return showCategoryTreeDialog();">
				<bean:message key="dialog.selectOther" />
			</a>
			<span class="txtstrong">*</span>
		</td>
		<%-- 排序号 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.fdOrder"/>
		</td>
		<td width=35%>
			<html:text property="fdOrder" style="width:85%"/>
		</td>
	</tr>
	<%---创建时间创建人 修改时间修改人 不显示在新建里， 仅在编辑页面---%>
	<c:if test="${sysRssMainForm.method_GET=='edit'}">
	<%-- 创建人 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.docCreatorId"/>
		</td>
		<td width=35%>
			<html:text property="docCreatorName" readonly="true" />
		</td>
	<%-- 创建时间 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.docCreateTime"/>
		</td>
		<td width=35%>
			<html:text property="docCreateTime" readonly="true"/>
		</td>
	</tr>
	<%-- 修改人 --%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.docAlterorId"/>
		</td>
		<td width=35%>
			<html:text property="docAlterorName" readonly="true" />
		</td>
	<%-- 修改时间 --%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-rss" key="sysRssMain.docAlterTime"/>
		</td>
		<td width=35%>
			<html:text property="docAlterTime" readonly="true"/>
		</td>
	</tr>
	</c:if>
	
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysRssMainForm" cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>
