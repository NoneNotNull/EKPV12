/*******************************************************************************
 * @author 杨帆
 * @version 1.2
 * 创建时间 2010-07-05
 * 修订记录 
 * 	2010-09-26 
 *  2011-08-05 修复当项目阶段达到100个以上的数目，页面损耗几十秒甚至假死的bug by yangf
 ******************************************************************************/
Com_RegisterFile ( "projecttable.js" );
Com_IncludeFile ( "data.js" );
// 用于生成工作英的ID生成计数
var ProjectItem_Id_Count = 1,

	// 一个ProjectTable的映射容器
	ProjectTableMap = {},

	ProjectTableImageStyle = Com_Parameter.ResPath + "style/default/icons";

/**
 * 项目表格对象的构造函数
 * @constructor
 */
function ProjectTable () {
	this.tbObj = null; // 所对应的表格对象
	this.items = []; // 工作项集合
	this.title = null; // 标题
	this.actions = []; // 操作集合
	this.referItem = null; // 基准行
	this.tmpRefDom = null; // 复制的基准行的DOM对象
	this.lastIndex = 0; // 项目表格的最后一个工作项的索引号
}

ProjectTable.FoldOnLoad = false;
ProjectTable.NoIndentLevel = 4; // 工作项处于该层次之后不再缩进；注：当值为<=0即所有层级都不缩进
ProjectTable.Version = "1.2"; 

ProjectTable.prototype = {
	
	/**
	 * 该方法用于初始化所操作的项目表格的所有工作项
	 * @param {String} tableId 项目表格对象的表格对象的ID
	 */
	init: function ( tableId ) {
		this.tbObj = document.getElementById ( tableId );
		var i, j, copyRefDom, item, trObj, tdObj, att, htmlCode;

		for ( i = 0; i < this.tbObj.rows.length; i++ ) {
			trObj = this.tbObj.rows[i];
			att = trObj.getAttribute ( "ProjectTable_ReferRow" );
			if ( att == "1" || att == "true" ) {
				if ( this.referItem == null ) {
					copyRefDom = trObj.cloneNode ( true ); // 复制基准行
					this.referItem = new ProjectItem ( null, null, copyRefDom );
					this.tmpRefDom = copyRefDom;
					this.tmpRefDom.style.display = "block";
					this.tbObj.deleteRow( i ); // 删除基准行
				}
				break;
			}
		}
		
		
		//i++; // 表格行标自增
		var thisItem, thatItem, thisTrObj, thatTrObj, thisArr, thatArr, diff, scriptObj, script,
			flag = 1, oneRow = (i == this.tbObj.rows.length - 1), rowIndex = i;
			
		if (oneRow) { // 当只有一个工作项的时候只初始化第一个项目对象 
			thisTrObj = this.tbObj.rows[i];
			thisItem = this.addWorkItem ( thisTrObj, thisTrObj.ProjectItem_ID, true );
			thisItem.wbs = thisTrObj.ProjectItem_WBS;
			return;
		}		
			
		for ( ; i < this.tbObj.rows.length - 1; i++ ) {
			thisTrObj = this.tbObj.rows[i];
			thatTrObj = this.tbObj.rows[i + 1];
			thisArr = thisTrObj.ProjectItem_WBS.split ( '.' );
			thatArr = thatTrObj.ProjectItem_WBS.split ( '.' );
			diff = thisArr.length - thatArr.length;
			if ( flag ) { // 添加第一个工作项
				thisItem = this.addWorkItem ( thisTrObj, thisTrObj.ProjectItem_ID, true );
				thisItem.wbs = thisTrObj.ProjectItem_WBS;
				flag = 0;
			}

			if ( diff == -1 ) {
				thatItem = thisItem.addChild ( thatTrObj, thatTrObj.ProjectItem_ID, true );
			} else if ( diff >= 0 ) {
				script = 'thisItem';
				for ( j = 0; j <= diff; j++ ) { // 拼接执行脚本
					script += '.parent';
				}
				scriptObj = eval ( script );

				if ( scriptObj ) {
					thatItem = scriptObj.addChild ( thatTrObj, thatTrObj.ProjectItem_ID, true);
				} else {
					thatItem = this.addWorkItem ( thatTrObj, thatTrObj.ProjectItem_ID, true);
				}
			}
			
			thatItem.wbs = thatTrObj.ProjectItem_WBS;
			thisItem = thatItem;
		}
		
		this.afterInit( rowIndex ); // 初始化后的操作
	},
	
	/**
	 * 对整个项目表格对象初始化完成之后的一些操作，尤其是为了改善页面展示的一些美观性。
	 * 譬如：需要对不同层级的子项目进行页面缩进等
	 * @param {Number} rowIndex 动态列表初始行号
	 */
	afterInit: function( rowIndex ) {
		var i = rowIndex, j, k, workItem, trObj, tdObj, level, tableId = this.tbObj.id;
		var allWorkItems = this.listAllWorkItems(); // 按顺序将所有的工作项对象存入数组
		for ( j = 0; i < this.tbObj.rows.length; i++, j++ ) {
			workItem = allWorkItems[j];
			trObj = this.tbObj.rows[i];
			for ( k = 0; k < trObj.cells.length; k++ ) {
				tdObj = trObj.cells[k];
				if ( tdObj.ProjectItem_WBS ) {
					if (workItem.level < ProjectTable.NoIndentLevel ) {
						level = workItem.level; // 保存需要缩进的层级
					} else {
						level = ProjectTable.NoIndentLevel;
					}
					tdObj.style.paddingLeft = level * 10 + 'px'; // 设置单元格左寸距
				}
				
				if ( tdObj.ProjectItem_Action ) { 
					ReplaceUtils.html ( tdObj, /!\{param:tableId\}/g, tableId ).html ( tdObj,
							/!\{param:itemId\}/g, workItem.id );
				}
			
				if ( tdObj.ProjectItem_Fold ) {
					var imgObj = tdObj.getElementsByTagName('img')[0];
					if ( ProjectTable.FoldOnLoad && workItem.hasChildItems() ) { // 判断是否默认展开项目阶段
						imgObj.src = ProjectTableImageStyle + '/plus.gif';
					} else {
						imgObj.src = ProjectTableImageStyle + '/minus.gif';
					}
					
					ReplaceUtils.html ( tdObj, /!\{param:tableId\}/g, tableId ).html ( tdObj,
							/!\{param:itemId\}/g, workItem.id );
				}
			}
		}
		this.refresh();
	},
	
	/**
	 * 刷新项目表格
	 */
	refresh: function () {
		var i, j, k, trObj, tdObj, breakWorkItem, hierarchy,
			projectItems = this.items, imgObj;

		for ( i = 0; i < projectItems.length; i++ ) {
			hierarchy = new Array ();
			projectItems[i].listHierarchyItems ( hierarchy );
			for ( j = 0; j < hierarchy.length; j++ ) {
				breakWorkItem = hierarchy[j];
				breakWorkItem.calculateWbs (); // 重新计算工作项的WBS编码
				trObj = breakWorkItem.htmlDom;
				for ( k = 0; k < trObj.cells.length; k++ ) {
					tdObj = trObj.cells[k];

					if ( tdObj.ProjectItem_WBS ) {
						// ReplaceUtils.html ( tdObj, /(\d\.?)+/g,
						// breakWorkItem.wbs );
						var span = tdObj.getElementsByTagName ( 'span' )[0];
						span.innerHTML = breakWorkItem.wbs;
					} 
				}

				ReplaceUtils.fieldName ( breakWorkItem.htmlDom, 'input', /\d+/g,
						breakWorkItem.realIndex );

				// 接着刷新表单域中的值/
				ReplaceUtils.replacement['id'] = breakWorkItem.fdId;
				ReplaceUtils.replacement['pid'] = (breakWorkItem.parent)
						? breakWorkItem.parent.fdId
						: '';
				ReplaceUtils.replacement['index'] = breakWorkItem.realIndex;
				ReplaceUtils.replacement['wbs'] = breakWorkItem.wbs;
				ReplaceUtils.fieldValue ( trObj, 'input' );

			}
		}
	},

	/**
	 * 向项目表格里添加工作项
	 * @param {HTMLTableRowElement} htmlDom
	 * @param {String} fdId
	 * @retun {ProjectItem}
	 */
	addWorkItem: function ( htmlDom, fdId, isInit) {
		var newItem, copyItemDom, newItemDom, tdObj, htmlCode, att,
			tableId = this.tbObj.id;

		if ( !htmlDom ) {
			// 用于复制工作项的DOM对象
			copyItemDom = this.tmpRefDom.cloneNode ( true );
			newItemDom = this.tbObj.tBodies[0].appendChild ( copyItemDom );
			newItemDom.setAttribute ( "ProjectItem", "true" );
		} else {
			newItemDom = htmlDom;
		}

		newItemDom.setAttribute ( "ProjectTable_ReferRow", "0" );
		newItem = new ProjectItem ( ++this.lastIndex, null, newItemDom, this, fdId ); // 每次添加工作项，项目集的最后一个工作项的索引自增一次
		newItem.id = ["ProjectItem", this.tbObj.id, (ProjectItem_Id_Count++)].join ( "_" );
		// addFdIdToWorkItem( newItem ); // 添加FdId
		this.items.push ( newItem );
		newItem.refreshRealIndexes ();

		for ( var i = 0; i < newItemDom.cells.length; i++ ) {
			tdObj = newItemDom.cells[i];
			if ( tdObj.ProjectItem_WBS ) {
				tdObj.innerHTML = tdObj.innerHTML + "<span>" + newItem.wbs + "</span>";
			} 
			
			if ( tdObj.ProjectItem_Action ) { 
				ReplaceUtils.html ( tdObj, /!\{param:tableId\}/g, tableId ).html ( tdObj,
						/!\{param:itemId\}/g, newItem.id );
			}
		}
		
		ReplaceUtils.fieldName ( newItemDom, 'input', /!\{index\}/g, newItem.realIndex );
		if (!isInit) {
			this.refresh ();
		}
		return newItem;
	},

	/**
	 * 添加工作项的子工作项
	 * @param {String} workItemId
	 */
	addChildItem: function ( workItemId ) {
		var workItem = this.findItem ( workItemId );
		return workItem.addChild ( );
	},

	removeChildItem: function ( workItemId ) {
		var parent, breakWorkItem, tBodyObj, i,
			hierarchy = [];
		breakWorkItem = this.findItem ( workItemId );

		parent = breakWorkItem.parent;
		if ( !parent ) {
			breakWorkItem.listHierarchyItems ( hierarchy );
			tBodyObj = this.tbObj.tBodies[0];
			for ( i = 0; i < hierarchy.length; i++ ) { // 再取出一个将要移动的HtmlDom数组
				tBodyObj.removeChild ( hierarchy[i].htmlDom ); // 从表格中删除对应工作项的DOM元素
			}

			ArrayUtil.remove ( this.items, breakWorkItem.index - 1 );
			breakWorkItem.refreshChildrenIndexes ( this.items, breakWorkItem.index - 1, '--' );
			breakWorkItem.refreshRealIndexes();
			this.refresh ();
			this.lastIndex--;
		} else {
			hierarchy = parent.removeChild ( breakWorkItem );
		}
		return hierarchy;
	},

	/**
	 * 通过工作项的ID，从ProjectTable中获取该工作项
	 * @param {String} workItemId
	 * @return {ProjectItem}
	 */
	findItem: function ( workItemId ) {

		var k = 0, len = this.items.length;
		for ( ; k < len; k++ ) {
			var aimeditem = this.items[k].fetchChildItem ( workItemId ); // 寻找目标工作项
			if ( aimeditem ) {
				return aimeditem;
			}
		}

		return null;
	},

	/**
	 * 将工作项向上移动
	 * @param {String} workItemId
	 * @param {Function} before 
	 * @param {Function} after
	 */
	moveItemUp: function ( workItemId, before, after ) {
		var hierarchy = [];
		if (before != null) before(); // 在执行以下代码之前调用函数before
		
		var workItem = this.findItem ( workItemId );
		if ( workItem ) {
			hierarchy = workItem.moveUp ();
		}
		
		if (after != null) after(); // 在执行以下代码之前调用函数before
		// 暴露数组对象2011-7-20 by yangf
		return hierarchy;
	},

	/**
	 * 将工作项向下移动
	 * @param {String} workItemId
	 * @param {Function} before 
	 * @param {Function} after
	 */
	moveItemDown: function ( workItemId, before, after ) {
		var hierarchy = [];
		if (before != null) before(); // 在执行以下代码之前调用函数before
		var workItem = this.findItem ( workItemId );
		if ( workItem ) {
			hierarchy = workItem.moveDown ();
		}
		
		if (after != null) after(); // 在执行以下代码之前调用函数before
		// 暴露数组对象2011-7-20 by yangf
		return hierarchy;
	},

	/**
	 * 将工作项向左移动
	 * @param {String} workItemId
	 * @param {Function} before 
	 * @param {Function} after
	 */
	moveItemLeft: function ( workItemId, before, after ) {
		if (before != null) before(); // 在执行以下代码之前调用函数before
		
		var workItem = this.findItem ( workItemId );
		if ( workItem ) {
			workItem.moveLeft ();
		}
		
		if (after != null) after(); // 在执行以下代码之前调用函数before
	},

	/**
	 * 将工作项向右移动
	 * @param {String} workItemId
	 * @param {Function} before 
	 * @param {Function} after
	 */
	moveItemRight: function ( workItemId, before, after ) {
		if (before != null) before(); // 在执行以下代码之前调用函数before
		
		var workItem = this.findItem ( workItemId );
		if ( workItem ) {
			workItem.moveRight ();
		}
		
		if (after != null) after(); // 在执行以下代码之前调用函数before
	},

	/**
	 * 展开工作项或收起工作项
	 * @param {String} workItemId
	 * @param {Object} imgObj
	 * @param {Function} before
	 * @param {Function} after
	 */
	toggleFoldItems: function( workItemId, imgObj, before, after ) {
		if (before != null) before(); // 在执行以下代码之前调用函数before
		
		var workItem = this.findItem( workItemId );
		
		if ( workItem && workItem.hasChildItems() ) {
			if ( workItem.isFolded ) {
				workItem.unFold();
				imgObj.src = ProjectTableImageStyle + '/minus.gif';
			} else {
				workItem.fold();
				imgObj.src = ProjectTableImageStyle + '/plus.gif';
			}
		}
		
		if (after != null) after();  // 在执行以上代码之后调用函数after
	},

	/**
	 * 高亮区域工作项
	 * @param {String} workItemId
	 * @param {Boolean} flag
	 */
	highlightItems: function ( workItemId, flag ) {
		var workItem = this.findItem ( workItemId ),
			hierarchy = [], i;
		if ( workItem.isFolded ) {
			workItem.highlight ( flag, '#F5F6CE' );
		} else {
			workItem.listHierarchyItems ( hierarchy );
			for ( i = 0; i < hierarchy.length; i++ ) {
				hierarchy[i].highlight ( flag, '#F5F6CE' );
			}
		}
	},

	/**
	 * 移动行时的高高操作
	 * @param {String} workItemId
	 * @param {String} action:'left', 'right', 'up', 'down'
	 * @param {Boolean} flag
	 */
	moveWithHighlight: function ( workItemId, action, flag ) {
		var workItem = this.findItem ( workItemId ), previousItem, nextItem;

		if ( action == 'up' && (previousItem = workItem.previous ()) ) {
			var hierarchy1 = [],
				hierarchy2 = [], i, j;
			previousItem.listHierarchyItems ( hierarchy1 );
			workItem.listHierarchyItems ( hierarchy2 );

			for ( i = 0; i < hierarchy1.length; i++ ) {
				hierarchy1[i].highlight ( flag, '#E0E0E0' );
			}

			for ( j = 0; j < hierarchy2.length; j++ ) {
				hierarchy2[j].highlight ( flag, '#ccff99' );
			}

		} else if ( action == 'down' && (nextItem = workItem.next ()) ) {
			var hierarchy1 = [],
				hierarchy2 = [], i, j;
			nextItem.listHierarchyItems ( hierarchy1 );
			workItem.listHierarchyItems ( hierarchy2 );

			for ( i = 0; i < hierarchy1.length; i++ ) {
				hierarchy1[i].highlight ( flag, '#ccff99' );
			}

			for ( j = 0; j < hierarchy2.length; j++ ) {
				hierarchy2[j].highlight ( flag, '#E0E0E0' );
			}
		} else if ( action == 'left' && workItem.parent ) {
			var i, hierarchy = [];
			workItem.listHierarchyItems ( hierarchy );

			for ( i = 0; i < hierarchy.length; i++ ) {
				hierarchy[i].highlight ( flag, '#ccff99' );
			}

		} else if ( action == 'right' && workItem.previous () ) {
			var i, hierarchy = [];
			workItem.listHierarchyItems ( hierarchy );
			
			for ( i = 0; i < hierarchy.length; i++ ) {
				hierarchy[i].highlight ( flag, '#ccff99' );
			}
			
		}

	},
	
	/**
	 * 循环整个项目表格，将所有的工作项按顺序添加到一个数组中
	 */
	listAllWorkItems: function() {
		var i, j, k = 0, allWorkItems = [], len = this.items.length, tmpWorkItems;
		for (i = 0; i < len; i++) {
			tmpWorkItems = [];
			this.items[i].listHierarchyItems(tmpWorkItems);
			for (j = 0; j < tmpWorkItems.length; j++) {
				allWorkItems[k++] = tmpWorkItems[j];
			}
		}
		
		return allWorkItems;
	}

};

/**
 * @constructor
 * @param {Number} index 索引号
 * @param {ProjectItem} parent 父工作项
 * @param {HTMLTableRowElement} htmlDom HTMLDOM对象
 * @param {ProjectTable} projectTable 所属的工程表格
 */
function ProjectItem ( index, parent, htmlDom, projectTable, fdId ) {
	this.id = null;
	this.fdId = null;
	this.index = index || 1;
	this.realIndex = 0;
	this.parent = parent || null;
	this.htmlDom = htmlDom || null;
	this.action = []; // 操作集合
	this.projectTable = (this.parent != null) ? this.parent.projectTable : projectTable;
	this.wbs = null; // 工作分解结构编号
	this.children = []; // 直接的子工作项
	this.lastIndex = 0; // 工作项直接子项的最后一个索引号
	this.isFolded = ProjectTable.FoldOnLoad ? true : false; // 工作项是否展开，收起
	this.level = 0; // 标志工作项所在层次级别
	
	/**
	 * 初始化函数，即在使用new运算符初始化ProjectItem的时候的初始化操作 些成员函数为私有成员，外部函数不能引用
	 */
	var __init__ = function ( that ) {
		that.wbs = (that.parent != null) ? [that.parent.wbs, that.index].join ( "." ) : that.index;
		if ( fdId == null && fdId != "" ) {
			addFdIdToWorkItem ( that );
		} else {
			that.fdId = fdId;
		}
	};

	__init__ ( this );
}

ProjectItem.prototype = {

	/**
	 * 获取根工作项
	 */
	getRoot: function () {
		if ( this.parent ) {
			return this.parent.getRoot ();
		} else {
			return this;
		}
	},

	/**
	 * 获取当前工作项的前一个工作项
	 * @return {ProjectItem}
	 */
	previous: function () {
		// 当前工作项的前一个工作项
		if ( this.parent ) {
			return (this.index >= 2) ? this.parent.children[this.index - 2] : null;
		} else {
			return (this.index >= 2) ? this.projectTable.items[this.index - 2] : null;
		}
	},

	/**
	 * 获取当前工作项的后一个工作项
	 * @return {ProjectItem}
	 */
	next: function () {
		// 当前工作项的后一个工作项
		if ( this.parent ) {
			return (this.index >= 1) ? this.parent.children[this.index] : null;
		} else {
			return (this.index >= 1) ? this.projectTable.items[this.index] : null;
		}
	},

	/**
	 * 获取直接子层级最后一个子节点
	 * @return {ProjectItem}
	 */
	lastChild: function () {

		return (this.children.length >= 1) ? this.children[this.children.length - 1] : null;
	},

	/**
	 * 获取最后一个层级的子节点
	 * @return {ProjectItem}
	 */
	lastHierarchyChild: function () {
		if ( !this.hasChildItems () ) { // 判断是否拥有子工作项
			return this;
		} else {
			return this.children[this.children.length - 1].lastHierarchyChild ();
		}
	},

	/**
	 * 将指定的工作项的自身与所有的层级的子工作项列出来，存入一个数组里
	 * @param {Array} hierarchy 不能为空
	 * @return {Number} 返回层级数组的长度
	 */
	listHierarchyItems: function ( hierarchy ) {
		hierarchy.push ( this ); // 首先将指定的工作项加入层级数组中
		var i = 0, 
		len = this.children.length;
		
		for ( ; i < len; i++) {
			if ( this.children[i].hasChildItems () ) {
				this.children[i].listHierarchyItems ( hierarchy );
			} else {
				hierarchy.push ( this.children[i] );
			}
		}

		return hierarchy.length;
	},

	/**
	 * 该方法用于计算并取得工作项的WBS编号
	 * @return {String} 返回指定工作项的WBS编号
	 */
	calculateWbs: function () {
		this.wbs = (this.parent != null) ? [this.parent.wbs, this.index].join ( "." ) : this.index;
	},

	/**
	 * 给指定的工作项添加子工作项
	 * @param {HTMLTableRowElement} htmlDom
	 * @param {String} fdId
	 * @return {ProjectItem}
	 */
	addChild: function ( htmlDom, fdId, isInit ) {
		var copyItemDom, newItemDom, pos, i, tdObj, htmlCode, dom,
			tableId = this.projectTable.tbObj.id, level,
			// 插入子项的位置
			tmpRefDom = this.projectTable.tmpRefDom;
		if ( !htmlDom ) {
			// 将子工作项插入DOM节点当中
			copyItemDom = tmpRefDom.cloneNode ( true );
			// 将新节点插入到当前工作项的最后个层级节点后
			newItemDom = insertAfter ( copyItemDom, this.lastHierarchyChild ().htmlDom );
			newItemDom.setAttribute ( "ProjectItem", "true" );
		} else {
			newItemDom = htmlDom;
		}

		newItemDom.setAttribute ( "ProjectTable_ReferRow", "0" );
		// 新建子工作项，并将其添加入当前工作项的子集里
		var newItem = new ProjectItem ( ++this.lastIndex, this, newItemDom, this.projectTable, fdId );
		newItem.id = ["ProjectItem", tableId, (ProjectItem_Id_Count++)].join ( "_" );
		newItem.level = this.level + 1; // 设置子项目阶段的层级标志
		if (ProjectTable.FoldOnLoad) { // 判断子项目阶段是否默认隐藏
			newItemDom.style.display = 'none';
		}
		this.children.push ( newItem );
		this.refreshRealIndexes (); // 更新真实索引

		for ( i = 0; i < newItemDom.cells.length; i++ ) {
			tdObj = newItemDom.cells[i];
			if ( tdObj.ProjectItem_WBS ) { // 判断是否需要替换wbs编码
				tdObj.innerHTML = tdObj.innerHTML + "<span>" + newItem.wbs + "</span>";
				
				if (newItem.level < ProjectTable.NoIndentLevel ) {
					level = newItem.level; // 保存需要缩进的层级
				} else {
					level = ProjectTable.NoIndentLevel;
				}
				tdObj.style.paddingLeft = level * 10 + 'px'; // 设置单元格左寸距
			}
			
			if ( tdObj.ProjectItem_Action ) { 
				ReplaceUtils.html ( tdObj, /!\{param:tableId\}/g, tableId ).html ( tdObj,
						/!\{param:itemId\}/g, newItem.id );
			}
		}

		ReplaceUtils.fieldName ( newItemDom, 'input', /!\{index\}/g, newItem.realIndex );
		if (!isInit) {
			this.projectTable.refresh ();		
		}
		return newItem;
	},

	/**
	 * 从工作项中删除指定的子工作项
	 * @param {ProjectItem} child
	 */
	removeChild: function ( child ) {
		var hierarchy = [], tBodyObj;
		child.listHierarchyItems ( hierarchy );
		tBodyObj = this.projectTable.tbObj.tBodies[0];
		
		var k = 0, len = hierarchy.length;
		for ( ; k < len; k++ ) { // 再取出一个将要移动的HtmlDom数组
			tBodyObj.removeChild ( hierarchy[k].htmlDom ); // 从表格中删除对应工作项的DOM元素
		}
		ArrayUtil.remove ( this.children, child.index - 1 );

		this.refreshChildrenIndexes ( this.children, child.index - 1, '--' );
		this.refreshRealIndexes (); // 更新真实索引
		this.projectTable.refresh ();
		this.lastIndex--;
		
		return hierarchy;
	},

	/**
	 * 通过Item的ID项，从指定的工作项中，批到目标子工作项
	 * @param {String} id
	 * @return {ProjectItem}
	 */
	fetchChildItem: function ( id ) {
		var tmp, len = this.children.length;
		if ( this.id == id ) {
			return this;
		} else {
			for ( var k = 0; k < len; k++ ) {
				tmp = this.children[k].fetchChildItem ( id );
				if ( tmp ) return tmp;
			}
		}
	},

	/**
	 * 判断工作项是否包含子工作项集合
	 * @return {Boolean}
	 */
	hasChildItems: function () {

		return ((this.children.length != 0) ? true : false);
	},

	/**
	 * 在指定的ProjectTable里，向上移动指定工作项位置
	 */
	moveUp: function () {
		var hierarchy = [],
			hierarchyDom = [],
			previousItem = this.previous ();
		if ( previousItem ) {
			var prevDom = previousItem.htmlDom;
			var lastHierarchyChild = this.lastHierarchyChild (); // 取得当前一个工作项的最后一个层级子工作项
			hierarchy.push ( lastHierarchyChild );
			previousItem.listHierarchyItems ( hierarchy ); // 再将前一个工作项的所有层级工作项加入一个数组中

			var len = hierarchy.length;
			for ( var k = 0; k < len; k++ ) { // 再取出一个将要移动的HtmlDom数组
				hierarchyDom[k] = hierarchy[k].htmlDom;
			}

			moveElemsAfterFirst ( hierarchyDom );
			swapWorkItem ( previousItem, this, (this.parent != null)
							? this.parent.children
							: this.projectTable.items );
			this.refreshRealIndexes (); // 更新真实索引
			this.projectTable.refresh (); // 刷新工作项表
		}
		// 暴露数组对象2011-7-20 by yangf
		return hierarchy;
	},

	/**
	 * 在指定的ProjectTable里，向下移动指定工作项位置
	 */
	moveDown: function () {
		var hierarchy = [],
			hierarchyDom = [],
			nextItem = this.next ();
		if ( nextItem ) {
			var nextDom = nextItem.htmlDom;
			var lastHierarchyChild = nextItem.lastHierarchyChild (); // 取得后一个工作项的最后一个层级子工作项
			hierarchy.push ( lastHierarchyChild );
			this.listHierarchyItems ( hierarchy ); // 再将当前工作项的所有层级工作项加入一个数组中

			var len = hierarchy.length;
			for ( var k = 0; k < len; k++ ) { // 再取出一个将要移动的HtmlDom数组
				hierarchyDom[k] = hierarchy[k].htmlDom;
			}

			moveElemsAfterFirst ( hierarchyDom );
			swapWorkItem ( this, nextItem, (this.parent != null)
							? this.parent.children
							: this.projectTable.items );
			this.refreshRealIndexes (); // 更新真实索引
			this.projectTable.refresh (); // 刷新工作项表
		}
		// 暴露数组对象2011-7-20 by yangf
		return hierarchy;
	},

	/**
	 * 在指定的ProjectTable里，向左移动指定工作项位置
	 */
	moveLeft: function () {
		var parentLastHierarchyChild,
			hierarchy = [],
			hierarchyDom = [];

		if ( this.parent ) { // 只有具有父工作节点的工作项才能够进行升级操作
			parentLastHierarchyChild = this.parent.lastHierarchyChild ();
			hierarchy.push ( parentLastHierarchyChild );
			this.listHierarchyItems ( hierarchy );

			var len = hierarchy.length;
			for ( var k = 0; k < len; k++ ) { 
				hierarchyDom[k] = hierarchy[k].htmlDom;
			}

			moveElemsAfterFirst ( hierarchyDom );
			this.rebuildHierarchyRalation ( 'left' ); // 重建层级关系
			this.refreshRealIndexes (); // 更新真实索引
			this.projectTable.refresh (); // 刷新工作项表
		}
	},

	/**
	 * 在指定的ProjectTable里，向右移动指定工作项位置
	 */
	moveRight: function () {
		var preSiblingLastHierarchyChild,
			hierarchy = [],
			hierarchyDom = [];

		if ( this.previous () ) { // 仅当前工作项前有一个兄弟节点才能进行降级操作
			preSiblingLastHierarchyChild = this.previous ().lastHierarchyChild ();
			hierarchy.push ( preSiblingLastHierarchyChild );
			this.listHierarchyItems ( hierarchy );

			var len = hierarchy.length;
			for ( var k = 0; k < len; k++ ) { 
				hierarchyDom[k] = hierarchy[k].htmlDom;
			}
			
			moveElemsAfterFirst ( hierarchyDom );
			this.rebuildHierarchyRalation ( 'right' );
			this.refreshRealIndexes (); // 更新真实索引
			this.projectTable.refresh (); // 刷新工作项表
		}
	},

	/**
	 * 重建工作项的层级关系
	 * @param {String} type
	 * @description type类型包括："left":升级操作;"right":降级操作
	 */
	rebuildHierarchyRalation: function ( type ) {
		var preParent,
			preSibling = this.previous (),
			opt = type.toLowerCase ();
		if ( opt == "left" ) {
			if ( this.parent ) {
				ArrayUtil.remove ( this.parent.children, this.index - 1 ); // 解除原有的父子关系
				this.parent.lastIndex--;
				this.refreshChildrenIndexes ( this.parent.children, this.index - 1, '--' );

				preParent = this.parent.parent;

				if ( preParent ) { // 建立新的父子关系
					ArrayUtil.merge ( preParent.children, this.parent.index, this );
					preParent.lastIndex++;
					this.refreshChildrenIndexes ( preParent.children, this.parent.index, '++' );

				} else {
					ArrayUtil.merge ( this.projectTable.items, this.parent.index, this );
					this.refreshChildrenIndexes ( this.projectTable.items, this.parent.index, '++' );
					this.projectTable.lastIndex++;
				}

				this.parent = preParent;

			}
		} else if ( opt == "right" ) {
			if ( this.parent ) {
				ArrayUtil.remove ( this.parent.children, this.index - 1 );
				this.parent.lastIndex--;
				this.refreshChildrenIndexes ( this.parent.children, this.index - 1, '--' );
			} else {
				ArrayUtil.remove ( this.projectTable.items, this.index - 1 );
				this.projectTable.lastIndex--;
				this.refreshChildrenIndexes ( this.projectTable.items, this.index - 1, '--' );
			}

			if ( preSibling ) { // 当前工作项有前一个兄弟节点
				preSibling.children.push ( this );
				this.refreshChildrenIndexes ( preSibling.children, preSibling.children.length - 1,
						'++' )
				this.parent = preSibling;
				preSibling.lastIndex++; // 子节点最后一个节点序号自增
			}
		}
	},

	/**
	 * 更新子工作集的索引
	 * @param {Array} projectItems
	 * @param {Number} index
	 * @param {String} type
	 * @description type类型包括：'++':索引号+1;'--':索引号-1
	 */
	refreshChildrenIndexes: function ( projectItems, index, type ) {
		var i, htmlCode;
		for ( i = projectItems.length - 1; i >= index; i-- ) {
			if ( type == '++' ) {
				projectItems[i].index = i + 1;
			} else if ( type == '--' ) {
				projectItems[i].index--;
			}
		}

	},

	/**
	 * 更新工作项的真实索引
	 */
	refreshRealIndexes: function () {
		var i, j, hierarchy,
			count = 0,
			baseWorkItems = this.projectTable.items;
		for ( i = 0; i < baseWorkItems.length; i++ ) {
			hierarchy = new Array ();
			var tmp = baseWorkItems[i].listHierarchyItems ( hierarchy );
			for ( j = 0; j < hierarchy.length; j++ ) {
				hierarchy[j].realIndex = count++;
			}
		}
	},

	/**
	 * 收起展开的工作项
	 */
	fold: function () {
		var hierarchy = [], tbCells, tdObj, imgObj;
		//var len = hierarchy.length;
		var len = this.listHierarchyItems ( hierarchy ) - 1;
		hierarchy.shift (); // 将第一个元素弹出数组
		for ( var k = 0; k < len; k++ ) {
			hierarchy[k].isFolded = true;
			hierarchy[k].htmlDom.style.display = "none";
			tbCells = hierarchy[k].htmlDom.cells;
			for ( var j  = 0; j < tbCells.length; j++ ) {
				tdObj = tbCells[j];
				var imgObj = tdObj.getElementsByTagName('img')[0];
				if ( tdObj.ProjectItem_Fold ) {
					imgObj.src = ProjectTableImageStyle + '/plus.gif';
				}
			}
		}

		this['isFolded'] = true;
	},

	/**
	 * 展开工作项
	 */
	unFold: function () {
		var hierarchy = [], tbCells, tdObj, imgObj;
		//var len = hierarchy.length;
		var len = this.listHierarchyItems ( hierarchy ) - 1;
		hierarchy.shift (); // 将第一个元素弹出数组
		for ( var k = 0; k < len; k++ ) {
			hierarchy[k].isFolded = false;
			hierarchy[k].htmlDom.style.display = "block";
			tbCells = hierarchy[k].htmlDom.cells;
			for ( var j  = 0; j < tbCells.length; j++ ) {
				tdObj = tbCells[j];
				var imgObj = tdObj.getElementsByTagName('img')[0];
				if ( tdObj.ProjectItem_Fold ) {
					imgObj.src = ProjectTableImageStyle + '/minus.gif';
				}
			}
		}

		this['isFolded'] = false;
	},

	/**
	 * 将工作项高亮
	 * @param {Boolean} flag
	 * @param {Boolean} highlight 用于高亮的颜色
	 */
	highlight: function ( flag, highlight ) {

		if ( flag ) {
			setCssStyle ( this.htmlDom, 'background-color', highlight );
		} else {
			setCssStyle ( this.htmlDom, 'background-color', 'white' );
		}
	}

};

var ReplaceUtils = {

	replacement: {
		'id': null,
		'index': null,
		'pid': null,
		'wbs': null
	},

	/**
	 * 正则替换域名称
	 * @param {HTMLElement} envObj 所要替换的域所处的Html对象
	 * @param {RegExp} regex 正则表达式
	 * @param {Object} replaceValue 替换的值
	 * @return {ReplaceUtils}
	 */
	html: function ( envObj, regex, replaceValue ) {
		envObj.innerHTML = envObj.innerHTML.replace ( regex, replaceValue );
		return this;
	},

	/**
	 * 正则替换域名称
	 * @param {HTMLElement} envObj 所要替换的域所处的Html对象
	 * @param {String} tag 域标签名称
	 * @param {RegExp} regex 正则表达式
	 * @param {Object} replaceValue 替换的值
	 */
	fieldName: function ( envObj, tag, regex, replaceValue ) {
		var i, fieldName,
			fields = envObj.getElementsByTagName ( tag ),
			len = fields.length;
		for ( i = 0; i < len; i++ ) {
			if ( fields[i].name == null || fields[i].name == '' ) continue;
			fieldName = fields[i].name.replace ( regex, replaceValue );
			if ( Com_Parameter.IE ) {
				fields[i].outerHTML = fields[i].outerHTML.replace ( 'name=' + fields[i].name,
						'name=' + fieldName );
			} else {
				fields[i].name = fieldName;
			}
		}
	},

	/**
	 * 正则替换域值
	 * @param {HTMLElement} envObj 所要替换的域所处的Html对象
	 * @param {String} tag 域标签名称
	 */
	fieldValue: function ( envObj, tag ) {
		var i, k,
			fields = envObj.getElementsByTagName ( tag );

		fieldLoop: for ( i = 0; i < fields.length; i++ ) {
			if ( fields[i].name == null || fields[i].name == '' ) continue;
			for ( k in this.replacement ) {
				if ( (fields[i].ProjectItem_Replacement) == k && (this.replacement[k] != null) ) { // 当域具有ProjectItem_Replacement属性的时候替换值
					fields[i].value = this.replacement[k];
					continue fieldLoop;
				}
			}
		}
	}
};

/**
 * 全局的ID生成器
 */
var IdGenerator = {

	// 装纳生成的所有的ID的容器
	container: [],

	// 标记ID容器的ID被取出的位置
	index: 0,

	/**
	 * 发送Ajax请求，获取100个新的Id，加入一个容器内
	 */
	get32BitIds: function () {
		var hashArray,
			kmssData = new KMSSData ();
		var that = this;
		kmssData.SendToBean ( 'XMLGetRadomIdService&count=100', function ( rtnVal ) {
					hashArray = rtnVal.data;
					if ( hashArray.length > 0 ) {
						for ( var k in hashArray ) {
							that.container[k] = hashArray[k]['value'];
						}
					}
				} );

	},

	/**
	 * 从ID容器中取得一个ID
	 */
	fetch: function () {
		return this.container[this.index++];
	},

	/**
	 * 判断ID容器是否被取空，如果为空，就将容器置空
	 */
	empty: function () {
		var flag;
		if ( this.index == 100 ) {
			this.container = [];
			flag = true;
		} else
			flag = false;

		return flag;
	}

};

/**
 * 数组工具类
 * @type
 */
var ArrayUtil = {

	/**
	 * 删除数组内指定索引的元素
	 * @param {Array} arrayObject
	 * @param {Number} index
	 * @return {Object}
	 */
	remove: function ( arrayObject, index ) {
		var rt, i;
		if ( isNaN ( index ) || index >= arrayObject.length ) {
			rt = false;
		} else if ( index == 0 ) {
			rt = arrayObject.shift ();
		} else if ( index == arrayObject.length - 1 ) {
			rt = arrayObject.pop ();
		} else {
			rt = arrayObject[index];
			for ( i = index; i < arrayObject.length; i++, index++ ) {
				arrayObject[index] = arrayObject[i + 1];
			}
			arrayObject.length--;
		}

		return rt;
	},

	/**
	 * 向数组指定索引添加元素
	 * @param {Array} arrayObject
	 * @param {Number} index
	 * @param {Object} elems
	 */
	merge: function ( arrayObject, index, elems ) {
		var i,
			rt = elems;
		if ( isNaN ( index ) ) {
			rt = false;
		} else if ( index <= 0 ) {
			arrayObject.unshift ( elems );
		} else if ( index >= arrayObject.length ) {
			arrayObject.push ( elems );
		} else {
			arrayObject.length++;
			for ( i = arrayObject.length - 1; i > index; i-- ) {
				arrayObject[i] = arrayObject[i - 1];
			}
			arrayObject[index] = elems;
		}

		return rt;
	}

}

/*
 * 以下为工具类函数
 */

/**
 * 交换DOM元素之间的位置
 * @param {Element} prevElem
 * @param {Element} nextElem
 */
function swapElem ( prevElem, nextElem ) {
	var parentElem, prevSb, nextSb;
	parentElem = prevElem.parentNode; // 取得父节点
	prevSb = prevElem.nextSibling; // 前一个节点的下个兄弟节点
	nextSb = nextElem.nextSibling; // 后一个节点的下个兄弟节点

	if ( prevSb ) {
		parentElem.insertBefore ( nextElem, prevSb );
	} else {
		parentElem.appendChild ( nextElem );
	}

	if ( nextSb ) {
		parentElem.insertBefore ( prevElem, nextSb );
	} else {
		parentElem.appendChild ( prevElem );
	}
}

/**
 * 将DOM类型的数组内的元素按顺序插入到第一个元素之后
 * @param {Array} elems
 */
function moveElemsAfterFirst ( elems ) {

	for ( var i = 0; i < elems.length - 1; i++ ) {
		insertAfter ( elems[i + 1], elems[i] );
	}
}

/**
 * 交换两个工作项在ProjectTable里的位置
 * @param {ProjectItem} prev
 * @param {ProjectItem} next
 * @param {Array} items
 */
function swapWorkItem ( prev, next, items ) {
	var tmpItem, tmpIndex, tmpWbs, prevK, nextK;

	for ( var k in items ) {
		if ( items[k] == prev ) prevK = k;
		if ( items[k] == next ) nextK = k;
	}

	tmpItem = items[prevK];
	items[prevK] = items[nextK];
	items[nextK] = tmpItem;

	tmpIndex = items[prevK].index;
	items[prevK].index = items[nextK].index;
	items[nextK].index = tmpIndex;

}

/**
 * 拓展insertAfter方法，用于将新的节点元素添加在目标DOM元素的后面
 * @param {Element} newElem
 * @param {Element} targetElem
 * @return {Element}
 */
function insertAfter ( newElem, targetElem ) {
	var parentElem = targetElem.parentNode;

	if ( parentElem.lastChild == targetElem ) {
		parentElem.appendChild ( newElem );
	} else {
		parentElem.insertBefore ( newElem, targetElem.nextSibling );
	}

	return newElem;
}

/**
 * 设置HTML元素的样式
 * @param {HTMLElement} obj
 * @param {String} style
 * @param {String} styleValue
 */
function setCssStyle ( obj, style, styleValue ) {
	var tmp,
		ind = style.indexOf ( '-' );
	if ( ind ) { // ind > 0
		tmp = style.split ( '' );
		tmp[ind + 1] = tmp[ind + 1].toUpperCase ();
		ArrayUtil.remove ( tmp, ind );
		style = tmp.join ( '' );
	}
	obj.style[style] = styleValue;
}

/**
 * 向工作项中添加FdId
 * @param {ProjectItem} workItem
 */
function addFdIdToWorkItem ( workItem ) {
	if ( IdGenerator.empty () ) { // 如果容器为空，重新申请100个随机ID存入容器
		IdGenerator.get32BitIds ();
	} else {
		workItem.fdId = IdGenerator.fetch ();
	}
}

/**
 * 从ProjectTableMap中获取指定ID的ProjectTable对象
 * @param {String} id
 * @return {ProjectTable}
 */
function $projectTable ( id ) {

	for ( var k in ProjectTableMap ) {
		if ( k == id ) {
			return ProjectTableMap[k];
		}
	}

}

/**
 * 初始化页面中所有的ProjectTable，即页面中具有属性ProjectTable的表格
 */
function $projectTableMapInit () {
	var projectTable,
		tables = document.all.tags ( "table" );
	for ( var k in tables ) {
		if ( tables[k].ProjectTable ) {
			projectTable = new ProjectTable ();
			projectTable.init ( tables[k].id );
			// 将初始化后的projectTable放入容器内
			ProjectTableMap[tables[k].id] = projectTable;
		}
	}
}

/**
 * 初始化ProjectItem fdId生成器的环境
 */
function $projectItemIdEnvInit () {
	IdGenerator.get32BitIds (); // 先获取100个随机fdId
}

window.attachEvent ( 'onload', $projectItemIdEnvInit );
window.attachEvent ( 'onload', $projectTableMapInit );