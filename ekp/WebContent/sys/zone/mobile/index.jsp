<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.organization.model.SysOrgPerson"%>
<%@ page import="com.landray.kmss.sys.zone.util.SysZoneConfigUtil"%>
<%@ page language="java"  import="com.landray.kmss.util.StringUtil" %>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/mobile/mui.tld" prefix="mui"%>
<template:include ref="mobile.list">
	<template:replace name="title">
		通讯录
	</template:replace>
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" 
			href="<%=request.getContextPath()%>/sys/zone/mobile/resource/list.css"></link>
		<mui:min-file name="mui-zone.js"/>
		<mui:min-file name="mui-zone-list.css"/>
	</template:replace>
	<template:replace name="content">
		<%
			SysOrgPerson user = UserUtil.getUser(request);
			if(user.getFdParent()!=null){
				pageContext.setAttribute("parent",user.getFdParent());
			}
		%>
	<script>
	var ORG_TYPE_ORG = 0x1; // 机构
	var ORG_TYPE_DEPT = 0x2; // 部门
	var ORG_TYPE_POST = 0x4; // 岗位
	var ORG_TYPE_PERSON = 0x8; // 个人
	var ORG_TYPE_GROUP = 0x10; // 群组
	var ORG_TYPE_ROLE = 0x20;
	var ORG_TYPE_ORGORDEPT = ORG_TYPE_ORG | ORG_TYPE_DEPT; // 机构或部门
	var ORG_TYPE_POSTORPERSON = ORG_TYPE_POST | ORG_TYPE_PERSON; // 岗位或个人
	var ORG_TYPE_ALLORG = ORG_TYPE_ORGORDEPT | ORG_TYPE_POSTORPERSON; // 所有组织架构类型
	var ORG_TYPE_ALL = ORG_TYPE_ALLORG | ORG_TYPE_GROUP; // 所有组织架构类型+群组
	var ORG_FLAG_AVAILABLEYES = 0x100; // 有效标记
	var ORG_FLAG_AVAILABLENO = 0x200; // 无效标记
	var ORG_FLAG_AVAILABLEALL = ORG_FLAG_AVAILABLEYES | ORG_FLAG_AVAILABLENO; // 包含有效和无效标记
	var ORG_FLAG_BUSINESSYES = 0x400; // 业务标记
	var ORG_FLAG_BUSINESSNO = 0x800; // 非业务标记
	var ORG_FLAG_BUSINESSALL = ORG_FLAG_BUSINESSYES | ORG_FLAG_BUSINESSNO; // 包含业务和非业务标记

	var currrtPersonId = "${KMSS_Parameter_CurrentUserId}";
	</script>
	
	
	<%
		JSONArray commmunicateList = SysZoneConfigUtil.getCommnicateList();
		JSONArray extendContact = new JSONArray();
	     for(Object map: commmunicateList) { 
	    	 JSONObject json = (JSONObject)map;
	    	 if(!"communicate_mobile".equals(json.get("showType"))) {
     	           	continue;
     	      }
	    	 JSONObject _json = new JSONObject();
	    	 _json.put("id" , json.get("unid"));
	    	 _json.put("icon" ,json.get("icon"));
	    	 _json.put("order" ,json.get("order"));
	    	 _json.put("text", json.get("text"));
	    	 String href = json.getString("href");
	    	 String path = "";
    		 String key = (String)json.get("server"); 
    		 String localKey = SysZoneConfigUtil.getCurrentServerGroupKey();
    		 if(StringUtil.isNotNull(key) && !key.equals(localKey)) { 
           		path = SysZoneConfigUtil.getServerUrl(key);
           	 } else {
           		path = request.getContextPath();
           	 }
    		 _json.put("href", path + href);
    		 _json.put("replace","personId");
	    	 extendContact.add(_json);
	     }
	    
	%>
	<script>
		window.extendContact = <%=extendContact%>;
	</script>
	<div data-dojo-type="sys/zone/mobile/js/address/AddressZoneHeader"
		data-dojo-props="curId:'${parent.fdId}',curName:'${parent.fdName}',key:'zoneAdress',height:'3.8rem'"></div>
	<div data-dojo-type="mui/category/CategoryNavInfo" data-dojo-props="key:'zoneAdress'"></div>
	<div id='_address_sgl_view_zoneAdress'
		data-dojo-type="dojox/mobile/ScrollableView"
		data-dojo-mixins="mui/category/_ViewScrollResizeMixin"
		data-dojo-props="scrollBar:false,threshold:100,key:'zoneAdress'">
		<div id='_address_sgl_search_zoneAdress'
			data-dojo-type="mui/address/AddressSearchBar" 
			data-dojo-props="orgType:ORG_TYPE_PERSON,key:'zoneAdress',height:'3.8rem'">
		</div>
		<ul data-dojo-type="mui/address/AddressList"
			data-dojo-mixins="sys/zone/mobile/js/address/AddressZoneItemListMixin
			,sys/zone/mobile/js/_AddressZoneListContactMixin"
			data-dojo-props="key:'zoneAdress',dataUrl:'/sys/zone/mobile/address/sysZoneAddress.do?method=addressList&parentId=!{parentId}&orgType=!{selType}'">
		</ul>
	</div>
	<div data-dojo-type="mui/category/CategoryScrollNav" 
		data-dojo-props="refrenceDom:'_address_sgl_view_zoneAdress',key:'zoneAdress',absoluteDom:'_address_sgl_search_zoneAdress'">
	</div>
	<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
			<li data-dojo-type="mui/back/BackButton" data-dojo-props="align:'left'"></li>
			
			<li data-dojo-type="mui/tabbar/TabBarButtonGroup" 
				data-dojo-props="icon1:'mui mui-more',align:'right'">
				<div data-dojo-type="mui/back/HomeButton"></div>
   			</li>
		</ul>
	</template:replace>
</template:include>

