<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>  
<%@ include file="/kms/wiki/kms_wiki_main/kmsWikiMain_edit_catelog_js.jsp"%>  
<html:form action="/kms/wiki/kms_wiki_main/kmsWikiMain.do">
<div id="optBarDiv">
    <input type=button value="<bean:message key="button.save"/>"
				onclick="return kmsWikiCatelog_doOk();"> 
	<input type="button" value="<bean:message key="button.close"/>" 
				onclick="Com_CloseWindow();">
</div>
<input type='hidden' name="fdId" value="${param.fdId}"/>
<div style="margin:0 auto;width:650px">
	<p class="txttitle">编辑目录</p>
	<p >
		<input type="button" value="添加" class="btnopt" id="addRow" onclick="add_Row();"/>
		<input type="button" value="上移" class="btnopt" id="upRow" onclick="move_Row(-1);"/>
		<input type="button" value="下移" class="btnopt" id="downRow" onclick="move_Row(1);"/>
		<input type="button" value="删除" class="btnopt" id="deleteRow" onclick="delete_Row();"/>
	</p>
	<table class="tb_normal"  width=100% id="TABLE_DocList">
		<tr>	
			<td class="td_normal_title" width="5%"><input type="checkbox" id="fdCatelogList_seclectAll" onclick="changeSelectAll(this);" /></td> 
			<td class="td_normal_title" width="10%">
				排序号
			</td> 
			<td class="td_normal_title" width="30%">
				目录名
			</td>
			<td class="td_normal_title" width="55%">
				默认可编辑者
			</td>
		</tr>
		<tr KMSS_IsReferRow="1" style="display:none;"> 
			<td>
				<input type="checkbox" name="fdCatelogList_seclect" onclick="changeSelect(this);" />
				<input type='hidden' name ='fdCatelogList[!{index}].fdId'/>
				<input type='hidden' name ='fdCatelogList[!{index}].fdOrder'/>
				<input type='hidden' name ='fdCatelogList[!{index}].docContent'/>
				<input type='hidden' name ='fdCatelogList[!{index}].fdParentId'/>
			</td>
			<td KMSS_IsRowIndex="1"></td>
			<td>
				<input type='text' name='fdCatelogList[!{index}].fdName' style="width:90%"  class="inputsgl"/>
			</td>
			<td>
				<input type='hidden' name="fdCatelogList[!{index}].authEditorIds"/>
				<textarea name="fdCatelogList[!{index}].authEditorNames" style="width:90%" rows="4" readonly="true" styleClass="inputsgl"></textarea>
				<a href="#" onclick="selectEditors(this);"><bean:message key="dialog.selectOrg"/></a>  
			</td>
		</tr>
	</table>
</div>

<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="kmsWikiMainForm"  cdata="false"
      dynamicJavascript="false" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>