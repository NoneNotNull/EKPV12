define([ "dojo/_base/declare", "mui/property/filter/FilterBase",
		"dojo/dom-construct", "dojo/_base/array", "dojo/topic",
		"dojo/dom-style" ], function(declare, FilterBase, domConstruct, array,
		topic, domStyle) {
	var claz = declare("mui.property.FilterRadio", [ FilterBase ], {

		SELECTED_EVENT : '/mui/property/filter/selected',

		buildRendering : function() {
			this.inherited(arguments);
			this.subscribe(this.SELECTED_EVENT, 'selectChange');
			this.subscribe('/mui/property/filter/item/add', 'addValue');
			this.subscribe('/mui/property/filter/item/remove', 'removeValue');
		},

		addValue : function(obj, evt) {
			if (!evt)
				return;
			if (evt.parent != this)
				return;
			var val = evt.value;
			if (this.values.indexOf(val) < 0)
				this.values.push(val);
			this.setValue();
		},

		removeValue : function(obj, evt) {
			if (!evt)
				return;
			if (evt.parent != this)
				return;
			var val = evt.value;
			var index = this.values.indexOf(val);
			if (index >= 0)
				this.values.splice(index, 1);
			this.setValue();
		},

		startup : function() {
			this.inherited(arguments);
			var children = this.getChildren();
			var maxHeight = 0;
			array.forEach(children, function(item, index) {
				domConstruct.place(item.domNode, this.contentNode);
				if (item.domNode.offsetHeight > maxHeight)
					maxHeight = item.domNode.offsetHeight;
			}, this);

			array.forEach(children, function(item) {
				domStyle.set(item.domNode, {
					'line-height' : maxHeight + 'px',
					'height' : maxHeight + 'px'
				});
			}, this);
		},

		selectChange : function(obj, evt) {
			var children = this.getChildren();
			array.forEach(children, function(item) {
				if (obj != item && evt.parent == this)
					item.unSelected();
			}, this);
		}

	});
	return claz;
});