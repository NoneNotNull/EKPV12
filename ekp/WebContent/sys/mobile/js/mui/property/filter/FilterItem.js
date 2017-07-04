define([ "dojo/_base/declare", "dijit/_WidgetBase", "dojo/dom-construct",
		"dojo/topic", "dojo/dom-class" ], function(declare, _WidgetBase,
		domConstruct, topic, domClass) {
	var claz = declare("mui.property.FilterItem", [ _WidgetBase ], {

		name : null,
		value : null,

		isSelected : false,

		baseClass : 'muiPropertyFilterItem',

		selectedClass : 'muiPropertyFilterSelected',

		SELECTED_EVENT : '/mui/property/filter/selected',

		buildRendering : function() {
			this.inherited(arguments);
			this.buildItem();
		},

		startup : function() {
			this.inherited(arguments);
		},

		buildItem : function() {
			var value = this.value, name = this.name;
			this.itemNode = domConstruct.create('div', {
				className : 'muiPropertyFilterText',
				innerHTML : '<span><div>' + name + '</div></span>'
			}, this.domNode);
			this.connect(this.domNode, 'click', '_onSelect');
		},

		unSelected : function() {
			domClass.remove(this.domNode, this.selectedClass);
			topic.publish('/mui/property/filter/item/remove', this, {
				value : this.value,
				name : this.name,
				parent : this.getParent()
			});
			this.isSelected = false;
		},

		selected : function() {
			topic.publish(this.SELECTED_EVENT, this, {
				value : this.value,
				name : this.name,
				parent : this.getParent()
			});
			domClass.add(this.domNode, this.selectedClass);
			topic.publish('/mui/property/filter/item/add', this, {
				value : this.value,
				name : this.name,
				parent : this.getParent()
			});
			this.isSelected = true;
		},

		_onSelect : function(evt) {
			if (this.isSelected)
				this.unSelected();
			else
				this.selected();

		}
	});
	return claz;
});