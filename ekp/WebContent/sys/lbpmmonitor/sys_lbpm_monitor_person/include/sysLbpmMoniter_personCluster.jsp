<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.cluster.interfaces.ClusterDiscover"%>
<%@ page import="com.landray.kmss.sys.cluster.model.SysClusterGroup"%>
<%@ page import="java.util.*"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
   <div>
      <list:criteria channel="channel_common" id="criteria1">
	    <%--我的流程 --%>  
		         <list:cri-criterion title="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.person.my')}" expand="true" key="myDoc" multi="false">
					<list:box-select>
						<list:item-select cfg-defaultValue="create" cfg-required="true">
							<ui:source type="Static">
							    [{text:'${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.person.myCreate')}', value:'create'},
								 {text:'${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.person.myApprovaled')}', value:'approved'},
								 {text:'${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.person.myApproval')}', value:'approval'}]
							</ui:source>
							<ui:event event="selectedChanged" args="evt">
									var vals = evt.values;
									if (vals.length > 0 && vals[0] != null) {
										var val = vals[0].value;
										if (val != 'approval') {
											LUI('fdStatus').setEnable(true);
										} else{
											LUI('fdStatus').setEnable(false);
										}
									}else{
									        LUI('fdStatus').setEnable(false);
									}
							 </ui:event>
						</list:item-select>
				   </list:box-select>
				</list:cri-criterion>
				<%--状态--%>  
				<list:cri-criterion title="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.order.status')}" key="fdStatus" multi="false" expand="true"> 
					<list:box-select>
						<list:item-select id="fdStatus" cfg-enable="false">
							<ui:source type="Static">
								  [{text:'${ lfn:message('sys-lbpmmonitor:status.activated') }',value:'20'},
								   {text:'${ lfn:message('sys-lbpmmonitor:status.completed') }',value:'30'},
								   {text:'${ lfn:message('sys-lbpmmonitor:status.error') }',value:'21'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>           
      </list:criteria>
   </div>
   <div style="width:100%">
	  <ui:tabpanel layout="sys.ui.tabpanel.light" id="panel">
	     <% List<SysClusterGroup> groups = ClusterDiscover.getInstance().getGroupByFunc("lbpmMonitorServer");
	        request.setAttribute("groups",groups);
	       %>
		     <!-- 排序 
			 <div class="lui_list_operation">
					 <table width="100%">
						<tr>
							<td  class="lui_sort">
								${ lfn:message('list.orderType') }：
							</td>
							<td>
								<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="6" cfg-criteriaInit="channel_common1">
									<list:sort property="fdCreateTime" text="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.order.creatorTime')}" group="sort.list" value="down"></list:sort>
									<list:sort property="fdStatus" text="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.order.status')}" group="sort.list"></list:sort>
								</ui:toolbar>
							</td>
						</tr>
					 </table>
			</div> -->
	  	    <%--列表--%>  
		    <c:forEach items="${groups}" var="group">
			  <ui:content title="${group.fdName}" style="padding:0;background-color:#f2f2f2;" id="content_${group.fdKey}" key="${group.fdKey}">
				    <%--列表 cfg-criteriaInit="true"--%>  
					<list:listview id="list_${group.fdKey}" channel="${group.fdKey}" cfg-criteriaInit="true">
						<ui:source type="AjaxJsonp">
								{url:'${group.fdUrl}/sys/lbpmmonitor/sys_lbpmmonitor_person/SysLbpmMonitorPerson.do?method=listChildren'}
						</ui:source>
						<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
							rowHref="${group.fdUrl}!{url}"  name="columntable">
							<list:col-checkbox></list:col-checkbox>
							<list:col-serial></list:col-serial>
							<list:col-auto props=""></list:col-auto>
						</list:colTable>
				   </list:listview> 
			 	   <list:paging channel="${group.fdKey}"></list:paging>	 	
			  </ui:content>
		    </c:forEach>  
		    <ui:event event="indexChanged" args="evt">
		         var content1 = LUI("content_ekp1");
		         var content = evt.panel.contents[evt.index.after];
		         window.currentKey = content.id.substring('content_'.length);
		         if( window.curr_criteria_evt != null){
		            if(initObject[window.currentKey]!=true){
						_topic.channel(currentKey).publish("criteria.changed", window.curr_criteria_evt);
						initObject[window.currentKey] = true;
					}
		         }
		    </ui:event>
		</ui:tabpanel>
	 </div> 
	 <script type="text/javascript">
		 seajs.use(['lui/dialog','lui/jquery','lui/topic'], function(dialog,$,topic) {
			    _topic = topic;
			    window.curr_criteria_evt = null;
			    initObject = {};
				//筛选器变化		
				topic.channel("channel_common").subscribe("criteria.changed", function(evt) {
					   window.curr_criteria_evt = evt;
					   topic.channel(window.currentKey).publish("criteria.changed", evt);
					   initObject = {};
					   initObject[window.currentKey] = true;

					   var contentsArr = LUI("panel").contents;
					   for(var i=0 ;i < contentsArr.length;i++){
			                var content = contentsArr[i];
			                var key = content.id.substring('content_'.length);
			                var name = content.title;
			                var url = LUI("list_"+key).getUrl(evt);
			                ajaxRequest(name,url,i);
			           }
				});

				window.ajaxRequest = function(name,url,index){
					   var data ={getTotalOnly:"true"};
					   $.ajax({
			              	url: url,
			            	dataType: "jsonp",
			            	data:data,
			           	    jsonp:"jsonpcallback",
			             	success: function(data,textStatus) {
		                	   LUI('panel').navs[index].navTitle.innerHTML = name+"("+data.page.totalSize+")";
			             	}
				        });
			    };
			});
	 </script>