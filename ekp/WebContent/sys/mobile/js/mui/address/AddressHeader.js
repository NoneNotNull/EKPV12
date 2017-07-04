define( [ "dojo/_base/declare", "mui/category/CategoryHeader"], function(declare,CategoryHeader) {
		var header = declare("mui.address.AddressHeader", [ CategoryHeader], {
				//获取详细信息地址
				detailUrl : '/sys/organization/mobile/address.do?method=detailList&orgIds=!{curId}'
			});
			return header;
});