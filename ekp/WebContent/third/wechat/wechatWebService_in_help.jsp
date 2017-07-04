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
		isExpand="1";
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


<div id="optBarDiv"><input type="button"
	value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle">${param.name}接口说明</p>

<center>
<div style="width: 95%;text-align: left;">
	<p>&nbsp;&nbsp;EKP系统提供了组织架构接入webservice接口服务，包含同步所有组织架构基本信息（syncOrgElementsBaseInfo）和
	       同步需要更新的组织架构信息(syncOrgElements)接口，以下是对该接口的具体说明。
	</p>
</div>
<br/>

<table border="0" width="95%">
	<tr>
		<td><b>1、接口说明</b></td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);">&nbsp;&nbsp;1.1同步所有组织架构基本信息（syncOrgElementsBaseInfo）
			<img src="${KMSS_Parameter_StylePath}icons/collapse.gif" border="0" align="bottom"/>
			</td>
	</tr>
	<tr>
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;组织架构接入上下文（SysSynchroSetOrgContext），详细说明如下:</div>
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
								<td>组织架构来源</td>
								<td>字符串（String）</td>
								<td>允许为空</td>
								<td> 该字段信息会存于系统组织架构表sys_org_element字段fd_import_info中，<br/>
									格式:  系统来源 +传入的组织架构唯一标识。<br/>
	 								若为空 则默认格式为 "com.landray.kmss.sys.organization.webservice.in.ISysSynchroSetOrgWebService" + 传入的组织架构唯一标识。</td>
							</tr>
							<tr>
								<td>orgJsonData</td>
								<td>所有组织机构基本信息json数组</td>
								<td>字符串（Json数组）</td>
								<td>不允许为空</td>
								<td>设置和ekpJ系统做组织架构同步系统的所有组织架构基本数据.<br/>
									<font style="font-weight: bolder;">格式为:
									[{"id":"13425","lunid":"eaac7762243cc6","name":"测试部","type":"dept","no":"CSDL01","keyword":"dept_01","order":"1001"},...].</font><br/>
									其中id（唯一标识）、lunid(唯一标示，可替换为主健),name（名称），type（类型有：org，dept，group，person，post）不允许为空。
									其他字段（no：编号、keyword：关键字、order：排序号）可为空。
								</td>
							</tr>
							<tr>
								<td>orgSyncConfig</td>
								<td>同步所需配置</td>
								<td>字符串（Json对象）</td>
								<td>允许为空</td>
								<td>根据业务要求,设置和ekpj同步时,需要同步到ekpj系统的字段信息,该<font color="red">参数在本接口中无效</font></td>
							</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;返回操作信息（SysSynchroSetResult），详细说明如下:</div>
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
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);"><br/>&nbsp;&nbsp;1.2 同步需要更新的组织架构信息（syncOrgElements）
			<img src="${KMSS_Parameter_StylePath}icons/collapse.gif" border="0" align="bottom"/>
			</td>
	</tr>
	<tr>
		<td>
			<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;">
				<tr>
					<td class="td_normal_title" width="20%">参数信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;组织架构接入上下文（SysSynchroSetOrgContext），详细说明如下:</div>
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
								<td>组织架构来源</td>
								<td>字符串（String）</td>
								<td>允许为空</td>
								<td> 该字段信息会存于系统组织架构表sys_org_element字段fd_import_info中，<br/>
									格式:  系统来源 +传入的组织架构唯一标识。<br/>
	 								若为空 则默认格式为 "com.landray.kmss.sys.organization.webservice.in.ISysSynchroSetOrgWebService" + 传入的组织架构唯一标识。</td>
							</tr>
							<tr>
								<td>orgJsonData</td>
								<td>所有组织机构基本信息json数组</td>
								<td>字符串（Json数组）</td>
								<td>不允许为空</td>
								<td>设置和ekpJ系统做组织架构同步系统的所有组织架构基本数据.<br/>
									<font style="font-weight: bolder;">格式为:<br/>
									[<br/>
									&nbsp;&nbsp;{<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;"id": "12d552352ac1dd47c57c307401f958f7", //唯一标识,不允许为空<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;"lunid": "12d552352ac1dd47c57c307401f958f7", //唯一标识，若不为空，直接作为主健存入数据库,可为空<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"name": "深圳蓝凌",     //名称 不允许为空  <br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"type": "dept",        //组织架构类型,不允许为空,org(机构),dept(部门),group(群组),post(岗位),person(人员)<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"no":"981",			   //编号,可为空<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"order":"00210",        //排序号,可为空<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"keyword":"18391297432nm",//关键字,可为空<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"memo":"说明",			//组织架构说明,可为空<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"isAvailable": true,   //是否有效,该属性决定该组织架构是否删除<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"parent": "1331a26cb4bcf91583c264b4803b69ae" ,   //设置该组织架构的父部门,对type为org,dept,post,person起作用.<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"thisLeader":"1331a26cb4bcf91583c264b4803b69ad"  //设置部门领导,对type为org,dept,post起作用<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"supperLeader":"1331a26cb4bcf91583c264b4803b69a1"//设置部门上级领导,对type为org,dept起作用<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"members":["113","43424",..],                    //成员,仅对type为group起作用<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"persons":["13868123","12313",..],				 //包含人员,仅对type为post起作用<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"posts":["cbda73","bac67843"..]                  //所属岗位,仅对type为person起作用<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"loginName":"test01",							 //登录名,仅当type为person时,有此信息<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"password":"c4ca4238a0b923820dcc509a6f75849b",   //密码,base64加密后的信息,仅当type为person时,有此信息<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"mobileNo":"1578277221",						 //手机号,仅当type为person时,有此信息<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"email":"sin@126.com",							 //邮件地址,仅当type为person时,有此信息<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"attendanceCardNumber":"20080901",               //考勤号,仅当type为person时,有此信息<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"workPhone":"0755878787782",					 //办公电话,仅当type为person时,有此信息<br/>
							        &nbsp;&nbsp;&nbsp;&nbsp;"rtx":"9527"									 // rtx账号,仅当type为person时,有此信息<br/>
									&nbsp;&nbsp;}<br/>
									&nbsp;&nbsp;...<br/>
									]<br/></font>
									各个字段的含义以及适用范围,请参考查阅 <a href="#orgfiled">2.2 组织架构字段类型说明</a>
								</td>
							</tr>
							<tr>
								<td>orgSyncConfig</td>
								<td>同步所需配置</td>
								<td>字符串（Json对象）</td>
								<td>允许为空</td>
								<td>
									根据业务要求,设置和ekpj同步时,需要同步到ekpj系统的字段信息.<font style="font-weight: bolder;">格式如下:<br/>
									{<br/>
										"org":["no","order","keyword","memo","parent","thisLeader","supperLeader"],<br/>
										"dept":["no","order","keyword","memo","parent","thisLeader","supperLeader"],<br/>
										"group":["no","order","keyword","memo","members"],<br/>
										"post":["no","order","keyword","memo","parent","thisLeader","persons"],<br/>
										"person":["no","order","keyword","memo","loginName","email","mobileNo",<br/>
												&nbsp;&nbsp;"attendanceCardNumber","workPhone","rtx","parent"]<br/>
									}<br/></font>
									用于配置哪些信息需要同步到ekpJ系统中。上面的配置内容为没有设置此信息时的默认值,
									从以上的配置可以看出:此次同步是不同步个人密码信息(password)的,个人和岗位之间的关系是靠岗位中的成员(persons)来维护的等.
									字段配置来源及含义,请查阅 <a href="#orgfiled">2.2 组织架构字段类型说明</a>
								</td>
							</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="20%">返回信息</td>
					<td style="padding: 0px;"><div style="margin: 8px;">&nbsp;&nbsp;返回操作信息（SysSynchroSetResult），详细说明如下:</div>
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
		<td><br/><b>2、通用数据类型说明</b></td>
	</tr>
	<tr>
		<td>
			<table class="tb_normal" style="width: 85%;margin-left: 40px;">
				<tr>
					<td>
						2.1 组织架构类型说明:<br/>
						该webservice中,组织架构类型标识分别为org(机构),dept(部门),group(群组),post(岗位),person(人员),如果在改webservice中设置了其他类型,会被认定为非法,不予处理.
					</td>
				</tr>
				<tr>
					<td id="orgfiled" style="padding: 0px;">
						2.2 组织架构字段类型说明:<br/>
						<table class="tb_normal" width=100%>
							<tr class="tr_normal_title">
								<td align="center" width="20%"><b>字段名</b></td>
								<td align="center" width="40%"><b>含义</b></td>
								<td align="center" width="40%"><b>适用组织架构类型</b></td>
							</tr>
							<tr >
								<td>id</td>
								<td>集成系统中组织架构的唯一标识,不允许为空</td>
								<td>所有组织架构类型</td>
							</tr>
							<tr >
								<td>name</td>
								<td>组织架构名称, 不允许为空</td>
								<td>所有组织架构类型</td>
							</tr>
							<tr >
								<td>type</td>
								<td>组织架构类型,不允许为空</td>
								<td>值为:org(机构),dept(部门),group(群组),post(岗位),person(人员)中的一个</td>
							</tr>
							<tr >
								<td>no</td>
								<td>编号,可为空</td>
								<td>所有组织架构类型</td>
							</tr>
							<tr >
								<td>order</td>
								<td>排序号,可为空</td>
								<td>所有组织架构类型</td>
							</tr>
							<tr >
								<td>keyword</td>
								<td>关键字,可为空</td>
								<td>所有组织架构类型</td>
							</tr>
							<tr >
								<td>memo</td>
								<td>组织架构说明,可为空</td>
								<td>所有组织架构类型</td>
							</tr>
							<tr >
								<td>isAvailable</td>
								<td>是否有效,该属性决定该组织架构是否删除</td>
								<td>所有组织架构类型,布尔类型</td>
							</tr>
							<tr >
								<td>parent</td>
								<td>设置该组织架构的父部门</td>
								<td>org(机构),dept(部门),post(岗位),person(人员)</td>
							</tr>
							<tr >
								<td>thisLeader</td>
								<td>设置组织架构领导</td>
								<td>org(机构),dept(部门),post(岗位)</td>
							</tr>
							<tr >
								<td>supperLeader</td>
								<td>设置部门上级领导</td>
								<td>org(机构),dept(部门)</td>
							</tr>
							<tr >
								<td>members</td>
								<td>成员</td>
								<td>group(群组)</td>
							</tr>
							<tr >
								<td>persons</td>
								<td>包含人员</td>
								<td>post(岗位)</td>
							</tr>
							<tr >
								<td>posts</td>
								<td>所属岗位</td>
								<td>person(人员)</td>
							</tr>
							<tr >
								<td>loginName</td>
								<td>登录名</td>
								<td>person(人员)</td>
							</tr>
							<tr >
								<td>password</td>
								<td>密码,base64加密后的信息</td>
								<td>person(人员)</td>
							</tr>
							<tr >
								<td>mobileNo</td>
								<td>手机号</td>
								<td>person(人员)</td>
							</tr>
							<tr >
								<td>email</td>
								<td>邮件地址</td>
								<td>person(人员)</td>
							</tr>
							<tr >
								<td>attendanceCardNumber</td>
								<td>考勤号</td>
								<td>person(人员)</td>
							</tr>
							<tr >
								<td>workPhone</td>
								<td>办公电话</td>
								<td>person(人员)</td>
							</tr>
							<tr >
								<td>rtx</td>
								<td>rtx账号</td>
								<td>person(人员)</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td><br/><b>3、参考代码</b></td>
	</tr>
	<tr>
		<td style="cursor: pointer;font-size: 15px;" onclick="expandMethod(this);">&nbsp;&nbsp;同步组织架构样例
		<img src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" align="bottom"/>
		</td>
	</tr>
	<tr style="display: none">
		<td>
		<table class="tb_normal" cellpadding="0" cellspacing="0"  style="width: 85%;margin-left: 40px;"><tr><td>
				   ~~~~~~~~~贴代码
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

</center>

<%@ include file="/resource/jsp/view_down.jsp"%>