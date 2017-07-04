define( [ 'dojo/_base/declare', 'dojo/_base/lang', 'dojo/topic',
		'dojo/_base/array', "dojo/query", 'dojox/mobile/View', 'dojo/request',
		"mui/util", 'dojox/mobile/viewRegistry', 'dojo/dom-construct',
		"dojo/dom-style", "dojo/dom-class", 'dojo/dom-attr'], 
		function(declare, lang, topic, array,
		query, View, request, util, viewRegistry, domConstruct, domStyle,
		domClass, domAttr) {

	return declare('sys.zone.mobile.js.BaseInfoView', [ View ],
			{
				refNavBar : null,

				userId : "",
				
				postCreate : function() {
					this.subscribe("/mui/list/onPush", "handleOnPush");
				},
				
				buildRendering : function() {
					this.inherited(arguments);
					domClass.add(this.domNode, "mui_zone_baseinfo");
					domStyle.set(this.domNode, "display" , "none");
				},
				
				
				handleOnPush : function(obj,handle) {
					if(handle.done)
						handle.done(this);
				}
			});
});