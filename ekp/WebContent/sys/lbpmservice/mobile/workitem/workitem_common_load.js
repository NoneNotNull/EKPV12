
require(["dojo/query", "dojo/_base/array", "dijit/registry", "dojo/store/Memory", "dojo/ready", "dojo/query"], 
		function(query, array, registry, Memory, ready, query) {
	lbpm.globals.loadWorkflowInfo=function(){
		var processorInfoObj = lbpm.globals.getProcessorInfoObj();
		if(processorInfoObj != null){
			var operationItemsRow = query("#operationItemsRow")[0];
			if(operationItemsRow != null){
					var operationItemsSelect = registry.byId("operationItemsSelect");
				  	if(operationItemsSelect != null){
			  			var data = [];
				  		array.forEach(processorInfoObj, function(pObj, i) {
				  			var processInfoShowText = "";
				  			var parentHandlerName= (pObj.parentHandlerName ? pObj.parentHandlerName + "：" : "");
				  			if(pObj.expectedName){
								processInfoShowText=pObj.nodeId +"."+ parentHandlerName + lbpm.nodes[pObj.nodeId].name+"("+pObj.expectedName+")";
							}else{
								processInfoShowText=pObj.nodeId +"."+ parentHandlerName + lbpm.nodes[pObj.nodeId].name;
							}
				  			data.push({text:processInfoShowText, value:i + ''});
				  		});
				  		operationItemsSelect.setStore(new Memory({
							data : data
						}));
				  		operationItemsSelect.on("attrmodified-value", function(evt) {
				  			var index = evt.detail.newValue;
				  			lbpm.globals.operationItemsChanged({selectedIndex: parseInt(index)}, false);
				  		});
				  	}
				  	if(processorInfoObj.length == 1) lbpm.globals.hiddenObject(operationItemsRow, true); else lbpm.globals.hiddenObject(operationItemsRow, false);
			}	
		}
	};
	
	lbpm.globals.loadDefaultParameters=function(){
		var operatorInfo = lbpm.globals.getProcessorInfoObj();
		if(operatorInfo == null){
			lbpm.globals.validateControlItem();
			return;
		}
		lbpm.globals.getCurrentNodeDescription();
		ready(function() {
			var operationItemsSelect = registry.byId("operationItemsSelect");
			if (operationItemsSelect) {
				lbpm.globals.operationItemsChanged({selectedIndex: parseInt(operationItemsSelect.value)},false);
			}
		});
	}
	
	ready(function() {
		if(lbpm.nowProcessorInfoObj==null) return;
		lbpm.globals.loadWorkflowInfo();
		lbpm.globals.loadDefaultParameters();
		setTimeout("lbpm.globals.getThroughNodes()",200);
	});
});