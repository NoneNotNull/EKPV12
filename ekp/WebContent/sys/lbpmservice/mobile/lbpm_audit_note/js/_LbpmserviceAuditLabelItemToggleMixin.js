define([ "dojo/_base/declare", "dojo/dom-construct", "dojo/dom-style",
		"dijit/_WidgetBase", "mui/util", "dojo/query", "dojo/_base/lang",
		"dojo/topic", "dojo/dom-class" ], function(declare, domConstruct,
		domStyle, widgetBase, util, query, lang, topic, domClass) {

	return declare(
			'sys.lbpmservice.audit.note._LbpmserviceAuditLabelItemToggleMixin',
			null, {

				toggle : false,

				_toggleClass : 'hide',

				methodPrex : 'show',

				startup : function() {
					this.inherited(arguments);
					if (this.toggle) {
						domConstruct.create('i', null, this.titleNode);
						this.connect(this.domNode, "onclick", '_onClick');
						this.subscribe('/mui/lbpmservice/label_toggle', lang
								.hitch(this.label_toggle));
					}
				},

				_onClick : function(e) {
					this._label_toggle();
				},

				_label_toggle : function(type) {
					var methodPrex = type ? type : this.getMehtodPrex();
					topic.publish('/mui/lbpmservice/label_toggle', this, {
						fdExecutionId : this.fdExecutionId,
						methodPrex : methodPrex
					});
					this.set('methodPrex', methodPrex);
				},

				label_toggle : function(obj, evt) {
					if (obj != this)
						return;
					var toggle = this.getMehtodPrex() == 'hide' ? true : false;
					domClass.toggle(this.titleNode, this._toggleClass, toggle);
				},

				getMehtodPrex : function() {
					return this.methodPrex == 'show' ? 'hide' : 'show';
				}

			})
});