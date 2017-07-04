/*
 * 文件: datagrid.js 描述: - 引用这个库用于ajax展现数据列表 - 所有的可配置的参数参照DataGrid类的options说明 日期:
 * 2011年3月26日 作者: yangf copyright: Copyright (c) 2001-2011 [Landray]
 * 
 * 依赖文件: - lib\mootools.js 版本： - v1.1.0 修改loading样式等 20110408 - v1.0.0 创建文件
 * 20110326
 */
Com_IncludeFile("datagrid_lang.jsp", KMS.basePath+"/multidoc/resource/js/datagrid/", 'js',true);

var DataGrid = new Class({
	Implements : [Events, Options],
	
	options : {
		showHeader : true,
		selectable : false,
		checkList : [],
		showIndex : true,
		rowcursor : 'pointer',
		highlight : '#E7E7E7',
		dataUrlTarget : '_blank',
		serverSort : true,
		pagination : true,
		page : 1,
		perPageSizes : [5, 10, 20, 50],
		perPage : 10,
		maxpage : 20,
		autoRefresh : 0
		// autoRefresh大于0于，就会每隔指定的秒数进行一次刷新同步
	},

	initialize : function(container, filter, options) {
		this.setOptions(options || {});
		this.container = document.id(container);
		this.filter = document.id(filter);
		// this.container.setStyle('position', 'relative');
		if (!this.container.hasClass('datagrid'))
			this.container.addClass('datagrid');
		// invoke drawing datagrid API
		this.draw();
	},

	// main drawing API
	draw : function() {
		var columnCount = this.columnCount = this.options.columnModel
				? this.options.columnModel.length
				: 0;
		var columnKeys = this.columnKeys = [];
		// var countFix = 0;
		var table = this.table = new Element('table');
		// table.addClass('t_b') ;
		// table.setStyle('width','100%');
		var grid = this.grid = new Element('tbody');
		table.appendChild(grid);
		// draw datagrid's columns
		var thElem = this.columnHeader = new Element('tr');
		thElem.addClass('columnHeader');
		grid.appendChild(thElem);
		// show checkbox
		var bind = this;
		if (this.options.selectable) {
			var tdElem = new Element('td');
			tdElem.setStyle('width', '20pt');
			var checkBox = new Element('input', {
						type : 'checkbox'
					});
			checkBox.addEvent('click', function(event) {
						bind.onColumnCheck.apply(bind, [event, this]);
					});
			tdElem.appendChild(checkBox);
			thElem.appendChild(tdElem);
			// countFix++;
		}

		// show tableIndex
		if (this.options.showIndex) {
			var tdElem = new Element('td');
			tdElem.set('html', messageInfo.sort);
			tdElem.setStyle('width', '30pt');
			thElem.appendChild(tdElem);
		}

		for (var c = 0; c < columnCount; c++) {
			var columnModel = this.options.columnModel[c];
			var tdElem = new Element('td');
			tdElem.setAttribute('nowrap', 'nowrap');
			// tdElem.setAttribute('align','center');

			// tdElem.setStyle('nowrap','nowrap');
			// tdElem.setStyle('align','center');
			// if (!columnModel.width) columnModel.width = 100;

			if (!columnModel.dataType)
				columnModel.dataType = 'text';
			columnKeys[c] = {};
			columnKeys[c]['index'] = columnModel.dataIndex;
			columnKeys[c]['unit'] = columnModel.unit;

			tdElem.set('text', columnModel.header);
			tdElem.setStyle('width', columnModel.width);
			tdElem.store('dataType', columnModel.dataType);
			tdElem.store('column', c);
			tdElem.inject(thElem, 'bottom');

			if (columnModel.sort == undefined)
				columnModel.sort = 'ASC';
			if (columnModel.sort == false) {// 不能排序
				tdElem.setStyle('cursor', 'default');
				continue;
			}
			tdElem.addEvent('click', this.onColumnClick.bind(this));
			tdElem.addEvent('mouseover', this.onColumnOver.bind(this));
			tdElem.addEvent('mouseout', this.onColumnOut.bind(this));
		}

		// this.columnCount += countFix;
		// whether show grid header or not
		if (this.options.showHeader == false) {
			thElem.setStyle('display', 'none');
		}

		this.loadData();
		this.container.appendChild(table);

		// show pagination toolbar
		if (this.options.pagination) {
			var pToolBar = new Element('div');
			pToolBar.addClass('pToolBar');
			var infoBox = new Element('span');
			infoBox.addClass('pInfoBox');
			this.pToolBarInfo = infoBox;
			var ctrlBox = new Element('span');
			ctrlBox.addClass('pCtrlBox');
			var ctrl = '<div class="pGroup"><div class="pageFirst ctrlButton"></div><div class="pagePrev ctrlButton"></div></div>';
			ctrl += '<div class="pGroup"><div class="curPage"><input class="cpage" type="text" value="1" size="4"/> / <span></span></div></div>';
			ctrl += '<div class="pGroup"><div class="pageNext ctrlButton"></div><div class="pageLast ctrlButton"></div></div>';
			ctrl += '<div class="pGroup"><div class="pageReload ctrlButton"></div></div>';
			ctrl += '<div class="pGroup"><select class="cpSize" name="cpSize">';
			var isDefPerPage = false;
			this.options.perPageSizes.each(function(size) {
						if (size != this.perPage) {
							ctrl += '<option value="' + size + '">' + size
									+ '</option>';
						} else {
							isDefPerPage = true;
							ctrl += '<option selected="selected" value="'
									+ size + '">' + size + '</option>';
						}
					}, this.options);
			ctrl += '</select></div>';
			ctrlBox.set('html', ctrl);
			// 绑定分页事件
			ctrlBox.getElement('.pageFirst').addEvent('click',
					this.firstPage.bind(this));
			ctrlBox.getElement('.pagePrev').addEvent('click',
					this.prevPage.bind(this));
			ctrlBox.getElement('.pageNext').addEvent('click',
					this.nextPage.bind(this));
			ctrlBox.getElement('.pageLast').addEvent('click',
					this.lastPage.bind(this));
			ctrlBox.getElement('.pageReload').addEvent('click',
					this.refresh.bind(this));
			ctrlBox.getElement('.cpSize').addEvent('change',
					this.changePageSize.bind(this));
			this.cpageInputField = ctrlBox.getElement('input.cpage');
			this.cpageInputField.addEvent('keyup', this.changePage.bind(this));
			this.cpageTotal = ctrlBox.getElement('.curPage span');
			this.cpSizeSelector = ctrlBox.getElement('.cpSize');
			pToolBar.appendChild(infoBox);
			pToolBar.appendChild(ctrlBox);
			this.container.appendChild(pToolBar);
		}

		var auto = this.options.autoRefresh * 1000;
		if (auto > 0) {
			this.autoRefresh.periodical(auto, this);
		}
	},
	
	loadingBox : new Array(),

	// fetch dataset
	loadData : function() {
		var source = this.options.dataSource;
		if (!source.data)
			source.data = {};
		if (!source.para)
			source.para = {};
		if (this.options.serverSort) {
			source.para['sortOn'] = this.options.sortOn;
			source.para['sortBy'] = this.options.sortBy;
		}

		if (this.options.pagination) {
			source.para['currentPage'] = this.options.page;
			source.para['pageSize'] = this.options.perPage;
		}

		var data = Object.merge({}, source.data, source.para);
		var req = new Request.JSON({
					url : source.url,
					noCache : Browser.ie
				});
		req.addEvent('success', this.onDataLoad.bind(this));
		req.send({
					method : source.method || 'get',
					data : Object.toQueryString(data)
				});
	},

	getParameter : function() {
		var source = this.options.dataSource;
		if (source.data) {
			return source.data;
		}
		return {};
	},

	setParameter : function(param) {
		var source = this.options.dataSource;
		if (!source.data)
			source.data = {};
		if (param) {
			Object.append(source.data, param);
		}
	},

	onDataLoad : function(dataSet) {
		this.renderData(dataSet);
		this.fireEvent('dataload', [this, dataSet]);
	},

	showLoadingBox : function() {
		var mask = new Element('div');
		mask.addClass('loadingMask');
		mask.setStyle('opacity', 0.4);
		var loading = new Element('span');
		loading.addClass('loading');
		loading.inject(mask, 'bottom');
		this.container.appendChild(mask);
		// 设置遮罩层位置
		var _p = this.table.getPosition(this.container);
		var _d = this.table.getSize();
		var p = {
			x : _p.x - 5,
			y : _p.y - 5
		};
		var d = {
			x : _d.x + 10,
			y : _d.y + 10
		};
		mask.setPosition(p);
		mask.setStyles({
					width : d.x,
					height : d.y
				});
		loading.setStyles({
					left : (d.x - 100) / 2,
					top : (d.y - 50) / 2
				});
		this.loadingBox.push(mask);
	},

	showLoadingBox2 : function() {
		var mask = new Element('div');
		mask.addClass('loadingMask');
		mask.setStyle('opacity', 0.4);
		var loading = new Element('span');
		loading.addClass('loading');
		loading.inject(mask, 'bottom');
		this.filter.appendChild(mask);
		// 设置遮罩层位置
		var _p = this.filter.getPosition();
		var _d = this.filter.getSize();
		var p = {
			x : _p.x - 5,
			y : _p.y - 5
		};
		var d = {
			x : _d.x + 10,
			y : _d.y + 10
		};
		mask.setPosition(p);
		mask.setStyles({
					width : d.x,
					height : d.y
				});
		loading.setStyles({
					left : (d.x - 100) / 2,
					top : (d.y - 50) / 2
				});
		this.loadingBox2 = mask;
	},

	hideLoadingBox : function() {
		if (this.loadingBox[0]) {
			this.loadingBox[0].dispose();
		}
//		if (this.loadingBox2[0]) {
//			this.loadingBox2[0].dispose();
//		}
	},

	// ************************** Datarow Events ************************ //

	// fire when one data row is clicked
	onDataRowClick : function(event, elem) {
		var dataurl = elem.retrieve('dataurl');
		if (dataurl) {
			window.open(dataurl, this.options.dataUrlTarget);
		}
	},

	// fire when mouse is enter a data row
	onDataRowEnter : function(event, elem) {
		event.stopPropagation();
		var highlight = this.options.highlight;
		if (highlight && typeOf(highlight) == 'string') {
			elem.store('bgcolor', elem.getStyle('background-color'));
			elem.setStyle('background-color', highlight);
		}
		elem.setStyle('cursor', this.options.rowcursor);
	},

	// fire when mouse is leave a data row
	onDataRowLeave : function(event, elem) {
		event.stopPropagation();
		var bgcolor = elem.retrieve('bgcolor');
		elem.setStyle('background-color', bgcolor);
	},

	// ************************** Column Events ************************ //
	onColumnClick : function(event) {
		var elem = event.target;
		var ind = elem.retrieve('column');
		var columnModel = this.options.columnModel[ind];
		if (columnModel.sort == false)
			return;
		elem.removeClass(columnModel.sort);
		columnModel.sort = columnModel.sort == 'ASC' ? 'DESC' : 'ASC';
		elem.addClass(columnModel.sort);
		// sort and refresh
		this.sort(ind);
	},

	onColumnCheck : function(event, elem) {
		var chkboxList = this.grid.getElements('.datagridchkbox');
		var checkList = this.options.checkList;
		for (var i = 0, l = chkboxList.length; i < l; i++) {
			var chkbox = chkboxList[i];
			if (elem.checked) {
				chkbox.checked = true;
				checkList.include(chkbox.value);
			} else {
				chkbox.checked = false;
				checkList.erase(chkbox.value);
			}
		}
	},

	onColumnOver : function(event) {
		var elem = event.target;
		var ind = elem.retrieve('column');
		var columnModel = this.options.columnModel[ind];
		if (columnModel.sort == false)
			return;
		elem.addClass(columnModel.sort);
	},

	onColumnOut : function(event) {
		var elem = event.target;
		var ind = elem.retrieve('column');
		var columnModel = this.options.columnModel[ind];
		if (columnModel.sort == false)
			return;
		elem.removeClass(columnModel.sort);
	},

	// ************************** Sort & Pagination ************************ //
	sort : function(c) {
		if (c < 0 || c >= this.options.columnModel.length)
			return;
		var columnModel = this.options.columnModel[c];
		this.options.sortOn = columnModel.dataIndex;
		this.options.sortBy = columnModel.sort;
		this.refresh();
	},

	firstPage : function(event) {
		this.options.page = 1;
		this.cpageInputField.value = 1;
		this.refresh();
	},

	prevPage : function(event) {
		if (this.options.page > 1) {
			this.options.page--;
			this.cpageInputField.value = this.options.page;
			this.refresh();
		}
	},

	nextPage : function(event) {
		if ((this.options.page + 1) > this.options.maxpage)
			return;
		this.options.page++;
		this.cpageInputField.value = this.options.page;
		this.refresh();
	},

	lastPage : function(event) {
		this.options.page = this.options.maxpage;
		this.cpageInputField.value = this.options.page;
		this.refresh();
	},

	changePage : function(event) {
		var np = this.cpageInputField.value;
		if (np > 0 && np <= this.options.maxpage) {
			if (this.refreshDelayID) {
				clearTimeout(this.refreshDelayID);
			}
			this.options.page = np;
			this.refreshDelayID = this.refresh.delay(1000, this);
		}
	},

	changePageSize : function(event) {
		var cpSize = this.cpSizeSelector.value;
		this.options.perPage = cpSize;
		this.refresh();
	},

	// 删除记录
	deleteDataRows : function(baseURI) {
		var checkList = this.options.checkList;
		var rowsize = checkList.length;
		if (!rowsize) {
			showAlert(messageInfo.noSelectData);
			return;
		}
		var obj = new Object();
		obj = this;
		showConfirm(messageInfo.deleteMsg, function() {
					var id = [];
					for (var i = 0; i < rowsize; i++) {
						id[i] = 'List_Selected=' + checkList[i];
					}
					var ids = id.join('&');
					var request = new Request({
								url : baseURI,
								noCache : true
							});
					request.post(ids);
					request.addEvent('success', obj.onDeleteDataRows.bind(obj));
					obj.options.checkList = []; // 清空选项

				}, function() {
					return;
				});

	},
	// 得到选择的文档Id
	findSelectedDoc : function(baseURI) {
		var checkList = this.options.checkList;
		var rowsize = checkList.length;
		if (!rowsize) {
			showAlert(messageInfo.noSelectData);
			return null;
		}
		var values = "";
		for (var i = 0; i < rowsize; i++) {
			values += checkList[i];
			values += ",";
		}
		return values;

	},
	onDeleteDataRows : function(data) {
		this.refresh();
	},

	// Data rows checkbox
	onDataRowCheck : function(event, chkbox) {
		event.stopPropagation(); // 禁止click事件冒泡到上层DOM节点
		var value = chkbox.value;
		var checkList = this.options.checkList;
		if (chkbox.checked) {
			checkList.include(value);
		} else {
			checkList.erase(value);
		}
	},

	autoRefresh : function() {
		if (this.loaded) {
			this.loadData();
		}
	},

	refresh : function() {
		this.isRefresh = true;
		this.showLoadingBox();
		// this.showLoadingBox2();
		this.loadData();
	},

	renderData : function(data) {
		if (!data)
			return;
		if (this.loadingBox[0]) {
			sleep(100);
			this.hideLoadingBox();
			this.loadingBox.shift();
		}
		this.grid.getChildren().dispose();
		var bind = this;
		this.options.data = data.data;
		if (this.options.pagination) {
			this.options.total = data.total;
			if (this.options.total == undefined) {
				this.options.total = 0;// change value "undefined" to "0"
			}
			this.options.maxpage = Math.ceil(this.options.total
					/ this.options.perPage);
			this.pToolBarInfo.innerHTML = messageInfo.total.replace("{0}",this.options.total);
			this.cpageTotal.innerHTML = this.options.maxpage;
		}

		var rowCount = this.options.data ? this.options.data.length : 0;
		var fragment = document.createDocumentFragment();
		for (var c = 0; c < rowCount; c++) {
			var data = this.options.data[c];
			var trElem = new Element('tr');
			trElem.addClass('datarow');

			// show checkbox
			if (this.options.selectable && data['fdId']) {
				var tdElem = new Element('td');

				tdElem.setStyle('width', '30px');
				var checkBox = new Element('input', {
							type : 'checkbox',
							'class' : 'datagridchkbox',
							value : data['fdId']
						});
				checkBox.addEvent('click', function(event) {
							bind.onDataRowCheck.apply(bind, [event, this]);
						});
				tdElem.appendChild(checkBox);
				trElem.appendChild(tdElem);
			}

			// show index
			if (this.options.showIndex) {
				var tdElem = new Element('td');
				tdElem.set('html', '<span>' + (c + 1) + '</span>');
				trElem.appendChild(tdElem);
			}

			// load data
			var o = this;
			this.columnKeys.each(function(column) {
				var tdElem = new Element('td'), k = column.index, unit = column.unit;
				if (k != 'fdThumbnail' && k != 'fdImg' && data[k]) {
					var txt = unit ? [data[k], unit].join('') : data[k];
					tdElem.set('text', txt);
				}
				// set dataurl
				var dataurl = trElem.retrieve('dataurl');
				if (!dataurl && data['fdUrl']) {
					trElem.store('dataurl', data['fdUrl']);
				}

				if (k == 'fdImg' && data['fdImg']) {
					var img = new Element('img', {
								src : data['fdImg']
							});

					tdElem.appendChild(img);
				}

				// 添加缩略图 2011-04-20
				if (k == 'fdThumbnail' && data['fdThumbnail']) {
					var img = new Element('img', {
								src : data['fdThumbnail'],
								width : 50,
								height : 50
							});

					img.addEvent('mouseenter', onThumbnailMouseEnter);
					img.addEvent('mouseleave', onThumbnailMouseLeave);
					tdElem.appendChild(img);
				}
				tdElem.inject(trElem, 'bottom');
			});

			// binding datarow's event
			trElem.addEvent('click', this.onDataRowClick.bindWithEvent(this,
							trElem));
			trElem.addEvent('mouseenter', this.onDataRowEnter.bindWithEvent(
							this, trElem));
			trElem.addEvent('mouseleave', this.onDataRowLeave.bindWithEvent(
							this, trElem));

			fragment.appendChild(trElem);
		}
		// this.grid.getChildren().dispose();
		// this.hideLoadingBox();
		this.grid.appendChild(this.columnHeader);
		this.grid.appendChild(fragment);
		if (!this.loaded)
			this.loaded = true;
	}

		// //// 显示一些dialog /////////////////
});

var popup, img;
function showThumbnailPopup(src, x, y) {
	if (!popup) {
		popup = new Element('div');
		popup.addClass('thumbnailPop')
		img = new Element('img');
		popup.appendChild(img);
		document.id(document.body).appendChild(popup);
	}
	popup.setStyles({
				'left' : x,
				'top' : y,
				'display' : 'block'
			});
	img.setProperty('src', src);
}

function hideThumbnailPopup() {
	if (popup)
		popup.setStyle('display', 'none');
}

function onThumbnailMouseEnter(event) {
	var pos = this.getPosition();
	var scroll = document.id(document).getScroll();
	var x = pos.x, y = pos.y - 215;
	if (y - scroll.y < 0) {
		y = pos.y + 55;
	}
	showThumbnailPopup(this.src, x, y);
}

function onThumbnailMouseLeave(event) {
	hideThumbnailPopup();
}

function sleep(millis) {
	var date = new Date();
	var curDate = new Date();
	do {
		curDate = new Date();
	} while (curDate - date < millis);
}

function ampersand(first, last) {
	var ret = [first, last], jn = '';
	if (first != '' && last != '') {
		jn = '&';
	}
	return ret.join(jn);
}

function setParameter(url, param, value) {
	var re = new RegExp();
	re.compile("([&]" + param + "=)[^&]*", "i");
	if (value == null) {
		if (re.test(url)) {
			url = url.replace(re, "");
		}
	} else {
		value = encodeURIComponent(value);
		if (re.test(url)) {
			url = url.replace(re, "$1" + value);
		} else {
			url += "&" + param + "=" + value;
		}
	}
	if (url.charAt(0) == "&")
		url = url.substring(1);
	return url;
}