define( [ "dojo/_base/declare", "mui/address/AddressHeader",
          "dojo/dom-geometry", "dojo/dom-style"], 
			function(declare, AddressHeader, domGeometry,domStyle) {
		var header = declare("sys.zone.mobile.js.address.AddressZoneHeader", [AddressHeader], {
			buildRendering : function() {
				this.inherited(arguments);
				this.cancelNode.innerHTML = "";
			},
			
			startup: function() {
				this.inherited(arguments);
				var h = domGeometry.position(this.titleDom).h;
				domStyle.set(this.contentNode , "height" , h + "px");
			}
		});
		return header;
});