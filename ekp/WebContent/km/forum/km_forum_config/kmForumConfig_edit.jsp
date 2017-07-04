<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<html:form action="/km/forum/km_forum_config/kmForumConfig.do" onsubmit="return validateKmForumConfigForm(this);">
<div id="optBarDiv">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="submitForm();">
</div>
<script type="text/javascript">
   function submitForm(){
	   var hotReplyCount = document.getElementsByName("hotReplyCount")[0].value;
	   if(hotReplyCount==null||hotReplyCount==""){
		    alert('<bean:message bundle="km-forum" key="kmForumConfig.tips.notNull"/>');
		    return;
		   }	  
	    if(isNaN(hotReplyCount)){
	    	alert('<bean:message bundle="km-forum" key="kmForumConfig.tips.mum"/>');
		    return;
		  }
	   Com_Submit(document.kmForumConfigForm, 'update');
	   }
</script>
<p class="txttitle"><bean:message bundle="km-forum" key="menu.kmForum.config"/></p>
<center>
<table class="tb_normal" width=95%>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumConfig.anonymous"/>
		</td><td colspan=3>
			<sunbor:enums property="anonymous"  enumsType="forumConfig_anonymous_yesno" elementType="radio" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" colspan="4">
			<bean:message  bundle="km-forum" key="kmForumConfig.anonymous.msg"/>
		</td>
	</tr>
    <tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumConfig.hotReplyCount"/>
		</td><td colspan=3>
			 	<bean:message  bundle="km-forum" key="kmForumConfig.tips"/><xform:text property="hotReplyCount" style="width:8.5%;"/>
	            <bean:message  bundle="km-forum" key="kmForumConfig.hot"/>
		</td>
	</tr> 

	<!--<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumConfig.canModifyRight"/>
		</td><td colspan=3>
			<sunbor:enums property="canModifyRight"  enumsType="forumConfig_canModifyRight_yesno" elementType="radio" />
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumConfig.canModifyNickname"/>
		</td><td colspan=3>
			<sunbor:enums property="canModifyNickname" enumsType="forumConfig_canModifyNickname_yesno" elementType="radio" />
		</td>
	</tr>

	--><tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumConfig.level"/>
		</td><td colspan=3>
			<html:textarea property="level" style="width:95%;height:270"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" colspan="4">
			<bean:message  bundle="km-forum" key="kmForumConfig.level.msg"/>
		</td>
	</tr>
	<%--敏感词检测配置--%>
	<tr>
		<td class="td_normal_title" width=15%>
		   <bean:message  bundle="km-forum" key="kmForumConfig.word"/>
		</td><td colspan=3>
			<sunbor:enums property="isWordCheck"  enumsType="forumConfig_wordcheck_yesno" elementType="radio" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumConfig.word.set"/>
		</td><td colspan=3>
			<html:textarea property="words" style="width:95%;height:70px"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" colspan="4">
			<bean:message  bundle="km-forum" key="kmForumConfig.word.tips"/>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>

<script type="text/javascript" language="Javascript1.1"> 
<!-- Begin 
 function validateKmForumConfigForm() {                                                                   
	var level = document.getElementsByName("level")[0];
	if(level.value=="")return true;
	var ls = level.value.split("\n");
	for(var i=0;i<ls.length;i++){
		var ks = ls[i].split(":");
		if(parseInt(ks[1])!=ks[1]|| ks[0]==""){
			alert("<bean:message  bundle="km-forum" key="kmForumConfig.level"/>:'"+ls[i]+"'<bean:message  bundle="km-forum" key="kmForum.error"/>");
			level.focus();
			return false;
		}
		if(-2147483648>parseInt(ks[1])||parseInt(ks[1])>2147483647){
			alert("<bean:message  bundle="km-forum" key="kmForumConfig.level"/>:'"+ls[i]+"'<bean:message  bundle="km-forum" key="kmForum.number.error"/>");
			level.focus();
			return false;
		}
	}
	return true;
 } 
//End --> 
</script>

<%@ include file="/resource/jsp/edit_down.jsp"%>