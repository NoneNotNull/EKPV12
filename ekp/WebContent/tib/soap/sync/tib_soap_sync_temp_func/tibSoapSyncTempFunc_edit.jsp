<%@ include file="/resource/jsp/edit_down.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/sys/xform/include/sysForm_script.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js|json2.js|dialog.js|formula.js|xml.js");
</script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/mustache.js" type="text/javascript"></script>
<link href="${KMSS_Parameter_ContextPath}tib/common/resource/css/jquery.treeTable.css" rel="stylesheet" type="text/css" />
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/jquery.treeTable.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/erp.parser.js" type="text/javascript"></script>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/common/resource/plugins/XMLParseUtil.js"></script>

<script>
XMLParseUtil.initDomByMozilla();
</script>
<div id="optBarDiv"><input type=button value="确定"
	onclick="submitSoapQuartzCfg()"> <input type="button"
	value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<center>
<script type="text/javascript"
	src="${KMSS_Parameter_ContextPath}tib/common/resource/js/tools.js"></script>
<p class="txttitle">SOAP 定时任务映射配置  <img src="${KMSS_Parameter_ContextPath}resource/style/default/tag/help.gif" title='帮助' style="cursor:hand" onclick='Com_OpenWindow("tibSoapSyncSettingHelp.jsp","_blank")' ></img> </p>
<table id="rfcTabel" class="tb_normal" width=95% >

</table>

<table class="tb_normal" width=95%>
  <tr>
     <td style="padding:0px;">
       <div id="tib_sys_soap_head">
       	 <table class="tb_normal" width="100%">
       	   <tr>
       	   	 <td width="15%">函数名称</td>
       	   	 <td width="35%">
       	   	 	<input type="hidden" readOnly="readonly" id="fdSoapMainId" name="fdSoapMainId"/>
       	   	 	<input type="text" readOnly="readonly" id="fdSoapMainName" name="fdSoapMainName" class="inputsgl"/>
       	   	 	<img style="cursor:pointer" alt="选择函数" onclick="soapFuncChange('fdSoapMainId', 'fdSoapMainName');"
       	   	 		src="${KMSS_Parameter_ContextPath}resource/style/common/images/small_search.png"/>
       	   	 </td>
       	   	 <td width="15%">数据源</td>
       	   	 <td width="35%">
       	   	 	<select id="dbselect" name="dbselect" onchange="">
       	   	 	</select>
       	   	 </td>
       	   </tr>
       	   <tr>
       	   	 <td width="15%">最后执行时间</td>
       	   	 <td width="85%" colspan="3">
       	   	 	<span id="fdLastDate"></span>
       	   	 </td>
       	   </tr>
       	 </table>
       </div>
     </td>
  </tr>
  <tr>
     <td>
       <div id="tib_sys_soap_input"></div>
     </td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
  </tr>
  <tr>
     <td>
       <div id="tib_sys_soap_output"></div>
     </td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
  </tr>
  <tr>
     <td>
       <div id="tib_sys_soap_falut"></div>
     </td>
  </tr>
</table>
</center>

<!-- js input脚本模板 -->
<script id="erp_query_template" type="text/mustache">
<table class="erp_template" style="table-layout:fixed;width:100%" >
<col style="width: 40%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 20%" />
<col style="width: 15%" />
	<caption>{{info.caption}}</caption>
	<thead>
		<tr>
		{{#info.thead}}
			<td style='font-size:13px; text-align:center;' nowrap >{{{th}}}</td>
		{{/info.thead}}
		</tr>
	</thead>
	<tbody>
		{{#info.tbody}}
		<tr  id="{{nodeKey}}"  {{^root}} class="child-of-{{parentKey}}" {{/root}} >
			<td><span {{^hasNext}} class='file' {{/hasNext}} {{#hasNext}} class='folder' {{/hasNext}}  >{{nodeName}}</span></td>
			<td>
				{{dataType}}
				<input type="hidden" nodeKey="{{nodeKey}}" commentName="dataType" value="{{dataType}}"/>
			</td>
			<td>{{#comment.minOccurs}}  min:{{comment.minOccurs}} {{/comment.minOccurs}}  {{#comment.maxOccurs}} max:{{comment.maxOccurs}}{{/comment.maxOccurs}} </td>
			<td>
				{{^isHead}}
				{{^hasNext}}
				<select name="{{nodeKey}}_inputSelect" id="{{nodeKey}}_inputSelect" commentValue="{{comment.inputSelect}}"
						onchange="inputSelectChange(this.value, '{{nodeKey}}');" nodeKey="{{nodeKey}}" commentName="inputSelect">
					<option value="1">固定值</option>
					<option value="2">最后更新时间</option>
					<option value="3">当前执行时间</option>
				</select>
				<input type="text" class="inputsgl" name="{{nodeKey}}_inputText" id="{{nodeKey}}_inputText" {{#comment.inputText}} value="{{comment.inputText}}" {{/comment.inputText}} nodeKey="{{nodeKey}}" commentName="inputText"/>
				{{/hasNext}}
				{{/isHead}}
			</td>
 			<td>
				{{^isHead}}
				{{^hasNext}}
            	<input type="text" id="{{nodeKey}}_mark" class="inputsgl" commentName="mark"  name="{{nodeKey}}_mark"  nodeKey="{{nodeKey}}" {{#comment.mark}} value="{{comment.mark}}" {{/comment.mark}} /> 
				{{/hasNext}}
				{{/isHead}}	
			</td>
		</tr>
		{{/info.tbody}}
	</tbody>
</table>
</script>

<script id="erp_query_outtemplate" type="text/mustache">
<table class="erp_template" style="table-layout:fixed;width:100%" >
<col style="width: 45%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 20%" />
<col style="width: 20%" />
	<caption>{{info.caption}}</caption>
	<thead>
		<tr>
		{{#info.thead}}
			<td style='font-size:13px; text-align:center;' nowrap >{{{th}}}</td>
		{{/info.thead}}
		</tr>
	</thead>
	<tbody>
		{{#info.tbody}}
			{{#isMore}}
			<tr>
				<td align="right">
				同步方式:
				<select style="width:110px;" id="{{nodeKey}}_syncType" name="{{nodeKey}}_syncType" onchange="syncTypeChange(this.value, '{{nodeKey}}');" 
						nodeKey="{{nodeKey}}" commentName="syncType" commentValue="{{comment.syncType}}">
       	   	 		<option value="">==请选择==</option>
       	   	 		<option value="2">全量</option>
       	   	 		<option value="1">增量</option>
       	   	 		<option value="3">增量(时间戳)</option>
       	   	 		<option value="4">增量(插入前删除)</option>
       	   	 		<option value="5">增量(条件删除)</option>
       	   	 	</select>
       	   	 	<select id="{{nodeKey}}_syncType_date" name="{{nodeKey}}_syncType_date" nodeKey="{{nodeKey}}" 
						commentName="syncType_date" commentValue="{{comment.syncType_date}}" style="display: none;">
       	   	 		<option value="">==请选择==</option>
       	   	 	</select>
       	   	 	<span id="{{nodeKey}}_delConditionSpan" style="display: none;">
       	   	 	<input type="text" id="{{nodeKey}}_fdDelConditionName" name="{{nodeKey}}_fdDelConditionName" value="" 
					nodeKey="{{nodeKey}}" commentName="fdDelConditionName" commentValue="{{comment.fdDelConditionName}}" readonly="readonly" size="17" class="inputsgl"/>
       	   	 	<img style="cursor:pointer" alt="公式定义" onclick="conditionImgClick('{{nodeKey}}_fdDelConditionName', '{{nodeKey}}_fdDelConditionName', '{{nodeKey}}');" src="${KMSS_Parameter_ContextPath}resource/style/default/icons/edit.gif"/>
       	   	 	<img style="cursor:pointer" alt="帮助" src="${KMSS_Parameter_ContextPath}resource/style/default/tag/help.gif" onclick="Com_OpenWindow('tibSoapSyncHelp.jsp','_blank')" />
       	   		</span>
				
				&nbsp;<font color="blur" align="right">同步表</font>
				</td>
				<td colspan="5">
					<input type="text" id="{{nodeKey}}_fdSyncTable" name="{{nodeKey}}_fdSyncTable" xpath="{{xpath}}"
						nodeKey="{{nodeKey}}" commentName="fdSyncTable" commentValue="{{comment.fdSyncTable}}" readonly="readonly" class="inputsgl"/>
					<img style="cursor:pointer" alt="选择同步表" onclick="syncTableChange('{{nodeKey}}_fdSyncTable', '{{nodeKey}}_fdSyncTable', '{{nodeKey}}');"
       	   	 			src="${KMSS_Parameter_ContextPath}resource/style/common/images/small_search.png"/>
					KEY:
					<select style="width:105px;" name="{{nodeKey}}_key_mappingValue" id="{{nodeKey}}_key_mappingValue" commentValue="{{comment.key}}"
						nodeName="{{nodeName}}" nodeKey="{{nodeKey}}" commentName="key" isMore="true">
						<option value="">==请选择==</option>
					</select>
					&nbsp;	
					生成FD_ID:
					<select style="width:105px;" name="{{nodeKey}}_generateFdId_mappingValue" id="{{nodeKey}}_generateFdId_mappingValue" 
						commentValue="{{comment.generateFdId}}" nodeName="{{nodeName}}" nodeKey="{{nodeKey}}" commentName="generateFdId" isMore="true">
						<option value="">==请选择==</option>
					</select>	
				</td>
			</tr>
			{{/isMore}}
		<tr id="{{nodeKey}}"  {{^root}} class="child-of-{{parentKey}}" {{/root}} >
			<td><span {{^hasNext}} class='file' {{/hasNext}} {{#hasNext}} class='folder' {{/hasNext}}  >{{nodeName}}</span></td>
			<td>{{dataType}}</td>
			<td>{{#comment.minOccurs}}  min:{{comment.minOccurs}} {{/comment.minOccurs}}  {{#comment.maxOccurs}} max:{{comment.maxOccurs}}{{/comment.maxOccurs}} </td>
			<td>
				{{^isHead}}
				{{^hasNext}}
				{{#pMore}}
				<select style="width:90%" name="{{nodeKey}}_mappingValue" id="{{nodeKey}}_mappingValue" commentValue="{{comment.mappingValue}}"
						nodeName="{{nodeName}}" nodeKey="{{nodeKey}}" commentName="mappingValue" {{#isMore}}isMore="true"{{/isMore}} {{^isMore}}isMore="false"{{/isMore}}>
					<option value="">==请选择==</option>
				</select>
				{{/pMore}}	
				{{/hasNext}}
				{{/isHead}}	
			</td>
 			<td>
				{{^isHead}}
				{{^hasNext}}
				{{#pMore}}
            	<input type="text" id="{{nodeKey}}_mark" class="inputsgl" commentName="mark"  
					name="{{nodeKey}}_mark"  nodeKey="{{nodeKey}}"
					{{#comment.mark}} value="{{comment.mark}}" {{/comment.mark}} /> 
				{{/pMore}}				
				{{/hasNext}}
				{{/isHead}}	
			</td>
		</tr>
		{{/info.tbody}}
	</tbody>
</table>
</script>
<script id="erp_query_faulttemplate" type="text/mustache">
<table class="erp_template" style="table-layout:fixed;width:100%" >
<col style="width: 45%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 20%" />
<col style="width: 15%" />
	<caption>{{info.caption}}</caption>
	<thead>
		<tr>
		{{#info.thead}}
			<td style='font-size:13px; text-align:center;' nowrap >{{{th}}}</td>
		{{/info.thead}}
		</tr>
	</thead>
	<tbody>
		{{#info.tbody}}
		<tr  id="{{nodeKey}}"  {{^root}} class="child-of-{{parentKey}}" {{/root}} >
			<td><span {{^hasNext}} class='file' {{/hasNext}} {{#hasNext}} class='folder' {{/hasNext}}  >{{nodeName}}</span></td>
			<td>{{dataType}}</td>
			<td>{{#comment.minOccurs}}  min:{{comment.minOccurs}} {{/comment.minOccurs}}  {{#comment.maxOccurs}} max:{{comment.maxOccurs}}{{/comment.maxOccurs}} </td>
			<td>
			</td>
 			<td>
				{{^isHead}}
				{{^hasNext}}
            	<input type="text" id="{{nodeKey}}_mark" class="inputsgl" commentName="mark"  name="{{nodeKey}}_mark"  nodeKey="{{nodeKey}}" {{#comment.mark}} value="{{comment.mark}}" {{/comment.mark}} /> 
				{{/hasNext}}
				{{/isHead}}	
			</td>
		</tr>
		{{/info.tbody}}
	</tbody>
</table>
</script>

<script type="text/javascript" src="soapQuartzCfg.js"></script>

<%@ include file="/resource/jsp/edit_down.jsp"%>


