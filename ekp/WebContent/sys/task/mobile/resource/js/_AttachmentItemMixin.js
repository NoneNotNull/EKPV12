define([ "dojo/_base/declare","dojo/request","dojo/html","dojo/query","dojo/dom-construct","mui/util"],
		function(declare,request,html,query,domConstruct,util){
	
	return declare("sys.task.mobile.resource.js._AttachmentItemMixin", null, {
		
		attUrl : '/sys/task/sys_task_feedback/sysTaskFeedback.do?method=loadAttachmentInfo',//没有默认的,暂时用任务的代替
		
		rscriptType : /^$|\/(?:java|ecma)script/i,
		
		//创建附件区域
		createAtt : function(container,args) {
			if(!args.fdModelId && !this.fdModelId )
				return;
			this.fdModelId=args.fdModelId || this.fdModelId;
			if(!args.fdModelName && !this.fdModelName )
				return;
			this.fdModelName=args.fdModelName || this.fdModelName;
			if(!args.formBeanName && !this.formBeanName)
				return;
			this.formBeanName=args.formBeanName || this.formBeanName;
			var self=this;
			var dhs = new html._ContentSetter({
				parseContent : true,
				onEnd : function() {
					var scripts = query('script', this.node);
					scripts.forEach(function(node, index) {
						//只处理javascript
						if (self.rscriptType.test(node.type || "")) {
							if (node.src) {
								//src方式引入的暂时没解决方案
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
			this.attContent=domConstruct.create('div',{className:'listAttachmentContent'},container,'last');
			dhs.node = this.attContent;
			this.getText(function(text) {
				dhs.set(text);
			});
			dhs.tearDown();
		},
	
		getText : function(callBack) {
			var self = this;
			var formData = {};
			formData['fdModelId'] = this.fdModelId;
			formData['fdModelName'] = this.fdModelName;
			formData['formBeanName'] = this.formBeanName;
			var promise = request.post(util.formatUrl(this.attUrl), {
				data : formData,
				sync : true
			}).response.then(function(data) {
				if (data.status == 200) {
					var text = data.data;
					callBack.call(self, text);
				}
			});
		}
		
	});
	
	
	
});