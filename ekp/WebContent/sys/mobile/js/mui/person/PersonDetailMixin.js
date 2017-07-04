/**提供默认详细人员列表 **/
define([
    "dojo/_base/declare", 
    "dojo/_base/array",
    "dojo/text!./person_detail.html",
    'dojo/dom-construct',
    "dojox/mobile/TransitionEvent",
    'dojo/parser',
    'dojo/_base/lang',
    'dojo/query'
    ],function(declare,array,detailTemplate,domConstruct,TransitionEvent,parser,lang,query){
	
	return declare("mui.person.PersonDetailMixin", null, {
		
		//详细页面属性
		detailTitle:'',
		detailUrl:'',
		detailTemplateString:detailTemplate,
		detailView:null,
		
		defaultDetailUrl:'/sys/organization/mobile/address.do?method=personDetailList',
		
		buildRendering : function(){
			this.inherited(arguments);
			if(this.personId && !this.detailUrl){
				this.detailUrl=this.defaultDetailUrl+'&personId='+this.personId;
			}
		},
		
		openDeatailView : function(){
			//未初始化,先创建一个默认的详细列表
			if(!this.detailView){
				var self=this;
				this.detailTemplateString = lang.replace(this.detailTemplateString,{
					title:this.detailTitle,
					url:this.detailUrl
				});
				
				parser.parse(domConstruct.create('div',{ innerHTML:this.detailTemplateString },query('#content')[0] ,'last'))
					.then(function(widgetList) {
					
						array.forEach(widgetList, function(widget, index) {
							if(index == 0){
								self.initWidget(widget);
								self.detailView=widget;
							}
						});
						var opts = {
							transition : 'slide',
							moveTo:self.detailView.id
						};
						new TransitionEvent(self.personMoreNode || document.body ,  opts ).dispatch();
				});
			}else{
				var opts = {
					transition : 'slide',
					moveTo:this.detailView.id
				};
				new TransitionEvent(this.personMoreNode || document.body ,  opts ).dispatch();
			}
		},
		
		initWidget : function(widget){
			widget.hide();//隐藏
			widget.placeAt(widget.domNode.parentNode,'after');//移除不必要的父节点,保证view的节点与其他view在同一层
			//绑定返回事件
			this.backView=widget.getShowingView();
			this.connect(query('.personHeaderReturn',widget.domNode)[0],'click','backOpt');
		},
		
		backOpt : function(){
			var opts = {
				transition : 'slide',
				moveTo:this.backView.id,
				transitionDir:-1
			};
			new TransitionEvent(document.body,  opts ).dispatch();
		}
		
	});
	
});