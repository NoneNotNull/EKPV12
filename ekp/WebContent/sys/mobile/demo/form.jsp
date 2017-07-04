<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld"
	prefix="template"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld"
	prefix="xform"%>
<template:include ref="mobile.view">
	<template:replace name="title">
		表单样例
	</template:replace>

	<template:replace name="content">

		<style>
.muiAccordionPanelContent {
	padding: 0 1rem;
}

.muiAccordionPanelContent>span {
	color: blue;
	font-size: 1.2rem;
}

.muiAccordionPanelTitle {
	background-color: #2e64aa;
}

.muiAccordionPanelTitle>div {
	color: #fff;
}
</style>
		<div data-dojo-type="mui/view/DocScrollableView">
			<div data-dojo-type="mui/panel/AccordionPanel">

				<div data-dojo-type="mui/panel/Content"
					data-dojo-props="title:'下拉框'">

					<span>编辑状态(单选)</span>
					
					<div data-dojo-type="mui/form/Select"
						data-dojo-props="subject:'下拉框',mul:false,name:'select1',value:'1',store:[{value:'1',text:'单选1'},{value:'2',text:'单选2'},{value:'3',text:'单选3'},{value:'4',text:'单选4'}]">
					</div>

					<span>编辑状态(多选)</span>
					
					<div data-dojo-type="mui/form/Select"
						data-dojo-props="subject:'下拉框',name:'select2',value:'1',store:[{value:'1',text:'单选1'},{value:'2',text:'单选2'},{value:'3',text:'单选3'},{value:'4',text:'单选4'},{value:'5',text:'单选5'},{value:'6',text:'单选6'},{value:'7',text:'单选7'}]">
					</div>
					
					<span>只读状态(单选)</span>
					<div data-dojo-type="mui/form/Select"
						data-dojo-props="subject:'下拉框',name:'select3',edit:false,value:'2',store:[{value:'1',text:'单选1'},{value:'2',text:'单选2'},{value:'3',text:'单选3'}]">
					</div>

					<span>只读状态(多选)</span>
					<div data-dojo-type="mui/form/Select"
						data-dojo-props="subject:'下拉框',name:'select4',edit:false,value:'2;3',store:[{value:'1',text:'单选1'},{value:'2',text:'单选2'},{value:'3',text:'单选3'}]">
					</div>
				</div>

				<div data-dojo-type="mui/panel/Content"
					data-dojo-props="title:'人员选择'">
					<span>编辑状态(多选)</span>
					<div data-dojo-type="mui/form/Address"
						data-dojo-mixins="mui/address/AddressMulMixin"
						data-dojo-props="type: ORG_TYPE_ALL,idField:'creatorId',
							nameField:'creatorName',subject:'申请人',placeholder:'请选择处理人。。'">
					</div>

					<span>编辑状态(单选)</span>
					<div data-dojo-type="mui/form/Address"
						data-dojo-mixins="mui/address/AddressSglMixin"
						data-dojo-props="type: ORG_TYPE_ALL,idField:'creatorSglId',
							nameField:'creatorSglName',subject:'申请人',curIds:'1183b0b84ee4f581bba001c47a78b2d9',curNames:'管理员'">
					</div>

					<span>只读状态</span>
					<div data-dojo-type="mui/form/Address"
						data-dojo-mixins="mui/address/AddressMulMixin"
						data-dojo-props="type: ORG_TYPE_ALL,idField:'authorId',
							nameField:'authorName',subject:'申请人',edit:false,curIds:'1183b0b84ee4f581bba001c47a78b2d9',curNames:'管理员'">
					</div>

				</div>

				<div data-dojo-type="mui/panel/Content"
					data-dojo-props="title:'分类选择'">
					<span>简单分类(多选)</span>
					<div data-dojo-type="mui/form/Category"
						data-dojo-mixins="mui/simplecategory/SimpleCategoryMulMixin"
						data-dojo-props="idField:'simpleCateId',
							nameField:'simpleCateName',modelName:'com.landray.kmss.sys.news.model.SysNewsTemplate',subject:'简单分类'">
					</div>

					<span>简单分类(单选)</span>
					<div data-dojo-type="mui/form/Category"
						data-dojo-mixins="mui/simplecategory/SimpleCategorySglMixin"
						data-dojo-props="idField:'simpleSglCateId',
							nameField:'simpleSglCateName',modelName:'com.landray.kmss.sys.news.model.SysNewsTemplate',subject:'简单分类'">
					</div>

					<span>全局分类(多选)</span>
					<div data-dojo-type="mui/form/Category"
						data-dojo-mixins="mui/syscategory/SysCategoryMulMixin"
						data-dojo-props="idField:'sysCateId',
							nameField:'sysCateName',modelName:'com.landray.kmss.km.review.model.KmReviewTemplate',subject:'全局分类'">
					</div>

					<span>全局分类(多选)</span>
					<div data-dojo-type="mui/form/Category"
						data-dojo-mixins="mui/syscategory/SysCategorySglMixin"
						data-dojo-props="idField:'sysSglCateId',
							nameField:'sysSglCateName',modelName:'com.landray.kmss.km.review.model.KmReviewTemplate',subject:'全局分类'">
					</div>

				</div>

				<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'单选'">
					<span>编辑状态</span>
					<div data-dojo-type="mui/form/RadioGroup"
						data-dojo-props="name:'radio1',store:[{text:'N5审批节点',value:'1',checked:true},{text:'N6审批节点',vallue:'2'},{text:'N7审批节点',value:'3'}]">
					</div>
					<input type="radio"
						data-dojo-type="mui/form/Radio"
						data-dojo-props="text:'N4审批节点',name:'radio1'"> 
					<input type="radio"
						data-dojo-type="mui/form/Radio" checked="checked1"
						data-dojo-props="text:'N5审批节点',name:'radio1'"> 
					<br /> 
					<span>只读状态</span>
					<div data-dojo-type="mui/form/RadioGroup"
						data-dojo-props="edit:false,name:'radio3',store:[{text:'N5审批节点[只读]',value:'1'},{text:'N6审批节点[只读]',vallue:'2'},{text:'N7审批节点[只读]',value:'3'}]">
					</div>
					<input type="radio" data-dojo-type="mui/form/Radio"
						 data-dojo-props="edit:false,text:'N4审批节点[只读]',name:'radio3'">
					<input type="radio" data-dojo-type="mui/form/Radio" checked="checked"
						data-dojo-props="edit:false,text:'N5审批节点[只读]',name:'radio4'"> <br />
				</div>

				<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'多选'">
					<span>编辑状态</span> 
					
					<div data-dojo-type="mui/form/CheckBoxGroup"
						data-dojo-props="name:'checkbox1',store:[{text:'N5审批节点',value:'1'},{text:'N6审批节点',vallue:'2',checked:true},{text:'N7审批节点',value:'3'}]">
					</div>
					
					<input type="checkbox"
						data-dojo-type="mui/form/CheckBox"
						data-dojo-props="name:'checkbox1',text:'N4审批节点',value:'1'"> 
					<input type="checkbox"
						data-dojo-type="mui/form/CheckBox" checked="checked1" data-dojo-props="name:'checkbox2',text:'N5审批节点',value:'1'"> 
					<br />
					<span>只读状态</span> 
					<br /> 
					
					<div data-dojo-type="mui/form/CheckBoxGroup"
						data-dojo-props="edit:false,name:'checkbox1',store:[{text:'N5审批节点',value:'1'},{text:'N6审批节点',vallue:'2',checked:true},{text:'N7审批节点',value:'3'}]">
					</div>
					<input type="checkbox"
						data-dojo-type="mui/form/CheckBox"
						data-dojo-props="name:'checkbox2',edit:false,text:'N4审批节点[只读]',value:'1'"> 
					<input
						type="checkbox" data-dojo-type="mui/form/CheckBox"
						checked="checked"
						data-dojo-props="name:'checkbox2',edit:false,text:'N5审批节点[只读]',value:'1'"> 
					<br />
				</div>

				<div data-dojo-type="mui/panel/Content"
					data-dojo-props="title:'时间控件'">
					<span>编辑状态</span>
					<div data-dojo-type="mui/form/DateTime"
						data-dojo-mixins="mui/datetime/_DateMixin"
						data-dojo-props="valueField:'date',value:'2014-02-20'"></div>
					<div data-dojo-type="mui/form/DateTime"
						data-dojo-mixins="mui/datetime/_TimeMixin"
						data-dojo-props="valueField:'time',value:'22:04'"></div>
					<div data-dojo-type="mui/form/DateTime"
						data-dojo-mixins="mui/datetime/_DateTimeMixin"
						data-dojo-props="dateField:'date1',dateValue:'2014-02-21',timeField:'time1',timeValue:'22:01'"></div>
					<span>只读状态</span>
					<div data-dojo-type="mui/form/DateTime"
						data-dojo-mixins="mui/datetime/_DateMixin"
						data-dojo-props="valueField:'date2',value:'2014-02-20',edit:false"></div>
					<div data-dojo-type="mui/form/DateTime"
						data-dojo-mixins="mui/datetime/_TimeMixin"
						data-dojo-props="valueField:'time2',value:'22：05',edit:false"></div>
					<div data-dojo-type="mui/form/DateTime"
						data-dojo-mixins="mui/datetime/_DateTimeMixin"
						data-dojo-props="dateField:'date3',dateValue:'2014-02-20',timeField:'time3',timeValue:'22:01',edit:false"></div>
				</div>

				<div data-dojo-type="mui/panel/Content"
					data-dojo-props="title:'多行文本'">
					<span>编辑状态</span>
					<div data-dojo-type="mui/form/Textarea"
						data-dojo-props="name:'input1',placeholder:'请输入摘要；请输入摘要；请输入摘要；请输入摘要；请输入摘要'"></div>
					<span> 只读状态</span>
					<div data-dojo-type="mui/form/Textarea"
						data-dojo-props="name:'input2',edit:false,value:'请输入摘要；请输入摘要；请输入摘要；请输入摘要；请输入摘要'"></div>
					
				</div>

				<div data-dojo-type="mui/panel/Content"
					data-dojo-props="title:'单行文本'">
					<span>编辑状态</span>
					<br />
					<input data-dojo-type="mui/form/Input"
						data-dojo-props="name:'input1',placeholder:'请输入主题'">
					<div data-dojo-type="mui/form/Input"
						data-dojo-props="name:'input1',value:'请输入主题'"></div>
					<span> 只读状态</span>
					<div data-dojo-type="mui/form/Input"
						data-dojo-props="name:'input2',edit:false,value:'请输入主题'"></div>
				</div>
			</div>
		</div>
	</template:replace>
</template:include>
