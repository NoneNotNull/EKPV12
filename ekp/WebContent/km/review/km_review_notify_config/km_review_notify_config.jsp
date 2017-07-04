<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/appconfig/sys_appconfig/sysAppConfig.do">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
		onclick="Com_Submit(document.sysAppConfigForm, 'update');">
</div>
<p class="txttitle"><bean:message bundle="sys-organization" key="sysOrgConfig"/></p>
<center>
<script type="text/javascript">
window.onload = function(){
	var base=document.getElementsByName("base")[0];
	var info=document.getElementsByName("info")[0];
	var note=document.getElementsByName("note")[0];
	var basevalue=document.getElementsByName("value(base)")[0];
	var infovalue=document.getElementsByName("value(info)")[0];
	var notevalue=document.getElementsByName("value(note)")[0];
	if(basevalue.value=="0"){
		base.checked=false;
	}else base.checked=true;
	if(infovalue.value=="0"){
		info.checked=false;
	} else 	info.checked=true;
	if(notevalue.value=="0"){
		note.checked=false;
	} else 	note.checked=true;
}
function changeValue(thisObj){
	var base=document.getElementsByName("base")[0];
	var info=document.getElementsByName("info")[0];
	var note=document.getElementsByName("note")[0];
	var basevalue=document.getElementsByName("value(base)")[0];
	var infovalue=document.getElementsByName("value(info)")[0];
	var notevalue=document.getElementsByName("value(note)")[0];
	if(base.checked){
		basevalue.value="base";
		}else{
		basevalue.value="0";
		}
	if(info.checked){
		infovalue.value="info";
	    }else{
	    infovalue.value="0";
		}
	if(note.checked){
		notevalue.value="note";
	    }else{
	    notevalue.value="0";
		}
}

</script>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message bundle="km-review" key="kmReview.config.notify.default"/>
		</td>
		<td colspan="3">
			<kmss:editNotifyType property="value(fdNotifyType)"/>
			<span class="txtstrong"><bean:message bundle="km-review" key="kmReview.config.notify.hint"/></span>			
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=20%>
			<bean:message bundle="km-review" key="kmReview.config.print"/>
		</td>
		<td>
			<html:hidden property="value(base)"/>
			<label>
			<input name="base" type="checkbox" onclick="changeValue(this);"/>
			<bean:message bundle="km-review" key="kmReview.config.base"/>
			</label>
		</td>
		<td>
			<html:hidden property="value(info)"/>
			<label>
			<input  name="info" type="checkbox" onclick="changeValue(this);"/>
			<bean:message bundle="km-review" key="kmReview.config.info"/>
			</label>
		</td>
		<td>
			<html:hidden property="value(note)"/>
			<label>
			<input name="note" type="checkbox" onclick="changeValue(this);"/>
			<bean:message bundle="km-review" key="kmReview.config.note"/>
			</label>
		</td>
	</tr>
</table>
</center>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
