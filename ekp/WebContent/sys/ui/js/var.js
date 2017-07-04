(function() {
	if(window.VariableSetting != null)
		return;
	
	window.VariableSetting = function(){
		this.VarSet = [];
	};
	VariableSetting.openConfigPage = function(nameField,idField,jsp,title){
		var _dialogWin = dialogWin || window;
		seajs.use(['lui/dialog','lui/jquery'],function(dialog){
			dialog.iframe(jsp, title, function(val){
				if(!val){
					return;
				}
				$("#"+nameField).val(val.fdName);
				$("#"+idField).val(val.fdId);
			}, {width:750,height:550,"topWin":_dialogWin});
		});
	};
	VariableSetting.prototype = {
		getValue : function(){
			var data = {};
			for(var i=0;i<this.VarSet.length;i++){
				var item = this.VarSet[i];
				data[item.name] = item.getter(); 
			}
			return data;
		},
		setValue : function(data){
			for (var key in data){
				for(var i=0;i<this.VarSet.length;i++){
					var item = this.VarSet[i];
					if(item.name == key){
						item.setter(data[key]);
					}
				}
			}
		},
		validation:function(xmsg){
			var errMsg = [];
			for(var i=0;i<this.VarSet.length;i++){
				var item = this.VarSet[i];
				if(item.validation != null){
					var msg = item.validation();
					if($.trim(msg)!=""){
						errMsg.push(msg);
					}
				}
			}
			if(errMsg.length > 0){
				if(xmsg!=null)
					xmsg = (xmsg+"\r\n"+errMsg.join("\r\n"));
				else
					xmsg = errMsg.join("\r\n");
				alert(xmsg);
				return false;
			}else{
				return true;
			}
		}
	};
})();