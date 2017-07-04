
define([
        "dojo/_base/declare",
        "dojo/dom-class",
        "dojo/on",
      	"mui/util",
      	"dojo/_base/window",
	], function(declare, domClass, on, util, win) {
	
	return declare("mui.list.item._ListLinkItemMixin", null, {
		
		hrefTarget: '_self',
		_selClass: "mblListItemSelected",
		_delayedSelection: true,
		_selStartMethod: "touch",
		
		handleSelection: function(/*Event*/e){
			this.set("selected", true);
		},
		
		makeLinkNode: function(linkNode) {
			linkNode.href = this.makeUrl();
			linkNode.target = "_self";
			on(linkNode, 'click', function(event) {
				event.preventDefault();
				return false;
			});
		},
		
		makeUrl: function() {
			var url = util.formatUrl(this.href);
			if (url.indexOf('?') > -1) {
				url += '&_mobile=1';
			} else {
				url += '?_mobile=1';
			}
			return url;
		},
		
		makeTransition: function(e) {
			var url = this.makeUrl();
			this.defer(function(){
				this.set("selected", false);
			}, 100);
			win.global.open(url, this.hrefTarget || "_self");
		},

		_onClick: function(e){
			this.defaultClickAction(e);
		},
		
		_setSelectedAttr: function(selected){
			this.inherited(arguments);
			domClass.toggle(this.domNode, this._selClass, selected);
		}
	});
});