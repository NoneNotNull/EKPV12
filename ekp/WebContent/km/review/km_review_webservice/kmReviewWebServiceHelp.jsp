<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("optbar.js|list.js");
</script>
<script>
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

 List_TBInfo = new Array(
			{TBID:"List_ViewTable1"},{TBID:"List_ViewTable2"},{TBID:"List_ViewTable3"}
		);
</script>


<div id="optBarDiv"><input type="button"
	value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle">${param.name}服务接口说明</p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>服务接口</td>
		<td width="85%">addReview(KmReviewParamterForm webForm)</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>功能描述</td>
		<td width="85%">启动审批流程</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>返回值</td>
		<td width="85%">主文档的数据库主键值（fd_id）</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>接口参数webForm</td>
		<td width="85%"><img id="viewSrc1"
			src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
			onclick="expandMethod('viewSrc1','paramDiv1')" style="cursor: pointer"><br>
		<div id="paramDiv1" style="display:none">
		<table id="List_ViewTable1" class="tb_noborder">
			<tr>
				<sunbor:columnHead htmlTag="td">
					<td width="40pt">序号</td>
				    <td width="20%">属性名</td>
				    <td width="20%">类 型</td>
				    <td width="10%">缺省值</td>
				    <td width="50%">描 述</td>
				</sunbor:columnHead>
			</tr>
			<tr>
				<td align="center">1</td>
				<td>docSubject</td>
				<td>字符串（String）</td>
				<td>无</td>
				<td>文档标题</td>
			</tr>
			<tr>
				<td align="center">2</td>
				<td>fdTemplateId</td>
				<td>字符串（String）</td>
				<td>无</td>
				<td>文档模板id</td>
			</tr>
			<tr>
				<td align="center">3</td>
				<td>docContent</td>
				<td>字符串（String）</td>
				<td>无</td>
				<td>文档的富文本内容</td>
			</tr>
			<tr>
				<td align="center">4</td>
				<td>formValues</td>
				<td>字符串（Json）</td>
				<td>无</td>
				<td>流程表单数据</td>
			</tr>
			<tr>
				<td align="center">5</td>
				<td>docStatus</td>
				<td>字符串（String）</td>
				<td>"20"</td>
				<td>文档状态，可以为草稿（"10"）或者待审（"20"）两种状态，默认为待审</td>
			</tr>
			<tr>
				<td align="center">6</td>
				<td>docCreator</td>
				<td>字符串（Json）</td>
				<td>无</td>
				<td>流程发起人，为单值，格式详见人员组织架构的定义说明</td>
			</tr>
			<tr>
				<td align="center">7</td>
				<td>fdKeyword</td>
				<td>字符串（Json）</td>
				<td>无</td>
				<td>文档关键字，格式为["关键字1", "关键字2"...]</td>
			</tr>			
			<tr>
				<td align="center">8</td>
				<td>docProperty</td>
				<td>字符串（Json）</td>
				<td>无</td>
				<td>辅类别，格式为["辅类别1的ID", "辅类别2的ID"...]</td>
			</tr>
			<tr>
				<td align="center">9</td>
				<td>flowParam</td>
				<td>字符串（Json）</td>
				<td>无</td>
				<td>流程参数</td>
			</tr>
			<tr>
				<td align="center">10</td>
				<td>attachmentForms</td>
				<td>链表（List&lt;AttachmentForm&gt;）</td>
				<td>无</td>
				<td>附件列表</td>
			</tr>														
		</table></div>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>流程表单数据formValues</td>
		<td width="35%">流程表单数据是采用Json格式传输，而流程表单原始数据的存储格式为xml，定义在km_review_main表中的extend_data_xml字段里，因此开发人员需要提取出流程表单中输入项的控件ID和控件值，组装成Json格式。其中明细表是按列来设置，格式为"明细表id.列id":["列值1","列值2","列值3"...]，每列单独组合成一个集合。		
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=15%>流程参数flowParam的定义</td>
		<td width="85%"><img id="viewSrc2"
			src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
			onclick="expandMethod('viewSrc2','paramDiv2')" style="cursor: pointer"><br>
		<div id="paramDiv2" style="display:none">
		<table id="List_ViewTable2" class="tb_noborder">
			<tr>
				<sunbor:columnHead htmlTag="td">
					<td width="40pt">序号</td>
				    <td width="30%">属性名</td>
				    <td width="20%">类 型</td>
				    <td width="20%">缺省值</td>
				    <td width="30%">描 述</td>
				</sunbor:columnHead>
			</tr>
			<tr>
				<td align="center">1</td>
				<td>auditNode</td>
				<td>字符串（Json）</td>
				<td>无</td>
				<td>审批意见</td>
			</tr>
			<tr>
				<td align="center">2</td>
				<td>futureNodeId</td>
				<td>字符串（Json）</td>
				<td>无</td>
				<td>流向下一节点的ID，需要人工决策时设置此参数</td>
			</tr>
			<tr>
				<td align="center">3</td>
				<td>changeNodeHandlers</td>
				<td>字符串（Json）</td>
				<td>无</td>
				<td>节点的处理人，格式为["节点名1：处理人ID1; 处理人ID2...","节点名2：处理人ID1; 处理人ID2..."...]，需要修改处理人时设置此参数</td>
			</tr>									
		</table>
		</div>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>流程参数flowParam的说明</td>
		<td width="35%">流程参数是采用JSon格式传输，格式为{auditNode:"审批意见", futureNodeId:"节点名", changeNodeHandlers:["节点名1：用户ID1; 用户ID2...", "节点名2：用户ID1; 用户ID2..."...]}。	
		</td>
	</tr>				
	<tr>
		<td class="td_normal_title" width=15%>附件AttachmentForm的定义</td>
		<td width="85%"><img id="viewSrc3"
			src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
			onclick="expandMethod('viewSrc3','paramDiv3')" style="cursor: pointer;"><br>
		<div id="paramDiv3" style="display:none">
		<table id="List_ViewTable3" class="tb_noborder">
			<tr>
				<sunbor:columnHead htmlTag="td">
					<td width="40pt">序号</td>
				    <td width="30%">属性名</td>
				    <td width="20%">类 型</td>
				    <td width="20%">缺省值</td>
				    <td width="30%">描 述</td>
				</sunbor:columnHead>
			</tr>
			<tr>
				<td align="center">1</td>
				<td>fdKey</td>
				<td>字符串（String）</td>
				<td>"fdAttachment"</td>
				<td>附件的关键字，富文本模式下为"fdAttachment"，表单模式下为附件控件的id</td>
			</tr>
			<tr>
				<td align="center">2</td>
				<td>fdFileName</td>
				<td>字符串（String）</td>
				<td>无</td>
				<td>附件文件名</td>
			</tr>
			<tr>
				<td align="center">3</td>
				<td>fdAttachment</td>
				<td>字节数组（byte[]）</td>
				<td>无</td>
				<td>附件内容，格式为字节编码</td>
			</tr>									
		</table>
		</div>
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=15%>支持的时间格式</td>
		<td width="35%">时间字段是采用字符串形式传输，格式为"yyyy-MM-dd HH:mm:ss"或者"yyyy/MM/dd HH:mm:ss"。</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>人员组织架构的说明</td>
		<td width="35%">人员组织架构是采用JSon格式传输，单值的格式为{类型: 值}，多值的格式为[{类型1: 值1} ,{类型2: 值2}...]。支持的类型有主键（Id）、编号（PersonNo、DeptNo、PostNo、GroupNo）、登录名（LoginName）、关键字（Keyword）、LDAP（LdapDN），其中Person表示个人，Dept表示机构/部门，Post表示岗位，Group表示群组。</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>参考代码</td>
		<td width="35%">
             <iframe width="100%" height="100%" src="KMReviewServiceClient.txt"></iframe>
        </td>
	</tr>	
</table>
</center>

<%@ include file="/resource/jsp/view_down.jsp"%>