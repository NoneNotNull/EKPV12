<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.organization.model.SysOrgPerson"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

	<div data-dojo-type="mui/category/CategoryHeader"
		data-dojo-props="curName:'备选人',key:'{categroy.key}',height:'3.8rem'"></div>
	<div id='_opthandler_view_{categroy.key}'
		data-dojo-type="dojox/mobile/ScrollableView"
		data-dojo-mixins="mui/category/_ViewScrollResizeMixin"
		data-dojo-props="scrollBar:false,threshold:100,key:'{categroy.key}'">
		<ul data-dojo-type="mui/address/AddressList"
			data-dojo-mixins="mui/address/AddressItemListMixin"
			data-dojo-props="isMul:{categroy.isMul},key:'{categroy.key}',curIds:'{categroy.curIds}',curNames:'{categroy.curNames}',selType:{categroy.type},dataUrl:'{categroy.dataUrl}'">
		</ul>
	</div>
	<div data-dojo-type="mui/address/AddressSelection" 
		data-dojo-props="key:'{categroy.key}' , curIds:'{categroy.curIds}',curNames:'{categroy.curNames}'" fixed="bottom">
	</div>
	<div data-dojo-type="mui/category/CategoryScrollNav" 
		data-dojo-props="key:'{categroy.key}',refrenceDom:'_opthandler_view_{categroy.key}'">
	</div>
