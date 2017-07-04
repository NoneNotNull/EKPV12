define("mui/nav/MobileCfgNavBar", ['dojo/_base/declare', 
                "./NavBarStore",
                "mui/util"], function(declare, NavBarStore, util) {
	
		return declare('mui.nav.MobileCfgNavBar', [NavBarStore], {

			url : "/sys/mobile/sys_mobile_module_category_config/sysMobileModuleCategoryConfig.do?method=data&fdModelName=!{modelName}",

			modelName: null,

			startup : function() {
				if (this._started)
					return;
				if (this.modelName) {
					this.url = util.urlResolver(this.url, {modelName: this.modelName});
				}
				this.inherited(arguments);
			}
		});
});