define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/query",
    "dojo/_base/array",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/dom-style",
	], function(declare, lang, query, array, domClass, domConstruct, domStyle) {
	
	return declare("sys.lbpmservice.mobile.GroupButtonMixin", null, {
		
		buildOptIcon: function(optContainer) {
			var parent = optContainer;
			// 创建icon容器
			var iconArea = domConstruct.create("div" , {className:'mblIconAreaInner'}, parent);
			arguments[0] = iconArea;
			this.inherited(arguments);
			domStyle.set(iconArea, {margin: '0 auto'});

			// 创建label容器
			var labelNode = domConstruct.create("span" ,{className:'mblIconAreaTitle'}, parent);
			labelNode.innerHTML = this.text ? this.text : "地址簿";
			domStyle.set(labelNode, {fontSize: '1.2rem'});
			domStyle.set(parent, {textAlign: 'center'});
		},
		
		postCreate: function() {
			this.inherited(arguments);
			domStyle.set(this.domNode, {height: '60px', width: '60px'});
		}
	});
});