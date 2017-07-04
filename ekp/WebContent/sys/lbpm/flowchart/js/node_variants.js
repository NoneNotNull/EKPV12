/**********************************************************
功能：属性页面附加属性
使用：
	在节点属性页面引入

作者：傅游翔
创建时间：2012-07-23
修改记录：
**********************************************************/

		AttributeObject.Init.AllModeFuns.push(function() {
			var NodeData = AttributeObject.NodeData;
			if(NodeData.variants!=null){
				$("#Node_Variant input[name^='Var_']").each(function() {
					for(var i=0; i<NodeData.variants.length; i++){
						if (this.name == 'Var_' + NodeData.variants[i].name) {
							this.checked = true;
						}
					}
				});
			}
		});
		AttributeObject.AppendDataFuns.push(function(data) {
			data.variants = new Array();
			$("#Node_Variant input[name^='Var_']:checked").each(function() {
				var variant = new Object();
				variant.name = this.name.substring(4);
				variant.value = "true";
				variant.XMLNODENAME = "variant";
				data.variants[data.variants.length] = variant;
			});
		});