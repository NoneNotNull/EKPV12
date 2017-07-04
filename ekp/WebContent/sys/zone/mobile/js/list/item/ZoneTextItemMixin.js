define(	["dojo/_base/declare", "dojo/dom-construct", 
				"dojo/dom-style", "dojo/dom-attr", 
					"mui/util", "mui/list/item/TextItemMixin"],
		function(declare, domConstruct, domStyle, domAttr,
				 util,TextItemMixin) {
			var item = declare("sys.zone.ZoneTextItemMixin", [TextItemMixin], {

						buildInternalRender : function() {

							this.titleNode = domConstruct.create('a', null,
									this.contentNode);
							
							if (this.label) {
								this.labelNode = domConstruct.create('span', {
											'innerHTML' : this.label,
											'className' : 'muiSubject'
										}, this.titleNode);
							}

							if (this.href) {
								this.makeLinkNode(this.titleNode);
							}

							this.otherNode = domConstruct.create('p', {
										className : 'muiListInfo'
									}, this.contentNode);

							if (this.creator) {
								this.creatorNode = domConstruct.create('div',
										{
											'innerHTML' : this.creator,
											'className' : 'muiAuthor muiTextCreator'
										}, this.otherNode);
							}

							if (this.created) {
								this.createdNode = domConstruct.create('div',
										{
											'innerHTML' : '<i class="mui mui-todo_date"></i>' + this.created,
											'className' : 'muiTextCreated'
										}, this.otherNode);
							}

						}
					});
			return item;
		});