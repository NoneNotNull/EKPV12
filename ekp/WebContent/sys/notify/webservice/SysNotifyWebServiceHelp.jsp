<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("optbar.js|list.js");
</script>
<script>
 function expandMethod(thisObj) {
	var isExpand=thisObj.getAttribute("isExpanded");
	if(isExpand==null)
		isExpand="0";
	var trObj=thisObj.parentNode;
	trObj=trObj.nextSibling;
	while(trObj!=null){
		if(trObj!=null && trObj.tagName=="TR"){
			break;
		}
		trObj = trObj.nextSibling;
	}
	var imgObj=thisObj.getElementsByTagName("IMG")[0];
	if(trObj.tagName.toLowerCase()=="tr"){
		if(isExpand=="0"){
			trObj.style.display="block";
			thisObj.setAttribute("isExpanded","1");
			imgObj.setAttribute("src","${KMSS_Parameter_StylePath}icons/collapse.gif");
		}else{
			trObj.style.display="none";
			thisObj.setAttribute("isExpanded","0");
			imgObj.setAttribute("src","${KMSS_Parameter_StylePath}icons/expand.gif");
		}
	}
 }
</script>


<div id="optBarDiv"><input type="button"
	value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle">${param.name}接口说明</p>

<center>
<div style="width: 95%;text-align: left;">
	<p>&nbsp;&nbsp;EKP系统提供了待办webservice服务，包含了发送待办（sendTodo）、删除待办（deleteTodo）、
	设为已办（setTodoDone）、获取待办信息（getTodo）等4个接口，以下是对上述接口的具体说明。
	</p>
</div>
<br/>

<table border="0" width="95%">
	<tr>
		<td><b>1、接口说明</b></td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);">&nbsp;&nbsp;1.1&nbsp;&nbsp;发送待办接口(sendTodo)
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
			</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;待办发送上下文（NotifyTodoSendContext），详细说明如下:</div>
						<table class="tb_normal" cellpadding="0" cellspacing="0" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="10%"><b>程序名</b></td>
								<td align="center" width="10%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="15%"><b>可否为空</b></td>
								<td align="center" width="55%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>appName</td>
								<td>待办来源</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>标识待办来源的系统</td>
							</tr>
							<tr>
								<td>modelName</td>
								<td>模块名</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>标识待办来源的模块</td>
							</tr>
							<tr>
								<td>modelId</td>
								<td>待办唯一标识</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>标识待办在原系统唯一标识</td>
							</tr>
							<tr>
								<td>subject</td>
								<td>标题</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>待办标题</td>
							</tr>
							<tr>
								<td>link</td>
								<td>链接</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>
									对应待办的链接地址(全路径)
								</td>
							</tr>
							<tr>
								<td>type</td>
								<td>待办类型</td>
								<td>数字(int)</td>
								<td>不允许为空</td>
								<td>1:表示审批类待办<br/>
									2:表示为通知类待办
								</td>
							</tr>
							<tr>
								<td>key</td>
								<td>关键字</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>待办关键字，用于区分同一文档下不同类型待办，
									如:会议文档的抄送待办和与会人参加待办属于同一文档的不同类型的待办。
								</td>
							</tr>
							<tr>
								<td>param1</td>
								<td>参数1</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>待办附加标识。功能同"关键字"，辅助区分不同类型的待办</td>
							</tr>
							<tr>
								<td>param2</td>
								<td>参数2</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>待办附加标识。功能同"关键字"，辅助区分不同类型的待办</td>
							</tr>
							<tr>
								<td>targets</td>
								<td>待办所属对象</td>
								<td>字符串(JSON)</td>
								<td>不允许为空</td>
								<td>待办对应接收人，数据格式为JSON，格式描述请查看"<a href="#orgInfo">《2.1  组织架构数据说明》</a>"。</td>
							</tr>
							<tr>
								<td>createTime</td>
								<td>创建时间</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>
									格式为:yyyy-MM-dd HH:mm:ss
								</td>
							</tr>
							<tr>
								<td>docCreator</td>
								<td>待办创建者</td>
								<td>字符串(JSON)</td>
								<td>可为空</td>
								<td>待办的创建者。数据格式为JSON，格式描述请查看"<a href="#orgInfo">《2.1  组织架构数据说明》</a>"。</td>
							</tr>
							<tr>
								<td>level</td>
								<td>待办优先级</td>
								<td>数字(Integer)</td>
								<td>可为空</td>
								<td>待办优先级。如：按紧急（1）、急（2）、一般（3）。 </td>
							</tr>
							<tr>
								<td>extendContent</td>
								<td>消息内容扩展</td>
								<td>字符串(JSON)</td>
								<td>可为空</td>
								<td> 数据格式为JSON，格式描述请查看"<a href="#extendContentInfo">《2.3 extendContent的格式说明》</a>"。 
							  </td>
							</tr>
							<tr>
								<td>others</td>
								<td>扩展参数</td>
								<td>字符串(JSON)</td>
								<td>可为空</td>
								<td>备用参数，方便以后参数的扩展。数据格式为JSON，格式如：{key1:value1,key2:value2}。</td>
							</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;待办发送后返回信息（NotifyTodoAppResult），详细说明如下:</div>
						<table class="tb_normal" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="10%"><b>程序名</b></td>
								<td align="center" width="10%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="15%"><b>可否为空</b></td>
								<td align="center" width="55%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>returnState</td>
								<td>返回状态</td>
								<td>数字(int)</td>
								<td>不允许为空</td>
								<td>0:表示未操作<br/>
									1:表示操作失败<br/>
									2:表示操作成功
								</td>
							</tr>
							<tr>
								<td>message</td>
								<td>返回信息</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>
									返回状态值为0时，该值返回空。<br/>
									返回状态值为1时，该值错误信息。<br/>
									返回状态值为2时， 该值返回空。
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);"><br/>&nbsp;&nbsp;1.2&nbsp;&nbsp;删除待办接口(deleteTodo)
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
			</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;待办上下文（NotifyTodoRemoveContext），详细说明如下:</div>
						<table class="tb_normal" cellpadding="0" cellspacing="0" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="10%"><b>程序名</b></td>
								<td align="center" width="10%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="15%"><b>可否为空</b></td>
								<td align="center" width="55%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>appName</td>
								<td>待办来源</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>标识待办来源的系统</td>
							</tr>
							<tr>
								<td>modelName</td>
								<td>模块名</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>标识待办来源的模块</td>
							</tr>
							<tr>
								<td>modelId</td>
								<td>待办唯一标识</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>标识待办在原系统唯一标识</td>
							</tr>
							<tr>
								<td>optType</td>
								<td>操作类型</td>
								<td>数字(int)</td>
								<td>不允许为空</td>
								<td>1:表示删除待办操作<br/>
									2:表示删除指定待办所属人操作
								</td>
							</tr>
							<tr>
								<td>key</td>
								<td>关键字</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>待办关键字，用于区分同一文档下不同类型待办，
									如:会议文档的抄送待办和与会人参加待办属于同一文档的不同类型的待办。
								</td>
							</tr>
							<tr>
								<td>param1</td>
								<td>参数1</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>待办附加标识。功能同"关键字"，辅助区分不同类型的待办</td>
							</tr>
							<tr>
								<td>param2</td>
								<td>参数2</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>待办附加标识。功能同"关键字"，辅助区分不同类型的待办</td>
							</tr>
							<tr>
								<td>targets</td>
								<td>待办所属对象</td>
								<td>字符串(JSON)</td>
								<td>当操作类型为2时,生效,且不能为空</td>
								<td>待办对应接收人，数据格式为JSON，格式描述请查看"<a href="#orgInfo">《2.1  组织架构数据说明》</a>"</td>
							</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;待办删除后返回信息（NotifyTodoAppResult），详细说明如下:</div>
						<table class="tb_normal" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="10%"><b>程序名</b></td>
								<td align="center" width="10%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="15%"><b>可否为空</b></td>
								<td align="center" width="55%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>returnState</td>
								<td>返回状态</td>
								<td>数字(int)</td>
								<td>不允许为空</td>
								<td>0:表示未操作<br/>
									1:表示操作失败<br/>
									2:表示操作成功
								</td>
							</tr>
							<tr>
								<td>message</td>
								<td>返回信息</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>
									返回状态值为0时，该值返回空。<br/>
									返回状态值为1时，该值错误信息。<br/>
									返回状态值为2时， 该值返回空。
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);"><br/>&nbsp;&nbsp;1.3&nbsp;&nbsp;设为已办接口(setTodoDone)
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
			</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;待办上下文（NotifyTodoRemoveContext），详细说明如下:</div>
						<table class="tb_normal" cellpadding="0" cellspacing="0" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="10%"><b>程序名</b></td>
								<td align="center" width="10%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="15%"><b>可否为空</b></td>
								<td align="center" width="55%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>appName</td>
								<td>待办来源</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>待办来源的系统标识</td>
							</tr>
							<tr>
								<td>modelName</td>
								<td>模块名</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>待办来源的模块标识</td>
							</tr>
							<tr>
								<td>modelId</td>
								<td>待办唯一标识</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>待办在原系统唯一标识</td>
							</tr>
							<tr>
								<td>optType</td>
								<td>操作类型</td>
								<td>数字(int)</td>
								<td>不允许为空</td>
								<td>1:表示设待办为已办操作<br/>
									2:表示设置目标待办所属人为已办操作
								</td>
							</tr>
							<tr>
								<td>key</td>
								<td>关键字</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>待办关键字，用于区分同一文档下不同类型待办，
									如:会议文档的抄送待办和与会人参加待办属于同一文档的不同类型的待办。
								</td>
							</tr>
							<tr>
								<td>param1</td>
								<td>参数1</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>待办附加标识。功能同"关键字"，辅助区分不同类型的待办</td>
							</tr>
							<tr>
								<td>param2</td>
								<td>参数2</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>待办附加标识。功能同"关键字"，辅助区分不同类型的待办</td>
							</tr>
							<tr>
								<td>targets</td>
								<td>待办所属人</td>
								<td>字符串(JSON)</td>
								<td>当操作类型为2时,生效,且不能为空</td>
								<td>待办所属人，数据格式为JSON，格式描述请查看"<a href="#orgInfo">《2.1  组织架构数据说明》</a>"。</td>
							</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;设为已办后返回信息（NotifyTodoAppResult），详细说明如下:</div>
						<table class="tb_normal" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="10%"><b>程序名</b></td>
								<td align="center" width="10%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="15%"><b>可否为空</b></td>
								<td align="center" width="55%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>returnState</td>
								<td>返回状态</td>
								<td>数字(int)</td>
								<td>不允许为空</td>
								<td>0:表示未操作<br/>
									1:表示操作失败<br/>
									2:表示操作成功
								</td>
							</tr>
							<tr>
								<td>message</td>
								<td>返回信息</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>
									返回状态值为0时，该值返回空。<br/>
									返回状态值为1时，该值错误信息。<br/>
									返回状态值为2时， 该值返回空。
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);"><br/>&nbsp;&nbsp;1.4&nbsp;&nbsp;获取待办接口(getTodo)
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
			</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;获取待办上下文（NotifyTodoGetContext），详细说明如下:</div>
						<table class="tb_normal" cellpadding="0" cellspacing="0" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="10%"><b>程序名</b></td>
								<td align="center" width="10%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="15%"><b>可否为空</b></td>
								<td align="center" width="55%"><b>备注说明</b></td>
							</tr>
							 <TR>
					          <TD>targets</TD>
					          <TD>待办所属对象</TD>
					          <TD>字符串(JSON)</TD>
					          <TD>不允许为空</TD>
					          <TD>
					          	    表示获取指定人待办列表。<BR>数据格式为JSON，格式描述请查看"《2.1  组织架构数据说明》"。
					          </TD></TR>
					        <TR>
					          <TD>type</TD>
					          <TD>待办类型</TD>
					          <TD>数字(int)</TD>
					          <TD>可为空</TD>
					          <TD>	
					                1:为审批类待办<BR>
					          		2:为通知类待办<BR>
					          		3:为已办通知<BR>
					          		为空，表示获取审批和通知类型待办列表<BR>
					          		不为空，表示获取指定类型待办列表。 
					        	</TD>
					        </TR>
					        <TR>
					          <TD>otherCond</TD>
					          <TD>其他条件</TD>
					          <TD>字符串(JSON)</TD>
					          <TD>可为空</TD>
					          <TD>辅助上两个查询条件，来定位要获取的待办列表。<BR/>
					          	  数据格式为JSON数组，为:[{类型1:值1}，{类型2:值2}...]<BR/>
					          	 如:[{"key":"reviewmain"}，{"modelId":"1edc3456bf"}]表示除待办所属人、待办类型外，
					          	 附加待办关键字和待办唯一标识来查询待办信息。<br/>
					          	 类型可为:appName（待办来源）、modelName（所属模块）、modelId（唯一标识）、subject（主题）、
					          	 link（链接）、key（关键字）、param1（参数1）、param2（参数2）
							  </TD>
					        </TR>
					        <TR>
					          <TD>rowSize</TD>
					          <TD>分页大小</TD>
					          <TD>数字(int)</TD>
					          <TD>可为空</TD>
					          <TD>设置获取待办每页条数<BR>
					          	为空，则取EKP系统默认每页条数。<BR>
					          	不为空，则取设定的每条条目数 </TD>
					        </TR>
					        <TR>
					          <TD>pageNo</TD>
					          <TD>页码</TD>
					          <TD>数字(int)</TD>
					          <TD>可为空</TD>
					          <TD>获取设置的第几页数据。<BR>为空表示获取第1页数据（1为ekp系统的起始页）。 </TD>
					          </TR>
					</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;获取待办列表返回信息（NotifyTodoAppResult），详细说明如下:</div>
						<table class="tb_normal" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="10%"><b>程序名</b></td>
								<td align="center" width="10%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="15%"><b>可否为空</b></td>
								<td align="center" width="55%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>returnState</td>
								<td>返回状态</td>
								<td>数字(int)</td>
								<td>不允许为空</td>
								<td>0未操作<br/>
									1失败<br/>
									2成功
								</td>
							</tr>
							<tr>
								<td>message</td>
								<td>返回信息</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>
									返回状态值为0时，该值返回空。<br/>
									返回状态值为1时，该值错误信息。<br/>
									返回状态值为2时，返回待办列表的数据，格式为JSON，格式说明请查看"<a href="#dataInfo">《2.2  待办列表数据格式说明 》</a>"。
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td><br/><b>2、各种数据格式说明</b></td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);" id="orgInfo"><br/>&nbsp;&nbsp;2.1&nbsp;&nbsp;组织架构数据说明
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
			</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">
						数据格式
					</td>
					<td>单值格式为:  {类型: 值}，    如{"PersonNo":"001"}。<br/>
						多值格式为: [{类型1:值1}，{类型2:值2}...]，如:  [{"PersonNo":"001"}，{"KeyWord":"2EDF6"}]。
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">说明</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;对于"格式"中的类型，以下是对应的类型说明表:</div>
						<table class="tb_normal" width=100%>
							<tr class="tr_normal_title">
								<td><b>类型名</b></td>
								<td><b>描述</b></td>
							</tr>
							<tr>
								<td>Id</td>
								<td>EKP系统组织架构唯一标识</td>
							</tr>
							<tr>
								<td>PersonNo</td>
								<td>EKP系统组织架构个人编号</td>
							</tr>
							<tr>
								<td>DeptNo</td>
								<td>EKP系统组织架构部门编号</td>
							</tr>
							<tr>
								<td>PostNo</td>
								<td>EKP系统组织架构岗位编号</td>
							</tr>
							<tr>
								<td>GroupNo</td>
								<td>EKP系统组织架构常用群组编号</td>
							</tr>
							<tr>
								<td>LoginName</td>
								<td>EKP系统组织架构个人登录名</td>
							</tr>
							<tr>
								<td>Keyword</td>
								<td>EKP系统组织架构关键字</td>
							</tr>
							<tr>
								<td>LdapDN</td>
								<td>和LDAP集成时LDAP中DN值</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);" id="dataInfo"><br/>&nbsp;&nbsp;2.2&nbsp;&nbsp;待办列表数据格式说明
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
			</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">
						数据格式
					</td>
					<td>
						<b>如果结果集大于0.则数据格式为:</b><br>
						{<br/>
							&nbsp;&nbsp;"pageCount":"100"，                //总页数 <br/>
							&nbsp;&nbsp;"pageno":"37"，                    //当前页码<br/>
							&nbsp;&nbsp;"count":"37001"                   //文档总数<br/>
							&nbsp;&nbsp;"docs":[						  //文档列表<br/>
							&nbsp;&nbsp;&nbsp;&nbsp;{<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;"id":"123443debc"，         //EKP系统待办唯一标识 ，不为空。<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;"subject":"请处理:XXXX"，	   //标题，不为空。<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;"type":"1"，                //待办类型， 不为空。<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;"key":"reviewmain"，        //待办关键字， 可为空。<br/>
						            &nbsp;&nbsp;&nbsp;&nbsp;"param1":""，               //参数1，可为空。<br/>
						          	&nbsp;&nbsp;&nbsp;&nbsp;"param2":""，               //参数2，可为空。<br/>
						          	&nbsp;&nbsp;&nbsp;&nbsp;"appName":"HR"，			   //待办来源，可为空，为空表示为ekp系统待办。<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;"modelName":"绩效"，        //模块名，不为空。<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;"modelId":"12342"，         //待办唯一标识，不为空。待办来源为空时，表示EKP系统待办对应的主文档ID<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;"createTime":""，           //创建时间 ，不为空。<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;"link":"/sys/notify/sys_notify_todo.do?method=view&fdId=12345"   //不为空<br/>
								&nbsp;&nbsp;&nbsp;&nbsp;}，<br/>
								&nbsp;&nbsp;&nbsp;&nbsp;……<br/>
							&nbsp;&nbsp;]<br/>
						}<br/>
						<b>没有结果集的时候返回信息:</b><br/>
						{<br/>
							&nbsp;&nbsp;"errorPage":"true"，                  // 请求数据错误<br/>
							&nbsp;&nbsp;"message":"很抱歉，未找到相应的记录！" //错误信息<br/>
						}
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);" id="extendContentInfo"><br/>&nbsp;&nbsp;2.3&nbsp;&nbsp;extendContent的格式说明
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
			</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">
						数据格式
					</td>
					<td>
						<b>待办发送接口参数extendContent的格式说明:</b><br/>
							 &nbsp;&nbsp;[<br>
									&nbsp;&nbsp;&nbsp;&nbsp;{<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//对于日期类型属性，类型type都为date,由dateType的值指定datetime,date,time这种类型，值为转换为的Long类型进行保存<br/>
						         	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;key:"fdHoldDate",    titleMsgKey:"km-meeting:kmMeetingMain.fdHoldDate",type:"Date",dateType:"datetime",value:63434343445,<br/>
						       		&nbsp;&nbsp;&nbsp;&nbsp;},<br/>
						        	&nbsp;&nbsp;&nbsp;&nbsp;{<br/>
						         	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; key:"fdHoldPlace",titleMsgKey:"km-meeting:kmMeetingMain.fdHoldPlace",type:"String",value:"5号会议室"<br/>
						        	&nbsp;&nbsp;&nbsp;&nbsp;},<br/>
						        	&nbsp;&nbsp;&nbsp;&nbsp;{<br/>
						        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//对于对象类型，需要在传入之前获取具体名称或内容传入，type为String<br>
						        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; key:"fdEmcee",titleMsgKey:"km-meeting:kmMeetingMain.fdEmceeId",type:"String":value:"张三"<br/>
						        	&nbsp;&nbsp;&nbsp;&nbsp;},<br/>
						       	 	&nbsp;&nbsp;&nbsp;&nbsp;{<br/>
						        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//对于枚举类型，type指定为Enums，枚举中的所有text的的msgKey的规则为,由enumsType中的值指定的enums.xml中定义的类型type<br/>
						        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;key:"fdNature",titleMsgKey:"km-missive:kmMissiveUnit.fdNature",type:"Enums",value:"1",enumsType:"kmMissiveUnit.fdNature"<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;},<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;{<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //当前节点<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;key:"lbpmCurrNode",titleMsgKey:"sys-lbpmservice:lbpmSupport.STATUS_RUNNING",value:"领导审批"<br/>
						        	&nbsp;&nbsp;&nbsp;&nbsp;}<br/>
						       		&nbsp;&nbsp;&nbsp;&nbsp;...<br/>
					     	&nbsp;&nbsp;]<br>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td><br/><b>3、参考代码</b></td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);">&nbsp;&nbsp;待办发送样例
		<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	<tr style="display: none">
		<td>
		<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;"><tr><td>
				public static void main(String[] args) throws Exception {<br/>
					&nbsp;&nbsp;WebServiceConfig cfg = WebServiceConfig.getInstance();<br/>
					&nbsp;&nbsp;ISysNotifyTodoWebService service = (ISysNotifyTodoWebService)callService(cfg.getAddress(), cfg.getServiceClass());<br/>
					&nbsp;&nbsp;// 请在此处添加业务代码<br/>
					&nbsp;&nbsp;NotifyTodoContext context = new NotifyTodoContext();<br/>
					&nbsp;&nbsp;context.setSubject("测试待办webservice~~~");<br/>
					&nbsp;&nbsp;context.setLink("http://news.sina.com.cn/");<br/>
					&nbsp;&nbsp;context.setType(2);<br/>
					&nbsp;&nbsp;context.setKey("sinaNews");<br/>
					&nbsp;&nbsp;context.setModelId("123456789");<br/>
					&nbsp;&nbsp;context.setTargets("{\"Id\":\"12fe2de141b7b97b32d1af34204a9f54\"}");<br/>
					&nbsp;&nbsp;context.setOptTime("2012-03-22 09:25:09");<br/>
					&nbsp;&nbsp;JSONObject nodeJson = new JSONObject();<br/>
            		&nbsp;&nbsp;nodeJson.accumulate("key", "lbpmCurrNode");<br/>
           			&nbsp;&nbsp;nodeJson.accumulate("titleMsgKey","sys-lbpmservice:lbpmSupport.STATUS_RUNNING");<br/>
            		&nbsp;&nbsp;nodeJson.accumulate("value", ((LbpmNode) taskInstance.getFdNode()).getFdFactNodeName());<br/>
			        &nbsp;&nbsp;JSONArray ctxExt = new JSONArray();<br/>
			        &nbsp;&nbsp;ctxExt.add(nodeJson);<br/>
			        &nbsp;&nbsp;context.setFdExtendContent(ctxExt.toString());<br/>
					&nbsp;&nbsp;NotifyTodoAppResult result = service.sendTodo(context);<br/>
					&nbsp;&nbsp;if (result != null) {<br/>
						&nbsp;&nbsp;&nbsp;&nbsp;if (result.getReturnState() != 2)<br/>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;System.out.println(result.getMessage());<br/>
					&nbsp;&nbsp;}<br/>
				}<br/>
				
				/**<br/>
				 * 调用服务，生成客户端的服务代理<br/>
				 * <br/>
				 * @param address WebService的URL<br/>
				 * @param serviceClass 服务接口全名<br/>
				 * @return 服务代理对象<br/>
				 * @throws Exception<br/>
				 */<br/>
				public static Object callService(String address, Class serviceClass)<br/>
						throws Exception {<br/>
					&nbsp;&nbsp;JaxWsProxyFactoryBean factory = new JaxWsProxyFactoryBean();<br/>
					&nbsp;&nbsp;// 记录入站消息<br/>
					&nbsp;&nbsp;factory.getInInterceptors().add(new LoggingInInterceptor());<br/>
					&nbsp;&nbsp;// 记录出站消息<br/>
					&nbsp;&nbsp;factory.getOutInterceptors().add(new LoggingOutInterceptor());<br/>
					
					&nbsp;&nbsp;// 添加消息头验证信息。如果服务端要求验证用户密码，请加入此段代码<br/>
					&nbsp;&nbsp;// factory.getOutInterceptors().add(new AddSoapHeader());<br/>
			
					&nbsp;&nbsp;factory.setServiceClass(serviceClass);<br/>
					&nbsp;&nbsp;factory.setAddress(address);<br/>
					
					&nbsp;&nbsp;// 使用MTOM编码处理消息。如果需要在消息中传输文档附件等二进制内容，请加入此段代码<br/>
					&nbsp;&nbsp;// Map<String, Object> props = new HashMap<String, Object>();<br/>
					&nbsp;&nbsp;// props.put("mtom-enabled", Boolean.TRUE);<br/>
					&nbsp;&nbsp;// factory.setProperties(props);<br/>
			        
			        &nbsp;&nbsp;// 创建服务代理并返回<br/>
					&nbsp;&nbsp;return factory.create();<br/>
				}
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

</center>

<%@ include file="/resource/jsp/view_down.jsp"%>