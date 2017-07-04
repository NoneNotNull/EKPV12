<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld"
	prefix="template"%>
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
					<br />
					<xform:select property="select1" subject="下拉框" showStatus="edit"
						mobile="true">
						<xform:simpleDataSource value="1">下拉框1</xform:simpleDataSource>
						<xform:simpleDataSource value="2">下拉框2</xform:simpleDataSource>
						<xform:simpleDataSource value="3">下拉框3</xform:simpleDataSource>
					</xform:select>
					<br />
					<span>阅读状态(单选)</span>
					<br />
					<xform:select property="select2" subject="下拉框" showStatus="view"
						mobile="true" value="2">
						<xform:simpleDataSource value="1">下拉框1</xform:simpleDataSource>
						<xform:simpleDataSource value="2">下拉框2</xform:simpleDataSource>
						<xform:simpleDataSource value="3">下拉框3</xform:simpleDataSource>
					</xform:select>
					<br />
					<span>只读状态(单选)</span>
					<br />
					<xform:select property="select3" subject="下拉框" showStatus="readOnly"
						mobile="true" value="2">
						<xform:simpleDataSource value="1">下拉框1</xform:simpleDataSource>
						<xform:simpleDataSource value="2">下拉框2</xform:simpleDataSource>
						<xform:simpleDataSource value="3">下拉框3</xform:simpleDataSource>
					</xform:select>
					<br />
					<span>隐藏状态(单选)</span>
					<br />
					<xform:select property="select4" subject="下拉框" showStatus="hidden"
						mobile="true" value="2">
						<xform:simpleDataSource value="1">下拉框1</xform:simpleDataSource>
						<xform:simpleDataSource value="2">下拉框2</xform:simpleDataSource>
						<xform:simpleDataSource value="3">下拉框3</xform:simpleDataSource>
					</xform:select>
				</div>

				<div data-dojo-type="mui/panel/Content"
					data-dojo-props="title:'人员选择'">
					<span>编辑状态(多选)</span>
					<xform:address propertyName="creatorName" propertyId="creatorId"
						mulSelect="true" showStatus="edit" orgType="ORG_TYPE_PERSON" mobile="true"></xform:address>

					<span>编辑状态(单选)</span>
					<xform:address propertyName="authorName" propertyId="authorId"
						mulSelect="false" showStatus="edit" orgType="ORG_TYPE_PERSON" mobile="true"></xform:address>

					<span>只读状态</span> 
					<br />

				</div>

				<div data-dojo-type="mui/panel/Content"
					data-dojo-props="title:'分类选择'">
					<span>简单分类(多选)</span> 
					<br /> 
					<span>简单分类(单选)</span> 
					<br /> 
					<span>全局分类(多选)</span>
					<br /> 
					<span>全局分类(多选)</span> 
					<br />

				</div>

				<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'单选'">
					<span>编辑状态</span> <br />
					<xform:radio property="radio" value="1" showStatus="edit"
						mobile="true" required="true">
						<xform:simpleDataSource value="1">单选1</xform:simpleDataSource>
						<xform:simpleDataSource value="2">单选2</xform:simpleDataSource>
						<xform:simpleDataSource value="3">单选3</xform:simpleDataSource>
					</xform:radio>
					<br /> 
					<span>阅读状态</span> <br />
					<xform:radio property="radio2" value="2" showStatus="view"
						mobile="true">
						<xform:simpleDataSource value="1">单选1</xform:simpleDataSource>
						<xform:simpleDataSource value="2">单选2</xform:simpleDataSource>
						<xform:simpleDataSource value="3">单选3</xform:simpleDataSource>
					</xform:radio>
					<br />
					<span>只读状态</span> 
					<br />
					<xform:radio property="radio3" value="2" showStatus="readOnly"
						mobile="true">
						<xform:simpleDataSource value="1">单选1</xform:simpleDataSource>
						<xform:simpleDataSource value="2">单选2</xform:simpleDataSource>
						<xform:simpleDataSource value="3">单选3</xform:simpleDataSource>
					</xform:radio>
					<br />
					<span>隐藏状态</span> <br />
					<xform:radio property="radio4" value="2" showStatus="hidden"
						mobile="true">
						<xform:simpleDataSource value="1">单选1</xform:simpleDataSource>
						<xform:simpleDataSource value="2">单选2</xform:simpleDataSource>
						<xform:simpleDataSource value="3">单选3</xform:simpleDataSource>
					</xform:radio>
					<br />
				</div>

				<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'多选'">
					<span>编辑状态</span> <br />
					<xform:checkbox property="checkbox" mobile="true" showStatus="edit" required="true"
						value="1">
						<xform:simpleDataSource value="1">多选框1</xform:simpleDataSource>
						<xform:simpleDataSource value="2">多选框2</xform:simpleDataSource>
						<xform:simpleDataSource value="3">多选框3</xform:simpleDataSource>
					</xform:checkbox>
					<br /> 
					<span>阅读状态</span> <br />
					<xform:checkbox property="checkbox2" mobile="true"
						showStatus="view" value="2">
						<xform:simpleDataSource value="1">多选框1</xform:simpleDataSource>
						<xform:simpleDataSource value="2">多选框2</xform:simpleDataSource>
						<xform:simpleDataSource value="3">多选框3</xform:simpleDataSource>
					</xform:checkbox>
					<br />
					<span>只读状态</span> <br />
					<xform:checkbox property="checkbox3" mobile="true"
						showStatus="readOnly" value="2">
						<xform:simpleDataSource value="1">多选框1</xform:simpleDataSource>
						<xform:simpleDataSource value="2">多选框2</xform:simpleDataSource>
						<xform:simpleDataSource value="3">多选框3</xform:simpleDataSource>
					</xform:checkbox>
					<br />
					<span>隐藏状态</span> <br />
					<xform:checkbox property="checkbox4" mobile="true"
						showStatus="hidden" value="2">
						<xform:simpleDataSource value="1">多选框1</xform:simpleDataSource>
						<xform:simpleDataSource value="2">多选框2</xform:simpleDataSource>
						<xform:simpleDataSource value="3">多选框3</xform:simpleDataSource>
					</xform:checkbox>
					<br />
				</div>

				<div data-dojo-type="mui/panel/Content"
					data-dojo-props="title:'时间控件'">
					<span>编辑状态</span>
					<br />
					<xform:datetime property="date" dateTimeType="date"
						showStatus="edit" mobile="true" value="2012-01-21"></xform:datetime>
					<br />
					<xform:datetime property="time" dateTimeType="time"
						showStatus="edit" mobile="true" value="20:01"></xform:datetime>
					<br />
					<xform:datetime property="datetime" dateTimeType="datetime"
						showStatus="edit" mobile="true" value="2012-01-21 20:01"></xform:datetime>
					<br /> 
					<span>阅读状态</span>
					<br />
					<xform:datetime property="date1" dateTimeType="date"
						showStatus="view" mobile="true" value="2012-01-21"></xform:datetime>
					<br />
					<xform:datetime property="time1" dateTimeType="time"
						showStatus="view" mobile="true" value="20:01"></xform:datetime>
					<br />
					<xform:datetime property="datetime1" dateTimeType="datetime"
						showStatus="view" mobile="true" value="2012-01-21 20:01"></xform:datetime>
					<br /> 
					<span>只读状态</span>
					<br />
					<xform:datetime property="date2" dateTimeType="date"
						showStatus="readOnly" mobile="true" value="2012-01-21"></xform:datetime>
					<br />
					<xform:datetime property="time2" dateTimeType="time"
						showStatus="readOnly" mobile="true" value="20:01"></xform:datetime>
					<br />
					<xform:datetime property="datetime2" dateTimeType="datetime"
						showStatus="readOnly" mobile="true" value="2012-01-21 20:01"></xform:datetime>
					<br /> 
					<span>隐藏状态</span>
					<br />
					<xform:datetime property="date3" dateTimeType="date"
						showStatus="hidden" mobile="true" value="2012-01-21"></xform:datetime>
					<br />
					<xform:datetime property="time3" dateTimeType="time"
						showStatus="hidden" mobile="true" value="20:01"></xform:datetime>
					<br />
					<xform:datetime property="datetime3" dateTimeType="datetime"
						showStatus="hidden" mobile="true" value="2012-01-21 20:01"></xform:datetime>
				</div>

				<div data-dojo-type="mui/panel/Content"
					data-dojo-props="title:'多行文本'">
					<span>编辑状态</span>
					<br />
					<xform:textarea property="textarea"
						value="请输入摘要；请输入摘要；请输入摘要；请输入摘要；请输入摘要请输入摘要" mobile="true" showStatus="edit">
					</xform:textarea>
					<br />
					<span>阅读状态</span>
					<br />
					<xform:textarea property="textarea"
						value="请输入摘要；请输入摘要；请输入摘要；请输入摘要；请输入摘要请输入摘要" showStatus="view" mobile="true">
					</xform:textarea>
					<br />
					<span>只读状态</span>
					<br />
					<xform:textarea property="textarea"
						value="请输入摘要；请输入摘要；请输入摘要；请输入摘要；请输入摘要请输入摘要" showStatus="readOnly" mobile="true">
					</xform:textarea>
					<br />
					<span>隐藏状态</span>
					<br />
					<xform:textarea property="textarea"
						value="请输入摘要；请输入摘要；请输入摘要；请输入摘要；请输入摘要请输入摘要" showStatus="hidden" mobile="true">
					</xform:textarea>
					<br />
				</div>

				<div data-dojo-type="mui/panel/Content"
					data-dojo-props="title:'单行文本'">
					<span>编辑状态</span>
					<br />
					<xform:text property="text" value="请输入标题" showStatus="edit" mobile="true"></xform:text>
					<br />
					<span>阅读状态</span>
					<br />
					<xform:text property="text" value="请输入标题" mobile="true" showStatus="view"></xform:text>
					<br />
					<span> 只读状态</span>
					<br />
					<xform:text property="text" value="请输入标题" mobile="true" showStatus="readOnly"></xform:text>
					<br />
					<span> 隐藏状态</span>
					<br />
					<xform:textarea property="text"
						value="请输入标题" showStatus="hidden" mobile="true">
					</xform:textarea>
					<br />
				</div>
			</div>
		</div>
	</template:replace>
</template:include>
