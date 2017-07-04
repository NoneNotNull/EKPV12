/**********************************************************
功能：缓存对象
备注：
	模糊浏览器对于大数据的存储本地的不同方法，提供统一调用模式。
作者：龚健
创建时间：2009-03-30
**********************************************************/
function Designer_Cache_Behavior() {
	this.search_order = ['gears', 'whatwg_db', 'localstorage', 'globalstorage', 'ie'];
	//支持不同浏览器和不同方法
	this.behavior = {
		//适用: webkit, Safari 3.1+
		//参考: http://code.google.com/apis/gears/api_database.html
		gears : {
			size         : -1,                                        //存储限制(必须)
			test         : _Designer_Cache_Gears_Test,                //检测浏览器(必须)
			init         : _Designer_Cache_Gears_Init,
			get          : _Designer_Cache_Gears_Get,
			set          : _Designer_Cache_Gears_Set,
			remove       : _Designer_Cache_Gears_Remove,
			transaction  : _Designer_Cache_Gears_Transaction          //提交事务
		},
		//适用: webkit, Safari 3.1+
		//参考: http://webkit.org/misc/DatabaseExample.html
		whatwg_db : {
			size         : 200 * 1024,                                //存储限制(必须)
			test         : _Designer_Cache_Whatwg_Test,               //检测浏览器(必须)
			init         : _Designer_Cache_Whatwg_Init,
			get          : _Designer_Cache_Whatwg_Get,
			set          : _Designer_Cache_Whatwg_Set,
			remove       : _Designer_Cache_Whatwg_Remove,
			transaction  : _Designer_Cache_Whatwg_Transaction         //提交事务
		},
		//适用: FF2+, IE8+
		//参考: http://developer.mozilla.org/en/docs/DOM:Storage#globalStorage
		globalstorage : {
			size         : 5 * 1024 * 1024,                           //存储限制(必须)
			test         : _Designer_Cache_Globalstorage_Test,        //检测浏览器(必须)
			init         : _Designer_Cache_Globalstorage_Init,
			key          : _Designer_Cache_Globalstorage_Key,
			get          : _Designer_Cache_Globalstorage_Get,
			set          : _Designer_Cache_Globalstorage_Set,
			remove       : _Designer_Cache_Globalstorage_Remove
		},
		//适用: FF2+, IE8+
		//参考: http://www.whatwg.org/specs/web-apps/current-work/#the-localstorage
		localstorage : {
			size         : -1,                                        //存储限制(必须)，此值不清楚
			test         : _Designer_Cache_Localstorage_Test,         //检测浏览器(必须)
			init         : _Designer_Cache_Localstorage_Init,
			key          : _Designer_Cache_Localstorage_Key,
			get          : _Designer_Cache_Localstorage_Get,
			set          : _Designer_Cache_Localstorage_Set,
			remove       : _Designer_Cache_Localstorage_Remove
		},
		ie : {
			size         : 64 * 1024,                                 //存储限制(必须)
			prefix       : '_dc_data-',
			test         : _Designer_Cache_IE_Test,                   //检测浏览器(必须)
			init         : _Designer_Cache_IE_Init,
			makeUserData : _Designer_Cache_IE_MakeUserData,
			get          : _Designer_Cache_IE_Get,
			set          : _Designer_Cache_IE_Set,
			load         : _Designer_Cache_IE_Load,
			save         : _Designer_Cache_IE_Save
		}
	};
};

/************************gears*************************/
function _Designer_Cache_Gears_Test() {
	return (window.google && window.google.gears) ? true : false;
};

function _Designer_Cache_Gears_Init() {
	var db;
	db = this.db = google.gears.factory.create('beta.database');
	db.open(this._esc(this.name));
	//创建表
	db.execute(this.sql.create).close();
};

function _Designer_Cache_Gears_Get(key, fn, scope) {
	var r, sql = this.sql.get;
	//若没有回调函数，则退出
	if (!fn) return;
	//开始执行
	this.transaction(function(t) {
		r = t.execute(sql, [key]);
		if (r.isValidRow())
			fn.call(scope || this, true, r.field(0));
		else
			fn.call(scope || this, false, null);
		r.close();
	});
};

function _Designer_Cache_Gears_Set(key, val, fn, scope) {
	var rm_sql = this.sql.remove, sql = this.sql.set, r;
	this.transaction(function(t) {
		t.execute(rm_sql, [key]).close();
		t.execute(sql, [key, val]).close();
		if (fn) fn.call(scope || this, true, val);
	});
};

function _Designer_Cache_Gears_Remove(key, fn, scope) {
	var get_sql = this.sql.get, sql = this.sql.remove, r, val;
	this.transaction(function(t) {
		//若有回调函数，则在删除前获得旧值
		if (fn) {
			r = t.execute(get_sql, [key]);
			if (r.isValidRow()) {
				val = r.field(0);
				t.execute(sql, [key]).close();
				fn.call(scope || this, true, val);
			} else {
				fn.call(scope || this, false, null);
			}
			r.close();
		} else {
			t.execute(sql, [key]).close();
		}
	});
};

function _Designer_Cache_Gears_Transaction(fn) {
	var db = this.db;
	//开始执行
	db.execute('BEGIN').close();
	//call回调函数
	fn.call(this, db);
	//提交变化
	db.execute('COMMIT').close();
};

/************************whatwg_db*************************/
function _Designer_Cache_Whatwg_Test() {
	return false;
//	var name = 'landray cache test', desc = 'landray database test.';
//	if (!window.openDatabase) return false;
//	if (!window.openDatabase(name, this.sql.version, desc, this.size)) return false;
//	return true;
};

function _Designer_Cache_Whatwg_Init() {
	var desc, size;
	desc = this.o.about || "landray storage for " + this.name;
	size = this.o.size || this.size;
	this.db = openDatabase(this.name, this.sql.version, desc, size);
};

function _Designer_Cache_Whatwg_Get(key, fn, scope) {
	var sql = this.sql.get;
	if (!fn) return;
	//获得回调函数作用对象
	scope = scope || this;
	this.transaction(function (t) {
		t.executeSql(sql, [key], function(t, r) {
			if (r.rows.length > 0)
				fn.call(scope, true, r.rows.item(0)['v']);
			else
				fn.call(scope, false, null);
		});
	});
};

function _Designer_Cache_Whatwg_Set(key, val, fn, scope) {
	var rm_sql = this.sql.remove, sql = this.sql.set;
	this.transaction(function(t) {
		t.executeSql(rm_sql, [key], function() {
			t.executeSql(sql, [key, val], function(t, r) {
				if (fn) fn.call(scope || this, true, val);
			});
		});
	});
	return val;
};

function _Designer_Cache_Whatwg_Remove(key, fn, scope) {
	var get_sql = this.sql.get, sql = this.sql.remove;
	this.transaction(function(t) {
		if (fn) {
			t.executeSql(get_sql, [key], function(t, r) {
				if (r.rows.length > 0) {
					var val = r.rows.item(0)['v'];
					t.executeSql(sql, [key], function(t, r) {
						fn.call(scope || this, true, val);
					});
				} else {
					fn.call(scope || this, false, null);
				}
			});
		} else {
			t.executeSql(sql, [key]);
		}
	});
};

function _Designer_Cache_Whatwg_Transaction(fn) {
	if (!this.db_created) {
		var sql = this.sql.create;
		this.db.transaction(function(t) {
			t.executeSql(sql, [], function() {
				this.db_created = true;
			});
		}, function(){});
	};
};

/************************globalstorage*************************/
function _Designer_Cache_Globalstorage_Test() {
	return window.globalStorage ? true : false;
};

function _Designer_Cache_Globalstorage_Init() {
	this.store = globalStorage[this.o.domain];
};

function _Designer_Cache_Globalstorage_Key(key) {
	return this._esc(this.name) + this._esc(key);
};

function _Designer_Cache_Globalstorage_Get(key, fn, scope) {
	key = this.key(key);
	if (fn) fn.call(scope || this, true, this.store.getItem(key));
};

function _Designer_Cache_Globalstorage_Set(key, val, fn, scope) {
	key = this.key(key);
	this.store.setItem(key, val);
	if (fn) fn.call(scope || this, true, val);
};

function _Designer_Cache_Globalstorage_Remove(key, fn, scope) {
	var val;
	//扩展Key
	key = this.key(key);
	//获得值
	val = this.store[key];
	//删除Key
	this.store.removeItem(key);
	if (fn) fn.call(scope || this, (val !== null), val);
};

/************************localstorage*************************/
function _Designer_Cache_Localstorage_Test() {
	return window.localStorage ? true : false;
};

function _Designer_Cache_Localstorage_Init() {
	this.store = window.localStorage;
};

function _Designer_Cache_Localstorage_Key(key) {
	return this._esc(this.name) + this._esc(key);
};

function _Designer_Cache_Localstorage_Get(key, fn, scope) {
	key = this.key(key);
	if (fn) fn.call(scope || this, true, this.store.getItem(key));
};

function _Designer_Cache_Localstorage_Set(key, val, fn, scope) {
	key = this.key(key);
	this.store.setItem(key, val);
	if (fn) fn.call(scope || this, true, val);
};

function _Designer_Cache_Localstorage_Remove(key, fn, scope) {
	var val;
	key = this.key(key);
	val = this.getItem(key);
	this.store.removeItem(key);
	if (fn) fn.call(scope || this, (val !== null), val);
};

/************************ie*************************/
function _Designer_Cache_IE_Test() {
	return window.ActiveXObject ? true : false;
};

function _Designer_Cache_IE_Init() {
	var id = this.prefix + this._esc(this.name);
	this.element = this.makeUserData(id);
	if (this.o.defer) this.load();
};

function _Designer_Cache_IE_MakeUserData(id) {
	var element = document.createElement('div');
	//设置属性
	element.id = id;
	element.style.display = 'none';
	element.addBehavior('#default#userData');
	//添加到Body
	document.body.appendChild(element);
	//返回对象
	return element;
};

function _Designer_Cache_IE_Get(key, fn, scope) {
	var val;
	key = this._esc(key);
	//载入数据
	if (!this.o.defer) this.load();
	//获得值
	val = this.element.getAttribute(key);
	//call回调函数
	if (fn) fn.call(scope || this, val ? true : false, val);
};

function _Designer_Cache_IE_Set(key, val, fn, scope) {
	key = this._esc(key);
	//设置属性
	this.element.setAttribute(key, val);
	//保存数据
	if (!this.o.defer) this.save();
	//call回调函数
	if (fn) fn.call(scope || this, true, val);
};

function _Designer_Cache_IE_Load() {
	this.element.load(this._esc(this.name));
};

function _Designer_Cache_IE_Save() {
	this.element.save(this._esc(this.name));
};

/**********************************************************
描述：
	存储对象定义
功能：
	
**********************************************************/
function Designer_Cache(name, options) {
	this.name = '';
	this.type = null;                                                //操作类型
	this.size = 0;                                                   //存储限制
	this.sql = null;                                                 //后台的SQL(gears和数据库时有用)

	//内部方法
	this._initSQL = _Designer_Cache_InitSQL;
	this._esc = _Designer_Cache_Esc;
	this._initBehavior = _Designer_Cache_InitBehavior;

	//公用方法
	this.initialize = Designer_Cache_Initialize;

	this.initialize(name, options);
};

function Designer_Cache_Initialize(name, options) {
	//获得SQL(为了兼容webkit, Safari)
	this._initSQL();
	//根据浏览器类型，获得相关方法
	this._initBehavior();
	//校验输入名的合法性
	if (!/^[a-z][a-z0-9_ -]+$/i.exec(name)) throw new Error("不可用的名称");
	//检测操作类型
	if (!this.type) throw new Error("没有找到合适的存储方法");
	//记录名称
	this.name = name;

	var o = options || {};
	//获得domain
	o.domain = o.domain || location.hostname || 'localhost.localdomain';
	//参数设置
	this.o = o;
	//两年后失效
	o.expires = o.expires || 365 * 2;

	//初始化
	this.init();
};

/**********************************************************
描述：
	内部调用函数
功能：
	_Designer_Cache_InitBehavior : 初始化对象
	_Designer_Cache_InitSQL      : 初始化SQL相关信息
	_Designer_Cache_Esc          : 替换命名中的空格
**********************************************************/
function _Designer_Cache_InitBehavior() {
	var cbehavior = new Designer_Cache_Behavior(), keys = cbehavior.search_order, behavior;
	for (var i = 0, length = keys.length; !this.type && i < length; i++) {
		behavior = cbehavior.behavior[keys[i]];
		if (behavior.test()) {
			this.type = keys[i];
			Designer.extend(true, this, behavior || {});
		}
	}
};

function _Designer_Cache_InitSQL() {
	this.sql = {
		version:  '1', //数据描述版本
		create : 'CREATE TABLE IF NOT EXISTS cache_data (k TEXT UNIQUE NOT NULL PRIMARY KEY, v TEXT NOT NULL)',
		get    : 'SELECT v FROM cache_data WHERE k = ?',
		set    : 'INSERT INTO cache_data(k, v) VALUES (?, ?)',
		remove : 'DELETE FROM cache_data WHERE k = ?' 
    }
};

function _Designer_Cache_Esc(str) {
	return 'dc' + str.replace(/_/g, '__').replace(/ /g, '_s');
};