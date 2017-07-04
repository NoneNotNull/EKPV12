<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import=" com.landray.kmss.util.ResourceUtil"%>
<%
	request.setAttribute("formatter", ResourceUtil.getString("date.format.date"));
%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<template:include ref="default.dialog">
	<template:replace name="content">
	<%--新增日程(详细设置)--%>
	<html:form action="/km/calendar/km_calendar_main/kmCalendarMain.do" styleId="eventform">
		<html:hidden property="fdId" />
		<html:hidden property="docCreateTime" />
		<html:hidden property="docCreatorId" />
		<html:hidden property="fdRecurrenceStr" />
		<html:hidden property="fdType"  value="event"/>
		<br/>
		<table id="event_base_tb" class="tb_simple" width="100%">
			<tr>
	     		<%--日历--%>
	              <td width="15%" class="td_normal_title" >
	              		<bean:message bundle="km-calendar" key="kmCalendarMain.docLabel" />
	              </td>
	              <td width="85%" colspan="3" >
	              		<select id="labelId" name="labelId">
	              			<c:forEach items="${labels}" var="label" >
	              				<option value="${label[0]}" <c:if test="${label[0] == kmCalendarMainForm.labelId }">selected</c:if>>${label[1]}</option>
							</c:forEach>
	              		</select>
	              		<%--所有者--%>
	              		<bean:message bundle="km-calendar" key="kmCalendarMain.docOwner" />
	              		<select id="docOwnerId" name="docOwnerId" onchange="changeOwner();">
		              		<c:forEach items="${owners}" var="owner" >
		              			<option value="${owner[0]}" <c:if test="${owner[0] == kmCalendarMainForm.docOwnerId }">selected</c:if>>${owner[1]}</option>
							</c:forEach>
							<c:if test="${kmCalendarMainForm.method_GET == 'addEvent' }">
							<kmss:authShow roles="ROLE_KMCALENDAR_MULTI_CREATE">
								<%--是否发起多人日程--%>
								<option value="multiCreate">
									<bean:message bundle="km-calendar" key="kmCalendarShareGroup.fdGroup"/>
								</option>
							</kmss:authShow>
							</c:if>
						</select>
						<span id="ownerTip" style="color: red;display: none;">
							<bean:message bundle="km-calendar" key="kmCalendarMain.docOwner.tip" />
						</span>
						<c:if test="${creatorName!=null}">
							&nbsp;&nbsp;&nbsp;<bean:message bundle="km-calendar" key="kmCalendarMain.docCreator" />：<span style="font-weight:bold;">${creatorName}</span>
						</c:if>
	              </td>
	         </tr>
	         <kmss:authShow roles="ROLE_KMCALENDAR_MULTI_CREATE">
	         <%--所有者(发起多人日程时以地址本选择)--%>
	         <tr id="multiOwner" style="display: none;">
	              <td width="15%" class="td_normal_title" >
	              		<bean:message bundle="km-calendar" key="kmCalendarShareGroup.fdGroupMemberIds" />
	              </td>
	              <td width="85%" colspan="3" >
	              		<xform:address showStatus="edit" propertyId="docOwnerIds" propertyName="docOwnerNames" orgType="ORG_TYPE_ALL" mulSelect="true"  style="width:90%" ></xform:address>
	              </td>
	         </tr>
	         </kmss:authShow>
			<tr>
	     		<%--内容--%>
	             <td width="15%" class="td_normal_title" valign="top">
	             	<bean:message bundle="km-calendar" key="kmCalendarMain.docContent" />
	              </td>
	               <td width="85%" colspan="3">
	                 <xform:textarea property="docSubject" showStatus="edit" subject="${lfn:message('km-calendar:kmCalendarMain.docContent')}" style="width:90%"/>
	              </td>
	         </tr>
	         <c:if test="${not empty kmCalendarMainForm.docContent }">
	         <tr>
	         	<%--详情（EKP系统的日程不存在详情，此字段存放来自exchange的内容）--%>
	             <td width="15%" class="td_normal_title" valign="top">
	             	<bean:message bundle="km-calendar" key="kmCalendarMain.detailDocContent" />
	              </td>
	         	 <td width="85%" colspan="3">
	         	 	<xform:rtf property="docContent" showStatus="edit"   toolbarCanCollapse="all" height="150"  width="90%" ></xform:rtf>
	              </td>
	         </tr>
	         </c:if>
	         <tr>
	        	<%--时间--%>
	            <td width="15%" class="td_normal_title" valign="top">
	               	<bean:message bundle="km-calendar" key="kmCalendarMain.docTime" />
	            </td>
	            <td width="85%" colspan="3">
	     			<div class="div_1">
	               		<%--全天--%>
	               		<input type="checkbox" id="fdIsAlldayevent" name="fdIsAlldayevent" value="true" onClick="changeAllDayValue();"
	                   		<c:if test="${kmCalendarMainForm.fdIsAlldayevent =='true' }">checked="checked"</c:if>/>
	                     	<label>
	                     		<bean:message bundle="km-calendar" key="kmCalendarMain.allDay" />
	                     	</label>
	                  	<%--农历--%>
	                   	<input type="checkbox" id="fdIsLunar" name="fdIsLunar" class="ck_lunar" value="true" onClick="changeLunarValue();"
	     					<c:if test="${kmCalendarMainForm.fdIsLunar =='true' }">checked="checked"</c:if>/> 
	     					<label>
	     						<bean:message bundle="km-calendar" key="lunar" />
	     					</label>
					</div>
					<%--公历时间选择器--%>
	             	<div id="div_solar" class="div_2" style="display:none;">
	                	<xform:datetime showStatus="edit"  property="docStartTime" onValueChange="docStartTimeChange" style="width:20%" dateTimeType="date"  required="true" />
                       <div id="startTimeDiv" class="startTime" style="top: -10px;position: relative; display: inline;" >
	                        <select id="startHour" name="startHour">
	                        	<c:forEach  begin="0" end="23" varStatus="status" >
	                            	<option value="${status.index}">${status.index}</option>
	                            </c:forEach>
	                        </select>
	                        <bean:message bundle="km-calendar" key="hour" />
	                        
	                        <select id="startMinute" name="startMinute">
	                        	<c:forEach  begin="0" end="59" varStatus="status" >
	                            	<option value="${status.index}">${status.index}</option>
	                            </c:forEach>
	                        </select>
	                        <bean:message bundle="km-calendar" key="minute" />
                       </div>
                       
	                  	<span style="top: -10px;position: relative;">-</span>
                        <xform:datetime showStatus="edit"  property="docFinishTime" style="width:20%" dateTimeType="date" required="true" />
                   		<div id="endTimeDiv" class="endTime" style="top: -10px;position: relative; display: inline;" >
	                         <select id="endHour" name="endHour">
	                         	<c:forEach  begin="0" end="23" varStatus="status" >
	                              	<option value="${status.index}">${status.index}</option>
	                            </c:forEach>
							</select><bean:message bundle="km-calendar" key="hour" />
                        	<select id="endMinute" name="endMinute">
                         		<c:forEach  begin="0" end="59" varStatus="status" >
                              		<option value="${status.index}">${status.index}</option>
                            </c:forEach>
                         </select><bean:message bundle="km-calendar" key="minute" />
                       </div>
	          		</div>
	          		<%--农历时间选择器--%>
	                <div id="div_lunar" class="div_2" style="display: none;">
	                	<div style="position: relative; display: inline;">
	                	    <select name="lunarStartYear" id="lunarStartYear">
                 	        	<option value="2000">2000年</option><option value="2001">2001年</option><option value="2002">2002年</option><option value="2003">2003年</option><option value="2004">2004年</option><option value="2005">2005年</option><option value="2006">2006年</option><option value="2007">2007年</option><option value="2008">2008年</option><option value="2009">2009年</option><option value="2010">2010年</option><option value="2011">2011年</option><option value="2012">2012年</option><option value="2013" selected="selected">2013年</option><option value="2014">2014年</option><option value="2015">2015年</option><option value="2016">2016年</option><option value="2017">2017年</option><option value="2018">2018年</option><option value="2019">2019年</option><option value="2020">2020年</option><option value="2021">2021年</option><option value="2022">2022年</option><option value="2023">2023年</option><option value="2024">2024年</option><option value="2025">2025年</option>
                 	        </select>
                 	        <select id="lunarStartMonth" name="lunarStartMonth">
	                 	        <option idx="0" value="1">正月</option><option idx="1" value="2">二月</option><option idx="2" value="3">三月</option><option idx="3" value="4">四月</option><option idx="4" value="5">五月</option><option idx="5" value="6">六月</option><option idx="6" value="7">七月</option><option idx="7" value="8">八月</option><option idx="8" value="9">九月</option><option idx="9" value="10" selected="selected">十月</option><option idx="10" value="11">十一月</option><option idx="11" value="12">十二月</option>
                 	        </select>
                 	        <select id="lunarStartDay" name="lunarStartDay">
	                 	        <option>初一</option>
                 	        </select>
	                	</div>
	                	<div id="startTimeDivLunar"  class="startTime" style="position: relative; display: inline;">
                           <select id="lunarStartHour" name="lunarStartHour">
                           		<c:forEach  begin="0" end="23" varStatus="status" >
	                               	<option value="${status.index}">${status.index}</option>
	                        	</c:forEach>
                           	</select>
                           	<bean:message bundle="km-calendar" key="hour" />
                           	
                           	<select id="lunarStartMinute" name="lunarStartMinute">
                        		<c:forEach  begin="0" end="59" varStatus="status" >
                               		<option value="${status.index}">${status.index}</option>
                               	</c:forEach>
                           	</select>
                           	<bean:message bundle="km-calendar" key="minute" />
                           	
	               		</div>
	                   	<span>-</span>
	                    <div style="position: relative; display: inline;">
	                	    <select id="lunarEndYear" name="lunarEndYear">
                 	        	<option value="2000">2000年</option><option value="2001">2001年</option><option value="2002">2002年</option><option value="2003">2003年</option><option value="2004">2004年</option><option value="2005">2005年</option><option value="2006">2006年</option><option value="2007">2007年</option><option value="2008">2008年</option><option value="2009">2009年</option><option value="2010">2010年</option><option value="2011">2011年</option><option value="2012">2012年</option><option value="2013" selected="selected">2013年</option><option value="2014">2014年</option><option value="2015">2015年</option><option value="2016">2016年</option><option value="2017">2017年</option><option value="2018">2018年</option><option value="2019">2019年</option><option value="2020">2020年</option><option value="2021">2021年</option><option value="2022">2022年</option><option value="2023">2023年</option><option value="2024">2024年</option><option value="2025">2025年</option>
                 	        </select>
                 	        <select id="lunarEndMonth" name="lunarEndMonth">
	                 	       <option idx="0" value="1">正月</option><option idx="1" value="2">二月</option><option idx="2" value="3">三月</option><option idx="3" value="4">四月</option><option idx="4" value="5">五月</option><option idx="5" value="6">六月</option><option idx="6" value="7">七月</option><option idx="7" value="8">八月</option><option idx="8" value="9">九月</option><option idx="9" value="10" selected="selected">十月</option><option idx="10" value="11">十一月</option><option idx="11" value="12">十二月</option>
                 	        </select>
                 	        <select id="lunarEndDay" name="lunarEndDay">
	                 	        <option>初一</option>
                 	        </select>
	                	</div>
	                	<div id="endTimeDivLunar" class="endTime" style="position: relative; display: inline;">
                           <select id="lunarEndHour" name="lunarEndHour">
                           		<c:forEach  begin="0" end="23" varStatus="status" >
	                               	<option value="${status.index}">${status.index}</option>
	                        	</c:forEach>
                           </select>
                           <bean:message bundle="km-calendar" key="hour" />
                           <select id="lunarEndMinute" name="lunarEndMinute">
                           		<c:forEach  begin="0" end="59" varStatus="status" >
                               		<option value="${status.index}">${status.index}</option>
                               	</c:forEach>
                           </select>
                           <bean:message bundle="km-calendar" key="minute" />
	                 	</div>
	                </div>
	               </td>
	            </tr>
	            <tr style="border-bottom: 1px dashed #ccc;"><td colspan="4"></td></tr>
	            <%--公历重复设置（开始）--%>
	            <tr id="tr_recurrence" style="display: none;">
	            	<%--重复类型--%>
	            	<td width="15%" class="td_normal_title" >
	            		<bean:message bundle="km-calendar" key="kmCalendarMain.fdRecurrenceType" />
	            	</td>
	            	<td>
	            		<xform:select property="RECURRENCE_FREQ" showPleaseSelect="false" showStatus="edit" htmlElementProperties="id='recurrence_freq'">
							<xform:enumsDataSource enumsType="km_calendar_recurrence_freq" />
						</xform:select>
	            	</td>
	            </tr>
	            <tr id="moreset" style="display: none;">
		            <td colspan="4">
		            	<table class="tb_simple" width="100%">
		            		<%--重复频率--%>
		            		<tr>
		            			<td width="15%" class="td_normal_title" >
		            				<bean:message bundle="km-calendar" key="kmCalendarMain.recurrenceInterval" />
		            			</td>
				             	<td colspan="3">
				             		<bean:message bundle="km-calendar" key="each" />
				             		<select name="RECURRENCE_INTERVAL" id="interval" class="interval">
			                              <c:forEach  begin="1" end="50" varStatus="index" >
			                              		<option value="${index.count}" <c:if test="${kmCalendarMainForm.RECURRENCE_INTERVAL == index.count}">selected</c:if> >${index.count}</option>
			                              </c:forEach>
			                            </select><span id="fdRecurrenceUnit" class="unit"></span>
				             	</td>
		            		</tr>
		            		<%--重复时间：星期一、星期二…………--%>
		            		<tr class="recurrence_time_type">
		            			<td width="15%" class="td_normal_title" >
		            				<bean:message bundle="km-calendar" key="kmCalendarMain.recurrenceTimeType" />
		            			</td>
				             	<td colspan="3">
				             		<xform:checkbox  property="RECURRENCE_WEEKS" showStatus="edit">
										<xform:enumsDataSource enumsType="km_calendar_recurrence_week" />
									</xform:checkbox >
				             	</td>
		            		</tr>
		            		<%--重复时间：每周的某天、每月的某天--%>
		            		<tr class="recurrence_time_type">
		            			<td width="15%" class="td_normal_title" >
		            				<bean:message bundle="km-calendar" key="kmCalendarMain.recurrenceTimeType" />
		            			</td>
				             	<td colspan="3">
				             		<xform:radio  property="RECURRENCE_MONTH_TYPE" showStatus="edit">
										<xform:enumsDataSource enumsType="km_calendar_recurrence_month_type" />	
									</xform:radio>
				             	</td>
		            		</tr>
		            		<%--结束条件--%>
		            		<tr class="recurrence_end_type">
		            			<td width="15%" class="td_normal_title"  valign="top">
		            				<bean:message bundle="km-calendar" key="kmCalendarMain.recurrenceEndType" />
		            			</td>
			             		<td colspan="3">
			             			<%--从不结束--%>
			             			<div>
			             				<input type="radio" name="RECURRENCE_END_TYPE" value="NEVER" <c:if test="${kmCalendarMainForm.RECURRENCE_END_TYPE==null || kmCalendarMainForm.RECURRENCE_END_TYPE=='NEVER'}"> checked="checked"</c:if> class="never">
			             				<span><bean:message bundle="km-calendar"  key="recurrence.end.type.never" /></span>
			             			</div>
			             			<%--发生X次后结束--%>
			             			<div>
			             				<input type="radio" name="RECURRENCE_END_TYPE" value="COUNT" <c:if test="${kmCalendarMainForm.RECURRENCE_END_TYPE=='COUNT'}"> checked="checked"</c:if>>
			             				<bean:message bundle="km-calendar"  key="recurrence.end.type.count" />
			             				<xform:text  showStatus="edit"  validators="count" property="RECURRENCE_COUNT"  style="width:20%;height:20px;margin:5px;"  className="re_count"/>
			             				<bean:message bundle="km-calendar" key="times" />
			             			</div>
			             			<%--直到某天结束--%>
			             			<div>
			             				<span style="position: relative;top:-10px;"><input type="radio" name="RECURRENCE_END_TYPE" value="UNTIL" <c:if test="${kmCalendarMainForm.RECURRENCE_END_TYPE=='UNTIL'}"> checked="checked"</c:if>>
			             					<bean:message bundle="km-calendar"  key="recurrence.end.type.until" />
			             				</span>
			             				<xform:datetime showStatus="edit"   property="RECURRENCE_UNTIL" onValueChange="untilChange"  style="width:20%;height:20px;margin:5px;" dateTimeType="date"  />
			             			</div>
			             		</td>
		            		</tr>
		            		<%--摘要--%>
		            		<tr>
			            		<td width="15%" class="td_normal_title" >
			            			<bean:message bundle="km-calendar" key="kmCalendarMain.summary" />
			            		</td>
				             	<td colspan="3">
				             		<input type="hidden" name="RECURRENCE_SUMMARY" />
				             		<span id="summary" class="summary"></span>
				             	</td>
		            		</tr>
		            	</table>
		            </td>
	            </tr>
	            <%--重复设置（结束）--%>
	            <%--农历重复设置（开始）--%>
	            <tr id="tr_recurrence_lunar" style="display: none;">
	            	<td width="15%" class="td_normal_title" >
	            		<bean:message bundle="km-calendar" key="kmCalendarMain.fdRecurrenceType" />
	            	</td>
	            	<td>
	            		<xform:select property="RECURRENCE_FREQ_LUNAR" showPleaseSelect="false" showStatus="edit" htmlElementProperties="id='recurrence_freq_lunar'">
							<xform:enumsDataSource enumsType="km_calendar_recurrence_freq_lunar" />
						</xform:select>
	            	</td>
	            </tr>
	            <tr id="moreset_lunar" style="display:none; " >
	            	<td colspan="4">
		            	<table class="tb_simple" width="100%">
		            		<%--重复频率--%>
		            		<tr>
		            			<td width="15%" class="td_normal_title" >
		            				<bean:message bundle="km-calendar" key="kmCalendarMain.recurrenceInterval" />
		            			</td>
			             		<td colspan="3">
			             		<bean:message bundle="km-calendar" key="each" />
			             		<select name="RECURRENCE_INTERVAL_LUNAR" id="interval" class="interval">
		                              <c:forEach  begin="1" end="50" varStatus="index" >
		                              		<option value="${index.count}" <c:if test="${kmCalendarMainForm.RECURRENCE_INTERVAL_LUNAR == index.count}">selected</c:if> >${index.count}</option>
		                              </c:forEach>
		                            </select><span id="fdRecurrenceUnitLunar" class="unit"></span>
			             	</td>
		            		</tr>
		            		<%--结束条件--%>
		            		<tr class="recurrence_end_type">
		            			<td width="15%" class="td_normal_title"  valign="top">
		            				<bean:message bundle="km-calendar" key="kmCalendarMain.recurrenceEndType" />
		            			</td>
			             		<td colspan="3">
			             			<%--从不结束--%>
			             			<div>
			             				<input type="radio" name="RECURRENCE_END_TYPE_LUNAR" value="NEVER" <c:if test="${kmCalendarMainForm.RECURRENCE_END_TYPE_LUNAR==null || kmCalendarMainForm.RECURRENCE_END_TYPE_LUNAR=='NEVER'}"> checked="checked"</c:if> class="never">
			             				<span><bean:message bundle="km-calendar"  key="recurrence.end.type.never" /></span>
			             			</div>
			             			<%--发生X次后结束--%>
			             			<div>
			             				<input type="radio" name="RECURRENCE_END_TYPE_LUNAR" value="COUNT" <c:if test="${kmCalendarMainForm.RECURRENCE_END_TYPE_LUNAR=='COUNT'}"> checked="checked"</c:if>>
			             				<bean:message bundle="km-calendar"  key="recurrence.end.type.count" />
			             				<xform:text showStatus="edit" validators="count" property="RECURRENCE_COUNT_LUNAR" style="width:20%;height:20px;margin:5px;"  className="re_count"/>
			             				<bean:message bundle="km-calendar" key="times" />
			             			</div>
			             			<%--直到某天结束--%>
			             			<div>
			             				<span style="position: relative;top:-10px;"><input type="radio" name="RECURRENCE_END_TYPE_LUNAR" value="UNTIL" <c:if test="${kmCalendarMainForm.RECURRENCE_END_TYPE_LUNAR=='UNTIL'}"> checked="checked"</c:if>>
			             					<bean:message bundle="km-calendar"  key="recurrence.end.type.until" />
			             				</span>
			             				<xform:datetime showStatus="edit"  property="RECURRENCE_UNTIL_LUNAR"  onValueChange="untilChange" style="width:20%;height:20px;margin:5px;" dateTimeType="date"  />
			             			</div>
			             		</td>
		            		</tr>
		            		<tr>
		            			<td width="15%" class="td_normal_title" >
		            				<bean:message bundle="km-calendar" key="kmCalendarMain.summary" />
		            			</td>
			             		<td colspan="3">
				             		<input type="hidden" name="RECURRENCE_SUMMARY_LUNAR" />
				             		<span id="summaryLunar" class="summary"></span>
			             		</td>
		            		</tr>
		            	</table>
	            	</td>
	            </tr>
	           	<%--农历重复设置（结束）--%>
	           	<tr>
	           		<%--提醒设置--%>
	           	   <td width="15%" class="td_normal_title"  valign="top">
	           	   		<bean:message bundle="km-calendar" key="kmCalendarMain.fdNotifySet" />
	           	   </td>
		           <td colspan="3"  style="padding: 0px;">
						<c:import url="/sys/notify/import/sysNotifyRemindMain_edit.jsp" charEncoding="UTF-8">
						    <c:param name="formName" value="kmCalendarMainForm" />
					         <c:param name="fdKey" value="kmCalenarMainDoc" />
					         <c:param name="fdPrefix" value="event" />
					         <c:param name="fdModelName" value="com.landray.kmss.km.calendar.model.KmCalendarMain" />
					    </c:import>
					</td>
	           </tr>
	            <tr>
	            	<%--关联URL--%>
	            	<td width="15%" class="td_normal_title">
	            		<bean:message bundle="km-calendar" key="kmCalendarMain.fdRelationUrl" />
	            	</td>
	            	<td>
	            		<xform:text property="fdRelationUrl" showStatus="edit" style="width:90%"/>
	            	</td>
	            </tr>
	            <tr>
	            	<%--地点--%>
	            	<td width="15%" class="td_normal_title" >
	            		<bean:message bundle="km-calendar" key="kmCalendarMain.fdLocation" />
	            	</td>
	            	<td>
	            		<xform:text property="fdLocation" showStatus="edit" style="width:90%"/>
	            	</td>
	            </tr>
	            <tr style="border-bottom: 1px dashed #ccc;"><td colspan="4"></td></tr>
	            <tr>
	            	<%--活动性质--%>
	            	<td width="15%" class="td_normal_title" >
	            		<bean:message bundle="km-calendar" key="kmCalendarMain.fdAuthorityType" />
	            	</td>
	            	<td>
	            		<xform:radio property="fdAuthorityType" showStatus="edit">
						<xform:enumsDataSource enumsType="km_calendar_fd_authority_type" />
					</xform:radio>
	            	</td>
	            </tr>
	        </table>
	        <table id="event_auth_tb" class="tb_simple" width="100%" style="display: none;">
	            <tr>
	            	<%--可阅读者--%>
					<td width="15%" class="td_normal_title">
						<bean:message bundle="km-calendar" key="kmCalendarMain.authReader" />
					</td>
					<td width="85%" colspan="3">
						<xform:address showStatus="edit" propertyId="authReaderIds" propertyName="authReaderNames" orgType="ORG_TYPE_ALL" mulSelect="true"  textarea="true"  style="width:90%" ></xform:address>
						<br>
					</td>
				</tr>
				 <tr>
				 	<%--可编辑者--%>
				 	<td width="15%" class="td_normal_title">
						<bean:message bundle="km-calendar" key="kmCalendarMain.authEditor" />
					</td>
					<td width="85%" colspan="3">
						<xform:address showStatus="edit" propertyId="authEditorIds" propertyName="authEditorNames" orgType="ORG_TYPE_ALL" mulSelect="true"  textarea="true"  style="width:90%" ></xform:address>
						<br>
					</td>
				 </tr>
			</table>
			<div style="margin: 0 auto;width: 200px;">
				<center>
					<ui:button text="${lfn:message('button.save')}"  onclick="save();"/>&nbsp;
					<c:if test="${kmCalendarMainForm.method_GET=='edit' }">
						<ui:button text="${lfn:message('button.delete')}"  styleClass="lui_toolbar_btn_gray" onclick="deleteDoc();"/>&nbsp;
					</c:if>
			        <ui:button text="${lfn:message('button.close')}"  styleClass="lui_toolbar_btn_gray" onclick="Com_CloseWindow();"/> 
		        </center>
			</div>
	</html:form>
	</template:replace>
</template:include>
<script>Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js",null,"js");</script>
<script type="text/javascript" src="${LUI_ContextPath}/km/calendar/resource/js/solarAndLunar.js"></script>
<script>
	seajs.use(['theme!form']);
	seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog,topic,toolbar) {
		
		var eventValidation=null;
		var label_html_all = null;
		var label_html_myEvent = "<option value=\"\" >${lfn:message('km-calendar:module.km.calendar.tree.my.calendar')}</option>";

		//常用字段
		var unitValue="YEARLY MONTHLY WEEKLY DAILY";//年月周日
		var weekValue=(function(){
			var shortNameValue="${lfn:message('calendar.week.shortNames')}".split(',');//周缩写
			var shortNameKey=["SU","MO","TU","WE","TH","FR","SA"];
			var tmp={};
			for(var i=0;i<shortNameKey.length;i++){
				tmp[shortNameKey[i]]=shortNameValue[i];
			}
			return tmp;
		})();//格式:{"SU":"日","MO":"一","TU":"二","WE":"三","TH":"四","FR":"五","SA":"六"};
		
		//修改摘要
		var summary=function(){
			var summaryText=new Array();
			var isLunar=$("#fdIsLunar").is(':checked');
			summaryText.push(isLunar ? "${lfn:message('km-calendar:lunar')}" : "${lfn:message('km-calendar:solar')}");//日历类型
			var set=isLunar?$("#moreset_lunar"):$("#moreset");
			var intervalStr="${lfn:message('km-calendar:kmCalendarMain.summary.interval')}"
				.replace("%interval%",set.find(".interval").val())
				.replace("%unit%",set.find(".unit").text());
			summaryText.push(intervalStr);//每隔xx(天、周、月、年)
			//公历下周、月特殊处理
			if(!isLunar){
				var unit=set.find(".unit").text();
				//如果是周重复
				if(unit=="${lfn:message('km-calendar:week')}"){
					var weekDays=$(".recurrence_time_type").eq(0).find(":checkbox").filter(':checked').map(function(){
						return weekValue[$(this).val()];
					}).get();
					if(weekDays.length){
						if(Com_Parameter['Lang']!=null && Com_Parameter['Lang']=='zh-cn'){
							summaryText.push("${lfn:message('km-calendar:week')}"+weekDays.join('、'));
						}else{
							summaryText.push(weekDays.join('、'));//周一、二、三……
						}
					}
				//如果是月重复
				}else if(unit=="${lfn:message('km-calendar:month')}"){
					var type=$(".recurrence_time_type").eq(1).find(":radio").filter(':checked').val();
					var d=$(":input[name=docStartTime]").eq(0).val();
					var date=new Date();
					if(d!=""){
						date=formatDate(d,"${formatter}");
					}
					if(type=="month"){
						var eachMonthStr="${lfn:message('km-calendar:kmCalendarMain.summary.eachMonth')}"
							.replace("%day%",date.getDate());
						summaryText.push(eachMonthStr);//每月第N天
					}else{
						var eachWeekStr="${lfn:message('km-calendar:kmCalendarMain.summary.eachWeek')}"
							.replace("%order%",Math.ceil(date.getDate() / 7)).replace("%week%","${lfn:message('calendar.week.names')}".split(',')[date.getDay()]);
						summaryText.push(eachWeekStr);//第N个周日、一、二……
					}
				}
			}
			var endType=set.find(".recurrence_end_type").find(":radio").filter(':checked').val();
			if(endType=="NEVER"){
				summaryText.push("${lfn:message('km-calendar:recurrence.end.type.never')}");//从不结束
			}else if(endType=="COUNT"){
				var countStr="${lfn:message('km-calendar:kmCalendarMain.summary.freqEnd')}"
					.replace('%count%',set.find(".re_count").val());
				summaryText.push(countStr);//重复N次结束
			}else{
				var endDate=isLunar?$("[name=RECURRENCE_UNTIL_LUNAR]").val():$("[name=RECURRENCE_UNTIL]").val();
				summaryText.push("${lfn:message('km-calendar:recurrence.end.type.until')}" + endDate);//直到yyyy-MM-dd结束
			}
			set.find(".summary").html($.map(summaryText, function(t){ return ['<span style="color:blue;margin-right:10px;">', t, '</span>'].join(''); }).join(''));
		};
		
		//是否显示公历重复信息
		window.displayMoreSet=function(self){
			var moreset=$("#moreset");
			var option=$("option:selected",self);
			var value=option.attr("value"),text=option.text();
			if (unitValue.indexOf(value) > -1) {
				$(".recurrence_time_type").hide();
				//如果是天重复
				if("DAILY"==value){
					moreset.find(".unit").text("${lfn:message('km-calendar:daily')}");
				}
				//如果是年重复
				if("YEARLY"==value){
					moreset.find(".unit").text("${lfn:message('km-calendar:year')}");
				}
				//如果是周重复
				if("WEEKLY"==value){
					moreset.find(".unit").text("${lfn:message('km-calendar:week')}");
					$(".recurrence_time_type").eq(0).show();
				}
				//如果是月重复
				if("MONTHLY"==value){
					moreset.find(".unit").text("${lfn:message('km-calendar:month')}");
					$(".recurrence_time_type").eq(1).show();
				}
				moreset.show();
			}
			else{
				moreset.hide();
			}
			summary();
		};
		
		//是否显示农历历重复信息
		window.displayMoreSetLunar=function(self){
			var option=$("option:selected",self);
			var value=option.attr("value"),text=option.text();
			//如果农历重复
			if ("MONTHLY YEARLY".indexOf(value) > -1) {
				//如果是农历月重复
				if(value=="MONTHLY"){
					$("#fdRecurrenceUnitLunar").text("${lfn:message('km-calendar:month')}");
				}
				if(value=="YEARLY"){
					$("#fdRecurrenceUnitLunar").text("${lfn:message('km-calendar:year')}");
				}
				$("#moreset_lunar").show();
			}
			else{
				$("#moreset_lunar").hide();
			}
			summary();
		};

		//公历重复类型修改时触发
		$("#recurrence_freq").change(function(){
			displayMoreSet(this);
		});
		//农历重复类型修改时触发
		$("#recurrence_freq_lunar").change(function(){
			displayMoreSetLunar(this);
		});
		//重复频率变化时修改摘要
		$(".interval").change(function(){
			summary();
		});
		//重复时间变化时修改摘要
		$(":checkbox[name=_RECURRENCE_WEEKS],:radio[name=RECURRENCE_MONTH_TYPE]").click(function(){
			summary();
		});
		//结束条件变化时修改摘要
		$(":radio[name=RECURRENCE_END_TYPE],:radio[name=RECURRENCE_END_TYPE_LUNAR]").click(function(){
			summary();
		});
		//结束次数变化时修改摘要
		$(".re_count").blur(function(){
			summary();
		});
		
		//结束时间变化时修改摘要
		window.untilChange=function(){
			summary();
		};

		//开始时间改变时，校验结束时间是否小于开始时间，如果小于将结束时间=开始时间
		window.docStartTimeChange=function(obj){
			if($("[name='docFinishTime']").val()==null || $("[name='docFinishTime']").val()==""){
				return;
			}
			var docStartTime=formatDate($("[name='docStartTime']").val(),"${formatter}");
			var docFinishTime=formatDate($("[name='docFinishTime']").val(),"${formatter}");
			if(docStartTime.getTime()>docFinishTime.getTime()){
				$("[name='docFinishTime']").val($("[name='docStartTime']").val());	
			}
		};
		
		var data_start = [];
		var data_end = [];

		//初始化农历级联下拉框
		window.initLunar=function(startDate,endDate){
			lunarDate = lunar(startDate);
			$startYear = $('#lunarStartYear');//农历开始年
			var year = lunarDate.sYear + 1984;
			$startYear.val(year);
			
			$startYear.change(function(evt){
				_calYearData("start");
				_fillMonth(evt,"start");
				_fillDate(evt,"start");
			}).change();//切换农历年时触发
			
			$('#lunarStartMonth').off('change').change(function(evt){
				_fillDate(evt,"start");
			}).change();

			if(endDate){
				lunarDate = lunar(endDate);
				$endYear = $('#lunarEndYear');
				year = lunarDate.sYear + 1984;
				$endYear.val(year);
				$endYear.change(function(evt){
					_calYearData("end");
					_fillMonth(evt,"end");
					_fillDate(evt,"end");
				}).change();
				$('#lunarEndMonth').off('change').change(function(evt){
					_fillDate(evt,"end");
				}).change();
			}
		};

		window._fillMonth=function(evt, preName){
			if(preName == "start"){
				$month = $('#lunarStartMonth');
				$date = $('#lunarStartDay');
				data = data_start;
			}
			if(preName == "end"){
				$month = $('#lunarEndMonth');
				$date = $('#lunarEndDay');
				data = data_end;
			}
			var month = evt.isTrigger ? ((lunarDate.isLeap ? 'r' : '') + (lunarDate.monthIndex + 1)) : $month.val().slice(-($month.val() - 1));
			var m = "";
			for(var i=0;i<data.length;i++){
				if(month-1==i){
					m += '<option idx="'+i +'" value="'+data[i].value+'"  selected="selected">'+data[i].text+'</option>';
				}else{
				m += '<option idx="'+i +'" value="'+data[i].value+'">'+data[i].text+'</option>';
				}
			}
			$month.empty().append(m);
			$month.change();
		};
		window._fillDate=function(evt, preName){
			var $month;
			var $date;
			var data;
			if(preName == "start"){
				$month = $('#lunarStartMonth');
				$date = $('#lunarStartDay');
				data = data_start;
			}
			if(preName == "end"){
				$month = $('#lunarEndMonth');
				$date = $('#lunarEndDay');
				data = data_end;
			}
			var idx = $month.find('option:selected').attr('idx');
			var date = evt.isTrigger ? lunarDate.dateIndex + 1 : $date.val();
			var dates = data[idx].days;
			var d = "";
			for(i=0;i<dates.length;i++){
				if(date-1==i){
					d += '<option date="'+i +'" value="'+dates[i].value+'"  selected="selected">'+dates[i].text+'</option>';
				}else{
				d += '<option date="'+i +'" value="'+dates[i].value+'">'+dates[i].text+'</option>';
				}
			}
			$date.empty().append(d);
			$date.change();
		};
		window._calYearData=function(preName){
			var $year;
			var data;
			if(preName == "start"){
				$year = $('#lunarStartYear');
				data = data_start;
			}
			if(preName == "end"){
				$year = $('#lunarEndYear');
				data = data_end;
			}
			var ar = lunar(new Date($year.val(), 2, 1)).getMonthInfo(); 
			var date = ar.solarSpringDay;
			var obj;
				$.each(ar, function(index, o){
					obj = data[index] = {
						value: (o.isLeap ? 'r' : '') + ((o.index - 2) % 12 + 1),
						text: o.name + '月',
						days: []
					};
					$.each(new Array(o.days), function(dayIndex){
						obj.days.push({
							value: dayIndex + 1,
							text: Lunar.DB.dateCn[dayIndex],
							date: [date.getFullYear(), date.getMonth() + 1, date.getDate()].join('-')
						});
						date.setDate(date.getDate() + 1);
					});
				}
			);
		};
		
		//是否全天
		window.changeAllDayValue=function(){
			var isAllday=$("#fdIsAlldayevent").prop('checked');
			if(isAllday){
				$("#startTimeDiv,#endTimeDiv").css("display","none");
				$("#startTimeDivLunar,#endTimeDivLunar").css("display","none");
			}else{
				$("#startTimeDiv,#endTimeDiv").css("display","inline");
				$("#startTimeDivLunar,#endTimeDivLunar").css("display","inline");
			}
		};
		
		//是否农历
		window.changeLunarValue=function(){
			var isLunar=$("#fdIsLunar").prop('checked');
			if(isLunar){
				$("#tr_recurrence_lunar").show();
				displayMoreSetLunar($("#recurrence_freq_lunar")[0]);//是否显示农历重复信息
				$("#tr_recurrence,#moreset").hide();
				$("#div_lunar").css("display","inline");
				$("#div_solar").css("display","none");
				var docStartTime = $("[name='docStartTime']").val();
				var docFinishTime = $("[name='docFinishTime']").val();
				initLunar(formatDate(docStartTime,"${formatter}"),formatDate(docFinishTime,"${formatter}"));
			}else{
				$("#tr_recurrence").show();
				displayMoreSet($("#recurrence_freq")[0]);//是否显示公历重复信息
				$("#tr_recurrence_lunar,#moreset_lunar").hide();
				$("#div_lunar").css("display","none");
				$("#div_solar").css("display","inline");
			}
			changeAllDayValue();
		};
		
		//保存日程
		window.save=function(){
			var method = "saveEvent";
			var last_method = Com_GetUrlParameter(window.location.href, "method");
			if("edit"==last_method){
				method = "updateEvent";
			}
			var isLunar=$("#fdIsLunar").prop('checked');
			if(isLunar){
				var lunarStartYear = $('#lunarStartYear').val();
				var lunarStartMonth = $('#lunarStartMonth').val();
				var lunarStartDay = $('#lunarStartDay').val();
				var isLeap = false;
				if(lunarStartMonth.indexOf("r")>-1){
					lunarStartMonth = lunarStartMonth.substring(1);
					isLeap = true;
				}
				var solarStartDate = getSolarDate(lunarStartYear,lunarStartMonth,lunarStartDay,isLeap);
				var solarMonth = solarStartDate.getMonth()+1;
				var solarStartDateStr = solarStartDate.format("${formatter}");
				$("[name='docStartTime']").val(solarStartDateStr);

				var lunarEndYear = $('#lunarEndYear').val();
				var lunarEndMonth = $('#lunarEndMonth').val();
				var lunarEndDay = $('#lunarEndDay').val();
				isLeap = false;
				if(lunarEndMonth.indexOf("r")>-1){
					lunarEndMonth = lunarEndMonth.substring(1);
					isLeap = true;
				}
				var solarEndDate = getSolarDate(lunarEndYear,lunarEndMonth,lunarEndDay,isLeap);
				solarMonth = solarStartDate.getMonth()+1;
				var solarEndDateStr = solarEndDate.format("${formatter}");
				$("[name='docFinishTime']").val(solarEndDateStr);
				
			}
			//校验
			if(eventValidation.validate()==false){
				return false;
			}
			//校验开始时间不能晚于结束时间
			var _startTime=$("[name='docStartTime']").val();
			var _finishTime=$("[name='docFinishTime']").val();
			//非全天.加上时、分
			if(!$("#fdIsAlldayevent").prop('checked')){
				//农历的时分
				if($("#fdIsLunar").prop('checked')){
					_startTime+=" "+$("#lunarStartHour option:selected").val()+":"+$("#lunarStartMinute option:selected").val()+":00";
					_finishTime+=" "+$("#lunarEndHour option:selected").val()+":"+$("#lunarEndMinute option:selected").val()+":00";
				//公历的时分
				}else{
					_startTime+=" "+$("#startHour option:selected").val()+":"+$("#startMinute option:selected").val()+":00";
					_finishTime+=" "+$("#endHour option:selected").val()+":"+$("#endMinute option:selected").val()+":00";
				}
			}
			 if(Date.parse(new Date(_finishTime.replace(/-/g,"/")))<Date.parse(new Date(_startTime.replace(/-/g,"/")))){
				 //开始时间不能晚于结束时间
				 dialog.alert("${lfn:message('km-calendar:kmCalendarMain.tip.validateDate.errorDate')}");
		    	return false;
			}
			//校验发生次数
			for(var i=0;i<$(".re_count").size();i++){
				var item=$(".re_count").eq(i);
				//选中了才校验
				if(item.is(":visible")&&item.prev().prop("checked")==true){
					if(/[^\d]/.test(item.val())||item.val().length<=0){
						//发生次数不能为空且必须为数字
						dialog.alert("${lfn:message('km-calendar:kmCalendarMain.tip.validateCount.errorCount')}");
						return false;
					}
				}
			}
			//校验结束条件的时间
			if(validateUntilTime($("[name=RECURRENCE_UNTIL]"),$("[name='RECURRENCE_END_TYPE'][value='UNTIL']"))==false){
				return false;
			}
			if(validateUntilTime($("[name=RECURRENCE_UNTIL_LUNAR]"),$("[name='RECURRENCE_END_TYPE_LUNAR'][value='UNTIL']"))==false){
				return false;
			}
			//beforeSubmit(document.kmCalendarMainForm);
			var url='${LUI_ContextPath}/km/calendar/km_calendar_main/kmCalendarMain.do?method='+method;

			<c:if test="${not empty kmCalendarMainForm.docContent }">
				var oEditor = eval("CKEDITOR.instances.docContent");
				$("[name='docContent']").val(oEditor.getData());
			</c:if>
			
			$.ajax({
				url: url,
				type: 'POST',
				dataType: 'json',
				async: false,
				data: $("#eventform").serialize(),
				beforeSend:function(){
					//window.loading = dialog.loading();
				},
				success: function(data, textStatus, xhr) {//操作成功
					if (data && data['status'] === true) {
						//dialog.success('<bean:message key="return.optSuccess" />');
						//	window.loading.hide();
						if(window.$dialog!=null){
							$dialog.hide({"schedule":data['schedule'],"isRecurrence":data['isRecurrence'],"method":method});
						}else{
							window.close();
						}
					}
				},
				error:function(xhr, textStatus, errorThrown){//操作失败
					dialog.success('<bean:message key="return.optFailure" />');
					if(window.$dialog!=null){
						$dialog.hide(null);
					}else{
						window.close();
					}
				}
			});
		}; 

		window.beforeSubmit=function(formObj){
			if(formObj.onsubmit!=null && !formObj.onsubmit()){
				return false;
			}
			//提交表单消息确认
			for(var i=0; i<Com_Parameter.event["confirm"].length; i++){
				if(!Com_Parameter.event["confirm"][i]()){
					return false;
				}
			}
		};

		//校验结束条件时间(radio:结束条件的单选框)
		var validateUntilTime=function(validator,radio){
			//选中了才校验
			if(validator.is(":visible")&&radio.prop("checked")==true){
				//校验结束条件日期不能为空
				if(validator.val().length<=0){
					dialog.alert("${lfn:message('km-calendar:kmCalendarMain.tip.validateUntilTime.notNull')}");
					return false;
				}
				//校验结束条件日期格式
				if(chkDateFormat(validator.val())==false){
					dialog.alert("${lfn:message('km-calendar:kmCalendarMain.tip.validateUntilTime.errorFormat')}");
					return false;
				}
				//校验日期不能早于日程开始时间
				if(compareDate(validator.val(),$("[name='docStartTime']").val())<0){
					dialog.alert("${lfn:message('km-calendar:kmCalendarMain.tip.validateUntilTime.errorDate')}");
					return false;
				}
			}
			return true;
		};
		
		//修改日程所有者
		window.changeOwner = function(){
			var docOwner=$("#docOwnerId");
			var selectedIndex = docOwner.get(0).selectedIndex;
			if(selectedIndex == 0){
				//日程所有者为自己时可选标签
				$("#labelId").html(label_html_all);
			}else{
				//日程所有者为别人时只可以选默认标签(即"我的日历")
				$("#labelId").html(label_html_myEvent);
			}
			if(docOwner.val()=="multiCreate"){
				$("#multiOwner").show();
			}else{
				$("#multiOwner").hide();
			}
		};

		//删除文档
		window.deleteDoc=function(){
			var fdId="${kmCalendarMainForm.fdId}";
			var url="${LUI_ContextPath}/km/calendar/km_calendar_main/kmCalendarMain.do?method=delete&fdId="+fdId;
			$.get(url,function(data){
				if(data!=null && data.status==true){
					$dialog.hide({"method":"delete"});
					//LUI('calendar').removeSchedule(fdId);//删除日程
				}
				else{
					dialog.failure('<bean:message key="return.optFailure" />');
				}
			},'json');
		};

		//切换到日程基础信息标签(时间管理模块下打开时用)
		window.parent.$("#event_base_label").click(function(){
			window.parent.$("#event_base_label").addClass("event_lable_select").removeClass("event_lable_unselect");
			window.parent.$("#event_auth_label").addClass("event_lable_unselect").removeClass("event_lable_select");
			$("#event_auth_tb").hide();
			$("#event_base_tb").show();
		});

		//切换到日程权限标签(时间管理模块下打开时用)
		window.parent.$("#event_auth_label").click(function(){
			window.parent.$("#event_base_label").addClass("event_lable_unselect").removeClass("event_lable_select");
			window.parent.$("#event_auth_label").addClass("event_lable_select").removeClass("event_lable_unselect");
			$("#event_auth_tb").show();
			$("#event_base_tb").hide();
		});

		//加载校验框架
		eventValidation=$KMSSValidation();
		
		//初始化
		var _solar=$("#div_solar"),_lunar=$("#div_lunar");
		if("${kmCalendarMainForm.fdIsLunar}"=="true"){//农历
			$("#tr_recurrence_lunar").show();
			_lunar.show();
			_solar.find(".startTime,.endTime").css("display","none");
			_lunar.find(".startTime,.endTime").css("display","inline");
			var docStartTime = $("[name='docStartTime']").val();
			var docFinishTime = $("[name='docFinishTime']").val();
			initLunar(formatDate(docStartTime,"${formatter}"),formatDate(docFinishTime,"${formatter}"));
		}else{//公历
			$("#tr_recurrence").show();
			_solar.show();
			_solar.find(".startTime,.endTime").css("display","inline");
			_lunar.find(".startTime,.endTime").css("display","none");
		}
		if("${kmCalendarMainForm.fdIsAlldayevent}"=="true"){//全天
			$(".startTime,.endTime").css("display","none");
		}else{//非全天
			$("#startHour").val(${kmCalendarMainForm.startHour});
			$("#startMinute").val(${kmCalendarMainForm.startMinute});
			$("#endHour").val(${kmCalendarMainForm.endHour});
			$("#endMinute").val(${kmCalendarMainForm.endMinute});
			$("#lunarStartHour").val(${kmCalendarMainForm.lunarStartHour});
			$("#lunarStartMinute").val(${kmCalendarMainForm.lunarStartMinute});
			$("#lunarEndHour").val(${kmCalendarMainForm.lunarEndHour});
			$("#lunarEndMinute").val(${kmCalendarMainForm.lunarEndMinute});
		}
		//是否显示重复信息
		if('${kmCalendarMainForm.RECURRENCE_FREQ}'!=null && '${kmCalendarMainForm.RECURRENCE_FREQ}' != 'NO'){
			displayMoreSet($("#recurrence_freq"));
		}
		//是否显示农历重复信息
		if('${kmCalendarMainForm.RECURRENCE_FREQ_LUNAR}'!=null && '${kmCalendarMainForm.RECURRENCE_FREQ_LUNAR}' != 'NO'){
			displayMoreSetLunar($("#recurrence_freq_lunar"));
		}
		label_html_all = $("#labelId").html();

		//提示：以下人员授权您为他/她创建日程
		$("#docOwnerId").click(function(){
			if($("#docOwnerId option").length>1){
				$("#ownerTip").toggle();
			}
		});

		//非中文环境下无显示农历选项
		if(Com_Parameter['Lang']!=null && Com_Parameter['Lang']!='zh-cn'){
			$("#fdIsLunar").hide().next().hide();
		}
		
	});
</script>