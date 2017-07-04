define( [ "dojo/_base/declare", "mui/header/HeaderItem", "mui/folder/_Folder",
		"mui/search/SearchBarDialogMixin" ], function(declare, HeaderItem, Folder,
		SearchBarDialogMixin) {

	return declare("mui.search.SearchButtonBar",
			[ HeaderItem, Folder, SearchBarDialogMixin ], {

				icon : "mui mui-search",

				baseClass : "muiSearchButton"

			});
});
