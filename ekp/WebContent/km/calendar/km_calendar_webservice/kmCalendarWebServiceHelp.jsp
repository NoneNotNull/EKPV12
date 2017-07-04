<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script type="text/javascript">Com_IncludeFile("optbar.js|list.js");</script>
<script>
 function expandMethod(thisObj) {
	var isExpand=thisObj.getAttribute("isExpanded");
	if(isExpand==null)
		isExpand="0";
	var trObj=thisObj.parentNode;
	trObj=trObj.nextSibling;
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

<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();"/>
</div>
<p class="txttitle">${param.name}接口说明</p>

<center>
<div style="width: 95%;text-align: left;">
	<p>EKP系统提供了日程管理webservice服务，包含了创建日程/笔记（addCalendar）、变更日程/笔记（updateCalendar）、读取日程/笔记（viewCalendar）、查询日程/笔记（listCalendar）、
		冲突检测（conflictCheck）、设置日程提醒（setNotify）等接口，以下是对上述接口的具体说明。
	</p>
</div>
<br/>


<table border="0" width="95%">
	<tr>
		<td><b>1、接口说明</b></td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);"><br/>1.1.创建日程/笔记(addCalendar)
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 95%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">日程/笔记表单(KmCalendarParamterForm)，详细说明如下:</div>
						<table class="tb_normal" cellpadding="0" cellspacing="0" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="14%"><b>程序名</b></td>
								<td align="center" width="11%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="20%"><b>可否为空</b></td>
								<td align="center" width="45%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>fdAppKey</td>
								<td>日程或笔记来源</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>标识日程或笔记来源的系统</td>
							</tr>
							<tr>
								<td>fdAppUUId</td>
								<td>日程或笔记id</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td>日程或笔记来源系统所存储的ID，若为空，与EKP系统ID一致</td>
							</tr>
							<tr>
								<td>fdId</td>
								<td>日程或笔记fdId</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td>日程或笔记EKP系统中的ID，若为空，EKP系统自动生成</td>
							</tr>
							<tr>
								<td>fdType</td>
								<td>类型</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>"note":笔记<br/>"event":日程</td>
							</tr>
							<tr>
								<td>docSubject</td>
								<td>标题</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td></td>
							</tr>
							<tr>
								<td>docContent</td>
								<td>内容</td>
								<td>字符串(String)</td>
								<td>若fdType="note"时不允许为空</td>
								<td></td>
							</tr>
							<tr>
								<td>fdIsAlldayevent</td>
								<td>是否全天</td>
								<td>字符串(String)</td>
								<td>若fdType="event"时不允许为空</td>
								<td>标示日程是否为全天任务; true:全天    false:非全天</td>
							</tr>
							<tr>
								<td>docStartTime</td>
								<td>开始时间</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>格式:yyyy-MM-dd mm:hh</td>
							</tr>
							<tr>
								<td>docFinishTime</td>
								<td>结束时间</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td></td>
							</tr>
							<tr>
								<td>fdAuthorityType</td>
								<td>日程活动性质</td>
								<td>字符串(String)</td>
								<td>若fdType="event"时不允许为空</td>
								<td>"DEFAULT":默认<br/>"PUBLIC":公开<br/>"PRIVATE":私有</td>
							</tr>
							<tr>
								<td>fdLocation</td>
								<td>日程地点</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td></td>
							</tr>
							<tr>
								<td>fdRelationUrl</td>
								<td>相关链接</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td>外部系统或者外部模块相关URL</td>
							</tr>
							<tr>
								<td>docCreator</td>
								<td>创建者</td>
								<td>字符串(JSON)</td>
								<td>不允许为空</td>
								<td>数据格式为JSON(单值)，格式描述请查看"<a href="#orgInfo">《2.1  组织架构数据说明》</a>"。</td>
							</tr>
							<tr>
								<td>docOwner</td>
								<td>日程所有者</td>
								<td>字符串(JSON)</td>
								<td>若fdType="event"时不允许为空</td>
								<td>数据格式为JSON(单值)，格式描述请查看"<a href="#orgInfo">《2.1  组织架构数据说明》</a>"。</td>
							</tr>
							<tr>
								<td>recurrenceFreq</td>
								<td>重复类型</td>
								<td>字符串(String)</td>
								<td>若fdType="event"时不允许为空</td>
								<td>"NO":不重复<br/>"DAILY":按天<br/>"WEEKLY":按周<br/>"MONTHLY":按月<br/>"YEARLY":按年</td>
							</tr>
							<tr>
								<td>recurrenceInterval</td>
								<td>重复频率</td>
								<td>字符串(String)</td>
								<td>若recurrenceFreq<font color="red">!=</font>"NO"时,不允许为空</td>
								<td>格式必须整数</td>
							</tr>
							<tr>
								<td>recurrenceWeeks</td>
								<td>周重复时间</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td>
									此字段在recurrenceFreq="WEEKLY"时起作用;可取"SU"、"MO"、"TU"、"WE"、"TH"、"FR"、"SA"中的多个值,并以,分开.....<br/>
									例:"SU,MO"表示重复时间为每周日、周一
								</td>
							</tr>
							<tr>
								<td>recurrenceMonthType</td>
								<td>月重复时间</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td>
									此字段在recurrenceFreq="MONTHLY"时起作用;<br/>
									"week":一个星期中的某天<br/>
									"month":一个月中的某天
								</td>
							</tr>
							<tr>
								<td>recurrenceEndType</td>
								<td>结束条件</td>
								<td>字符串(String)</td>
								<td>若recurrenceFreq<font color="red">!=</font>"NO"时,不允许为空</td>
								<td>"NEVER":从不<br/>"COUNT":发生X次后结束<br/>"UNTIL":直到某天结束</td>
							</tr>
							<tr>
								<td>recurrenceCount</td>
								<td>发生X次后结束</td>
								<td>字符串(String)</td>
								<td>若recurrenceEndType<font color="red">!=</font>"COUNT"时,不允许为空</td>
								<td>格式必须整数</td>
							</tr>
							<tr>
								<td>recurrenceUntil</td>
								<td>直到某天结束</td>
								<td>字符串(String)</td>
								<td>若recurrenceEndType<font color="red">!=</font>"UNTIL"时,不允许为空</td>
								<td>日期格式yyyy-MM-dd</td>
							</tr>
							<tr>
								<td>kmCalendarNotify</td>
								<td>提醒列表</td>
								<td>字符串(Json)</td>
								<td>不允许为空</td>
								<td>数据格式为JSON，格式描述请查看"<a href="#orgInfo">《2.4  提醒Json说明》</a>"。</td>
							</tr>
							<tr>
								<td>attachmentForms</td>
								<td>笔记附件</td>
								<td>列表(List)</td>
								<td></td>
								<td>fdType="note"时起作用</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">创建后返回信息（KmCalendarResult），详细说明如下:</div>
						<table class="tb_normal" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="14%"><b>程序名</b></td>
								<td align="center" width="11%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="20%"><b>可否为空</b></td>
								<td align="center" width="45%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>returnState</td>
								<td>返回状态</td>
								<td>数字(int)</td>
								<td>不允许为空</td>
								<td>0:失败<br/>1:成功</td>
							</tr>
							<tr>
								<td>message</td>
								<td>返回信息</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>返回状态值为0时，该值错误信息。<br/>返回状态值为1时，该值返回空。</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);"><br/>1.2.变更日程/笔记(updateCalendar)
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 95%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">日程/笔记表单(KmCalendarParamterForm)，详细说明如下:</div>
						<table class="tb_normal" cellpadding="0" cellspacing="0" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="14%"><b>程序名</b></td>
								<td align="center" width="11%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="20%"><b>可否为空</b></td>
								<td align="center" width="45%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>fdAppKey</td>
								<td>日程或笔记来源</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>标识日程或笔记来源的系统</td>
							</tr>
							<tr>
								<td>fdAppUUId</td>
								<td>日程或笔记id</td>
								<td>字符串(String)</td>
								<td><font color="red">不允许</font>为空</td>
								<td>日程或笔记来源系统所存储的ID，若为空，与EKP系统ID一致</td>
							</tr>
							<tr>
								<td>fdId</td>
								<td>日程或笔记fdId</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td>日程或笔记EKP系统中的ID</td>
							</tr>
							<tr>
								<td>fdType</td>
								<td>类型</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>"note":笔记<br/>"event":日程</td>
							</tr>
							<tr>
								<td>docSubject</td>
								<td>标题</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td></td>
							</tr>
							<tr>
								<td>docContent</td>
								<td>内容</td>
								<td>字符串(String)</td>
								<td>若fdType="note"时不允许为空</td>
								<td></td>
							</tr>
							<tr>
								<td>fdIsAlldayevent</td>
								<td>是否全天</td>
								<td>字符串(String)</td>
								<td>若fdType="event"时不允许为空</td>
								<td>标示日程是否为全天任务</td>
							</tr>
							<tr>
								<td>docStartTime</td>
								<td>开始时间</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>格式:yyyy-MM-dd mm:hh</td>
							</tr>
							<tr>
								<td>docFinishTime</td>
								<td>结束时间</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td></td>
							</tr>
							<tr>
								<td>fdAuthorityType</td>
								<td>日程活动性质</td>
								<td>字符串(String)</td>
								<td>若fdType="event"时不允许为空</td>
								<td>"DEFAULT":默认<br/>"PUBLIC":公开<br/>"PRIVATE":私有</td>
							</tr>
							<tr>
								<td>fdLocation</td>
								<td>日程地点</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td></td>
							</tr>
							<tr>
								<td>fdRelationUrl</td>
								<td>相关链接</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td>外部系统或者外部模块相关URL</td>
							</tr>
							<tr>
								<td>docCreator</td>
								<td>创建者</td>
								<td>字符串(JSON)</td>
								<td>不允许为空</td>
								<td>数据格式为JSON(单值)，格式描述请查看"<a href="#orgInfo">《2.1  组织架构数据说明》</a>"。</td>
							</tr>
							<tr>
								<td>docOwner</td>
								<td>日程所有者</td>
								<td>字符串(JSON)</td>
								<td>若fdType="event"时不允许为空</td>
								<td>数据格式为JSON(单值)，格式描述请查看"<a href="#orgInfo">《2.1  组织架构数据说明》</a>"。</td>
							</tr>
							<tr>
								<td>recurrenceFreq</td>
								<td>重复类型</td>
								<td>字符串(String)</td>
								<td>若fdType="event"时不允许为空</td>
								<td>"NO":不重复<br/>"DAILY":按天<br/>"WEEKLY":按周<br/>"MONTHLY":按月<br/>"YEARLY":按年</td>
							</tr>
							<tr>
								<td>recurrenceInterval</td>
								<td>重复频率</td>
								<td>字符串(String)</td>
								<td>若recurrenceFreq<font color="red">!=</font>"NO"时,不允许为空</td>
								<td>格式必须整数</td>
							</tr>
							<tr>
								<td>recurrenceWeeks</td>
								<td>周重复时间</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td>
									此字段在recurrenceFreq="WEEKLY"时起作用;可取"SU"、"MO"、"TU"、"WE"、"TH"、"FR"、"SA"中的多个值,并以,分开.....<br/>
									例:"SU,MO"表示重复时间为每周日、周一
								</td>
							</tr>
							<tr>
								<td>recurrenceMonthType</td>
								<td>月重复时间</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td>
									此字段在recurrenceFreq="MONTHLY"时起作用;<br/>
									"week":一个星期中的某天<br/>
									"month":一个月中的某天
								</td>
							</tr>
							<tr>
								<td>recurrenceEndType</td>
								<td>结束条件</td>
								<td>字符串(String)</td>
								<td>若recurrenceFreq<font color="red">!=</font>"NO"时,不允许为空</td>
								<td>"NEVER":从不<br/>"COUNT":发生X次后结束<br/>"UNTIL":直到某天结束</td>
							</tr>
							<tr>
								<td>recurrenceCount</td>
								<td>发生X次后结束</td>
								<td>字符串(String)</td>
								<td>若recurrenceEndType<font color="red">!=</font>"COUNT"时,不允许为空</td>
								<td>格式必须整数</td>
							</tr>
							<tr>
								<td>recurrenceUntil</td>
								<td>直到某天结束</td>
								<td>字符串(String)</td>
								<td>若recurrenceEndType<font color="red">!=</font>"UNTIL"时,不允许为空</td>
								<td>日期格式yyyy-MM-dd</td>
							</tr>
							<tr>
								<td>kmCalendarNotify</td>
								<td>提醒列表</td>
								<td>字符串(Json)</td>
								<td>不允许为空</td>
								<td>数据格式为JSON，格式描述请查看"<a href="#orgInfo">《2.4  提醒Json说明》</a>"。</td>
							</tr>
							<tr>
								<td>attachmentForms</td>
								<td>笔记附件</td>
								<td>列表(List)</td>
								<td></td>
								<td>fdType="note"时起作用</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">创建后返回信息（KmCalendarResult），详细说明如下:</div>
						<table class="tb_normal" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="14%"><b>程序名</b></td>
								<td align="center" width="11%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="20%"><b>可否为空</b></td>
								<td align="center" width="45%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>returnState</td>
								<td>返回状态</td>
								<td>数字(int)</td>
								<td>不允许为空</td>
								<td>0:失败<br/>1:成功</td>
							</tr>
							<tr>
								<td>message</td>
								<td>返回信息</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>返回状态值为0时，该值错误信息。<br/>返回状态值为1时，该值返回空。</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);"><br/>1.3.读取日程/笔记(viewCalendar)
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 95%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">日程/笔记ID(fdAppUUId)，详细说明如下:</div>
						<table class="tb_normal" cellpadding="0" cellspacing="0" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="14%"><b>程序名</b></td>
								<td align="center" width="11%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="20%"><b>可否为空</b></td>
								<td align="center" width="45%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>fdAppUUId</td>
								<td>日程或笔记id</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>日程或笔记来源系统所存储的ID，若不存在，与EKP系统ID一致</td>
							</tr>
							<tr>
								<td>appKey</td>
								<td>日程或笔记来源</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>标识日程或笔记来源的系统</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">日程/笔记信息（KmCalendarParamterForm），详细说明参考addCalendar接口中的KmCalendarParamterForm参数</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);"><br/>1.4.删除日程/笔记(deleteCalendar)
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 95%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">日程/笔记ID(fdAppUUId)，详细说明如下:</div>
						<table class="tb_normal" cellpadding="0" cellspacing="0" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="14%"><b>程序名</b></td>
								<td align="center" width="11%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="20%"><b>可否为空</b></td>
								<td align="center" width="45%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>fdAppUUId</td>
								<td>日程或笔记id</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>日程或笔记来源系统所存储的ID，若不存在，与EKP系统ID一致</td>
							</tr>
							<tr>
								<td>appKey</td>
								<td>日程或笔记来源</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>标识日程或笔记来源的系统</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">查询后返回信息（KmCalendarResult），详细说明如下:</div>
						<table class="tb_normal" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="14%"><b>程序名</b></td>
								<td align="center" width="11%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="20%"><b>可否为空</b></td>
								<td align="center" width="45%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>returnState</td>
								<td>返回状态</td>
								<td>数字(int)</td>
								<td>不允许为空</td>
								<td>0:失败<br/>1:成功</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);"><br/>1.5.查询日程/笔记(listCalendar)
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 95%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">日程/笔记查询上下文(KmCalendarQueryContext)，详细说明如下:</div>
						<table class="tb_normal" cellpadding="0" cellspacing="0" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="14%"><b>程序名</b></td>
								<td align="center" width="11%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="20%"><b>可否为空</b></td>
								<td align="center" width="45%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>appKey</td>
								<td>日程或笔记来源</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td>标识日程或笔记来源的系统</td>
							</tr>
							<tr>
								<td>persons</td>
								<td>日程人员</td>
								<td>字符串(JSON)</td>
								<td>允许为空</td>
								<td>数据格式为JSON(单值、多值)，格式描述请查看"《2.1 组织架构数据说明》"。</td>
							</tr>
							<tr>
								<td>fdType</td>
								<td>查询类型</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td>"note":查询笔记<br/>"event":查询日程<br/>为空查询所有</td>
							</tr>
							<tr>
								<td>docStartTime</td>
								<td>开始时间</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td>格式:yyyy-MM-dd mm:hh</td>
							</tr>
							<tr>
								<td>docFinishTime</td>
								<td>结束时间</td>
								<td>字符串(String)</td>
								<td>允许为空</td>
								<td>格式:yyyy-MM-dd mm:hh</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">查询后返回信息（KmCalendarResult），详细说明如下:</div>
						<table class="tb_normal" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="14%"><b>程序名</b></td>
								<td align="center" width="11%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="20%"><b>可否为空</b></td>
								<td align="center" width="45%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>returnState</td>
								<td>返回状态</td>
								<td>数字(int)</td>
								<td>不允许为空</td>
								<td>0:失败<br/>1:成功</td>
							</tr>
							<tr>
								<td>message</td>
								<td>返回信息</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>返回状态值为0时，该值错误信息。
										<br/>
										返回状态值为1时，返回日程/笔记列表的数据，格式为JSON，格式说明请查看"<a href="#dataInfo">《2.2  日程列表数据格式说明 》</a></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);"><br/>1.6.冲突检测(conflictCheck)
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 95%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">日程冲突检测上下文(KmCalendarCheckContext)，详细说明如下:</div>
						<table class="tb_normal" cellpadding="0" cellspacing="0" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="14%"><b>程序名</b></td>
								<td align="center" width="11%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="20%"><b>可否为空</b></td>
								<td align="center" width="45%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>person</td>
								<td>日程人员</td>
								<td>字符串(JSON)</td>
								<td>不允许为空</td>
								<td>数据格式为JSON，格式描述请查看"《2.1 组织架构数据说明》"。</td>
							</tr>
							<tr>
								<td>docStartTime</td>
								<td>开始时间</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>冲突检测的开始时间,格式:yyyy-MM-dd</td>
							</tr>
							<tr>
								<td>docFinishTime</td>
								<td>结束时间</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>冲突检测的结束时间,格式:yyyy-MM-dd</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">查询后返回信息（KmCalendarResult），详细说明如下:</div>
						<table class="tb_normal" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="14%"><b>程序名</b></td>
								<td align="center" width="11%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="20%"><b>可否为空</b></td>
								<td align="center" width="45%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>returnState</td>
								<td>返回状态</td>
								<td>数字(int)</td>
								<td>不允许为空</td>
								<td>0:失败<br/>1:成功</td>
							</tr>
							<tr>
								<td>message</td>
								<td>返回信息</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>返回状态值为0时，该值错误信息。
										<br/>
										返回状态值为1时，返回冲突列表的数据，格式为JSON，格式说明请查看"<a href="#dataInfo">《2.3  冲突列表数据格式说明 》</a></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);"><br/>1.7.设置提醒(setNotify)
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 95%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">日程/笔记ID(fdAppUUId)，详细说明如下:</div>
						<table class="tb_normal" cellpadding="0" cellspacing="0" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="14%"><b>程序名</b></td>
								<td align="center" width="11%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="20%"><b>可否为空</b></td>
								<td align="center" width="45%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>fdAppUUId</td>
								<td>日程或笔记id</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>日程或笔记来源系统所存储的ID，若不存在，与EKP系统ID一致</td>
							</tr>
							<tr>
								<td>appKey</td>
								<td>日程或笔记来源</td>
								<td>字符串(String)</td>
								<td>不允许为空</td>
								<td>标识日程或笔记来源的系统</td>
							</tr>
							<tr>
								<td>kmCalendarNotify</td>
								<td>提醒列表</td>
								<td>字符串(Json)</td>
								<td>不允许为空</td>
								<td>数据格式为JSON，格式描述请查看"<a href="#orgInfo">《2.4  提醒Json说明》</a>"。</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;">
						<div style="margin: 8px;">设置消息后返回信息（KmCalendarResult），详细说明如下:</div>
						<table class="tb_normal" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="14%"><b>程序名</b></td>
								<td align="center" width="11%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="20%"><b>可否为空</b></td>
								<td align="center" width="45%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>returnState</td>
								<td>返回状态</td>
								<td>数字(int)</td>
								<td>不允许为空</td>
								<td>0:失败<br/>1:成功</td>
							</tr>
							<tr>
								<td>message</td>
								<td>返回信息</td>
								<td>字符串(String)</td>
								<td>可为空</td>
								<td>返回状态值为0时，该值错误信息。<br/>返回状态值为1时，该值返回空。</td>
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
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);" id="orgInfo"><br/>2.1.组织架构数据说明
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
			</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 95%;margin-left: 40px;">
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
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);" id="orgInfo"><br/>2.2.日程列表数据格式说明
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 95%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">
						数据格式
					</td>
					<td>
<pre>
{
	"datas":
	[  
		{
			"fdId":"ABC"     //日程ID
			"docStartTime":2014-2-11 14:00:00,   //日程开始时间
			"docFinishTime":2014-2-11 15:00:00,  //日程结束时间
			"docSubject":"2月11号下午开例会",    //标题
	      	"docContent":"YY" ,            //内容
			"person":{"loginName":"admin"},       //人员
			"appKey":"com.landray.kmss.km.calendar.model.KmCalendarMain",  //日程来源
		},
		………………
	]
}
</pre>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);" id="orgInfo"><br/>2.3.冲突列表数据格式说明
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 95%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">
						数据格式
					</td>
					<td>
<pre>
{
	"datas":
	[  
		{
			"conflictTime":2014-2-11 14:00:00-2014-2-11 15:00:00",   //冲突时间段
			"docSubject":"2月11号下午开例会",    //标题
		},
		………………
	]
}
</pre>
					</td>
				</tr>
			</table>
		</td>
	</tr>
		
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);" id="orgInfo"><br/>2.4.提醒Json说明
			<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 95%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">
						数据格式
					</td>
					<td>
<pre>
[{"fdNotifyType":"todo","fdBeforeTime":"1","fdTimeUnit":"hour"}]
</pre>
fdNotifyType为提醒类型(todo:待办);<br/>
fdBeforeTime为提前多长时间(必须为数字);<br/>
fdTimeUnit为单位("minute":分钟、"hour":小时、"day":天、"week":周)
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td><br/><b>3、参考代码</b></td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);">新增日程样例
		<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	<tr style="display: none">
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;">
				<tr><td>
<pre>
public static void main(String[] args) throws Exception {
	WebServiceConfig cfg = WebServiceConfig.getInstance();
	Object service = callService(cfg.getAddress(), cfg.getServiceClass());
	// 请在此处添加业务代码
	IKmCalendarWebserviceService kmCalendarWebserviceService = (IKmCalendarWebserviceService) service;
	add(kmCalendarWebserviceService);
	System.out.println("success!");
}
//新增测试
private static void add(IKmCalendarWebserviceService service) throws Exception{
	KmCalendarParamterForm form=new KmCalendarParamterForm();
	form.setFdAppKey("com.landray.kmss.test");
	form.setFdAppUUId(IDGenerator.generateID());
	form.setFdType("event");
	form.setDocSubject("Ws测试用例");
	form.setFdIsAlldayevent("true");
	form.setDocStartTime("2014-2-19");
	form.setDocStartTime("2014-2-20");
	form.setFdAuthorityType("DEFAULT");
	form.setDocCreator("{\"Id\":\"1183b0b84ee4f581bba001c47a78b2d9\"}");
	form.setDocOwner("{\"Id\":\"1183b0b84ee4f581bba001c47a78b2d9\"}");
	form.setRecurrenceFreq("NO");
	service.addCalendar(form);
}
</pre>
				</td></tr>
			</table>
		</td>
	</tr>
</table>


</center>



<%@ include file="/resource/jsp/view_down.jsp"%>