define( [ "dojo/_base/declare","mui/category/CategoryList" ], function(declare,
		CategoryList) {
	return declare("mui.address.AddressList", [ CategoryList ], {
		//数据请求URL
		dataUrl : '/sys/organization/mobile/address.do?method=addressList&parentId=!{parentId}&orgType=!{selType}'
			
	});
});