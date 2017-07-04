Com_IncludeJsFile("svg.js");
( function(FlowChartObject) {
	
	FlowChartObject.SVG = new Object();
	FlowChartObject.SVG.Drawer = null;
	FlowChartObject.SVG.Initialize = function() {
		SVG.eid = function(name) { // Id生成规则
			return 'lbpm' + name.charAt(0).toUpperCase() + name.slice(1)
					+ (SVG.did++);
		};
		FlowChartObject.SVG.Drawer = window.SVG('lbpmSvg');
		var g = FlowChartObject.SVG.Group = FlowChartObject.SVG.Drawer.group();
		FlowChartObject.SVG.Nodes = g.group();
		FlowChartObject.SVG.Lines = g.group();
		FlowChartObject.SVG.Points = g.group();
	};
	FlowChartObject.InitializeArray.unshift(FlowChartObject.SVG); // 优先初始化
	
	// 调整画布宽度、高度
	FlowChartObject.Resize = function(isEdit) {
		var bbox;
		var drawer = FlowChartObject.SVG.Drawer;
		try {
			bbox = drawer.node.getBBox();
		} catch(e) {
			bbox = {
				x: drawer.node.clientLeft,
				y: drawer.node.clientTop,
				width: drawer.node.clientWidth,
				height: drawer.node.clientHeight
			};
		}
		if(bbox.height + bbox.y > 0) {
			document.body.style.height = (bbox.height + bbox.y + 50) + "px";
		}
		if(bbox.width + bbox.x > 0) {
			document.body.style.width = (bbox.width + bbox.x + 50) + "px";
		}
	};
	
	// 显示隐藏
	FlowChartObject.ShowElement = function(element, show) {
		if (!element) {
			return;
		}
		if (element.node) { // svg
			if (show) {
				element.show();
			} else {
				element.hide();
			}
		} else {
			element.style.display = show ? "" : "none";
		}
	};
	// 删除元素
	FlowChartObject.RemoveElement = function(element) {
		if (element.node) { // svg
			element.remove();
		} else {
			element.parentNode.removeChild(element);
		}
	};
	// 获取元素大小
	FlowChartObject.GetElementSize = function(element) {
		return {
			width : element.node.offsetWidth || element.node.scrollWidth || element.attr('width') || 0,
			height : element.node.offsetHeight || element.node.scrollHeight || element.attr('height') || 0
		};
	};
	// 设置位置
	FlowChartObject.SetPosition = function(obj, left, top) {
		obj.move(left, top);
		FlowChartObject.Resize();
	};
	// 设置填充颜色
	FlowChartObject.SetFillcolor = function(obj, color) {
		var child = obj.children()[0];
		child.attr("fill", color);
		if (child.type == "polyline") {
			createLineArrow(child, color); // 创建颜色箭头
		}
	};
	// 设置边框颜色
	FlowChartObject.SetStrokeColor = function(obj, color) {
		var child = obj.children()[0];
		child.attr("stroke", color);
		if (child.type == "polyline") {
			createLineArrow(child, color); // 创建颜色箭头
		}
	};
	// 设置连线拐点
	FlowChartObject.SetLinePoints = function(obj, points) {
		obj.children()[0].plot(points);
	};
	// 设置文本
	FlowChartObject.SetText = function(obj, text) {
		if (obj) {
			if(text && text.constructor == Array) {
				var label = "";
				for (var i = 0; i < text.length; i++) {
					if(i > 0) {
						label += "\r\n-----------------------------------------------\r\n";
					}
					label += text[i];
				}
				text = label;
			}
			obj.text(text);
			if(obj.parent.node.LKSObject.Height) {
				// FIXME 调整垂直定位，IE10、firefox下obj.bbox().height高度有时候读取不到
				obj.y((obj.parent.node.LKSObject.Height - (obj.bbox().height || 13)) / 2);
			}
		}
	};

	function getRectDOMImageUrl(obj) {
		var nodeType = FlowChartObject.Nodes.Types[obj.Type];
		return nodeType.BackgroundImage
				|| ("../images/" + obj.Type.toLowerCase() + ".gif");
	}

	function createLineArrow(line, color) {
		var arrow = FlowChartObject.SVG.Drawer.node.getElementById("lbpmArrow"
				+ color);
		if (arrow) {
			line.attr("marker-end", "url(#lbpmArrow" + color + ")");
			return;
		}
		var defs = FlowChartObject.SVG.Drawer.defs();
		var marker = SVG.create("marker");
		marker.setAttributeNS(null, 'id', "lbpmArrow" + color);
		marker.setAttributeNS(null, 'viewBox', '0 0 20 20');
		marker.setAttributeNS(null, 'refX', "13px");
		marker.setAttributeNS(null, 'refY', "10px");
		marker.setAttributeNS(null, 'markerUnits', 'strokeWidth');
		marker.setAttributeNS(null, 'markerWidth', "3px");
		marker.setAttributeNS(null, 'markerHeight', "3px");
		marker.setAttributeNS(null, 'orient', "auto");
		defs.node.appendChild(marker);
		var path = SVG.create("path");
		path.setAttributeNS(null, 'd', "M 0 0 L 20 10 L 0 20 z");
		path.setAttributeNS(null, 'fill', color);
		path.setAttributeNS(null, 'stroke', color);
		path.setAttributeNS(null, 'stroke-width', "1px");
		marker.appendChild(path);
		line.attr("marker-end", "url(#lbpmArrow" + color + ")");
	}
	
	function createNodeGroup() {
		var group = FlowChartObject.SVG.Nodes.group();
		//group.attr("filter", "url(#filter)");
		return group;
	}

	// 线
	FlowChartObject.Lines.CreateLineDOM = function(obj) {
		var group = FlowChartObject.SVG.Lines.group();
		var polyline = group.polyline("0, 0", true).attr("class",
				"line_" + obj.Type).attr("fill", "none").attr("stroke",
				FlowChartObject.LINESTYLE_STATUSCOLOR[obj.Status]).attr(
				"stroke-width", obj.Weight);
		polyline.attr("stroke-linecap", "round").attr("stroke-linejoin",
				"round");
		createLineArrow(polyline,
				FlowChartObject.LINESTYLE_STATUSCOLOR[obj.Status]);
		obj.DOMElement = group;
		if (obj.Type == "opt") {
			polyline.attr("stroke-dasharray", "20, 10"); // 虚线
		} else {
			group.node.LKSObject = obj;
			// 文本
			var text = group.text(obj.Text).attr("class", "line_text text").fill(
					"#000000");
			text.font( {
				size : 12
			});
			text.node.LKSObject = obj;
			obj.DOMText = text;
		}
	};

	// 点
	FlowChartObject.Points.CreatePointDOM = function(obj) {
		var group = FlowChartObject.SVG.Points.group().hide(); // 隐藏
		var circle = group.circle(8).attr("class", "point_main").attr("stroke",
				"#0000FF");
		obj.DOMElement = group;
		if (obj.Type == "line") {
			circle.attr("fill", "#00FF00");
			circle.attr("title", FlowChartObject.Lang.PointHelp);
			group.node.LKSObject = obj;
			circle.on("mouseover", function(e) {
				this.instance.attr("fill", "#FF0000");
			});
			circle.on("mouseout", function(e) {
				this.instance.attr("fill", "#00FF00");
			});
		} else {
			circle.attr("fill", "#9999FF");
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

		var group = createNodeGroup();
		group.node.LKSObject = obj;
		obj.DOMElement = group;

		if (FlowChartObject.isNeedSmall && !FlowChartObject.IsEdit
				&& !FlowChartObject.IsTemplate && obj.Small_ImgageURL) {
			group.image(obj.Small_ImgageURL, obj.Width, obj.Height);
		} else {
			group.rect(obj.Width, obj.Height).attr("class", "node_main").attr(
					"rx", 20).attr("ry", 20).attr("stroke", "#000000").fill("#ffffff");
			group.image(getRectDOMImageUrl(obj), 25, 25).move(6,
					(obj.Height - 25) / 2);
			// create text
			var text = group.text(obj.Text).attr("class", "round_nodetb text").fill(
					'#000000').move((obj.Width + 25) / 2, (obj.Height - 12) / 2);
			text.font( {
				size : 12,
				anchor: 'middle'
			});
			
			obj.DOMText = text;
		}
	};

	// 功能：创建方角节点
	FlowChartObject.Nodes.CreateRectDOM = function(obj) {
		if (obj.DOMElement != null)
			FlowChartObject.RemoveElement(obj.DOMElement);
		obj.Width = 120;
		obj.Height = 40;

		if (FlowChartObject.isNeedSmall && !FlowChartObject.IsEdit
				&& !FlowChartObject.IsTemplate) {
			obj.Width = obj.Width - obj.Small_WidthRank;
			obj.Height = obj.Height - obj.Small_HeightRank;
		}

		var group = createNodeGroup();
		group.node.LKSObject = obj;
		obj.DOMElement = group;

		if (FlowChartObject.isNeedSmall && !FlowChartObject.IsEdit
				&& !FlowChartObject.IsTemplate && obj.Small_ImgageURL) {
			group.image(obj.Small_ImgageURL, obj.Width, obj.Height);
		} else {
			var rect = group.rect(obj.Width, obj.Height).attr("class",
					"node_main").attr("rx", 5).attr("ry", 5).attr("stroke",
					"#000000").fill("#ffffff");

			group.image(getRectDOMImageUrl(obj), 25, 25).move(3,
					(obj.Height - 28) / 2);
			// create text
			var text = group.text(obj.Text).attr("class", "round_nodetb").fill(
					'#000000').move((obj.Width + 25) / 2, (obj.Height - 12) / 2);
			text.font( {
				size : 12,
				anchor: 'middle'
			});

			obj.DOMText = text;
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

			var group = createNodeGroup();
			group.node.LKSObject = obj;
			obj.DOMElement = group;

			var rect = group.rect(obj.Width, obj.Height).attr("class",
					"node_main").attr("rx", 5).attr("ry", 5).attr("stroke",
					"#000000").fill("#ffffff");

			group.image(getRectDOMImageUrl(obj), 25, 25).move(3,
					6);
			// create text
			var text = group.text(obj.Text).attr("class", "round_nodetb").fill(
					'#000000').move(obj.Width / 2, (obj.Height - 12) / 2);
			text.font( {
				size : 12,
				anchor: 'middle'
			});

			obj.DOMText = text;
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

		if (FlowChartObject.isNeedSmall && !FlowChartObject.IsEdit
				&& !FlowChartObject.IsTemplate) {
			obj.Width = obj.Width - obj.Small_WidthRank;
			obj.Height = obj.Height - obj.Small_HeightRank;
		}

		var group = createNodeGroup();
		group.node.LKSObject = obj;
		obj.DOMElement = group;

		if (FlowChartObject.isNeedSmall && !FlowChartObject.IsEdit
				&& !FlowChartObject.IsTemplate && obj.Small_ImgageURL) {
			group.image(obj.Small_ImgageURL, obj.Width, obj.Height);
		} else {
			var points = new Array();
			points.push((obj.Width / 2) + ", 0");
			points.push(obj.Width + ", " + (obj.Height / 2));
			points.push((obj.Width / 2) + ", " + obj.Height);
			points.push("0, " + (obj.Height / 2));
			group.polygon(points.join(" "), true).attr("stroke", "#000000")
					.fill("#ffffff");

			group.image(getRectDOMImageUrl(obj), 25, 25).move(
					(obj.Width - 25) / 2, (obj.Height - 25) / 2);

			var text = group.text(obj.Text).attr("class", "round_nodetb")
					.fill('#000000').move(obj.Width / 2,
							(obj.Height - 12) / 2);
			text.font( {
				size : 12,
				anchor: 'middle'
			});

			obj.DOMText = text;

		}
	};

	function createConcurrentDOM(obj) {
		if (obj.DOMElement != null)
			FlowChartObject.RemoveElement(obj.DOMElement);
		obj.Width = 40;
		obj.Height = 40;

		var group = createNodeGroup();
		group.node.LKSObject = obj;
		obj.DOMElement = group;

		var points = new Array();
		points.push((obj.Width / 2) + ", 0");
		points.push(obj.Width + ", " + (obj.Height / 2));
		points.push((obj.Width / 2) + ", " + obj.Height);
		points.push("0, " + (obj.Height / 2));

		group.polygon(points.join(" "), true).attr("class", "node_main").attr(
				"stroke", "#000000").fill("#ffffff");

		group.line((obj.Width / 4), (obj.Height / 2), (obj.Width / 4 * 3),
				(obj.Height / 2)).attr("stroke", "#000000").fill("#000000")
				.attr("stroke-width", 5);
		group.line((obj.Width / 2), (obj.Height / 4), (obj.Width / 2),
				(obj.Height / 4 * 3)).attr("stroke", "#000000").fill("#000000")
				.attr("stroke-width", 5);

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