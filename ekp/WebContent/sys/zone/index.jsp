<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include  file="/sys/zone/zoneSearchTemplate.jsp">
  <template:replace name="title">
           ${lfn:message('sys-zone:sysZonePerson.zoneIndex') }
  </template:replace>
  <template:replace name="content">
   <!--主体区域 Starts-->
    <div class="lui_zone_mbody">
        <!--员工头像墙 Starts-->
        <div style="max-width:980px;">
       		<c:import url="/sys/zone/sys_zone_photo_main/import/sysZonePhotoMain_index.jsp" 
       			charEncoding="UTF-8">
       		</c:import>
       	</div>
        <!--员工头像墙 Ends-->
        <!--搜索栏 Starts-->
           <html:form action="/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do">
        <div class="lui_zone_searchwrap">
            <div class="lui_zone_searchtitle"></div>
            <div class="lui_zone_searchbox">
                <div class="inputbar_l">
                    <div class="inputbar_r">
                        <div class="inputbar_c">
                        <input  id="searchValue" name="searchValue" type="text" value="<bean:message bundle="sys-zone" key="sysZonePerson.searchInputHelp"/>"/>
                        <input  id="fdTags" name="fdTags" type="hidden" value=""/>
                        </div>
                    </div>
                </div>
                <a class="lui_zone_btn_search_l"  href="javascript:zoneSearch();">
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
            <!--推荐专家 Starts-->
            <div class="lui_zone_expert_list">
                <div class="head">
                    <h3>
                        <span>最新员工</span>
                    </h3>
                </div>
				<list:listview channel="new">
					<ui:source type="AjaxJson">
						{"url":"/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=newOrgPerson&searchValue=''"}
					</ui:source>
				  <list:gridTable name="gridtable" columnNum="3" >
					<list:row-template >
						<c:import url="/sys/zone/sys_zone_personInfo/sysZoneNewPersonInfo_grid_content.jsp" charEncoding="UTF-8"></c:import>
					</list:row-template>
				  </list:gridTable> 
			   </list:listview>
		       <list:paging channel="new"></list:paging>
            </div>
            <!--推荐专家 Ends-->
        </div>
        <!--左侧区域 Ends-->
        <!--右侧区域 Starts-->
        <div class="lui_zone_mbody_r">
            <!--人员标签查找 Starts-->
            <div class="lui_zone_tag_search" id="staffYpage_tagSearch">
          	  <h2><span>${lfn:message('sys-zone:sysZonePerson.personTagSelect') }</span></h2>
          	   <list:listview >
				<ui:source type="AjaxJson">
					{"url":"/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=getTags&searchValue="+ encodeURI('${searchValue}')}
				</ui:source>
			  <list:gridTable name="gridtable" columnNum="1" cfg-norecodeLayout="none">
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
    <!--主体区域 Ends-->
	<%@ include file="/sys/zone/zone_index_js.jsp" %> 
   </template:replace>
</template:include>