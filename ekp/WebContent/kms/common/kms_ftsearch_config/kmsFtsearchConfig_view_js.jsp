<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
	Com_IncludeFile("jquery.js|treeview.js|json2.js", null, "js");
</script>
<script>
	//重写treeview生成多选框的方法，设置为disabled
	function FtsearchTree(refName, text, DOMElement) {
		var root = new TreeNode(text);
		root.isExpanded = true;
		root.treeView = this;
		this.treeRoot = root;
		this.noHTMLCache = false;
		this.DrawNodeInnerHTML = function(node, indent_level) {
			var Result;
			var isEnd = false;
			if (this.OnNodeQueryDraw != null) {
				Result = this.OnNodeQueryDraw(node)
				if (typeof (Result) == "string")
					isEnd = true;
			}
			if (!isEnd) {
				Result = "<table id='TVN_"
						+ node.id
						+ "' cellpadding=0 cellspacing=0 border=0><tr>"
						+ "<td valign=middle nowrap>"
						+ this.DrawNodeIndentHTML(node, indent_level)
						+ "</td>"
						+ "<td valign=middle nowrap "
						+ (this.currentNodeID == node.id ? "class=TVN_TreeNode_Current"
								: "") + ">";
				if ((node.isShowCheckBox == true || node.isShowCheckBox == null
						&& this.isShowCheckBox == true)
						&& node.value != null)
					var ChkStr = "<input onClick='" + this.refName
							+ ".SelectNode(" + node.id + ")' type="
							+ (this.isMultSel ? "checkbox" : "radio")
							+ " id='CHK_" + node.id + "' value=\""
							+ Com_HtmlEscape(node.value)
							+ "\" name=List_Selected "
							+ (node.isChecked ? "Checked" : "")
							+ " disabled='disabled'>";
				else
					var ChkStr = "";
				Result += "<a lks_nodeid=" + node.id + " title=\""
						+ Com_HtmlEscape(node.title)
						+ "\" href=\"javascript:void(0)\"";
				if (this.DblClickNode != null)
					Result += " ondblclick=\"" + this.refName
							+ ".DblClickNode(" + node.id + ");\"";
				Result += ">" + ChkStr + Com_HtmlEscape(node.text) + "</a>";
				Result += "</td></tr></table>";
				if (this.OnNodePostDraw != null) {
					var tmpStr = this.OnNodePostDraw(node, Result);
					if (typeof (tmpStr) == "string")
						Result = tmpStr;
				}
			}
			if (TREENODESTYLE.isOneoff)
				Tree_ResumeStyle();
			return Result;
		};
		this.DOMElement = DOMElement;
	}
	FtsearchTree.prototype = new TreeView("LKSTree", "搜索范围");

	var LKSTree;
	function generateTree(beanName, dom, module) {
		LKSTree = new FtsearchTree("LKSTree", module, dom);
		LKSTree.isShowCheckBox = true;
		LKSTree.isMultSel = true;
		LKSTree.isAutoSelectChildren = false;
		var n1, n2;
		n1 = LKSTree.treeRoot;
		n1.authType = "01";
		n2 = n1.AppendBeanData(beanName);
		LKSTree.Show();
	}

	$( function() {
		$('#categoryRange')
				.find('[data-category-range="data-category-range-div"]')
				.each(
						function() {
							String
							beanName = "kmsFtSearchCategoryDataBean&selectdId=!{value}&fdId=${kmsFtsearchConfigForm.fdId}&type=view&modelName="
									+ $(this).attr('id')
									+ "&date="
									+ new Date();
							generateTree(beanName, $(this)[0], $(this).attr(
									'moduleTitle'));
						});

		$('#propertyRange')
				.find('[data-property-range="data-property-range-div"]')
				.each(
						function() {

							generateTree(
									"kmsFtSearchPropertyDataBean&selectdId=!{value}&fdId=${kmsFtsearchConfigForm.fdId}&type=view&date="
											+ new Date(), $(this)[0], '文档属性范围');

						});
	});
</script>