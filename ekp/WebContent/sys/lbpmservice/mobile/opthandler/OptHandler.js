define([ 
	"dojo/_base/declare", 
	"dojo/_base/array", 
	"dojo/topic", 
	"dojo/dom-construct", 
	"mui/form/Address",
	"mui/util"
	], function(declare, array, topic, domConstruct, Address, util) {
	
	return declare("sys.lbpmservice.mobile.opthandler.OptHandler", [Address], {
		type: ORG_TYPE_POSTORPERSON,
		
		text: "备选列表",
		
		isMul: true , 
		
		templURL:  dojoConfig.baseUrl + "sys/lbpmservice/mobile/opthandler/opthandler.jsp",
		
		_cateDialogPrefix: "__opthandler__",
		
		optHandlerIds: null,
		
		optHandlerSelectType: null,
		
		fdModelName: null,
		
		fdModelId: null,
		
		dataUrl: '/sys/lbpmservice/mobile/opthanlder.do?method=handlers&optHandlerIds=!{optHandlerIds}&optHandlerSelectType=!{optHandlerSelectType}&fdModelName=!{fdModelName}&fdModelId=!{fdModelId}',
		
		startup : function() {
			this.inherited(arguments);
			this.dataUrl = encodeURI(util.urlResolver(this.dataUrl, this));
			this.templURL =  dojoConfig.baseUrl + "sys/lbpmservice/mobile/opthandler/opthandler.jsp";
		},
		
		buildOptIcon:function(optContainer){
			domConstruct.create("i" ,{className:'mui mui-backupList'},optContainer);
		}
	});
});