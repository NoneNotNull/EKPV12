<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js|list.js");
</script>
<script type="text/javascript">
function expandMethod(domObj) {
	var thisObj = $(domObj);
	var isExpand = thisObj.attr("isExpanded");
	if(isExpand == null)
		isExpand = "1";
	var trObj=thisObj.parents("tr");
	trObj = trObj.next("tr");
	var imgObj = thisObj.find("img");
	if(trObj.length > 0){
		if(isExpand=="0"){
			trObj.show();
			thisObj.attr("isExpanded","1");
			imgObj.attr("src","${KMSS_Parameter_StylePath}icons/collapse.gif");
		}else{
			trObj.hide();
			thisObj.attr("isExpanded","0");
			imgObj.attr("src","${KMSS_Parameter_StylePath}icons/expand.gif");
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
	<p>&nbsp;&nbsp;EKP系统提供了组织架构接出webservice接口服务，接口包含两部分，获取所有组织架构基本信息（getElementsBaseInfo）以及获取需要更新的组织架构信息（getUpdatedElements）等2个接口，
	接口getElementsBaseInfo的作用是暴露本系统所有组织架构唯一标示信息，以便于异构系统做组织架构关系对应，另外也方便异构系统做组织架构架构删除检测。
	接口getUpdatedElements的作用是返回此次组织架构同步时，在ekp系统中发生过变更的组织架构详细信息。以下是对上述接口参数的具体说明。
	</p>
</div>
<br/>

<table border="0" width="95%">
	<tr>
		<td><b>1、接口说明</b></td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);">&nbsp;&nbsp;1.1&nbsp;&nbsp;获取所有组织架构基本信息（getElementsBaseInfo）
			<img src="${KMSS_Parameter_StylePath}icons/collapse.gif" border="0" align="bottom"/>
			</td>
	</tr>
	<tr>
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;组织架构基本信息接出上下文（SysSynchroGetOrgBaseInfoContext），详细说明如下:</div>
						<table class="tb_normal" cellpadding="0" cellspacing="0" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="10%"><b>程序名</b></td>
								<td align="center" width="10%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="15%"><b>可否为空</b></td>
								<td align="center" width="55%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>returnOrgType</td>
								<td>设置需要返回的组织架构信息类型</td>
								<td>String(json数组)</td>
								<td>允许为空</td>
								<td>为空，表示获取所有组织架构类型的数据。<br/>
	 								不为空，表示获取设置的组织架构类型,<font style="font-weight: bolder;">格式为:[{"type":"person"},..]</font>。<br/>
	 								<font style="font-weight: bolder;">可供设置的组织类型有:org(机构),dept(部门),group(群组),post(岗位),person(人员)。</font>
	 							</td>
							</tr>
							<tr>
								<td>returnType</td>
								<td>设置需要返回的基本信息字段列表</td>
								<td>String(json数组)</td>
								<td>允许为空</td>
								<td>为空,返回的基本信息仅包含:id(唯一标识),lunid(唯一标示，可作为数据主健),name(名称),type(组织架构类型)信息。<br/>
								          不为空,则表示返回的基本信息中处理id,name,type外,还包含设置的字段列表内容。
								    <font style="font-weight: bolder;">格式为:[{"type":"no"},..]</font>。<br/>
								    <font style="font-weight: bolder;"> 可供设置的字段名称有:no(编号),order(排序号),keyword(关键字)。</font>
								</td>
							</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;返回信息（SysSynchroOrgResult），详细说明如下:</div>
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
								<td>数字（int）</td>
								<td>不允许为空</td>
								<td>0:表示未操作。<br/>
									1:表示操作失败。<br/>
									2:表示操作成功。
								</td>
							</tr>
							<tr>
								<td>message</td>
								<td>返回信息</td>
								<td>字符串（String）</td>
								<td>可为空</td>
								<td>
									返回状态值为0时，该值返回空。<br/>
									返回状态值为1时，该值返回错误信息。<br/>
									返回状态值为2时，该值返回所有组织架构的基本信息json数组。说明如下：<br/><br/>
									<font style="font-weight: bolder;">返回值格式和参数returnType的设置有关。</font><br/>
									1、returnType为空时,返回信息格式为：<br/>[{"id":"13425","name":"测试部","type":"dept"},...]。<br/><br/>
									2、returnType不为空时，返回的信息格式和returnType的设置对应，<br/>
									如returnType设置为 [{"type":"no"},{"type":"keyword"},{"type":"order"}]时,<br/>
									则对应返回信息格式为：<br/>[{"id":"13425","name":"测试部","type":"dept","no":"CSDL01","keyword":"dept_01","order":"1001"},...]。
								</td>
							</tr>
							<tr>
								<td>count</td>
								<td>返回数据的条目数</td>
								<td>数字（int）</td>
								<td>可为0</td>
								<td>
									返回数据的条目数。
								</td>
							</tr>
							
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);"><br/>&nbsp;&nbsp;1.2&nbsp;&nbsp;获取需要更新的组织架构信息（getUpdatedElements）
			<img src="${KMSS_Parameter_StylePath}icons/collapse.gif" border="0" align="bottom"/>
			</td>
	</tr>
	<tr>
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;组织架构信息接出上下文（SysSynchroGetOrgInfoContext），详细说明如下:</div>
						<table class="tb_normal" cellpadding="0" cellspacing="0" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="10%"><b>程序名</b></td>
								<td align="center" width="10%"><b>描述</b></td>
								<td align="center" width="10%"><b>类型</b></td>
								<td align="center" width="15%"><b>可否为空</b></td>
								<td align="center" width="55%"><b>备注说明</b></td>
							</tr>
							<tr>
								<td>returnOrgType</td>
								<td>设置需要返回的组织架构信息类型</td>
								<td>String(json数组)</td>
								<td>允许为空</td>
								<td>为空，表示获取所有组织架构类型的数据。<br/>
	 								不为空，表示获取设置的组织架构类型,<font style="font-weight: bolder;">格式为:[{"type":"person"},..]</font>。<br/>
	 								<font style="font-weight: bolder;">可供设置的组织类型有:org(机构),dept(部门),group(群组),post(岗位),person(人员)。</font>
	 							</td>
							</tr>
							<tr>
								<td>count</td>
								<td>设置此次同步需要获取组织架构条目数</td>
								<td>数字（int）</td>
								<td>不允许为空</td>
								<td>设置此次同步需要获取组织架构条目数。
	 							</td>
							</tr>
							<tr>
								<td>beginTimeStamp</td>
								<td>设置同步的时间戳</td>
								<td>字符串（String）</td>
								<td>允许为空</td>
								<td> 为空，   则取系统所有组织架构信息中的count(见)条信息。<br/>
									   不为空，则取系统组织架构信息中，大于beginTimeStamp的组织架构信息中count条数据。<br/>
									 <font style="font-weight: bolder;"> 格式:yyyy-MM-dd HH:mm:ss.SSS</font></td>
							</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;返回的部门信息（SysSynchroOrgDeptResult），详细说明如下:</div>
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
								<td>数字（int）</td>
								<td>不允许为空</td>
								<td>0:表示未操作。<br/>
									1:表示操作失败。<br/>
									2:表示操作成功。
								</td>
							</tr>
							<tr>
								<td>message</td>
								<td>返回信息</td>
								<td>字符串（String）</td>
								<td>可为空</td>
								<td>
									返回状态值为0时，该值返回空。<br/>
									返回状态值为1时，该值错误信息。<br/>
									返回状态值为2时，该值返回此次调用返回的组织架构信息json数组,格式说明如下:<br/>
									[<br/>
									&nbsp;&nbsp;{<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;"id": "12d552352ac1dd47c57c307401f958f7", //唯一标识<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;"lunid": "12d552352ac1dd47c57c307401f958f7", //标示该值可以作为数据存储的主健<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"name": "深圳蓝凌",     //名称           <br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"type": "dept",        //组织架构类型,org(机构),dept(部门),group(群组),post(岗位),person(人员)<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"no":"981",			   //编号<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"order":"00210",        //排序号<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"keyword":"18391297432nm",//关键字<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"memo":"说明",			//组织架构说明<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"isAvailable": true,   //是否有效,该属性决定该组织架构是否删除<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"parent": "1331a26cb4bcf91583c264b4803b69ae" ,   //父部门,仅当type为org,dept,post,person时,有此信息.<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"thisLeader":"1331a26cb4bcf91583c264b4803b69ad"  //部门领导,仅当type为org,dept,post时,有此信息<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"supperLeader":"1331a26cb4bcf91583c264b4803b69a1"//上级领导,仅当type为org,dept时,有此信息<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"members":["113","43424",..],                    //成员,仅当type为group时,有此信息<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"persons":["13868123","12313",..],				 //包含人员,仅当type为post时,有此信息<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"posts":["cbda73","bac67843"..],                  //所属岗位,仅当type为person时,有此信息<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"loginName":"test01",							  //登录名,仅当type为person时,有此信息
							        &nbsp;&nbsp;&nbsp;&nbsp;"password":"c4ca4238a0b923820dcc509a6f75849b",    //密码,base64加密后的信息,仅当type为person时,有此信息
							        &nbsp;&nbsp;&nbsp;&nbsp;"mobileNo":"1578277221",						  //手机号,仅当type为person时,有此信息
							        &nbsp;&nbsp;&nbsp;&nbsp;"email":"sin@126.com",							  //邮件地址,仅当type为person时,有此信息	
							        &nbsp;&nbsp;&nbsp;&nbsp;"attendanceCardNumber":"20080901",                //考勤号,仅当type为person时,有此信息
							        &nbsp;&nbsp;&nbsp;&nbsp;"workPhone":"0755878787782",					  //办公电话,仅当type为person时,有此信息
							        &nbsp;&nbsp;&nbsp;&nbsp;"rtx":"9527"									 // rtx账号,仅当type为person时,有此信息
									&nbsp;&nbsp;}<br/>
									&nbsp;&nbsp;...<br/>
									]<br/>
									<font style="font-weight: bolder;">如果组织架构信息中,上述属性值为空,就不返回该属性信息。</font>
								</td>
							</tr>
							<tr>
								<td>count</td>
								<td>返回此次调用后,所返回的组织架构信息条目数</td>
								<td>数字（int）</td>
								<td>可为0</td>
								<td style="color: red">
									当此值小于参数设置中的count值时,表示分批次调用已结束.
								</td>
							</tr>
							<tr>
								<td>timeStamp</td>
								<td>返回此次调用后的时间戳</td>
								<td>字符串（String）</td>
								<td>不为空</td>
								<td>
									<font style="font-weight: bolder;">格式:yyyy-MM-dd HH:mm:ss.SSS</font>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td><br/><b>2、通用数据类型说明</b></td>
	</tr>
	<tr>
		<td>
			<table class="tb_normal" style="width: 85%;margin-left: 40px;">
				<tr>
					<td>
						组织架构类型说明:<br/>
						该webservice中,组织架构类型标识分别为org(机构),dept(部门),group(群组),post(岗位),person(人员),如果在改webservice中设置了其他类型,会被认定为非法,不予处理.
					</td>
				</tr>
			</table>
		</td>
	</tr>

	<tr>
		<td><br/><b>3、参考代码</b></td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);">&nbsp;&nbsp;获取人员信息样例
		<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	<tr style="display: none">
		<td>
		<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;"><tr><td>
					<pre>
				  	 <c:import url="out.txt" charEncoding="UTF-8"></c:import>
				   </pre>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

</center>

<%@ include file="/resource/jsp/view_down.jsp"%>