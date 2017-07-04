<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("jquery.js|json2.js|data.js|select.js|design_doc.js");
</script>
<p class="txttitle"><bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tagMaintain"/></p>
<center>
<table class="tb_normal" width="1000">
	<!-- 显示标签信息 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-core-provider" key="table.tibSysCoreTag"/>
		</td><td width="85%" id="tagHtml">
			
		</td>
	</tr>
	
	<tr id="systemTrContent">
		<td class="td_normal_title" colspan="2">
			<table class="tb_normal" width="1000">
				<tr class="tr_normal_title">
					<td width="450">
						<bean:message bundle="tib-sys-core-provider" key="tibSysCoreTag.tagList"/>
					</td>
					<td width="100"><bean:message bundle="tib-sys-core-provider" key="tibSysCoreTag.operation"/></td>
					<td width="450">
						<bean:message bundle="tib-sys-core-provider" key="tibSysCoreTag.waitDelTag"/>
					</td>
				</tr>
				<tr>
					<td valign="top">
						<select id="optionalList" name="optionalList" multiple ondblclick="listTolist('optionalList','selectedList',false);" style="width:100%" size="15"></select>
					</td>
					<td>
						<center>
							<input type=button class="btnopt" value=">>>" onclick="listTolist('optionalList','selectedList',false);">
							<br><br>
							<input type=button class="btnopt" value="<<<" onclick="listTolist('selectedList','optionalList',false);">
						</center>
					</td>
					<td>
						<select id="selectedList" name="selectedList" multiple ondblclick="listTolist('selectedList','optionalList',false);" style="width:100%" size="15"></select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center" colspan="2">
			<input type=button class="btnopt" value='<bean:message key="button.delete"/>' onclick="deleteTag();">
			<a href=#" onclick="window.close();"><input class="btnopt" type="button" value="<bean:message key="button.close"/>"></a>
		</td>
	</tr>
</table>
</center>
<script type="text/javascript">

$(document).ready(function(){
	var tagHtml = "";
	<c:forEach items="${list }" var="tibSysCoreTag">
		var optionHtml = "";
		// 遍历数组
		<c:forEach items="${tibSysCoreTag }" var="attr" varStatus="vstatus">
			<c:if test="${vstatus.index == 0}">
				<c:if test="${attr != ''}">
					optionHtml += "<option value='${attr }'>";
				</c:if>
			</c:if>
			<c:if test="${vstatus.index != 0}">
				<c:if test="${vstatus.index == 1}">
					tagHtml += "${attr }";
					<c:if test="${attr != '其他'}">
						optionHtml += "${attr }</option>";
					</c:if>
				</c:if>
				<c:if test="${vstatus.index == 2}">
					tagHtml += "(<font color='blue'>${attr }</font>)&nbsp;&nbsp;";
				</c:if>
			</c:if>
		</c:forEach>
		// 添加下拉列表值
		if (optionHtml != "") {
			$("#optionalList").append(optionHtml);
		}
		
	</c:forEach>
	$("#tagHtml").html(tagHtml);
});

/*******************************************
功能:两个select中的option的移动
参数:
	fromid:源list的id.  
	toid:目标list的id.  
	isAll参数(true或者false):是否全部移动或添加  
*********************************************/
function listTolist(fromid,toid,isAll) {  
	var fromStyle = $("#"+fromid).attr('style');
	var toStyle = $("#"+toid).attr('style');
    if(isAll == true) { //全部移动   
        $("#"+fromid+" option").each(function() {   
            //将源list中的option添加到目标list,当目标list中已有该option时不做任何操作.   
            $(this).appendTo($("#"+toid+":not(:has(option[value="+$(this).val()+"]))"));   
        });   
        $("#"+fromid).empty();  //清空源list   
    } else if(isAll == false) {   
        $("#"+fromid+" option:selected").each(function() {   
            //将源list中的option添加到目标list,当目标list中已有该option时不做任何操作.   
            $(this).appendTo($("#"+toid+":not(:has(option[value="+$(this).val()+"]))"));   
            //目标list中已经存在的option并没有移动,仍旧在源list中,将其清空.   
            if($("#"+fromid+" option[value="+$(this).val()+"]").length > 0) {   
                $("#"+fromid).get(0).removeChild($("#"+fromid+" option[value="+$(this).val()+"]").get(0));   
            }   
        });   
    }   
	$("#"+fromid).attr('style',fromStyle);
	$("#"+toid).attr('style',toStyle);
}

function deleteTag() {
	var r=confirm('<bean:message bundle="tib-sys-core-provider" key="tibSysCoreTag.isDel"/>');
	if(r==false)return;
	var selectedArr = new Array();
	$("select[name='selectedList'] option").each(function(){
		selectedArr.push($(this).val());
	});
	if (selectedArr == "") {
		alert('<bean:message bundle="tib-sys-core-provider" key="tibSysCoreTag.delNone"/>');
		return;
	}
	window.location.href = "tibSysCoreTag.do?method=deleteall&List_Selected="+ selectedArr;
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>