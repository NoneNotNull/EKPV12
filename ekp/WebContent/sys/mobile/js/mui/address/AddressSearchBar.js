define([ "dojo/_base/declare","mui/search/SearchBar"],
		function(declare, SearchBar) {

			return declare("mui.address.AddressSearchBar",
					[ SearchBar ],{
						
						//搜索请求地址
						searchUrl : "/sys/organization/mobile/address.do?method=searchList&keyword=!{keyword}&orgType=!{orgType}",
						
						//搜索结果直接挑转至searchURL界面
						jumpToSearchUrl:false,
						
						//搜索关键字
						keyword : "",
						
						//提示文字
						placeHolder : '搜索',

						//是否需要输入提醒
						needPrompt:false,
						
						orgType:null
		});
});
