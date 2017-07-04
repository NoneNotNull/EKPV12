define([ "dojo/_base/declare",  "mui/list/JsonStoreList"
    ],function(declare,JsonStoreList){
	
	return declare("mui.person.PersonDetailJsonStoreList", [JsonStoreList], {
		
		formatDatas : function(datas) {
			var dataed = [];
			if(datas.length>0){
				var item=datas[0];
				if(item instanceof Array)
					dataed=this.inherited(arguments);
				else
					dataed=datas;
			}
			return dataed;
		}
		
	});
	
});