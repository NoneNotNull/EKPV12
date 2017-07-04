<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.organization.model.SysOrgPerson"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	SysOrgPerson user = UserUtil.getUser(request);
	if(user.getFdParent()!=null){
		pageContext.setAttribute("parent",user.getFdParent());
	}
%>
	<div data-dojo-type="mui/address/AddressHeader"
		data-dojo-props="curId:'${parent.fdId}',curName:'${parent.fdName}',key:'{categroy.key}',height:'3.8rem'"></div>
	<div data-dojo-type="mui/category/CategoryNavInfo" data-dojo-props="key:'{categroy.key}'"></div>
	<div id='_address_sgl_view_{categroy.key}'
		data-dojo-type="dojox/mobile/ScrollableView"
		data-dojo-mixins="mui/category/_ViewScrollResizeMixin"
		data-dojo-props="scrollBar:false,threshold:100,key:'{categroy.key}'">
		<div id='_address_sgl_search_{categroy.key}'
			data-dojo-type="mui/address/AddressSearchBar" 
			data-dojo-props="orgType:{categroy.type},key:'{categroy.key}',height:'3.8rem'">
		</div>
		<ul data-dojo-type="mui/address/AddressList"
			data-dojo-mixins="mui/address/AddressItemListMixin"
			data-dojo-props="isMul:{categroy.isMul},key:'{categroy.key}',curIds:'{categroy.curIds}',curNames:'{categroy.curNames}',selType:{categroy.type}">
		</ul>
	</div>
	<div data-dojo-type="mui/category/CategoryScrollNav" 
		data-dojo-props="refrenceDom:'_address_sgl_view_{categroy.key}',key:'{categroy.key}',absoluteDom:'_address_sgl_search_{categroy.key}'">
	</div>
