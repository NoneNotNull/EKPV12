define([
    "dojox/mobile/iconUtils",
	"dojo/_base/lang",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/dom-style"
	], function(iconUtils, lang, domClass, domConstruct, domStyle) {
	
	var setIcon = function(
			/*String*/icon, 
			/*String*/iconPos, 
			/*DomNode*/iconNode, 
			/*String?*/alt, 
			/*DomNode*/parent, 
			/*DomNode?*/refNode, 
			/*String?*/pos) {
		if(!parent || !icon && !iconNode){ return null; }
		
		if(icon && icon !== "none" && icon.indexOf('mui-') > -1){
			if(iconNode && iconNode.tagName !== "I"){
				domConstruct.destroy(iconNode);
				iconNode = null;
			}
			iconNode = this.createIcon(icon, null, iconNode, alt, parent, refNode, pos);
			return iconNode;
		}
		this._setIcon.apply(this, arguments);
	};
	
	var createIcon = function(
			/*String*/icon, 
			/*String?*/iconPos, 
			/*DomNode?*/node, 
			/*String?*/title, 
			/*DomNode?*/parent, 
			/*DomNode?*/refNode, 
			/*String?*/pos) {
		if(icon && icon !== "none" && icon.indexOf('mui-') > -1){
			if(!node){
				node = domConstruct.create("I", null, refNode || parent, pos);
			}
			node.title = title;
			domClass.add(node, icon);
			if(iconPos && parent){
				var arr = iconPos.split(/[ ,]/);
				domStyle.set(parent, {
					position: "relative",
					width: arr[2] + "px",
					height: arr[3] + "px"
				});
				domClass.add(parent, "mblSpriteIconParent");
			}
			return node;
		}
		return	this._createIcon.apply(this, arguments);
	};
	
	iconUtils._setIcon = iconUtils.setIcon;
	iconUtils.setIcon = setIcon;
	
	iconUtils._createIcon = iconUtils.createIcon;
	iconUtils.createIcon = createIcon;
	
	return iconUtils;
});