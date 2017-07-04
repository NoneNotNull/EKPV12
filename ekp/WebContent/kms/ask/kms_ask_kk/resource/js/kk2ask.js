/**
 * ! requires:[ jquery.js & kms.js ]
 */
;
Com_IncludeFile("kk2ask_lang.jsp", KMS.basePath
				+ "/ask/kms_ask_kk/resource/js/", 'js', true);

(function(jq, doc) {

	// 回复索引
	KMS.Index = 0;

	var kk2ask = EventTarget.extend({
		constructor : function(context, options) {

			this.options = {
				// data:'',
				xmlPath : KMS.contextPath + 'kms/ask/resource/js/NewFile.xml',
				refresh : function() {

				}
				// render : function() {
				//
				// },
			};

			this.context = jq('#' + context);

			this.base(options);
			// this.createXml();
			// this.loadXML();
			this.str2xml();
			this.flag = false;
			return this;
		},

		// 字符串转换为xml
		str2xml : function() {
			var data = this.options.data;
			var xml, tmp;
			try {
				xml = new ActiveXObject("Microsoft.XMLDOM");
				xml.async = "false";
				xml.loadXML(data);
			} catch (e) {
				xml = undefined;
			}
			if (!xml || !xml.documentElement
					|| xml.getElementsByTagName("parsererror").length) {
				alert("Invalid XML error: " + data);
			}
			this.xmlDoc = xml;
			// var aa = this.xmlDoc.documentElement;
			// alert(typeof this.xmlDoc);
			// alert(this.xmlDoc.documentElement.xml);
			this.render();
			// this.findNodeByTagName(xml.childNodes[0], 'group');
			return xml;
		},

		// 根据节点名查找某节点的子节点
		findNodeByTagName : function(node, name) {
			var nodes = [];
			if (!node)
				return nodes;
			for (var i = 0; i < node.childNodes.length; i++) {
				if (node.childNodes[i]
						&& (node.childNodes[i].nodeName == name || !name)) {
					if (node.childNodes[i].nodeType == 1) {
						nodes[nodes.length] = node.childNodes[i];
					}
				}
			}
			return nodes;
		},

		// 设置节点的值
		setNodeText : function(node, text) {
			node.text = text || "";
			return node;
		},

		// 获取节点的值
		getNodeText : function(node) {
			var text = node.text;
			return text;
		},

		// 根据属性名获取节点属性的值
		getNodeAttrByName : function(node, attrName) {
			var value = node.getAttribute(attrName);
			return value;
		},

		// 根据文件路径获取XMLDOM对象
		loadXML : function() {
			var xmlDoc = null;
			if (window.ActiveXObject) {
				xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			} else if (doc.implementation && doc.implementation.createDocument) {
				xmlDoc = doc.implementation.createDocument("", "", null);
			} else {
				alert('Your browser cannot handle this script');
			}
			xmlDoc.async = false;
			// 不兼容谷歌浏览器
			xmlDoc.load(this.options.xmlPath);
			this.xmlDoc = xmlDoc;
			// alert(this.xmlDoc.xml);
			this.render();
			// this.findNodeByTagName(xmlDoc.documentElement, 'group');
			return xmlDoc;
		},

		// 更新回复列表，kk用于获取后5条
		refresh : function() {
			// for (var obj in this.options) {
			// if (jq.isFunction(this.options[obj]))
			// alert(obj);
			// }
			window.external.fetchnext('kk2ask', 5);
		},

		renderPosts : function() {

		},

		// 删除回复dd
		deletePost : function() {
			var checkBoxs = jq(this.context).find('input:checked');
			if (checkBoxs.size() == 0) {
				art.artDialog.alert(messageInfo.deleteMsg);
				return;
			}
			$.each(checkBoxs, function(i, n) {
						if (n.checked) {
							$(n).parent().parent().remove();
						}
					});
		},

		// 绑定删除&刷新事件
		bindEvent : function() {
			$('#refresh').bind('click', this.refresh.binding(this));
			$('#deletePost').bind('click', this.deletePost.binding(this));
		},

		// 渲染显示
		render : function() {
			var docSubject = this.findNodeByTagName(
					this.xmlDoc.documentElement, "subject"), org = this
					.findNodeByTagName(this.xmlDoc.documentElement, "org"), group = this
					.findNodeByTagName(this.xmlDoc.documentElement, "group");

			var docContent = this.findNodeByTagName(
					this.xmlDoc.documentElement, "content");
			docContent && docContent.length > 0 && docContent[0].text ? jq(doc
					.getElementsByName('docContent')[0])
					.text(docContent[0].text.trim()) : '';

			// 提问主题赋值
			docSubject && docSubject.length > 0 && docSubject[0].text ? jq(doc
					.getElementsByName('docSubject')[0])
					.text(docSubject[0].text.trim()) : '';

			var topicLoginName = this.getNodeAttrByName(org[0], 'loginname')
					.trim(), time = this.getNodeAttrByName(
					this.xmlDoc.documentElement, 'time').trim(), groupId = this
					.getNodeAttrByName(group[0], 'id').trim();
			if (topicLoginName) {
				jq(doc.getElementsByName('fdPosterName')[0])
						.val(topicLoginName);
			}
			if (time) {
				jq(doc.getElementsByName('docCreateTime')[0]).val(time);
				jq(doc.getElementsByName('fdPostTime')[0]).val(time);
			}

			if (groupId) {
				jq(doc.getElementsByName('fdGroupId')[0]).val(groupId);
			}

			// 拼装回复列表
			var posts = jq(this.findNodeByTagName(this.xmlDoc.documentElement,
					"posts"))[0], post = jq(this.findNodeByTagName(posts,
					"post"));

			if (!$('#megInfo').length) {
				var div = jq('<div class="title6" id="megInfo"></div>');
				var text = messageInfo.getAfterData.replace("{0}", 5);
				var h3 = [
						'<h3 class="h3_1">',
						messageInfo.allAnswer,
						'<span style="float: right;">',
						'<a href="javascript:void(0)" title="' + text
								+ '" class="a_b m_l10" id="refresh">',
						text,
						'</a>',
						'<a href="javascript:void(0)" title="'
								+ messageInfo.deleteText
								+ '" class="a_b m_l10" id="deletePost">',
						messageInfo.deleteText, '</a>', '</span>', '</h3>'];
				jq(h3.join('')).appendTo(div);
				div.appendTo(this.context);
				this.bindEvent();
			}
			var kkIm = "";
			if (this.options.kkPort && this.options.kkIp) {
				kkIm = this.options.kkIp + ":" + this.options.kkPort;
			}
			for (var i = 0; i < post.length; i++) {
				var org = this.findNodeByTagName(post[i], 'org')[0];
				var postLoginName = this.getNodeAttrByName(org, 'loginname')
						.trim();
				// 过滤回复者等于提问者的回复
				if (postLoginName == topicLoginName) {
					continue;
				};

				var userName = this.getNodeAttrByName(org, 'username'), postTime = this
						.getNodeAttrByName(post[i], 'time'), postId = this
						.getNodeAttrByName(post[i], 'id');

				var content = this.findNodeByTagName(post[i], 'content')[0];
				content = this.getNodeText(content)
				// alert("<img src=\"D:\\Program Files\\KK\Res\faces\big\7.gif\"
				// \/>");
				// content = content
				// .replace(/\/:007/g,
				// "<img src=\"D:\\Program Files\\KK\\Res\\faces\\big\\7.gif\"
				// \/>");
				var dl = ['<dl class="dl_f c">'];
				var user = '<span class="a1">{{username}}</span>';
				var time = '<span class="a2" style="float: right;">{{time}}</span>';
				if (kkIm) {
					var im = [
							'<A HREF="landray://im?u=',
							'{{loginname}}',
							'&t=0">',
							'<img src="http://',
							kkIm,
							'/kkonline/?p=0:',
							'{{loginname}}"',//
							' border="0" title="' + messageInfo.sendSession
									+ '"/> ', '</A>'].join('');
					dl.push(im);
				}
				var dt = ['<dt style = "padding-top:5px;padding-bottom:5px;">',
						'<input type="checkbox" name="fdKmsAskPostListForms[',
						'{{index}}',//
						'].fdId" style="margin-right:5px" value="',// 
						'{{fdid}}',//
						'"/>', //
						'{{content}}', //
						'</dt>'].join('');

				dl.push(user);
				dl.push(time);
				dl.push(dt);
				var hidden = [
						"<input type='hidden' name='fdKmsAskPostListForms[",
						"{{index}}",//
						"].fdPosterName' value='",
						"{{loginname}}",
						"'>",
						"<input type='hidden' name='fdKmsAskPostListForms[",
						"{{index}}",//
						"].docContent' value='",
						"{{content}}",//
						"'>",
						"<input type='hidden' name='fdKmsAskPostListForms[",
						"{{index}}",//
						"].fdPostTime' value='", //
						"{{time}}", //
						"'>"];
				dl = dl.concat(hidden);
				dl.push('</dl>');
				var htmlCode = dl.join('');
				htmlCode = htmlCode
						.replace(/\{\{loginname\}\}/g, postLoginName);
				htmlCode = htmlCode.replace(/\{\{username\}\}/g, userName);
				htmlCode = htmlCode.replace(/\{\{time\}\}/g, postTime);
				htmlCode = htmlCode.replace(/\{\{fdid\}\}/g, postId);
				htmlCode = htmlCode.replace(/\{\{content\}\}/g, content);
				htmlCode = htmlCode.replace(/\{\{index\}\}/g, KMS.Index);
				jq(htmlCode).insertAfter($('#megInfo'));
				KMS.Index++;
			}
		}
	});

	KMS.Kk2ask = kk2ask;

}(jQuery, window.top.document));
