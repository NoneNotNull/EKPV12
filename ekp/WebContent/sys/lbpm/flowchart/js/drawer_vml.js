(function(FlowChartObject) {

	// 显示隐藏
	FlowChartObject.ShowElement = function(element, show) {
		if (!element) {
			return;
		}
		element.style.display = show ? "" : "none";
	};
	// 删除元素
	FlowChartObject.RemoveElement = function(element) {
		element.parentNode.removeChild(element);
	};
	// 获取元素大小
	FlowChartObject.GetElementSize = function(element) {
		return {
			width : element.clientWidth,
			height : element.clientHeight
		};
	};
	// 设置位置
	FlowChartObject.SetPosition = function(element, left, top) {
		element.style.left = left + "px";
		element.style.top = top + "px";
	};
	// 设置填充颜色
	FlowChartObject.SetFillcolor = function(obj, color) {
		if (obj.nodeName && obj.nodeName == "group") {
			obj.firstChild.fillcolor = color; // 并发节点
		} else {
			obj.fillcolor = color;
		}
	};
	// 设置边框颜色
	FlowChartObject.SetStrokeColor = function(obj, color) {
		if (obj.nodeName && obj.nodeName == "group") {
			obj.firstChild.StrokeColor = color; // 并发节点
		} else {
			obj.StrokeColor = color;
		}
	};
	// 设置连线拐点
	FlowChartObject.SetLinePoints = function(obj, points) {
		obj.points.value = points;
	};
	// 设置文本
	FlowChartObject.SetText = function(obj, text) {
		if (obj) {
			var label = "";
			if (text && text.constructor == Array) {
				for ( var i = 0; i < text.length; i++) {
					if (i > 0) {
						label += "<hr size=1>";
					}
					label += Com_HtmlEscapeText(text[i]);
				}
				text = label;
			} else {
				label += Com_HtmlEscapeText(text);
			}
			obj.rows[0].cells[0].innerHTML = label;
		}
	};

	FlowChartObject.Nodes.SetRectDOMImage = function(tbObj, obj) {
		var nodeType = FlowChartObject.Nodes.Types[obj.Type];
		var backgroundImage = nodeType.BackgroundImage ? "url("
				+ nodeType.BackgroundImage + ")" : "url(../images/"
				+ obj.Type.toLowerCase() + ".gif)";
		tbObj.style.backgroundImage = backgroundImage;
	};

	// 线
	FlowChartObject.Lines.CreateLineDOM = function(obj) {
		var htmlCode = "<v:PolyLine filled='false' style='position:absolute' strokeWeight='"
				+ obj.Weight
				+ "px' StrokeColor='"
				+ FlowChartObject.LINESTYLE_STATUSCOLOR[obj.Status] + "' />";
		var newElem = document.createElement(htmlCode);
		document.body.appendChild(newElem);
		obj.DOMElement = newElem;
		newElem.className = "line_" + obj.Type;
		if (obj.Type == "opt") {
			newElem.innerHTML = "<v:stroke EndArrow=Classic /><v:stroke dashstyle=LongDash />";
		} else {
			newElem.innerHTML = "<v:stroke EndArrow=Classic />";
			newElem.LKSObject = obj;
			// 文本
			var tableElem = document.createElement("table");
			tableElem.className = "line_text";
			tableElem.style.position = "absolute";
			tableElem.style.display = "none";
			tableElem.insertRow(-1).insertCell(-1);
			document.body.appendChild(tableElem);
			tableElem.LKSObject = obj;
			obj.DOMText = tableElem;
		}
	};

	// 点
	FlowChartObject.Points.CreatePointDOM = function(obj) {
		var htmlCode = obj.Type == "line" ? "<v:oval class='point_main' style='position:absolute;width:8;height:8;display:none' fillcolor='#00FF00'/>"
				: "<v:oval class='point_main' style='position:absolute;width:8;height:8;display:none' strokecolor='#0000FF' fillcolor='#9999FF'/>";
		var newElem = document.createElement(htmlCode);
		document.body.appendChild(newElem);
		obj.DOMElement = newElem;
		if (obj.Type == "line") {
			newElem.title = FlowChartObject.Lang.PointHelp;
			newElem.LKSObject = obj;
			newElem.onmouseover = function(e) {
				this.fillcolor = "#FF0000";
			};
			newElem.onmouseout = function(e) {
				this.fillcolor = "#00FF00";
			};
		}
	};

	// 功能：创建圆角节点
	FlowChartObject.Nodes.CreateRoundRectDOM = function(obj) {
		if (obj.DOMElement != null)
			FlowChartObject.RemoveElement(obj.DOMElement);
		obj.Width = 120;
		obj.Height = 40;
		if (FlowChartObject.isNeedSmall && !FlowChartObject.IsEdit
				&& !FlowChartObject.IsTemplate) {
			obj.Width = obj.Width - obj.Small_WidthRank;
			obj.Height = obj.Height - obj.Small_HeightRank;
		}

		// 模板不隐藏节点文本和背景 @作者：曹映辉 @日期：2013年3月5日
		if (FlowChartObject.isNeedSmall && !FlowChartObject.IsEdit
				&& !FlowChartObject.IsTemplate && obj.Small_ImgageURL) {
			// 缩小图标，不需要显示文本
			// 构造页面对象
			var newElem = document
					.createElement("<v:RoundRect class='node_main' arcsize='0.5' style='position:absolute;width:"
							+ obj.Width + "px;height:" + obj.Height + "px' />");

			var htmlCode = "<v:imagedata src='" + obj.Small_ImgageURL + "'/>";
			htmlCode += "<v:TextBox inset=\"0pt,0pt,0pt,0pt\">";
			htmlCode += "<table><tr><td></td></tr></table></v:TextBox>";
			newElem.innerHTML = htmlCode;
			document.body.appendChild(newElem);
			newElem.LKSObject = obj;
			obj.DOMElement = newElem;

			var tbObj = newElem.lastChild.lastChild;
			FlowChartObject.Nodes.SetRectDOMImage(tbObj, obj);
		} else {
			// 构造页面对象
			var newElem = document
					.createElement("<v:RoundRect class='node_main' arcsize='0.5' style='position:absolute;width:"
							+ obj.Width + "px;height:" + obj.Height + "px' />");
			var htmlCode = "<v:shadow on=\"T\" type=\"single\" color=\"#b3b3b3\" offset=\"3px,3px\"/>";
			htmlCode += "<v:TextBox inset=\"0pt,0pt,0pt,0pt\">";
			htmlCode += "<table class=\"round_nodetb\"><tr><td></td></tr></table></v:TextBox>";
			newElem.innerHTML = htmlCode;
			document.body.appendChild(newElem);
			newElem.LKSObject = obj;
			obj.DOMElement = newElem;

			var tbObj = newElem.lastChild.lastChild;
			FlowChartObject.Nodes.SetRectDOMImage(tbObj, obj);
			obj.DOMText = tbObj;
		}

	};

	// 功能：创建方角节点
	FlowChartObject.Nodes.CreateRectDOM = function(obj) {
		if (obj.DOMElement != null)
			FlowChartObject.RemoveElement(obj.DOMElement);
		obj.Width = 120;
		obj.Height = 40;
		// 增加 图标缩小功能@作者：曹映辉 @日期：2013年4月3日

		if (FlowChartObject.isNeedSmall && !FlowChartObject.IsEdit
				&& !FlowChartObject.IsTemplate) {
			obj.Width = obj.Width - obj.Small_WidthRank;
			obj.Height = obj.Height - obj.Small_HeightRank;
		}

		// 模板不隐藏节点文本和背景 @作者：曹映辉 @日期：2013年3月5日
		if (FlowChartObject.isNeedSmall && !FlowChartObject.IsEdit
				&& !FlowChartObject.IsTemplate && obj.Small_ImgageURL) {
			// 构造页面对象
			var newElem = document
					.createElement("<v:RoundRect stroked='f' class='node_main' style='border:0px;position:absolute;width:"
							+ obj.Width + "px;height:" + obj.Height + "px' />");
			var htmlCode = "<v:imagedata src='" + obj.Small_ImgageURL + "'/>";
			htmlCode += "<v:TextBox>";
			htmlCode += "<table><tr><td></td></tr></table></v:TextBox>";
			newElem.innerHTML = htmlCode;
			document.body.appendChild(newElem);
			newElem.LKSObject = obj;
			obj.DOMElement = newElem;
			var tbObj = newElem.lastChild.lastChild;
			FlowChartObject.Nodes.SetRectDOMImage(tbObj, obj);
			// obj.DOMText = tbObj.rows[0].cells[0];
			obj.Refresh = FlowChart_Node_Refresh;
		} else {
			// 构造页面对象
			var newElem = document
					.createElement("<v:RoundRect class='node_main' style='position:absolute;width:"
							+ obj.Width + "px;height:" + obj.Height + "px' />");
			var htmlCode = "<v:shadow on=\"T\" type=\"single\" color=\"#b3b3b3\" offset=\"3px,3px\"/>";
			htmlCode += "<v:TextBox inset=\"0pt,0pt,0pt,0pt\">";
			htmlCode += "<table class=\"normal_nodetb\"><tr><td></td></tr></table></v:TextBox>";
			newElem.innerHTML = htmlCode;
			document.body.appendChild(newElem);
			newElem.LKSObject = obj;
			obj.DOMElement = newElem;
			var tbObj = newElem.lastChild.lastChild;
			FlowChartObject.Nodes.SetRectDOMImage(tbObj, obj);
			obj.DOMText = tbObj;
			obj.Refresh = FlowChart_Node_Refresh;
		}
	};

	// 功能：创建大图标节点
	FlowChartObject.Nodes.CreateBigRectDOM = function(obj) {
		if (FlowChartObject.IconType == ICONTYPE_BIG) {
			if (obj.DOMElement != null)
				FlowChartObject.RemoveElement(obj.DOMElement);
			obj.Width = 200;
			obj.Height = 80;
			// 构造页面对象
			var newElem = document
					.createElement("<v:RoundRect class='node_main' style='position:absolute;width:200px;height:80px' />");
			var htmlCode = "<v:shadow on=\"T\" type=\"single\" color=\"#b3b3b3\" offset=\"3px,3px\"/>";
			htmlCode += "<v:TextBox inset=\"0pt,0pt,0pt,0pt\">";
			htmlCode += "<table class=\"big_nodetb\"><tr><td></td></tr></table></v:TextBox>";
			newElem.innerHTML = htmlCode;
			document.body.appendChild(newElem);
			newElem.LKSObject = obj;
			obj.DOMElement = newElem;
			var tbObj = newElem.lastChild.lastChild;
			FlowChartObject.Nodes.SetRectDOMImage(tbObj, obj);
			obj.DOMText = tbObj;
			obj.Refresh = FlowChart_Node_BigIconRefresh;
		} else {
			FlowChartObject.Nodes.CreateRectDOM(obj);
		}
		obj.ChangeIconType = FlowChart_Node_ChangeIconType;
	};

	// 功能：创建菱形节点
	FlowChartObject.Nodes.CreateDiamondDOM = function(obj) {
		if (obj.DOMElement != null)
			FlowChartObject.RemoveElement(obj.DOMElement);
		obj.Width = 120;
		obj.Height = 80;
		// 增加 图标缩小功能 @作者：曹映辉 @日期：2013年3月6日
		if (FlowChartObject.isNeedSmall && !FlowChartObject.IsEdit
				&& !FlowChartObject.IsTemplate) {
			obj.Width = obj.Width - obj.Small_WidthRank;
			obj.Height = obj.Height - obj.Small_HeightRank;
		}

		// 模板不隐藏节点文本和背景 @作者：曹映辉 @日期：2013年3月5日
		if (FlowChartObject.isNeedSmall && !FlowChartObject.IsEdit
				&& !FlowChartObject.IsTemplate && obj.Small_ImgageURL) {
			// 缩小图标，不需要显示文本
			// 构造页面对象
			var newElem = document
					.createElement("<v:shape stroked='f' class='node_main' type='#diamond' style='position:absolute;width:"
							+ obj.Width + "px;height:" + obj.Height + "px' />");
			var htmlCode = "<v:imagedata src='" + obj.Small_ImgageURL + "'/>";
			htmlCode += "<v:TextBox inset=\"0pt,0pt,0pt,0pt\">";
			htmlCode += "<table><tr><td></td></tr></table></v:TextBox>";
			newElem.innerHTML = htmlCode;
			document.body.appendChild(newElem);
			newElem.LKSObject = obj;
			obj.DOMElement = newElem;
			var tbObj = newElem.lastChild.lastChild;
			FlowChartObject.Nodes.SetRectDOMImage(tbObj, obj);

		} else {
			// 构造页面对象
			var newElem = document
					.createElement("<v:shape class='node_main' type='#diamond' style='position:absolute;width:"
							+ obj.Width + "px;height:" + obj.Height + "px' />");
			var htmlCode = "<v:shadow on=\"T\" type=\"single\" color=\"#b3b3b3\" offset=\"3px,3px\"/>";
			htmlCode += "<v:TextBox inset=\"0pt,0pt,0pt,0pt\">";
			htmlCode += "<table class=\"diamond_nodetb\"><tr><td></td></tr></table></v:TextBox>";
			newElem.innerHTML = htmlCode;
			document.body.appendChild(newElem);
			newElem.LKSObject = obj;
			obj.DOMElement = newElem;
			var tbObj = newElem.lastChild.lastChild;
			FlowChartObject.Nodes.SetRectDOMImage(tbObj, obj);
			obj.DOMText = tbObj;
		}
	};

	function createConcurrentDOM(obj) {
		if (obj.DOMElement != null)
			FlowChartObject.RemoveElement(obj.DOMElement);
		obj.Width = 40;
		obj.Height = 40;
		// 构造页面对象
		var newElem = document
				.createElement("<v:group style='position:absolute;width:40px;height:40px' coordsize='40,40' />");
		var htmlCode = "<v:shape type='#diamond' style='width:40px;height:40px' >";
		htmlCode += "<v:shadow on=\"T\" type=\"single\" color=\"#b3b3b3\" offset=\"3px,3px\"/></v:shape>";
		htmlCode += "<v:shape class='node_main' type='#cross' fillcolor=black style='z-index:200;width:20px;height:20px;top:10px;left:10px;' />";
		newElem.innerHTML = htmlCode;
		document.body.appendChild(newElem);
		newElem.LKSObject = obj;
		obj.DOMElement = newElem;
	}

	// 功能：创建并行分支节点
	FlowChartObject.Nodes.CreateSplitDOM = function(obj) {
		createConcurrentDOM(obj);
	};

	// 功能：创建合并分支节点
	FlowChartObject.Nodes.CreateJoinDOM = function(obj) {
		createConcurrentDOM(obj);
	};

})(FlowChartObject);
