<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/cluster/sys_cluster_server/sysClusterServer.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message bundle="sys-cluster" key="sysClusterDispatcher.setting"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/cluster/sys_cluster_dispatcher/sysClusterDispatcher.do" />?method=list');">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/cluster/sys_cluster_server/sysClusterServer.do" />?method=add');">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysClusterServerForm, 'deleteall');">
		<input type="button" value="<bean:message key="button.refresh"/>"
			onclick="history.go(0);">
	</div>
	<table id="List_ViewTable">
		<tr>
			<td width="10pt">
				<input type="checkbox" name="List_Tongle">
			</td>
			<td>
				<bean:message bundle="sys-cluster" key="sysClusterServer.fdName"/>
			</td>
			<td>
				<bean:message bundle="sys-cluster" key="sysClusterServer.fdKey"/>
			</td>
			<td>
				<bean:message bundle="sys-cluster" key="sysClusterServer.status"/>
			</td>
			<td>
				<bean:message bundle="sys-cluster" key="sysClusterServer.fdPid"/>
			</td>
			<td>
				<bean:message bundle="sys-cluster" key="sysClusterServer.fdAddress"/>
			</td>
			<td>
				<bean:message bundle="sys-cluster" key="sysClusterServer.fdStartTime"/>
			</td>
			<td>
				<bean:message bundle="sys-cluster" key="sysClusterServer.fdRefreshTime"/>
			</td>
			<td>
				<bean:message bundle="sys-cluster" key="sysClusterServer.fdDispatcherType"/>
			</td>
		</tr>
		<c:forEach items="${serverList}" var="sysClusterServer" varStatus="vstatus">
			<c:set var="serverStatus" value="${sysClusterServer.status}"/>
			<c:set var="styleTxt" value=""/>
			<c:if test="${sysClusterServer.local}">
				<c:set var="styleTxt" value=" style='font-weight:bold;'"/>
			</c:if>
			<tr
				kmss_href="<c:url value="/sys/cluster/sys_cluster_server/sysClusterServer.do" />?method=view&fdId=${sysClusterServer.fdId}">
				<td>
					<c:if test="${serverStatus!=2}">
						<input type="checkbox" name="List_Selected" value="${sysClusterServer.fdId}"> 
					</c:if>
				</td>
				<td${styleTxt}>
					<c:if test="${not sysClusterServer.local && not empty sysClusterServer.fdUrl}">
						<a href="${sysClusterServer.fdUrl}/sys/cluster/sys_cluster_server/sysClusterServer.do?method=list"
							target="_self" title="<bean:message bundle="sys-cluster" key="sysClusterServer.linkTitle"/>">
					</c:if>
					<c:out value="${sysClusterServer.fdName}" />
					<c:if test="${not sysClusterServer.local && not empty sysClusterServer.fdUrl}">
						</a>
					</c:if>
				</td>
				<td${styleTxt}>
					<c:out value="${sysClusterServer.fdKey}" />
				</td>
				<td${styleTxt}>
					<xform:select property="serverStatus" value="${serverStatus}">
						<xform:enumsDataSource enumsType="sysClusterServer.status" />
					</xform:select>
				</td>
				<c:if test="${serverStatus==2}">
					<td${styleTxt}>
						<c:out value="${sysClusterServer.fdPid}" />
					</td>
					<td${styleTxt}>
						<c:out value="${sysClusterServer.fdAddress}" />
					</td>
					<td${styleTxt}>
						<xform:datetime property="fdStartTime" value="${sysClusterServer.fdStartTime}" pattern="yyyy-MM-dd HH:mm:ss" />
					</td>
					<td${styleTxt}>
						<xform:datetime property="fdRefreshTime" value="${sysClusterServer.fdRefreshTime}" pattern="yyyy-MM-dd HH:mm:ss" />
					</td>
					<td${styleTxt}>
						<xform:select property="fdDispatcherType" value="${sysClusterServer.fdDispatcherType}">
							<xform:enumsDataSource enumsType="sysClusterServer.fdDispatcherType" />
						</xform:select>
					</td>
				</c:if>
				<c:if test="${serverStatus!=2}">
					<td>N/A</td>
					<td>N/A</td>
					<td>N/A</td>
					<td>N/A</td>
					<td>N/A</td>
				</c:if>
			</tr>
		</c:forEach>
	</table>
	<br><br>
	<style>
		.help li{
			font-weight: bold;
			line-height:250%;
		}
		.help div{
			font-weight:normal;
			line-height:180%;
		}
	</style>
	<div width="85%">
		<a href="#" style="width:100%;display:block;background-color: #f0f0f0; padding:10px; font-size: 12px;"
			onclick="DIV_HELP.style.display=DIV_HELP.style.display=='none'?'':'none';">
			常见问题（点击展开）</a>
		<div id="DIV_HELP" class="help" style="display:none;">
			<li>如何辨别几个节点处于同一群集环境？</li>
			<div>
				若几个节点连到同一个数据库上，则视为这些节点都处于同一群集环境。
			</div>
			<li>为什么要为每个节点指定节点标识？</li>
			<div>
				由于系统中许多后台服务只允许在单个节点上运行，为了方便安排每个节点的后台服务，我们需要对每个节点都进行标识。<br>
				您可以在admin.do中为该节点设置节点标识，但这样导致群集中每个节点的配置不一致，给系统部署带来麻烦，因此建议您在JVM的启动参数中设定节点名，如：-DLandray.kmss.cluster.serverName=server1。<br>
				对于没有指定节点标识的节点，或者产生节点标识重名的情况，那该节点将以匿名的方式启动，启动后，您可以在上面的列表中发现这些节点，匿名节点的标识为一个32位的随机字符串。<br>
				匿名节点不允许指派任何后台服务；若匿名节点关闭后，匿名节点的信息将会在下一个节点启动的时候自定删除。
			</div>
			<li>运行状态的心跳超时是怎么产生的？</li>
			<div>
				系统中总共有三种运行状态：运行中、已关闭、心跳超时。<br>
				每个节点都设有心跳检测，心跳每15秒进行一次，其它节点若判断到某节点最后心跳时间超过了60秒，则认为该节点出现了异常关闭的现象，即：心跳超时。<br>
				另外，若发生强行关闭系统的情况，系统可能会发生来不及通知自己是正常关闭的现象，此时其它系统也会认为该节点心跳超时了。
			</div>
			<li>后台服务将以什么样的方式进行调度？</li>
			<div>
				后台服务的调度方式跟第一台启动的节点关系很大。<br>
				若第一台启动的节点没有设置以群集的方式启动，则它将“抢占”了所有的后台服务，即便后续启动的节点启用了群集，那它也不会承担任何后台服务。<br>
				若第一台启动的节点以群集的方式启动，那后续启动的任何节点，不管是否启动群集，都按群集的方式进行启动。此时，所有的实名节点将承担指派给它的后台服务，所有的匿名节点将不承担任何后台服务。
			</div>
			<li>群集间将以什么样的方式进行通讯？</li>
			<div>
				群集间的通讯将以两种方式进行：点对点消息通道和数据库数据交换。<br>
				两个节点间的网络正常的时候，将采用点对点消息通道进行通讯，这种通讯方式的优势是基本上没有太多的延时。<br>
				两个节点间的网络出现异常，系统将采用数据库的数据交换进行通讯，这种通讯方式能很好地保障通讯的准确性，但延时比较严重（会有最大30秒的延时）。
			</div>
			<li>如何尽量避免点对点消息通道的异常？</li>
			<div>
				1、请保证群集中每个节点的网络正常，并且尽量使用同一网段。<br>
				2、请尽量使用IPV4协议，建议在JVM的启动参数中添加参数：-Djava.net.preferIPv4Stack=true。<br>
				3、上面列表中的消息通道是以：“IP:端口”的格式显示。<br>
				若配置中的起始端口以及往后的连续20个端口都被占用，则点对点的消息通道将无法正常启动。<br>
				启动后，若IP不对也会导致该节点无法正常连接到其它节点，此时，请在JVM的启动参数中添加：-Djgroups.bind_addr=192.168.1.10，以绑定IP。
			</div>
		</div>
	</div>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>