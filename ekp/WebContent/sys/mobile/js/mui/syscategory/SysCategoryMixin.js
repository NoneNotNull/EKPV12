define( [ "dojo/_base/declare"],
		function(declare) {
			window.SYS_CATEGORY_TYPE_CATEGORY = 0; //"CATEGORY" 类别
			
			window.SYS_CATEGORY_TYPE_TEMPLATE = 1;//"TEMPLATE" 模板
			
			var sysCategory = declare("mui.syscategory.SysCategoryMixin", null, {

				type : window.SYS_CATEGORY_TYPE_TEMPLATE ,
				
				//模块名
				modelName:null,
				
				//是否取模板, 值:0 否  , 1 是
				getTemplate:1,
				
				//0显示显示子机构分类,只1显示父机构分类,2只父机构分类和子机构分类
				showType:"0",
				
				//对节点的验证权限,0显示所有(00可以选中所有,01只能选中有维护权限的,02只能选中有使用权限的),1 只显示有维护权限的
				authType:"02",
				
				isMul: false ,
				
				templURL : "mui/syscategory/syscategory_sgl.jsp?modelName=!{modelName}&authType=!{authType}",
				
				_setIsMulAttr:function(mul){
					this._set('isMul' , mul);
					if(this.isMul){
						this.templURL =  "mui/syscategory/syscategory_mul.jsp?modelName=!{modelName}&authType=!{authType}";
					}else{
						this.templURL =  "mui/syscategory/syscategory_sgl.jsp?modelName=!{modelName}&authType=!{authType}";
					}
				}
				
			});
			return sysCategory;
	});
