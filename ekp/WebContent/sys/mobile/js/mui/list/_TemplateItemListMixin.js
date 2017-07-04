define([
	"dojo/_base/declare",
	"mui/list/item/_TemplateItemMixin"
	], function(declare, Item) {
	
	return declare("mui.list._TemplateItemListMixin", null, {
		
		itemRenderer: Item,
		
		itemTemplateString: null,
		
		createListItem: function(/*Object*/item){
			//console.info('createListItem');
			return new this.itemRenderer(this._createItemProperties(item));
		},
		
		_createItemProperties: function(/*Object*/item) {
			//console.info('_createItemProperties', item);
			var props = this.inherited(arguments);
			props['templateString'] = this.itemTemplateString;
			return props;
		}
	});
});