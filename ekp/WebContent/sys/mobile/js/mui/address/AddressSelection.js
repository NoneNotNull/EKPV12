define([ "dojo/_base/declare", "mui/iconUtils",
				"mui/category/CategorySelection" , "mui/util"],
		function(declare, iconUtils, CategorySelection, util) {
			var selection = declare("mui.address.AddressSelection",[ CategorySelection ],{

				//获取详细信息地址
				detailUrl : '/sys/organization/mobile/address.do?method=detailList&orgIds=!{curIds}',

				buildIcon : function(iconNode, item) {
					
					if (item.icon) {
						iconUtils.setIcon(util.formatUrl(item.icon), null, null, null,
								iconNode);
					} else {
						if ((item.type | window.ORG_TYPE_ORGORDEPT) == window.ORG_TYPE_ORGORDEPT) {
							item.icon = "mui mui-group muiAddressDept";
						}
						if ((item.type | window.ORG_TYPE_POST) == window.ORG_TYPE_POST) {
							item.icon = "mui mui-post muiAddressPost";
						}
						iconUtils.setIcon(item.icon, null, null, null,
								iconNode);
					}
				}
			});
			return selection;
		});