<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include  file="/sys/zone/zoneSearchTemplate.jsp">
  <template:replace name="title">
  			${lfn:message('sys-zone:sysZonePerson.zoneSearchTitle') }
  </template:replace>
  <template:replace name="content">
    <!--主体区域 Starts-->
    <div class="lui_zone_mbody">
        <!--搜索栏 Starts-->
        <html:form action="/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do">
        <div class="lui_zone_searchwrap">
            <div class="lui_zone_searchtitle"></div>
            <div class="lui_zone_searchbox">
                <div class="inputbar_l">
                    <div class="inputbar_r">
                        <div class="inputbar_c">
                        <input  id="searchValue" name="searchValue" type="text" value="${lfn:message('sys-zone:sysZonePerson.searchInputHelp') }"/>
                        <input  id="fdTags" name="fdTags" type="hidden" value=""/>
                        </div>
                    </div>
                </div>
                <a class="lui_zone_btn_search_l" href="javascript:zoneSearch();">
                    <span class="lui_zone_btn_search_r">
                        <span class="lui_zone_btn_search_c"></span>
                    </span>
                </a>
            </div>
        </div>
        </html:form>
        <!--搜索栏 Ends-->
        <!--左侧区域 Starts-->
        <div class="lui_zone_mbody_l">
            <!--人员查找搜索内容 Starts-->
            <div class="lui_zone_search_content">
                <!--已选条件 Starts-->
                <div class="lui_zone_search_conditon" id="staffYpage_searchConditon" style="display: none;">
                    <div class="lui_zone_search_conditon_r">
                        <div class="lui_zone_search_conditon_c">
                            <ul class="lui_zone_search_cdt" id="searchTagsDiv">
                                <li class="title">${lfn:message('sys-zone:sysZonePerson.hasSelected') }</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <!--已选条件 Ends-->
                <!--人员内容 Starts-->
             <list:listview>
				<ui:source type="AjaxJson">
					{"url":"/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=searchPerson&tagNames="+ encodeURI(encodeURI('${tagNames}'))+"&searchValue="+ encodeURI(encodeURI('${searchValue}'))}
				</ui:source>
			  <list:gridTable name="gridtable" columnNum="1" >
				<list:row-template >
					<c:import url="/sys/zone/sys_zone_personInfo/sysZonePersonInfo_grid_content.jsp" charEncoding="UTF-8"></c:import>
				</list:row-template>
				
			</list:gridTable> 
				<ui:event  event="load" args="data">
						seajs.use('sys/fans/sys_fans_main/style/listView.css');
						
						var personIds = [];
						$("[data-fans-sign='sys_fans']").each(function() {
							var $this = $(this), personId = $this.attr("data-action-id");
							personIds.push(personId);
						});
						
						seajs.use(['sys/fans/resource/sys_fans'], function(follow) {
							follow.changeFansStatus(personIds,".fans_follow_btn");
							follow.bindButton(".lui_zone_btn_p")
						});
						
						//seajs.use(['sys/zone/resource/zone_follow'], function(follow){
						//	follow.bindButton(".lui_zone_btn_p")
						//});
						var datas = [];
						$("[data-person-role='contact']").each(function() {
							var $this = $(this), personParam = $this.attr("data-person-param");
							datas.push({
								elementId : $this.attr("id"),
								personId: Com_GetUrlParameter(personParam, "fdId"),
								personName:Com_GetUrlParameter(personParam, "fdName"),
								loginName :Com_GetUrlParameter(personParam, "fdLoginName"),
								email:Com_GetUrlParameter(personParam, "fdEmail"),
								mobileNo:Com_GetUrlParameter(personParam, "fdMobileNo"),
								isSelf : ("${KMSS_Parameter_CurrentUserId}" == Com_GetUrlParameter(personParam, "fdId"))
							});
						});
						onRender(datas);
						
						
				</ui:event>
			</list:listview>
			<list:paging></list:paging>
                <!--人员内容 Ends-->
            </div>
            <!--人员查找搜索内容 Ends-->
        </div>
        <!--左侧区域 Ends-->
        <!--右侧区域 Starts-->
        <div class="lui_zone_mbody_r">
            <!--人员标签查找 Starts-->
            <div class="lui_zone_tag_search" id="staffYpage_tagSearch">
          	  <h2><span>${lfn:message('sys-zone:sysZonePerson.personTagSelect') }</span></h2>
          	   <list:listview>
				<ui:source type="AjaxJson">
					{"url":"/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=getTags&searchValue="+ encodeURI('${searchValue}')}
				</ui:source>
			  <list:gridTable name="gridtable" columnNum="1"  cfg-norecodeLayout="none">
				<list:row-template >
				{$
					 <dl>
				          	   {%grid['categoryName']%}
				          	    {%grid['tags']%}
				     </dl>
				$}
				</list:row-template>
			</list:gridTable> 
			</list:listview>
            </div>
            <!--人员标签查找 Ends-->
        </div>
        <!--右侧区域 Ends-->
    </div>
    <%@ include file="/sys/zone/sys_zone_personInfo/sysZonePersonContact_include.jsp"%>
   
    <!--主体区域 Ends-->
	<%@ include file="/sys/zone/zoneSearch_js.jsp" %> 
</template:replace>
</template:include>