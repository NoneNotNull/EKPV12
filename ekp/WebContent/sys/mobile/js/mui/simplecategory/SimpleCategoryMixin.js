define( [ "dojo/_base/declare"],
		function(declare) {
			window.SIMPLE_CATEGORY_TYPE_CATEGORY = 0;//"CATEGORY" 类别
			
			var simpleCategory = declare("mui.simplecategory.SimpleCategoryMixin", null, {

				type : window.SIMPLE_CATEGORY_TYPE_CATEGORY ,
				
				//模块名
				modelName:null,
				
				//对节点的验证权限,0显示所有(00可以选中所有,01只能选中有维护权限的,02只能选中有使用权限的),1 只显示有维护权限的
				authType:"02",
				
				isMul: false , 
				
				templURL : "mui/simplecategory/simplecategory_sgl.jsp?modelName=!{modelName}&authType=!{authType}",
				
				_setIsMulAttr:function(mul){
					this._set('isMul' , mul);
					if(this.isMul){
						this.templURL =  "mui/simplecategory/simplecategory_mul.jsp?modelName=!{modelName}&authType=!{authType}";
					}else{
						this.templURL =  "mui/simplecategory/simplecategory_sgl.jsp?modelName=!{modelName}&authType=!{authType}";
					}
				}
				
			});
			return simpleCategory;
	});