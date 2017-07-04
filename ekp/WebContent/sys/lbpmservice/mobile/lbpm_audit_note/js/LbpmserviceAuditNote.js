define([ "dojo/_base/declare", "dijit/_WidgetBase", "mui/util",
		"dijit/_Contained", "dijit/_Container", "dojo/html",
		"dojo/dom-construct", "dojo/query", "dojo/request" ], function(declare,
		widgetBase, util, Contained, Container, html, domConstruct, query,
		request) {

	return declare('sys.lbpmservice.audit.note', [ widgetBase, Contained,
			Container ], {

		url : '/sys/lbpmservice/mobile/lbpm_audit_note/index.jsp',
		fdModelId : '',
		fdModelName : '',
		formBeanName : '',
		lazy : false,

		rscriptType : /^$|\/(?:java|ecma)script/i,

		buildRendering : function() {
			this.domNode = this.containerNode = this.srcNodeRef;
			this.inherited(arguments);
		},

		getText : function(callBack) {
			var self = this;
			var formData = {};
			formData['fdModelId'] = this.fdModelId;
			formData['fdModelName'] = this.fdModelName;
			formData['formBeanName'] = this.formBeanName;
			var promise = request.post(util.formatUrl(this.url), {
				data : formData,
				sync : true
			}).response.then(function(data) {
				if (data.status == 200) {
					var text = data.data;
					callBack.call(self, text);
				}
			});
		},

		reload : function() {
			this.doLoad();
		},

		doLoad : function() {
			if (this.loaded)
				return;
			var self = this;
			var dhs = new html._ContentSetter({
				parseContent : true,
				onEnd : function() {
					var scripts = query('script', this.node);
					scripts.forEach(function(node, index) {
						if (self.rscriptType.test(node.type || "")) {
							if (node.src) {

							} else {
								window["eval"].call(window,
										(node.text || node.textContent
												|| node.innerHTML || ""));
							}
						}
					});
					this.inherited("onEnd", arguments);
				}
			});
			this.container = domConstruct.create('div', {
				className : 'muiLbpmserviceAuditContainer'
			}, this.domNode, 'last');
			dhs.node = this.container;
			this.getText(function(text) {
				dhs.set(text);
			});
			dhs.tearDown();
			this.loaded = true;
		},

		startup : function() {
			this.inherited(arguments);
			if (!this.lazy)
				this.doLoad();
		}
	})
});