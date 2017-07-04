<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page language="java"  import="com.landray.kmss.sys.zone.forms.SysZonePersonInfoForm" %>
<%@ page language="java"  import="com.landray.kmss.util.StringUtil" %>
<%@ page import="com.landray.kmss.sys.zone.util.SysZoneConfigUtil"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/mobile/mui.tld" prefix="mui"%>
<template:include ref="mobile.list">
	<template:replace name="title">
		<c:out value="${lfn:message('sys-zone:sysZonePerson.personInfoTitle')}"/> 
		- <c:out value="${sysZonePersonInfoForm.personName}"/>
	</template:replace>
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" 
			href="<%=request.getContextPath()%>/sys/zone/mobile/resource/view.css"></link>
		<mui:min-file name="mui-zone.js"/>
		<mui:min-file name="mui-zone-view.css"/>
		<script>
			require(['dojox/mobile/TransitionEvent','dojo/topic',"dojo/dom",
			     	"dojo/query","dijit/registry", "dojo/dom-geometry",
			     	"dojo/domReady!" ], function(TransitionEvent, topic, dom,query,registry,domGeometry) {
				window.backToDocView =  function(obj) {
					var opts = {
							transition : 'slide',
							moveTo:'docView',
							transitionDir : -1
						};
					new TransitionEvent(obj, opts).dispatch();
					topic.publish("/mui/list/pushDomHide",this);
				};
		
				window.fansMoreView = function(viewId, obj) {
					topic.publish("/sys/zone/onSlide", this, {
						moreViewId : viewId,
						target : obj
					});
				};
				topic.subscribe('/mui/list/noData',function(){
					var h = dom.byId('docView').offsetHeight - dom.byId('nav_view').offsetTop -30;
					query('.muiListNoData').style({
						'line-height' : h + 'px',
						'height' : h + 'px'
					});
				});
		
			});
		</script>
	</template:replace>
	<template:replace name="content">
	<div data-dojo-type="mui/view/DocScrollableView" id="docView"
		data-dojo-mixins="mui/list/_ViewPushAppendMixin">
		<div  class="mui_zone_perinfo" id="zone_perinfo">
			<c:if test="${KMSS_Parameter_CurrentUserId !=  sysZonePersonInfoForm.fdId}">
			<div>
				<div  style="width: 38%;">
					         <span data-dojo-type="dojox/mobile/Button"
					         		data-dojo-mixins="sys/zone/mobile/js/_FollowButtonMixin"
					         		data-dojo-props="orgId1:'${KMSS_Parameter_CurrentUserId}',
					         			userId:'${sysZonePersonInfoForm.fdId}',
					         			attentModelName:'com.landray.kmss.sys.zone.model.SysZonePersonInfo',
					        			fansModelName:'com.landray.kmss.sys.zone.model.SysZonePersonInfo',
					        			isFollowPerson:'true'">
					         </span>
					</div>
			</div>
			</c:if>
			<div class="mui_zone_per_content">
				<div class="mui_zone_img_content">
					<div>
						<img src="<%=request.getContextPath()%>/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${sysZonePersonInfoForm.personId}&size=b">
					</div>
				</div>
				<div class="mui_zone_info_content">
			         <h2>
			         	<c:out value="${sysZonePersonInfoForm.personName}"/>
			         </h2>
			         <p class="lui_info_tip"><c:out value="${sysZonePersonInfoForm.dep}"/></p>
			        
			    </div>
			</div>
			<div class="mui_zone_relation">
				<div class="mui_zone_item">
					<c:import url="/sys/fans/mobile/import/view.jsp" charEncoding="UTF-8">
						<c:param name="fdModelId" value="${sysZonePersonInfoForm.fdId }"/>
						<c:param name="attentModelName" value="com.landray.kmss.sys.zone.model.SysZonePersonInfo"/>
						<c:param name="fansModelName" value="com.landray.kmss.sys.zone.model.SysZonePersonInfo"/>
						<c:param name="muiIcon" value="mui-heart"/>
						<c:param name="type" value="attention"/>
						<c:param name="fdMemberNum" value="${empty attentNum ? '0': attentNum}"/>
					</c:import>
					<c:import url="/sys/fans/mobile/import/view.jsp" charEncoding="UTF-8">
						<c:param name="fdModelId" value="${sysZonePersonInfoForm.fdId }"/>
						<c:param name="attentModelName" value="com.landray.kmss.sys.zone.model.SysZonePersonInfo"/>
						<c:param name="fansModelName" value="com.landray.kmss.sys.zone.model.SysZonePersonInfo"/>
						<c:param name="muiIcon" value="mui-depart"/>
						<c:param name="type" value="fans"/>
						<c:param name="fdMemberNum" value="${empty fansNum ? '0': fansNum}"/>
					</c:import>
                </div>
				<c:if test="${KMSS_Parameter_CurrentUserId !=  sysZonePersonInfoForm.fdId}">
					<div class="itemOpearte">
	                    <span><a  class="mui mui-tel mui_zone_replace" href="tel:${sysZonePersonInfoForm.mobilPhone}"></a></span>
	                    <span><a  class="mui mui-mail mui_zone_replace" href="mailto:${sysZonePersonInfoForm.email}"></a></span>
	                    <span><a class="mui mui-msg mui_zone_replace" href="sms:${sysZonePersonInfoForm.mobilPhone}"></a></span>
               		</div>
				</c:if>
			</div>
		</div>
		<div data-dojo-type="mui/fixed/Fixed">
			<div data-dojo-type="mui/fixed/FixedItem">
				
				<div class="muiHeader" style="margin:0;">
					<div style="display:table-cell;"
						data-dojo-type="mui/nav/NavBarStore" 
						data-dojo-props="defaultUrl:'/sys/zone/mobile/nav.jsp?zone_TA_text=${zone_TA_text}'">
					</div>
					<!--
					<div style="display:table-cell;" class="mui_more_zone_button"
							data-dojo-type="sys/zone/mobile/js/more/MoreButtonBar"> 
					</div>
					<div class="mui_zone_search_bar"
						data-dojo-type="mui/search/SearchButtonBar"
						data-dojo-props="modelName:'com.landray.kmss.sys.zone.model.SysZonePersonInfo'">
					</div>
				--></div>
				<div  class="mui_zone_cri" id="mui_zone_cri">
					<span class="mui_zone_selected_text"></span><span class="knowledge_num"></span>
					<span class="mui_zone_cri_btn "><span class="mui mui-filter"></span>筛选</span>
				</div>
			</div>
		</div>
		
		<%--mui/list/NavSwapScrollableView  --%>
		<div data-dojo-type="sys/zone/mobile/js/NavSwapView" id="nav_view"
			 data-dojo-props="userId:'${sysZonePersonInfoForm.fdId}',currentServerKey:'<%=SysZoneConfigUtil.getCurrentServerGroupKey() %>'">
			 <div data-dojo-type="sys/zone/mobile/js/BaseInfoView" class="gray">
				<section class="mui_zone_info_section">
					<h2 class="mui_section_head">基本信息</h2>
					<div class="mui_section_content">
						<div class="mui_section_catalog">
						 	<div class="mui_zone_eva_box">
							 	<div class="mui_zone_eva_score">
							 		<div data-dojo-type="mui/rating/Rating"
							 			data-dojo-props="value:'${sysZonePersonInfoForm.evaluationForm.fdEvaluateScore}'">
							 		</div>
						 		</div>
						 		<span class="mui_zone_ratingScore">
						 			${sysZonePersonInfoForm.evaluationForm.fdEvaluateScore}</span>
						 		<a class="mui_zone_eva_count" style="cursor: pointer;"
						 			href="<%=request.getContextPath()%>/sys/evaluation/mobile/index.jsp?modelName=com.landray.kmss.sys.zone.model.SysZonePersonInfo&modelId=${sysZonePersonInfoForm.fdId}&isNotify=no">
						 			${empty  sysZonePersonInfoForm.docEvalCount ? 0 : sysZonePersonInfoForm.docEvalCount}人评价
						 			<span class="mui-forward mui mui_zone_eva_forward"></span>
						 		</a>
					 		</div>
						</div>
						<div class="mui_section_catalog">
							 <span class="mui_zone_section_title">签名 </span>
							 <p class="mui_zone_section_content"><c:out value="${sysZonePersonInfoForm.fdSignature}"/></p>
						</div>
						<div class="mui_section_catalog">
							 <span class="mui_zone_section_title">标签 </span>
							 <p class="mui_zone_section_content">
							 	<%
							 		SysZonePersonInfoForm zoneForm = (SysZonePersonInfoForm)request.getAttribute("sysZonePersonInfoForm");
							 		String fdTagNames = zoneForm.getSysTagMainForm().getFdTagNames().trim();
							 		if(StringUtil.isNotNull(fdTagNames)) {
							 			String[] tags = fdTagNames.trim().split("\\s+");
							 			for(String tag : tags ) {
							 	%>	
							 			<span class="mui_zone_tag ">
							 				<%=tag%>
							 			</span>
							 	<%		
							 			}
							 		}
							 	%>
							 </p>
						</div>
						<div class="mui_section_catalog" >
							 <span class="mui_zone_section_title">电话 
							 </span>
							 <div class="mui_zone_section_content">
							 	<em><c:out value="${sysZonePersonInfoForm.mobilPhone }"/></em>
							 </div>
						</div>
						<div class="mui_section_catalog" >
							 <span class="mui_zone_section_title">邮箱 
							 </span>
							 <div class="mui_zone_section_content">
							 	<em><c:out value="${sysZonePersonInfoForm.email }"/></em>
							 </div>
						</div>
					</div>
				</section>
				<div class="___muiDocContent">
					<c:forEach items="${personDatas}" var="data">
						<section class="mui_zone_info_section">
							<h2 class="mui_section_head"><c:out value="${data.fdName}"/></h2>
							<div class="mui_section_content">
								${data.docContent}
							</div>
						</section>
					</c:forEach>
				</div>
				<script>
						require(
								[ 'mui/rtf/RtfResizeUtil', 'dojo/query' ],
								function(RtfResizeUtil, query) {
									new RtfResizeUtil(
											{
												containerNode : query('.___muiDocContent')[0],
												channel : 'zoneView'
											});
								})
				</script>
			</div>
		    <ul 
		    	data-dojo-type="sys/zone/mobile/js/JsonStoreZoneList" 
		    	data-dojo-mixins="sys/zone/mobile/js/list/TextItemListMixin,mui/list/_ListNoDataMixin" >
			</ul>
		</div>
		<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" data-dojo-props="fill:'grid'">
			<li data-dojo-type="mui/back/BackButton" data-dojo-props="align:'left'"></li>
			<%--提问  --%>
			<c:if test="${KMSS_Parameter_CurrentUserId !=  sysZonePersonInfoForm.fdId}">
				      <%
			    					 JSONArray commmunicateList = SysZoneConfigUtil.getCommnicateList();
								     for(Object map: commmunicateList) { 
								    	 JSONObject json = (JSONObject)map;
								    	 if(!"communicate_mobile".equals(json.get("showType"))) {
				        	           			continue;
				        	           	 }
								    	 if("ask_mobile".equals(json.get("unid"))) {
								    		 String path = "";
								    		 String key = (String)json.get("server"); 
								    		 String localKey = SysZoneConfigUtil.getCurrentServerGroupKey();
								    		 if(StringUtil.isNotNull(key) && !key.equals(localKey)) { 
					        	           			path = SysZoneConfigUtil.getServerUrl(key);
					        	           	 } 
								    		 String askHref = path + json.get("href");
								    		 if(StringUtil.isNotNull(askHref)) {
								    			 askHref =  askHref.replaceAll("\\!\\{personId\\}",
								    					 (String)request.getAttribute("KMSS_Parameter_CurrentUserId"));
								    		 }
								 %>
								 			<kmss:auth requestURL="<%=askHref%>" requestMethod="GET"> 
									 			<li data-dojo-type="mui/tabbar/TabBarButton"
									 				class="muiBtnSubmit" data-dojo-props='colSize:2'
									 				data-dojo-props='href:"<%=askHref%>"'>
									 				<i class="mui mui-quiz"></i>提问
									 			</li>
								 			</kmss:auth>
								 		
								 <%   		 
								    	 }
								     }
	  	  				  		%>
       		 </c:if>
			
			<li data-dojo-type="mui/tabbar/TabBarButtonGroup" class="muiZoneBottomRight"
				data-dojo-props="icon1:'mui mui-more',align:'right'">
				<div data-dojo-type="mui/back/HomeButton"></div>
   			</li>
		</ul>
	</div>
	</template:replace>
</template:include>

