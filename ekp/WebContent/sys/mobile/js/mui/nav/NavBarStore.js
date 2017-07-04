define("mui/nav/NavBarStore", [
                "./NavBar", 
                "dojo/_base/declare",
				"./_StoreNavBarMixin"
                ], function(NavBar, declare,
				StoreNavBarMixin) {
	return declare('mui.nav.NavBarStore', [NavBar, StoreNavBarMixin], {
		height:'3.8rem'
	});
});