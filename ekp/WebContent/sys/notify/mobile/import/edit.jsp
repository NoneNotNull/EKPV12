<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysNotifyRemindMainContextForm" value="${mainModelForm.sysNotifyRemindMainContextForm}" scope="request" />
<link rel="stylesheet" href="${LUI_ContextPath}/sys/notify/mobile/import/edit.css" />
<script type="text/javascript">Com_IncludeFile("doclist.js");</script>
<script type="text/javascript">DocList_Info.push("TABLE_${param.fdPrefix}_${param.fdKey}");</script>

<table class="muiNormal muiAgendaNormal" width="100%" border="0" cellspacing="0" cellpadding="0" id="TABLE_${param.fdPrefix}_${param.fdKey}" >
	<tr>
		<td colspan="2">
			<span class="title">日程提醒</span>
		</td>
		<td colspan="2">
			<span class="muiDetailTableAdd" onclick="_${param.fdPrefix}_${param.fdKey}_add();">+添加提醒</span>
		</td>
	</tr>
	<%--基准行--%>
	<tr data-dojo-type="mui/form/Template" data-celltr="true" KMSS_IsReferRow="1" style="display:none;" border='0'>
		<td width="30%">
			<%-- modelName --%>
		 	<input  type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[!{index}].fdModelName" value="${param.fdModelName}"  />
		 	<%-- 通知方式 --%>
		 	<kmss:editNotifyType property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[!{index}].fdNotifyType" multi="false"   value="todo" mobile="true"></kmss:editNotifyType>
		</td>
		<td width="30%">
			<%--提前多少时间通知 --%>
	       	<div data-dojo-type="mui/form/Input" 
				data-dojo-props="name:'sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[!{index}].fdBeforeTime',
					value:'30',showStatus:'edit',subject:'提前时间',validate:'digits required',required:true,opt:false">
			</div>
		</td>	
		<td width="30%">
			<%--时间单位 --%>
			<xform:select property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[!{index}].fdTimeUnit"
				 value="minute" showStatus="edit" showPleaseSelect="false" mobile="true">
				<xform:enumsDataSource enumsType="sys_notify_fdTimeUnit" />
			</xform:select>
		</td> 
		<td width="10%">
			<div class="muiDetailTableDel" onclick="_${param.fdPrefix}_${param.fdKey}_del(this);">
				<i class="mui mui-close"></i>
			</div>
		</td>	
	</tr>
	<%--内容行--%>
	<c:forEach items="${sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList}" var="sysNotifyRemindMainFormListItem" varStatus="vstatus">
		<tr KMSS_IsContentRow="1" data-celltr="true">			
			<td width="30%">
			 	<input type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdId" value="${sysNotifyRemindMainFormListItem.fdId}" />
			 	<input type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdModelId" value="${sysNotifyRemindMainFormListItem.fdModelId}" />
			 	<input type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdKey" value="${sysNotifyRemindMainFormListItem.fdKey}" />
			 	<input type="hidden" name="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdModelName" value="${param.fdModelName}" />
			 	<kmss:editNotifyType property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdNotifyType" multi="false" mobile="true"></kmss:editNotifyType>
			 </td>
			 <td width="30%">
			 	<div data-dojo-type="mui/form/Input" 
					data-dojo-props="name:'sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdBeforeTime',
						value:'${sysNotifyRemindMainFormListItem.fdBeforeTime}',
						showStatus:'edit',subject:'提前时间',validate:'digits required',required:true,opt:false">
				</div>
			</td>
			<td width="30%">	
				<xform:select property="sysNotifyRemindMainContextForm.sysNotifyRemindMainFormList[${vstatus.index}].fdTimeUnit" 
					value="${sysNotifyRemindMainFormListItem.fdTimeUnit}" showStatus="edit" showPleaseSelect="false" mobile="true">
					<xform:enumsDataSource enumsType="sys_notify_fdTimeUnit" />
				</xform:select>
		    </td>
		    <td width="10%">
				<div class="muiDetailTableDel" onclick="_${param.fdPrefix}_${param.fdKey}_del(this);">
					<i class="mui mui-close"></i>
				</div>
			</td>
		</tr>
	</c:forEach>
</table>

<script type="text/javascript">
require(["dojo/parser", "dojo/dom", "dojo/dom-construct","dojo/dom-style", "dijit/registry","dojo/ready","dojo/query","dojo/topic"],
		function(parser, dom, domConstruct,domStyle, registry,ready,query,topic){
	//添加行
	window._${param.fdPrefix}_${param.fdKey}_add = function() {
		event = event || window.event;
		if (event.stopPropagation)
			event.stopPropagation();
		else
			event.cancelBubble = true;
		var newRow = DocList_AddRow("TABLE_${param.fdPrefix}_${param.fdKey}");
		parser.parse(newRow);
	};
	//删除行
	window._${param.fdPrefix}_${param.fdKey}_del = function(domNode) {
		var TR=DocListFunc_GetParentByTagName('TR',domNode);
		var modelNameField=query('[name$="fdModelName"]',TR)[0];
		modelNameField.value="";
		domStyle.set(TR,'display','none');
	};
	
	ready(function(){
		if(DocList_TableInfo['TABLE_${param.fdPrefix}_${param.fdKey}']==null){
			DocListFunc_Init();
		}
	});
	
	
    topic.subscribe('mui/form/checkbox/valueChange', function(widget, args) {
        if (args.name.indexOf('__notify_type') > -1 && document.getElementById(args.name) ) {
            var fields = document.getElementsByName(args.name);
            var values = '';
            for (var i = 0; i < fields.length; i++)
                if (fields[i].checked)
                    values += ';' + fields[i].value;
            if (values != '')
                document.getElementById(args.name).value = values.substring(1);
            else
                document.getElementById(args.name).value = '';
        }
    });
	
});
	
</script>


