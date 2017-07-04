define(["dojo/_base/declare",
        "dojo/dom-style",
        "dojo/dom-class",
        "dojo/dom-construct",
        "dojo/topic",
        "mui/tabbar/TabBarButtonGroup"],
		function(declare,domStyle,domClass,domConstruct,topic,TabBarButtonGroup){
	
	return declare("km.imeeting.mobile.resource.js._TabBarButtonGroupMixin", [TabBarButtonGroup], {
		
		criteriaType:'',//当前选中节点
		criteriaText:'全部',
		
		buildRendering:function(){
			this.inherited(arguments);
			//当前选中节点设置
			this.subscribe('/km/imeeting/onFeedbackCriteria',function(widget){
				this.criteriaType=widget.criteriaType;
				this.criteriaText=widget.criteriaText;
			});
			//数据请求结束后显示label
			this.subscribe('/mui/list/loaded', function(widget){
				if(!this.countLabel){
					this.countLabel=domConstruct.create('span',{className:'' },this.domNode,'before');
				}
				this.countLabel.innerHTML=this.criteriaText+'（'+ widget.totalSize +'）';
				topic.publish('/km/imeeting/feedbackCriteriaSelect',this.criteriaType);
			});
		},
		
		startup :function(){
			this.inherited(arguments);
			domClass.add(this.domNode,'muiMeetingFeedbackCriteria');//筛选按钮
			domClass.add(this.openerContainer.domNode,'muiMeetingFeedbackOpener');//弹出框
		},
		
		//重写打开opener
		_onClick:function(evt){
			var opener = this.openerContainer;
			if (opener.resize)
				this.hideOpener(this);
			else
				opener.show(this.iconDivNode?this.iconDivNode:this.domNode, ['below']);
			this.defaultClickAction(evt);
			this.handle = this.connect(document.body, 'touchend', 'unClick');
		}
		
	});
	
	
	
});