/**
 * v1.1
 * easymilib.js是对easymicore.js的封装,屏蔽三种平台(模拟器，iOS,Android)的差异
 * 以后更新需要增加changeLog.
 *
 * changeLog
 * v1.2 2013-7-31
 *   1.规范所有接口的错误回调，在错误回调时，可以获取错误码和错误原因
 *   2.新增网络类型判断，可以判断当前网络是wifi还是数据网络(3g/2g)
 *   3.适配新的EasyMI模拟器，新的模拟器可以进行上传、下载、文件判断、本地db、文件目录判断等操作。(旧的模拟器也可以使用新的easymilib.js文件)
 *
 * v1.2.1 2013-9-27 
 *   1. 加入联系人操作相关API: Easymi.contact
 *
 * v1.2.2 2013-10-15 
 *   1. 加入微信分享相关API: Easymi.weixin
 * 
 * v1.2.3 2013-11-12
 *   录制视频success回调中增加一个结束类型endingType
 *
 * v1.2.4 2013-11-20
 *   拨打电话 api 增加一个参数: confirm, 用于决定是否进入拨号界面进行确认 (iOS上只能进入拨号界面, 不能直接拨打)
 *
 * v1.2.5 2013-12-09
 *   1.新增应用获取推送消息列表方法和删除一条推送消息方法
 *   2.新增快钱支付API
 *
 * v1.2.6 2013-12-13
 *   录制视频 api 增加一个参数: duration, 用于指定录制视频的时间
 * 
 * v1.2.7 2014-4-16
 *   修改phone.call方法，传递给native的confirm参数值
 * 
 * v1.2.8 2014-8-25
 *   添加 Easymi.contactor.chooseContactors方法, 可以从门户通讯录中选择联系人
 * 
 * v1.2.9 2014-9-1
 *   添加 Easymi.proxy.requestSetup方法, 可以为request设置默认参数
 */
var Easymi={
    /**
	 * detailLog表示是否需要记录详细日志。在业务代理访问和db操作时，返回的数据较多。
	 * 可通过detailLog这个标志标记是否记录这些数据,缺省为false,应用可以通过修改这个值，
	 * 增加更详细的日志信息。
	 */
	detailLog:false,
    defaultFailCallback:function(errCode,errMsg){
		if(Was.isEmulator){
			console.error("[Easymi.defaultFailCallback]code="+errCode+',msg='+errMsg);
		}else{//device no error method!xx
			console.debug("[Easymi.defaultFailCallback]code="+errCode+',msg='+errMsg);
		}
    }
};
Easymi.Utils={
    /**
     * Returns true if the passed value is empty, false otherwise. The value is deemed to be empty if it is either:
     *
     * - `null`
     * - `undefined`
     * - a zero-length array
     * - a zero-length string (Unless the `allowEmptyString` parameter is set to `true`)
     *
     * @param {Object} value The value to test
     * @param {Boolean} allowEmptyString (optional) true to allow empty strings (defaults to false)
     * @return {Boolean}
     * @markdown
     */
    isEmpty: function(value, allowEmptyString) {
        return (value === null) || (value === undefined) || (!allowEmptyString ? value === '' : false) || (Easymi.Utils.isArray(value) && value.length === 0);
    },

    /**
     * Returns true if the passed value is a JavaScript Array, false otherwise.
     *
     * @param {Object} target The target to test
     * @return {Boolean}
     * @method
     */
    isArray: ('isArray' in Array) ? Array.isArray : function(value) {
        return toString.call(value) === '[object Array]';
    },

    /**
     * Returns true if the passed value is a JavaScript Date object, false otherwise.
     * @param {Object} object The object to test
     * @return {Boolean}
     */
    isDate: function(value) {
        return toString.call(value) === '[object Date]';
    },

    /**
     * Returns true if the passed value is a JavaScript Object, false otherwise.
     * @param {Object} value The value to test
     * @return {Boolean}
     * @method
     */
    isObject: (toString.call(null) === '[object Object]') ?
        function(value) {
            // check ownerDocument here as well to exclude DOM nodes
            return value !== null && value !== undefined && toString.call(value) === '[object Object]' && value.ownerDocument === undefined;
        } :
        function(value) {
            return toString.call(value) === '[object Object]';
        },

    /**
     * Returns true if the passed value is a JavaScript 'primitive', a string, number or boolean.
     * @param {Object} value The value to test
     * @return {Boolean}
     */
    isPrimitive: function(value) {
        var type = typeof value;

        return type === 'string' || type === 'number' || type === 'boolean';
    },

    /**
     * Returns true if the passed value is a JavaScript Function, false otherwise.
     * @param {Object} value The value to test
     * @return {Boolean}
     * @method
     */
    isFunction:
    // Safari 3.x and 4.x returns 'function' for typeof <NodeList>, hence we need to fall back to using
    // Object.prorotype.toString (slower)
        (typeof document !== 'undefined' && typeof document.getElementsByTagName('body') === 'function') ? function(value) {
            return toString.call(value) === '[object Function]';
        } : function(value) {
            return typeof value === 'function';
        },

    /**
     * Returns true if the passed value is a number. Returns false for non-finite numbers.
     * @param {Object} value The value to test
     * @return {Boolean}
     */
    isNumber: function(value) {
        return typeof value === 'number' && isFinite(value);
    },

    /**
     * Validates that a value is numeric.
     * @param {Object} value Examples: 1, '1', '2.34'
     * @return {Boolean} True if numeric, false otherwise
     */
    isNumeric: function(value) {
        return !isNaN(parseFloat(value)) && isFinite(value);
    },

    /**
     * Returns true if the passed value is a string.
     * @param {Object} value The value to test
     * @return {Boolean}
     */
    isString: function(value) {
        return typeof value === 'string';
    },

    /**
     * Returns true if the passed value is a boolean.
     *
     * @param {Object} value The value to test
     * @return {Boolean}
     */
    isBoolean: function(value) {
        return typeof value === 'boolean';
    },
    /**
     * 对象赋值
     * @param object
     * @param config
     * @return {*}
     */
    applyIf: function(object, config) {
        var property;

        if (object) {
            for (property in config) {
                if (object[property] === undefined) {
                    object[property] = config[property];
                }
            }
        }

        return object;
    },
    /**
     * 格式化字符串,用法：{1},{2}表示第1,2,...个参数
     *      var str="My name is {1},i am {2} years old."
     *      Easymi.Utils.format(str,"tom",25);==>"My name is tom,i am 25 years old."
     * @param str
     */
    format:function(str){
        var args = arguments;
        return str.replace(/\{(\d+)\}/g,
            function(m,i){
                return args[i];
            });
    },
    /**
     * 将src中的@key等变量替换为obj[key]值
     * 如果是字符串，自动加上单引号
     * 如果是Date类型，自动按照yyyy-MM-DD hh:mm:ss格式格式化
     * 如：
     * sql='update mytable set field2=@field2 where field1=@field1';
     * sql2=replace(sql,{field1:123,field2:'iame'});
     * 则sql2的值为
     *      update mytable set field2='iame' where field1=123
     * @param src
     * @param obj
     */
    replace:function(src,obj,isExecute){
        return src.replace(/@(\w*)/g,function(m){
            var key= m.replace('@','');
			var value=obj[key];
            if(typeof value=='string'){
				//modify by wangfg@2012-4-22 替换字符串中的'特殊字符为''(sqlite,websql都是这个要求)
				//在设备上还需要替换回车换行
                if(isExecute){ //modify by wangfg@2012-6-18只在insert/update时才替换特殊字符
                    if(Was.isEmulator){
                        value=value.replace(/'/g,"''");
                    }else{
                        value=value.replace(/'/g,"\'\'");
                        value=value.replace(/\n/g,"\\n");
                        value=value.replace(/\r/g,"\\r");
                        value=value.replace(/;/g,"/;");//如果内容中有;需要转义，避免和sql语句的分隔;混淆
                    }
                }
                if(value.charAt(0)=="'"){
                    return value;
                }else{
                    return "'"+value+"'";
                }

            }else if(value instanceof Date){
                return "'"+Easymi.Utils.formatDate(obj[key])+"'";
            }
            if(value===0){       //要三等号，双等号时0==''是true的！
                return 0;           //避免下面的return把0转换为''
            }
            return value||"''";
        });
    },
    /**
     *
     * @param name
     * @param value
     * @param recursive
     * @return {Array}
     */
    toQueryObjects: function(name, value, recursive) {
        var self = Easymi.Utils.toQueryObjects,
            objects = [],
            i, ln;

        if (Easymi.Utils.isArray(value)) {
            for (i = 0, ln = value.length; i < ln; i++) {
                if (recursive) {
                    objects = objects.concat(self(name + '[' + i + ']', value[i], true));
                }
                else {
                    objects.push({
                        name: name,
                        value: value[i]
                    });
                }
            }
        }
        else if (Easymi.Utils.isObject(value)) {
            for (i in value) {
                if (value.hasOwnProperty(i)) {
                    if (recursive) {
                        objects = objects.concat(self(name + '[' + i + ']', value[i], true));
                    }
                    else {
                        objects.push({
                            name: name,
                            value: value[i]
                        });
                    }
                }
            }
        }
        else {
            objects.push({
                name: name,
                value: value
            });
        }

        return objects;
    },

    /**
     * 将json转为queryString
     * @param object
     */
    toQueryString: function(object) {
        var paramObjects = [],
            params = [],
            i, j, ln, paramObject, value;

        for (i in object) {
            if (object.hasOwnProperty(i)) {
                paramObjects = paramObjects.concat(Easymi.Utils.toQueryObjects(i, object[i], true));
            }
        }

        for (j = 0, ln = paramObjects.length; j < ln; j++) {
            paramObject = paramObjects[j];
            value = paramObject.value;

            if (Easymi.Utils.isEmpty(value)) {
                value = '';
            }
            else if (Easymi.Utils.isDate(value)) {
                value = Easymi.Utils.formatDate(value);
            }

            params.push(encodeURIComponent(paramObject.name) + '=' + encodeURIComponent(String(value)));
        }

        return params.join('&');
    },
    /**
     * 从select语句中获取列数组
     * 例如 sql='select f1,f2 from T1 where f1=123';
     * 获取的结果为['f1','f2']
     * @param sql
     */
    getColumnFromSql:function(sql){
       var columns=sql.replace(/^select/i,'').replace(/from.*/i,'').split(',');
        var result=[],column,index,index2;
        for(var i=0;i<columns.length;i++){
            column=columns[i].replace(/(^\s*)|(\s*$)/g, '');//trim
            index=column.toLowerCase().indexOf(" as ");
            if(index==-1){
                index2=column.lastIndexOf(' ');//no as,use blank
                if(index2==-1){
                    result.push(column.replace(/.*\./,''));//convert ST.STAGE to STAGE
                }else{
                    result.push(column.substr(index2+1));
                }
            }else{
                result.push(column.substr(index+3).replace(/(^\s*)|(\s*$)/g, ''));
            }
        }
        return result;
    },
    /**
     * 模拟Javascript继承，用法
     * var Super=extend({
     *     init:function(name){     //必须，接收构造函数参数初始化
     *          this.name=name;
     *     },
     *     f1:function(){
     *         alert("Super Name is:"+this.name);
     *     }
     *     f2:function(){
     *         alert("f2");
     *     }
     * })
     * var Sub=extend(Super,{
     *     init:function(name,age){
     *          this.base(name);  //调用父类的同名方法，相当于Java的super
     *          this.age=age;
     *     },
     *     f1:function(){   //覆盖父类方法
     *          alert("Sub Name is:"+this.name);
     *     }
     * });
     *
     * var sub1=new Sub("wfg",30);
     * sub1.f1();   ==>Sub Name is:wfg
     * sub1.f2();   ==>f2
     *
     *
     * @param baseClass
     * @param props
     * @return {Function}
     */
    extend:function(baseClass,props){
        window.classInitializing=false;
        if(typeof(baseClass)==="object"){
            props=baseClass;
            baseClass=null;
        }
        function F(){
            if(!window.classInitializing){
                if(baseClass){
                    this.basePrototype=baseClass.prototype;
                }
                this.init.apply(this,arguments);
            }
        }
        if(baseClass){
            window.classInitializing=true;
            F.prototype=new baseClass();
            F.prototype.constructor=F;
            window.classInitializing=false;
        }
        for(var name in props){
            if(props.hasOwnProperty(name)){
                if(baseClass && typeof(props[name])==='function' && typeof (F.prototype[name])==='function'){
                    F.prototype[name]=(function(name,fn){
                        return function(){
                            this.base=baseClass.prototype[name];
                            return fn.apply(this,arguments);
                        };
                    })(name,props[name]);
                }else{
                    F.prototype[name]=props[name];
                }
            }
        }
        return F;
    },
    /**
     * 格式化日期(可以指定format)
     *      yyyy-year
     *      MM-Month
     *      dd-day
     *      hh-hour
     *      mm-minute
     *      ss-second
     * @param date
     * @param format
     * @return {*}
     */

    /*   formatDate:function(date,format) {
     var o = {
     "M+" : date.getMonth()+1, //month
     "d+" : date.getDate(),    //day
     "h+" : date.getHours(),   //hour
     "m+" : date.getMinutes(), //minute
     "s+" : date.getSeconds(), //second
     "q+" : Math.floor((date.getMonth()+3)/3),  //quarter
     "S" : date.getMilliseconds() //millisecond
     }
     if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
     (date.getFullYear()+"").substr(4 - RegExp.$1.length));
     for(var k in o){
     if(new RegExp("("+ k +")").test(format)){
     format = format.replace(RegExp.$1,RegExp.$1.length==1 ? o[k] :("00"+ o[k]).substr((""+ o[k]).length));
     }
     }
     return format;
     },*/
    /*
     将String类型解析为Date类型.
     parseDate('2006-1-1') return new Date(2006,0,1)
     parseDate(' 2006-1-1 ') return new Date(2006,0,1)
     parseDate('2006-1-1 15:14:16') return new Date(2006,0,1,15,14,16)
     parseDate(' 2006-1-1 15:14:16 ') return new Date(2006,0,1,15,14,16);
     parseDate('2006-1-1 15:14:16.254') return new Date(2006,0,1,15,14,16,254)
     parseDate(' 2006-1-1 15:14:16.254 ') return new Date(2006,0,1,15,14,16,254)
     parseDate('不正确的格式') retrun null
     */
    /**
     * 将字符串解析为Date，字符串格式必须为yyyy-MM-dd hh:mm:ss.ms
     * @param str
     * @return Date
     */
    parseDate:function(str){
        if(typeof str == 'string'){
            var results = str.match(/^ *(\d{4})-(\d{1,2})-(\d{1,2}) *$/);
            if(results && results.length>3)
                return new Date(parseInt(results[1]),parseInt(results[2]) -1,parseInt(results[3]));
            results = str.match(/^ *(\d{4})-(\d{1,2})-(\d{1,2}) +(\d{1,2}):(\d{1,2}):(\d{1,2}) *$/);
            if(results && results.length>6)
                return new Date(parseInt(results[1]),parseInt(results[2]) -1,parseInt(results[3]),parseInt(results[4]),parseInt(results[5]),parseInt(results[6]));
            results = str.match(/^ *(\d{4})-(\d{1,2})-(\d{1,2}) +(\d{1,2}):(\d{1,2}):(\d{1,2})\.(\d{1,9}) *$/);
            if(results && results.length>7)
                return new Date(parseInt(results[1]),parseInt(results[2]) -1,parseInt(results[3]),parseInt(results[4]),parseInt(results[5]),parseInt(results[6]),parseInt(results[7]));
        }
        return null;
    },
    /**
     * 将date格式化，按照yyyy-MM-dd hh:mm:ss.ms格式
     * @param v
     * @return {String}
     */
    formatDate:function(v){
        if(v instanceof Date){
            var y = v.getFullYear();
            var m = v.getMonth() + 1;
            var d = v.getDate();
            var h = v.getHours();
            var i = v.getMinutes();
            var s = v.getSeconds();
            var ms = v.getMilliseconds();
            if(ms>0) return y + '-' + m + '-' + d + ' ' + h + ':' + i + ':' + s + '.' + ms;
            if(h>0 || i>0 || s>0) return y + '-' + m + '-' + d + ' ' + h + ':' + i + ':' + s;
            return y + '-' + m + '-' + d;
        }
        return 'argument is not date';
    }

}
/**
 * Created with JetBrains WebStorm.
 * User: wangfg
 * Date: 12-8-8
 * Time: 下午5:23
 * To change this template use File | Settings | File Templates.
 */
__App = function() {
}
/**
 * 退出应用
 */
__App.prototype.exit = function() {
    Was.exec('app', 'exitApp',{});
};

/**
 * 启动其他应用
 * @param command，需要保证command在目标应用的app.xml中有配置，且全局唯一
 * 例子：AppA调用AppB
 * 在AppB的app.xml中配置
 *      <command>AppB.main<command>
 *      <command>AppB.sub1<command>
 *  通过如下方法启动AppB:
 *      Was.app.callApp(''AppB.main',{...});
 *      然后在AppB的onCreate/onResume
 * @param args
 */
__App.prototype.callApp = function(command,args,successCB,failCB) {
    args["__command"] = command;
    Was.exec('app', 'callApp',args,successCB,failCB || Easymi.defaultFailCallback);
};
/**
 * 启动第三方native应用
 *  iOS输入参数：
 *      {
 *          __url:Native应用注册处理的url。
 *      }
 *  Android输入参数：
 *      {
 *          __url:Intent url
 *          __type:Intent MimeType
 *          __action:Intent Action
 *          __category:Intent category。暂不支持多个。
 *          __package:Intent package。
 *          __class:Intent class。
 *          __otherParam:作为extra放到启动Intent中.
 *          	key为extra的name,value为char(3)+char(type)+extra_value,其中:
 *          	type==1为字符串，此时value可以直接为extra_value。
 *          	type==2为整型。
 *          	type==3为浮点型。
 *          	type==4为字符串数组。数组元素用char(4)分隔。
 *          	type==5为整型数组。数组元素用char(4)分隔。
 *          	type==6为浮点型数组。数组元素用char(4)分隔。
 *          	type==8为HTML内容，需要执行HTML.parse操作。
 *          	type==9为url。
 *      }
 */
__App.prototype.callNativeApp=function(options,successCB,failCB){
	var fcb=failCB || Easymi.defaultFailCallback;
    if(!options){
        fcb(1,'必须传递参数');
		return;
    }
    if(options.__otherParam){
        Easymi.Utils.applyIf(options,options.__otherParam);
    }
    Was.exec('app', 'callNativeApp',options,function(){
		console.debug('[app][callNativeApp][successCB]');
		if(successCB){
			successCB();
		}
	},fcb);

}
/**
 * 启动邮件 Native应用,对callNativeApp函数，具体应用的调用封装。options为
 *      {
 *          sendTo:收件人，可以为一个或多个，如果是多个，传字符串数组
 *          subject:主题，字符串
 *          content:正文，字符串
 *          mimeType:正文的MIME_TYPE，缺省为text/html。
 *      }
 */
__App.prototype.callNativeApp_Email_Android=function(options,successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
    if(!options || !options.sendTo || !options.subject || !options.content){
        fcb(1,'必须传递相关参数');
		return;
    }
	//参数缺省处理
	options.mimeType=options.mimeType || 'text/html';
	if(options.mimeType.toLowerCase()=='text/html'){
		options.contentIsHtml=true;
	}
	if(!Easymi.Utils.isArray(options.sendTo)){
		options.sendTo=[options.sendTo];
	}
	//参数预处理
	var emailAddresses = String.fromCharCode(3)+String.fromCharCode(4);
    for(var i=0;i<options.sendTo.length;i++){
		emailAddresses = emailAddresses + options.sendTo[i];
		if(i!=options.sendTo.length - 1){
			emailAddresses = emailAddresses + String.fromCharCode(4);
		}
	}
	options.sendTo=emailAddresses;
	if(options.contentIsHtml){
		options.content = String.fromCharCode(3)+String.fromCharCode(8)+options.content;
	}
	//调用原子函数
	this.callNativeApp({
		__action:"android.intent.action.SEND",
		__category:"android.intent.category.DEFAULT",
		__type:options.mimeType,
		__otherParam:{
			"android.intent.extra.SUBJECT":options.subject,
			"android.intent.extra.TEXT":options.content,
			"android.intent.extra.EMAIL":options.sendTo
		}
	},successCB,fcb);
}
/**
 * 启动日历 Native应用,对callNativeApp函数，具体应用的调用封装。options为
 *      {
 *          date：定位到日历上的那一天，缺省为当前日期。日期格式为''
 *      }
 */
__App.prototype.callNativeApp_Calander_Android=function(options,successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
	//参数缺省处理
	options=options||{};
	if(options.date){
		options.date=Easymi.Utils.parseDate(options.date);
	}else{
		options.date=new Date();
	}
	options.date=options.date.getTime();
	
	//调用原子函数
	this.callNativeApp({
		__url:"content://com.android.calendar/time/"+options.date,
		__action:"android.intent.action.VIEW",
	},successCB,fcb);
}
/**
 * 应用用来注册事件监听的方法
 * @param eventName,需要监听的事件名称
 *   包括:
 *      onCreate:应用启动，eventCB参数为
 *          netState：网络状态。1在线；0离线；
 *          startType：触发类型。
 *              1用户请求使用应用。
 *              2被推送消息拉起。
 *              3被其它应用调用拉起。
 *          callArgs：调用参数
 *              当startType==3时，为调用参数。
 *              当startType==2时，为推送消息数据，具体定义请参见onPushMessage事件中的描述。
 *       onPause:应用暂停。应用进入暂停之前，本事件发生。eventCB参数:无
 *       onResume:应用继续之后，本事件都会发生。。eventCB参数同onCreate事件
 *       onExit:应用退出之前，本事件发生。eventCB参数:无
 *       onPushMessage：推送消息到达之时，本事件发生。eventCB参数:
 *          type：推送消息类型
 *              1为推送到应用的消息
 *              2为推送到应用图标的消息
 *          format：消息内容类型
 *              1表示普通字符串
 *              2表示二进制内容经过BASE64编码得到的字符串
 *          content：推送消息的内容。
 *       onNetStateChange:托座的网络状态变化之后，本事件发生。eventCB参数:
 *          netState：网络状态
 *              1在线，0离线。
 *       onBackKeyPressed:返回键点击事件(Android Only)，eventCB参数：
 *			无
 *       onPhoneStateChange:电话状态改变的事件(Android Only)，eventCB参数:
 *          state:变化后的状态
 *              1:RING(响铃),2:OFFHOOK(摘机),3.IDLE(空闲)
 *          param:状态参数
 *              当state为1时，表示来电号码，state为其他值，param参数无意义
 *
 * @param eventCB,回调函数
 */
__App.prototype.addEventListener = function(eventName, eventCB) {
    Was.addEventListener(eventName, eventCB);
};
/**
 * 向当前应用的Context中设置参数
 * @param key
 * @param value
 */
__App.prototype.putContextValue=function(key,value){
    console.debug("[app][putContextValue]key="+key+",value="+value);
    Was.exec("context","put",{k:key,v:value},function(){
        console.debug("[app][putContextValue]sucessCB="+JSON.stringify(arguments));
    },Easymi.defaultFailCallback);
};

/**
 * 从当前应用的Context中获取参数，获取的参数通过successCB(value)得到
 * @param key
 * @param successCB
 */
__App.prototype.getContextValue=function(key,successCB){
    console.debug("[app][getContextValue]key="+key);
    Was.exec("context","get",{k:key},
        function(args){
            console.debug("[app][getContextValue]sucessCB:"+JSON.stringify(args));
            successCB(args["v"]);
        },
        Easymi.defaultFailCallback
    );
}
/**
 * 设置图标数字标记
 * @param value
 */
__App.prototype.setBadget=function(value){
    if(typeof value=="string"){
        value=parseInt(value);
    }
    if(typeof value!="number"){
        return;
    }
    Was.exec("message","setAppBadge",{num:value},null,Easymi.defaultFailCallback);
}

/**
 * 获取图标数字标记
 * @param successCB
 */
__App.prototype.getBadget=function(successCB){
    Was.exec("message","getAppBadge",{}
        ,function(args){
            successCB(args["num"]);
        },
        Easymi.defaultFailCallback
    );
}
/**
 * 获取应用的所有设置，sucessCB参数为获取到的JSON对象
 * @param successCB
 */
__App.prototype.getSettings=function(successCB){
    Was.exec("app","settings",{},successCB,Easymi.defaultFailCallback);
}
/**
 * 获取应用的所有设置，sucessCB参数为key对应的value
 * @param key
 * @param successCB
 */

__App.prototype.getSetting=function(key,successCB){
    Was.exec("app","setting",{key:key},function(setting){
        console.debug("[app][getSettings]success:"+JSON.stringify(arguments));
        successCB(setting['value']);
    },Easymi.defaultFailCallback);
}
/**
 * 获取HybirdEngine的网络状态：0:未连接。1:连接。
 */
__App.prototype.getNetState=function(){
    return Was.netState;
}
/**
 * return {
 *     os:操作系统,iOS/Android
 *     type:类型，phone/pad
 *     pixel:分辨率，形如:1024x767（大数在前）
 *     largerPixel:pixel中教大的一边
 *     smallerPixel:pixel中的较小的一边
 * }
  */
__App.prototype.getDeviceInfo=function(){
    if(Was.deviceInfo){//mobile device
        var p=Was.deviceInfo.pixel.split('x');
        return {
            os:Was.deviceInfo.os,
            type:Was.deviceInfo.type,
            largerPixel:parseInt(p[0]),
            smallerPixel:parseInt(p[1]),
            pixel:Was.deviceInfo.pixel
        };
    }

    return {
        os:'windows',
        type:'pad',
        largerPixel:screen.width,
        smallerPixel:screen.height,
        pixel:screen.width+'x'+screen.height
    };

};
/**
 * 获取用户信息,返回:
 * {
 *     userID:'xxx',        //用户ID
 *     loginName:'xxx'		//登录名
 *     userName:'xxx'       //用户实际名称
 * }
 *
 */
__App.prototype.getUserInfo=function(){
	//add by wangfg@2013-3-28 兼容还没有loginName的情况
	if(!Was.userInfo.loginName){
		Was.userInfo.loginName=Was.userInfo.userName
	}
    return Was.userInfo;
}
/**
 * 给WebView设置Cookie
 * @param url  要设置cookie的url
 * @param cookie 要设置的cookie内容，必须符合rfc2109规范。
 */
__App.prototype.setCookie=function(url,cookie,successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
    Was.exec("cookie","setCookie",{
        url:url,
        cookie:cookie
    },successCB,fcb);
}
/**
 * 从WebView中获取Cookie
 * @param url  要获取cookie的url
 * @param successCB 获取结果的回调函数，参数为cookie
 */
__App.prototype.getCookie=function(url,successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
    Was.exec("cookie","getCookie",{
        url:url
    },function(cookie){
        if(successCB){
            successCB(cookie);
        }
    },fcb);
}

/**
 * 方法getPushMsgList：获取推送消息列表，输入以下参数：
 * @param mode 过滤的消息模式
 *  	1：拉起应用；
 *		2：冒泡消息；
 *		3：应用消息数量消息；
 *		4：即时消息。
 * 备注：若不指定其值，则表示获取所有模式的推送消息。
 * @param start 从第几个消息开始读取，缺省值为0
 * 备注：若不指定其值，则从第一个消息开始读取。
 * @param recordCount 本次读取多少条消息。
 * 备注：若不指定其值，则读取全部信息。
 * 
 * @param successCB 成功返回值，包含以下参数：
 * 	msgCount:所有消息数量。
 * 	recordCount:本次获取到的记录数。
 *    EOF:0/1。1表示已经全部读完了。
 *		record:消息对象的JS对象格式化字符串[{消息1},{消息2}…{消息recordCount}]。其中，每个记录的格式为：
 * 		msgID:消息ID
 * 		title:消息标题
 * 		mode:模式。
 *  		pushTime:服务器推送时间。  
 *  		format:格式（1:文本;2：Base64编码文本。)
 * 		content:消息内容
 */
__App.prototype.getPushMsgList = function(args,successCB,failCB){
    var fcb = failCB || Easymi.defaultFailCallback;
	
	 if(!args){
		fcb(-1,'args can not be empty');
	 }

    Was.exec("message","getPushMsgList",args,function(result){
        console.debug("[app][getPushMsgList]success:"+JSON.stringify(result));

        result.record = eval(result.record);

        if(successCB){
            successCB(result);
        }
    },fcb);
}

/**
 * 方法delPushMsg ：删除一条推送消息，输入以下参数：
 * @param msgID 消息ID
 */
 __App.prototype.delPushMsg = function(args,successCB,failCB){
    var fcb = failCB || Easymi.defaultFailCallback;
	
	if(!args){
		fcb(-1,'args can not be empty');
	}
	
	if(!args.msgID){
		fcb(-1,'msgID can not be empty');
	}
	 
    Was.exec("message","delPushMsg",{
		msgID : args.msgID
	},function(){
        if(successCB){
            successCB();
        }
    },fcb);
}

/**
 * 应用截屏
 * @param  {Object}   option 配置参数
 *                        所有的配置项有
 *                        targetWidth:输出图片宽, 默认100
 *                        targetHeight:输出图片高, 需和targetHeight配合使用, 默认100
 *                        encodingType:输出格式 (jpeg,png), 默认png
 *                        quality: 输出图片质量 (0-100), 默认50
 *                        destinationType：输出形式(file,data), 默认 data
 *                        savePath：保存路径(只支持协议格式,如果不指定默认保存在
 *                            sdcard://easymi/ 下
 * @param  {Function} done   成功回调
 *                        成功回调函数接收一个对象作为参数, 对象中的参数有:
 *                        imageURI 处理后的文件保存路径(当destinationType为file时)
 *                        imageFileOSPath 处理后的文件的操作系统路径(当destinationType为file时)
 *                        imageData 图片内容的base编码(当destinationType为data时)"
 * @param  {Function}   fail   失败回调
 *                         失败毁掉接收错误代码作为参数, 目前定义的错误代码有:
 *                             -2: 参数错误
 */
__App.prototype.captureScreen = function (option, done, fail){
    fail = fail || Easymi.defaultFailCallback;
    option = option || {};
    option.targetWidth = option.targetWidth || 100;
    option.targetHeight = option.targetHeight || 100;
    option.encodingType = option.encodingType || 'png';
    option.quality = option.quality || 50;
    option.destinationType = option.destinationType || 'data';
    Was.exec('app', 'screenCapture', option, done, fail);
};

/**
 * 显示webview标题栏/导航栏
 */
__App.prototype.showTitleBar = function (){
    Was.exec('app', 'config', {isTitleBarVisible:true}, null, null);
};

/**
 * 隐藏webview标题栏/导航栏
 */
__App.prototype.hideTitleBar = function (){
    Was.exec('app', 'config', {'isTitleBarVisible': false}, null, null);
};

Easymi.app=new __App();


__Device = function() {}

/**
 * 控制设备屏幕的旋转
 * @param orientation的取值
 *  1：Portrait，竖屏
 *  2：Landscape，横屏
 */
__Device.prototype.setOrientation=function(orientation){
    console.debug("[Device][setOrientation]orientation="+orientation);
	if(orientation!=1 && orientation!=2){
		console.error("[Device][setOrientation]illegal param");
		return;
	}
    Was.exec("device","setOrientation",{orientation:orientation},function(){
        console.debug("[Device][setOrientation][successCB]:"+JSON.stringify(arguments));
    },Easymi.defaultFailCallback);

};

/**
 * 获取设备使用的网络类型
 * @param successCB(netType)
 * netType的值为2G/3G/WIFI，如果无网络返回''
 * 注：iOS无法区分2G/3G网络，因此，只要设备当前使用的是移动网络，则当成是3G。
 */
__Device.prototype.getCurrentNetType=function(successCB,failCB){
	var fcb=failCB || Easymi.defaultFailCallback;
    Was.exec("device","getCurrentNetType",{},function(netType){
        if(successCB){
		   successCB(netType);
		}
    },fcb);
}
Easymi.device=new __Device();
/**
 * Created with JetBrains WebStorm.
 * User: wangfg
 * Date: 12-8-23
 * Time: 下午2:56
 * To change this template use File | Settings | File Templates.
 */
function __File(fileName) {
    this.fileName=fileName;
};
/**
 * 获取文件在操作系统中的绝对路径
 * @param successCB(osPath)
 * @param failCB
 */
__File.prototype.getOSPath=function(successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
    console.debug("[file][getOSPath]fileName="+this.fileName);
    Was.exec("file","getFileOSPath",{EasyMIPath:this.fileName},function(args){
		console.debug('[file][getOSPath]successCB:'+JSON.stringify(args));
        if(successCB){
			successCB(args.OSPath);
		}
    },fcb);
}
/**
 * 获取文件信息
 * @param successCB(info)
 *      info:{
 *          isDir:true|false,
 *          size:大小，单位byte
 *          lastModifyTime:最后修改时间
 *      }
 * @param failCB
 */
__File.prototype.info=function(successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
    Was.exec("file","info",{filepath:this.fileName},function(info){
        console.debug('[file][info][successCB]'+JSON.stringify(info));
        if(successCB){
            info.isDir=info.isDir==1;
            successCB(info);
        }
    },fcb);
};
__File.prototype.exist=function(successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
    console.debug('[file][exist]fileName:' + this.fileName);
    Was.exec("file","exists",{filepath:this.fileName},function(args){
        console.debug('[file][exist][successCB]');
		//add by wangfg@2013-6-27 增加兼容性处理，兼容没有调整错误码前的逻辑，原先是根据retCode判断是否存在的
		var retCode = args["retCode"];
        if(retCode==0){
            successCB(true);
        }else if(retCode==1){
            successCB(false);
        }else if (retCode!=undefined){
            fcb();
		}else if(successCB){
            successCB(true);//新逻辑
        }
    },function(code,msg){
        console.debug('[file][exist][failCB]'+code+","+msg);
        if(code==1){
            if(successCB){
                successCB(false);
            }
        }else{
            fcb(code,msg);
        }
    });
}

__File.prototype.remove=function(successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
    Was.exec("file","delete",{filepath:this.fileName,needConfirm:0}
        ,function(){
            if(successCB){
                successCB();
            }
        },fcb);
}
/**
 * options:参数
 *    useWebview：是否使用webview打开，android Only
 *    otherButton:可以定义其他的按钮文字（缺省带返回按钮），如果多个用逗号分隔
 *    mimeType:文件的类型，如果不传，从文件名分析。
 * callback:按了按钮后的回调，参数为
 *    buttonIndex:按钮的顺序，1~N,0表示按了返回
 *    
 *
 */
__File.prototype.view=function(options,callback){
    console.debug("[file][view]fileName="+this.fileName);
	options=options||{};
	if(!options.hasOwnProperty('useWebview')){
		options.useWebview=false;  //default set to false
	}
	options.filepath=this.fileName;
    //Was.exec("file","viewdoc",{filepath:filepath},null,null);
    Was.exec("file","viewdoc",options,function(arg){
		console.debug("[file][view]callback,you clicked button "+arg.buttonIndex);
		if(callback){
		    callback(arg.buttonIndex);
		}
	});
}
__File.prototype.readAsText=function(encoding,successCB,failCB){
	if(Easymi.Utils.isFunction(encoding)){
		successCB=encoding;
		failCB=successCB;
		encoding='utf-8';
	}
    var fcb=failCB || Easymi.defaultFailCallback;
	console.debug("[file][readAsText]fileName="+this.fileName+',encoding='+encoding);
    Was.exec("file","getFileContent",{filepath:this.fileName,encode:encoding},function(args){
		console.debug("[file][readAsText]sucessCB");
		if(successCB){
			successCB(args.content);
		}
	},fcb);
}


Easymi.File=__File;

/**
 * Created with JetBrains WebStorm.
 * User: wangfg
 * Date: 12-8-16
 * Time: 上午10:12
 * To change this template use File | Settings | File Templates.
 */
var __Media=function(){

}
/**
 *   获取图片
 *   optionParams
 *          sourceType  数据来源  album/camera,缺省为camera
 *          destinationType 期望的数据类型 file|data,缺省为data
 *          targetWidth  期望的图片宽度，缺省为100
 *          targetHeight  期望的图片高度  (必须和targetWidth配合，同时使用)，缺省为100
 *          encodingType  期望得到的图片的格式  jpeg/ png，缺省为png
 *          quality  图片压缩率  : 0-100，缺省为50
 *          savePath   如果destinationType==file,savePath可以设置保存的文件路径
 *                      文件路径的格式参见《EasyMI JS API参考手册.doc》中的说明
 *          saveLocation 是否在照片中保存位置信息,只有在
 *                      sourceType==camera,
 *                      destinationType==file
 *                      encodingType==jpeg
 *                      三种条件下时，才生效
 *
 *   successCB  成功后的回调
 *          successCB(data,savePth)
 *              如果destinationType=='file',
					data为操作系统实际的路径，形如：file:///data/data/com.mibridge.easymi/appfile/common/photo/1364555998813.jpg,webapp拿到这个路径后，可以直接赋值给img.src等
					savePath为参数传入的路径(若没有传入，则系统自动生成一个路径)
				如果destinationType=='data'
					data为图片的base64后的编码,savePath为空
				
 *   failCB   失败后的回调
 */
__Media.prototype.getPicture=function(optionParams,successCB,failCB){
    optionParams=optionParams||{};
    if(!optionParams.sourceType){
        optionParams.sourceType="camera";
    }
    if(!optionParams.destinationType){
        optionParams.destinationType="data";
    }
    if(!optionParams.targetWidth){
        optionParams.targetWidth=100;
    }
    if(!optionParams.targetHeight){
        optionParams.targetHeight=100;
    }
    if(!optionParams.encodingType){
        optionParams.encodingType="jpeg";
    }
    if(!optionParams.quality){
        optionParams.quality=50;
    }
    optionParams.exifFlag=optionParams.saveLocation;
    var fcb=failCB || Easymi.defaultFailCallback;
    console.debug("[media][getPicture]optionParams:"+JSON.stringify(optionParams));
    Was.exec("image", "getPicture", optionParams,
        function(args) {
            console.debug("[media][getPicture][successCB]");
            if(optionParams.destinationType=="data"){
                successCB(args["imageData"]);
            }else{
                successCB(args["imageFileOSPath"],args["imageURI"]);
            }
        },fcb);
};

/**
 *   一次拍多张照片
 *   optionParams
 *          targetWidth  期望的图片宽度，缺省为100
 *          targetHeight  期望的图片高度  (必须和targetWidth配合，同时使用)，缺省为100
 *          encodingType  期望得到的图片的格式  jpeg/ png，缺省为png
 *          quality  图片压缩率  : 0-100，缺省为50
 *          savePath   照片的保存路径，用逗号(,)分隔多个文件路径
 *                      文件路径的格式参见《EasyMI JS API参考手册.doc》中的说明
 *			limitTime  拍照限制时间，单位为秒。不传认为不限制
 *
 *   successCB  成功后的回调
 *          successCB(imageURI,imageFileOSPath)
 *              imageURI为实际拍照的图片路径（传入的路径格式），以逗号分隔
 * 				imageFileOSPath为实际拍照的图片绝对路径，以逗号分隔
 *   failCB   失败后的回调
 */
__Media.prototype.getMultiPicture=function(optionParams,successCB,failCB){
    optionParams=optionParams||{};
    if(!optionParams.targetWidth){
        optionParams.targetWidth=100;
    }
    if(!optionParams.targetHeight){
        optionParams.targetHeight=100;
    }
    if(!optionParams.encodingType){
        optionParams.encodingType="jpeg";
    }
    if(!optionParams.quality){
        optionParams.quality=50;
    }
	if(!optionParams.limitTime){
        optionParams.limitTime=-1;
    }
	optionParams.exifFlag=false;
    var fcb=failCB || Easymi.defaultFailCallback;
    console.debug("[media][getMultiPicture]optionParams:"+JSON.stringify(optionParams));
    Was.exec("image", "getMultiCameraPics", optionParams,
        function(args) {
            console.debug("[media][getMultiPicture][successCB]:"+JSON.stringify(args));
            successCB(args["imageURI"],args["imageFileOSPath"]);
        }, function(code,msg){
			console.debug("[media][getMultiPicture][failCB]:"+JSON.stringify(args));
			fcb(code,msg);
		});
};

/**
 *   保存照片到相册
 *   options
 *          filepath  照片路径
 *   successCB  成功后的回调,无参数
 *   failCB   失败后的回调，参数为(errCode,errMsg)
 *   	errCode的取值
 *        	1：读取图片文件失败
 *			9：保存到相册失败
 */
__Media.prototype.save2album=function(options,successCB,failCB){
	console.debug("[media][save2album]options:"+JSON.stringify(options));
	var fcb=failCB||Easymi.defaultFailCallback;
	if(!options.filepath){
		fcb(1,'必须指定照片路径');
		return;
	}
    Was.exec("image", "save2album", options,
        function(args) {
            console.debug("[media][save2album][successCB]:"+JSON.stringify(args));
            if(successCB){
				successCB();
			}
        }, fcb);
};


/**
 * 开始音频录制，录制的格式取决于移动设备操作系统支持
 * 在Android下，录制的格式为amr(audio/amr)
 * 在iOS下，录制的格式为wav(audio/wav)
 *
 * @param options,录音参数
 *  {
 *      savePath:要保存的路径 (如果不指定，将使用sdcard://协议保存一个随机文件名)。
 *  }
 * @param successCB
 *    录制启动成功的回调
 * @param failCB
 *    录制启动失败的回调
 */
__Media.prototype.captureAudioStart=function(options,successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
    Was.exec("media", "captureAudioStart",options, function(){
        console.debug("[media][captureAudioStart]successCB:"+JSON.stringify(arg));
        if(successCB){
            successCB();
        }
    },fcb);
}
/**
 * 录音暂停
 * @param successCB
 *    暂停成功的回调
 * @param failCB
 *    暂停失败的回调
 */
__Media.prototype.captureAudioPause=function(successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
    Was.exec("media", "captureAudioPause",options, function(){
        console.debug("[media][captureAudioPause]successCB:"+JSON.stringify(arg));
        if(successCB){
            successCB();
        }
    },fcb);
}
/**
 * 录音继续
 * @param 
 * @param successCB
 *    录音继续成功的回调
 * @param failCB
 *    录音继续失败的回调
 */
__Media.prototype.captureAudioResume=function(successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
    Was.exec("media", "captureAudioResume",options, function(){
        console.debug("[media][captureAudioResume]successCB:"+JSON.stringify(arg));
        if(successCB){
            successCB();
        }
    },fcb);
}


/**
 * 停止音频录制
 *
 * @param successCB
 *    录制停止成功的回调，参数为JSONObject,描述录制后的文件信息，包括：
 *        name:不含路径信息的文件名
 *        fullPath： 包含文件名的文件全路径
 *        type： MIME类型
 *        lastModifiedDate:文件最后修改的日期和时间
 *        size：以字节数表示的文件大小
 * @param failCB
 *    录制停止失败的回调
 */
__Media.prototype.captureAudioStop=function(successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
    Was.exec("media", "captureAudioStop", {},function(file){
        console.debug("[media][captureAudioStop]successCB:"+JSON.stringify(file));
        if(successCB){
            successCB(file);
        }
    },fcb);
};
/**
 * 获取设备支持的视频质量
 * @param successCB
 *    设备支持的视频质量列表，列表项之间通过逗号(,)分隔。
 *	  选择一种视频质量，作为参数传入视频录制的API中。
 *    视频质量可能的值包括：
 *        HIGH   
 *        MEDIUM 
 *        LOW    
 *        480P   
 *        540P   
 *        720P   
 *        1080P  
 *        QVGA   
 *        QCIF   
 *        CIF
 * 具体设备支持的质量参数是上述值的子集
 *      
 */
__Media.prototype.getSupportedVideoQuality=function(successCB){
    Was.exec("media", "getSupportVideo",{},function(arg){
        if(successCB){
            successCB(arg.supportList);
        }
    }, Easymi.defaultFailCallback);
};
/**
 * 开始视频录制，录制的格式取决于移动设备操作系统支持
 * 在Android下，录制的格式为3gpp(video/3gpp)
 * 在iOS下，录制的格式为mov(video/3gpp)
 * @param options，录制参数
 *  {
 *		quality:质量参数，来源于getSupportedVideoQuality方法，默认为LOW
 *      savePath:要保存的路径 (如果不指定，将使用sdcard://协议保存一个随机文件名)。
 *      duration:录像时常(单位:秒;如果不指定，则默认长度不做限制)。
 *  }
 *
 * @param successCB
 *    录制成功的回调,参数为JSONObject,描述录制后的文件信息，包括：
 *        name:不含路径信息的文件名
 *        fullPath： 包含文件名的文件全路径
 *        type： MIME类型
 *        lastModifiedDate:文件最后修改的日期和时间
 *        size：以字节数表示的文件大小
 *		  endingType:录制结束方式，0：手工结束，1：电话或其他因素打断
 *
 * @param failCB
 *    录制失败的回调
 */
__Media.prototype.captureVideo=function (options,successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
	options = options || {};
    Was.exec("media", "captureVideo",options,function(result){
        console.debug("[media][captureVideo]successCB:"+JSON.stringify(result));
        if(successCB){
            successCB(result);
        }
    },fcb);
};


/**
 * 带native UI的录音能力
 * @param  {Function} successCB 成功回调
 *                          成功回调接收一个对象作为参数, 该对象拥有的字段有:
 *                          name 文件名
 *                          fullPath 文件全路径
 *                          type 文件mime-type
 *                          size 文件大小（单位为字节）
 * @param  {Function} failCB    失败回调
 *                          失败回调接收错误代码作为参数, 目前定义的错误代码有:
 *                          -3:录音被取消了
 *                          -9:录音错误
 */
__Media.prototype.captureAudioView = function(successCB,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
    Was.exec("media", "captureAudioView",{},function(result){
        console.debug("[media][captureAudioView]successCB:"+JSON.stringify(result));
        if(successCB){
            successCB(result);
        }
    },fcb);
};

/**
 * 待native UI的音频播放能力
 * @param  {String}   filePath  音频文件路径
 * @param  {Function} failCB    失败回调
 *                           失败回调接收错误代码作为参数, 目前定义的错误代码有:
 *                           -3:播放被取消了
 *                           -9:播放错误
 */
__Media.prototype.playAudioView = function(filePath,failCB){
    var fcb=failCB || Easymi.defaultFailCallback;
    Was.exec("media", "playAudioView",{fileurl: filePath}, function(result){
        console.debug("[media][playAudioView]successCB:"+JSON.stringify(arguments));
    },fcb);
};

Easymi.media = new __Media();

var __Proxy=function(){

};

/**
 * 设置request的默认参数
 * @param  {Object} defaultOpts 默认参数, 参数形式和request的一致
 * @return {This}             proxy实例
 */
__Proxy.prototype.requestSetup =  function (defaultOpts) {
    this.defaultOpts = defaultOpts || {};
    return this;
};
__Proxy.prototype.extend =function(dest, source) {
  var args, i, k, ride, v;
  args = [].slice.call(arguments);
  ride = typeof args[args.length - 1] === 'boolean' ? args.pop() : true;
  i = 1;
  if (args.length === 1) {
    dest = {};
    i = 0;
  }
  while (source = args[i++]) {
    for (k in source) {
      v = source[k];
      if (ride || !(k in dest)) {
        dest[k] = v;
      }
    }
  }
  return dest;
};
/**
 * 设置request的请求参数
 * @param  {Object} opts request接受的参数
 * @return {Object}      处理完成的参数
 */
__Proxy.prototype._setOptions =  function (opts) {
    var defaultOpts = this.defaultOpts || {},
        res = {};
    opts = opts || {};
    opts = this.extend({}, defaultOpts, opts);

    res.__url = opts.url;

    if (defaultOpts.params && opts.params) {
        opts.params = this.extend({}, defaultOpts.params, opts.params);
    }
    //add by wangfg@2013-3-26 中间件不允许params为空，只好赋一个缺省占位值
    opts.params = opts.params || {_easymi_random_:new Date().getTime()};

    if (defaultOpts.headers && opts.headers) {
        opts.headers = this.extend({}, defaultOpts.headers, opts.headers);
    }
    opts.headers = opts.headers || {};

    var encoding = opts.encoding || 'UTF-8';
    var type, content;
    if (opts.format == 'json') {
        type = 'application/json';
        content = JSON.stringify(opts.params);
    } else {
        type = 'application/x-www-form-urlencoded';
        content = Easymi.Utils.toQueryString(opts.params);
    }

    res['Content-Type'] = Easymi.Utils.format("{1}; charset={2}",type,encoding);
    res.__content = content;
    this.extend(res,opts.headers,false);
    
    res.failure = opts.failure;
    res.success = opts.success;
    return res;
};
/**
 *  远程访问代理
 * @param options
 * {
 *      url:'/add.do',      //请求的URL
 *      params:{            //请求的参数,JSON Object
 *          x:'xxx',
 *          y:'yyy'
 *     },
 *     encoding:发送参数是的编码格式，缺省为UTF-8
 *     format:参数格式。form|json。缺省为form。
 *          如果是form,则到业务服务器请求的Content-Type为
 *              application/x-www-form-urlencoded
 *          如果是json,则到业务服务器请求的Content-Type为
 *              application/json
 *     headers:额外的http头，Object
 *     success:function(content){...}     		//成功回调
 *     failure:function(code,msg){...}          //失败回调
 * }
 */
__Proxy.prototype.request=function(options){
    options = options || {};
    var pkg = this._setOptions(options),
        fcb = pkg.failure || Easymi.defaultFailCallback,
        scb = pkg.success;
    console.debug("[proxy][request]options="+ JSON.stringify(options) );
    if(!pkg.__url) {
        return;
    }
    // 删除pkg中的回调
    delete pkg.failure;
    delete pkg.success;
    console.debug("pkg="+JSON.stringify(pkg));
    Was.exec("message","send",pkg,function(args){
		if(Easymi.detailLog){
			console.debug("[proxy][request][successCB]"+JSON.stringify(args));
		}else{
			console.debug("[proxy][request][successCB]");
		}
		scb && scb(args["content"]);
    },fcb);
    return this;
}

/**
 * @param url
 * @param path,路径说明
 *      temp/word.doc                   //当前应用的缺省路径
 *      public://subdir/word.doc    //公共区域
 *      album://photo.png             //相册
 * @param successCB
 *      successCB:function(progress,path),progress为下载进度，path为下载后的路径
 * @param failCB
 *      failCB:function(errorCode,errorMsg)
 * @constructor
 */
var __FileTrans=Easymi.Utils.extend({
    init:function(url,path,successCB,failCB,plugIn,methods){
        this.url=url;
        this.path=path;
        this.successCB=successCB;
        this.failCB=failCB || Easymi.defaultFailCallback;
        this.plugIn=plugIn;
        this.methods=methods;
        console.debug("[FileTrans][construtor]:"+JSON.stringify(this));
    },
	/**
	 * 启动上传、下载任务。参数
	 *   isInstant:是否即时任务。
	 *		true:表示任务是即时任务，处理过程中如果网络不可用则任务立刻终止，不会断点续传；
	 *		false:表示任务不是即时任务，处理过程中如果网络不可用则任务会暂停，网络可用之后任务会自动继续处理。
	 */
    start:function(isInstant){
        console.debug("[FileTrans][start]begin...");
        var that=this;
		isInstant=isInstant||false;	//不传默认为false
        // Was.exec("download","download", {
        Was.exec(that.plugIn, that.methods[0], {
            url : that.url,path : that.path,taskflag:isInstant
        }, function(args) {
            console.debug("[FileTrans][successCB]:"+JSON.stringify(args));
            that.successCB(args["progress"],args["path"]);
        },this.failCB);
    },
    pause:function(){
        console.debug("[FileTrans][start]pause...");
        Was.exec(this.plugIn, this.methods[1], {
            //Was.exec("download","pauseDownload",{
            url : this.url
        });
    },
    resume:function() {
        this.pause();
    },
    stop:function() {
        console.debug("[FileTrans][start]stop...");
        Was.exec(this.plugIn, this.methods[2], {
            //Was.exec("download","stopDownload",{
            url : this.url
        });
    }
});
/**
 * Download构造函数
 * Download(url,path,successCB,failCB,progressCB);
 *  用法：说明path的位置
 *      temp/word.doc                   //当前应用的缺省路径
 *      public://subdir/word.doc    //公共区域
 *      album://photo.png             //相册
 *  var d=new Was.proxy.Download('/word.doc','temp/word.doc',function(path){
 *      //下载成功后的处理，path为下载后的路径
 *  },function(){
 *      //下载失败后的处理
 *  },function(progress){
 *      //下载过程回调，progress是0~100的int值
 *  });
 *  d.start();
 *  d.pause();
 *  d.resume();
 *  d.stop();
 *
 */
__Proxy.prototype.Download=Easymi.Utils.extend(__FileTrans,{
    init:function(url,path,successCB,failCB){
        this.base(url,path,successCB,failCB,"download",['download','pausedown','stopdown']);
    }
});
/**
 * 用法同Download
 */
__Proxy.prototype.Upload=Easymi.Utils.extend(__FileTrans,{
    init:function(url,path,successCB,failCB){
        this.base(url,path,successCB,failCB,"upload",['upload','pauseupload','stopupload']);
    }
});

/**
 * 针对EKP定制的上传的接口
 * @param {Object}   option   上传配置项
 *                         配置项需包含以下参数
 *                         {
 *                             token 上传的token
 *                             url 上传至服务器的url
 *                             fullPath 文件在本地的路径
 *                         }
 * @param {Function} done     成功回调函数
 *                         成功回调接收一个对象作为参数, 该对象包含以下字段
 *                         {
 *                             progress 进度。0-100，100表示上传成功
 *                             // 以下参数只有上传成功才返回。
 *                             filekey 服务端返回的filekey。
 *                             name 上传文件名。
 *                             fullPath  上传文件全路径。
 *                             type 上传文件mime-type
 *                             size  上传文件大小（单位为字节）
 *                         }
 * @param {Function}   fail   失败回调函数
 *                         失败回调接收错误代码作为参数, 目前定义的错误代码有
 *                         -1 网络不可用
 *                         -2 调用参数错误
 *                         -3 上传被取消了
 *                         -9 服务端返回了错误
 */
__Proxy.prototype.uploadView = function (option, done, fail) {
    fail = fail || Easymi.defaultFailCallback;
    if (!option || (!option.userkey && !option.token)||
        !option.fullPath || !option.url ) {
        fail(1, '缺少必要参数');
        return;
    }
    if (option.userkey && !option.token) {
        option.token = option.userkey;
    }
    Was.exec('ekpupload', 'upload', option, done, fail);
}



Easymi.proxy=new __Proxy();

/**
 * Created with JetBrains WebStorm.
 * User: wangfg
 * Date: 12-8-9
 * Time: 上午11:42
 * To change this template use File | Settings | File Templates.
 *
 * 基本方法：
 * var db=new Easymi.sqlite.Connection();
 * db.execute('create table T1(f1 int,f2 char');
 * db.execute('insert into T1(f1,f2) values (@f1,@f2)',{
 *     f1:123,
 *     f2:'xxx'
 * });
 * var mycb=function(records){
 *      console.debug(records.length);
 *      for(var i=0;i<records.length;i++){
 *          var r=records[i];
 *          console.debug('##',r[0],r[1]);
 *      }
 * }
 * db.query('select f1,f2 from T1 where f1=@f1',{colsDef:'I,S'},{
 *      f1:234
 * },mycb);
 */
function __SqliteDB(dbName) {
    this.dbName=dbName?dbName:"";
    this.connID=-1;
};

/**
 * 打开db，如果不传dbName，打开当前App的私有db，如果传入了dbName，打开共享的db
 * @param dbName
 */
__SqliteDB.prototype.open = function(successCB,failCB) {
    var _this=this;
    var fcb=failCB || Easymi.defaultFailCallback;
    console.debug("[sqlite][open]enter,dbName="+this.dbName);
    Was.exec("sdb","open",{dbname:this.dbName},function(args){
        console.debug("[sqlite][open][sucessCB]:args="+JSON.stringify(args));
        _this.connID=args.connID;
		if(successCB){
			successCB();
		}
    },fcb);
};
/**
 * 关闭db
 */
__SqliteDB.prototype.close = function() {
    console.debug("[sqlite][close]enter,connID="+this.connID);
	var that=this;
    Was.exec("sdb","close",{connID:this.connID},function(args){
		that.connID=-1;
        console.debug("[sqlite][close][sucessCB]:args="+JSON.stringify(args));
    },function(code,msg){
		that.connID=-1;
		console.debug("[sqlite][close][failCB]:args="+JSON.stringify(args));
		Easymi.defaultFailCallback(code,msg);
	});
};
/**
 * 执行语句，用来执行没有返回值的sql，如insert,updte,delete,create table等
 * 可以带参数，参数用法参见query
 * @param sql
 *      可以含有@打头的变量，可以是单sql，也可以是sql数组
 * @param params
 *      JSON对象数组，可选。包含sql中的变量值，执行时，替换sql中的变量
 * @param returnRowId
 *      当insert时，如果有autoincrement字段，设置这属性为true，可返回新增后的id值。如果sql是数组，忽略该值
 * @param successCB
 *      如果returnRowId为true，successCB返回新的ID
 * @param failCB(code,msg)
 *
 */
__SqliteDB.prototype.execute = function(sql,params,returnRowId,successCB,failCB) {
    var fcb=failCB || Easymi.defaultFailCallback;
    if(this.connID==-1){
        fcb(-1,"connection is not ready!");
        return;
    }
    var finalSql,sqlArray;
    if(Easymi.Utils.isArray(sql)){
        returnRowId=false;
        sqlArray=[];
        for(var i=0;i<sql.length;i++){
            sqlArray.push(Easymi.Utils.replace(sql[i],params?params[i]:undefined,true));
        }
        //add by wangfg@2013-5-23 模拟器上可以直接传数组，设备上要把数组join成字符串
        if(Was.isEmulator){
            finalSql=sqlArray;
        }else{
            finalSql=sqlArray.join(";");
        }

    }else{
        finalSql=Easymi.Utils.replace(sql,params,true);
    }
	if(Easymi.detailLog){
		console.debug("[sqlite][execute]connID="+this.connID+",sql:"+finalSql);
	}else{
		console.debug("[sqlite][execute]connID="+this.connID);
	}
    
    Was.exec("sdb","execute",{connID:this.connID,sql:finalSql,getNewRowID:returnRowId},function(args){
        console.debug("[sqlite][execute][sucessCB]:args="+JSON.stringify(args));
		if(successCB){
			successCB(args["rowID"]);
		}
    },fcb);
};
/**
 * 执行查询语句，sql中可以带参数，结果数组通过successCB(records)返回
 * 注意：不支持select *，必须指定要获取的列。select f1,f2或者select count(*)都可以
 * 示例：
 *   sql='select field1,field2 from mytable where field1=@field1';
 *   params={field1:'xxxx'}
 *   Was.sqlite.execute(sql,params);
 *   实际执行的sql为
 *      select count(*) from mytable where field1='xxxx'
 *  返回的结果集
 * @param sql
 * @param params
 * @param queryConfig
 *      colsDef         列的类型：I:int;S:string;F:float;L:long(一般用于日期)
 *      recordType   结果记录的格式：array:数组；object:对象,default is object,如果是对象，
 *          必须保证select的列名是合法的标示符[大小字母、数字、下划线( _ )和美元符号$组成，标识符不能以数字开头]，
 *          对于计算列，需要增加别名。如:
 *          select name,count(*) as c from ....。获取的对象结构为
 *          {
 *              name:'xxx',
 *              c:100
 *          }
 *
 * @param successCB
 */
__SqliteDB.prototype.query=function(sql,params,queryConfig,successCB,failCB){
    console.debug("[sqlite][query]enter");
    var errorMsg;
    var fcb=failCB || Easymi.defaultFailCallback;
    if(this.connID==-1){
		fcb(-1,"connection is not ready!");
        return;
    }
    if(!queryConfig || !(queryConfig.colsDef)){
        errorMsg="[sqlite][query] queryConfig.colsDef must define";
        fcb(errorMsg);
        return;
    }
    queryConfig.columnTypes=queryConfig.colsDef.split(",");
    if(!(queryConfig.recordType)){
        queryConfig.recordType="object";
    }
	//add by wangfg@2013-6-18
	//新增countPerNext参数，读取数据时，每次Next从NativeDB读取多少条，缺省为10。一般用于读取较多数据(>20条)时，
	//为了减少Native<-->JS之间传递解析时间，修改这个值。模拟器不支持这个参数(2013-6-18)
	if(!(queryConfig.countPerNext)){
        queryConfig.countPerNext=10;
    }
    if(queryConfig.recordType=="object"){
        queryConfig.objectNames=Easymi.Utils.getColumnFromSql(sql);
    }
    var _this=this;
    sql=Easymi.Utils.replace(sql,params);
    if(queryConfig.recordType=="object" && queryConfig.objectNames.length!=queryConfig.columnTypes.length){
        errorMsg="[sqlite][query]select中的列数量与queryConfig.colsDef数量不同，执行中断！！！"+sql;
        fcb(-1,errorMsg);
        return;
    }
    console.debug("[sqlite][query]connID="+this.connID+",sql:"+sql+",queryConfig:"+JSON.stringify(queryConfig));
    var records=[];
    Was.exec("sdb","query",{connID:this.connID,sql:sql},
        function(args){
            console.debug("[sqlite][query][sucessCB]:connId="+_this.connID+JSON.stringify(args));
            _this._next(_this,args.cursorID,queryConfig,records,successCB,fcb);
        },
        fcb
    );
};

//内部方法，不将cursor暴露给使用者
__SqliteDB.prototype._next=function(_this,cursorId,queryConfig,records,callback,failCB){
	if(Easymi.detailLog){
		console.debug("[sqlite][_next],connID="+_this.connID+",cursorId="+cursorId);
	}
    Was.exec("sdb","next",{cursorID:cursorId,colsTypeDef:queryConfig.colsDef,readCount:queryConfig.countPerNext},
        function(args){
			if(Easymi.detailLog){
				console.debug("[sqlite][_next][sucessCB]connID="+_this.connID+",cusorID="+cursorId+',args='+JSON.stringify(args));
			}
			//add begin by wangfg@2013-6-28 增加兼容性处理，兼容没有调整错误码前的逻辑，原先是根据retCode判断是否存在的
			 var retCode=args.retCode;
            if(retCode==-1){
                console.debug("[sqlite][_next],retCode=-1,release cursor and return result");
                //释放游标
                Was.exec("sdb","releaseCursor",{cursorID:cursorId},null);
                //返回结果
                callback(records);
				return;
			}
			//add end
            if(Was.isEmulator){
                var temp=args.record;
            }else{
                eval("var temp ="+args.record+";");
            }
			//add by wangfg@2013-6-18 一个next返回多条记录
			//统一转化为数组，兼容老版本
			if(!(Easymi.Utils.isArray(temp))){
				temp=[temp];
			}
			if(Easymi.detailLog){
				console.debug("[sqlite][_next]temp="+JSON.stringify(temp));
			}
			for(var ri=0;ri<temp.length;ri++){
			    var tempi=temp[ri];
				if(queryConfig.recordType=='array'){
					if(Easymi.detailLog){
						console.debug("to array begin");
					}
					var r=[],v;
					for(var i=0;i<100;i++){
						v=tempi[i];
						if(v!=undefined){
							if(queryConfig.columnTypes[i]=='D'){
								r.push(Easymi.Utils.parseDate(v));
							}else{
								r.push(v);
							}
						}else{
							break;
						}
					}
					if(Easymi.detailLog){
						console.debug("to array end."+JSON.stringify(r));
					}
					records.push(r);
				}else{
					if(Easymi.detailLog){
						console.debug("to object begin");
					}
					var r={},v;
					for(var i=0;i<100;i++){
						v=tempi[i];
						if(v!=undefined){
							if(queryConfig.columnTypes[i]=='D'){
								r[queryConfig.objectNames[i]]=Easymi.Utils.parseDate(v);
							}else{
								r[queryConfig.objectNames[i]]=v;
							}
						}else{
							break;
						}
					}
					if(Easymi.detailLog){
						console.debug("to object end."+JSON.stringify(r));
					}
					records.push(r);
				}
			}
			//EOF==1,表示结果取完了
			if(args.EOF==1){
				Was.exec("sdb","releaseCursor",{cursorID:cursorId},null);
                //返回结果
                callback(records);
			}else{
				//继续获取下一批
				_this._next(_this,cursorId,queryConfig,records,callback,failCB);
			}
        },
        function(code,msg){
            if(code==-1){
                console.debug("[sqlite][_next],retCode=-1,release cursor and return result");
                //释放游标
                Was.exec("sdb","releaseCursor",{cursorID:cursorId},null);
                //返回结果
                callback(records);
            }else{
                failCB(code,msg);
            }
        }
    );
};
/**
 * 执行语句的快捷方法，内部自动进行数据库连接打开，关闭
 */
__SqliteDB.prototype.executeQ = function(sql,params,returnRowId,successCB,failCB) {
    var _this=this;
    this.open(function(){
        _this.execute(sql,params,returnRowId,function(rowid){
            _this.close();
            if(successCB){
                successCB(rowid);
            }
        },failCB);
    },failCB);
};
/**
 * 执行查询的快捷方法，内部自动进行数据库连接打开，关闭
 */
__SqliteDB.prototype.queryQ = function(sql,params,queryConfig,successCB,failCB) {
    var _this=this;
    this.open(function(){
        _this.query(sql,params,queryConfig,function(records){
            _this.close();
            successCB(records);
        },failCB);
    },failCB);
};
/**
 * 判断某个db是否存在，不需要事先Open
 */
__SqliteDB.prototype.exists = function(successCB,failCB){
	var fcb=failCB || Easymi.defaultFailCallback;
	if(!successCB){
		fcb(-1,'必须有successCB回调函数');
		return;
	}
	Was.exec("sdb","exists",{dbname:this.dbName},function(){
		successCB(true);
	},function(code,msg){
		if(code==1){
			successCB(false);
		}else{
			fcb(code,msg);
		}
	});
};
/**
 * 恢复数据库,不需要open
 */
__SqliteDB.prototype.restore = function(sourceDBPath,successCB,failCB){
	var fcb=failCB || Easymi.defaultFailCallback;
	Was.exec("sdb","restore",{dbname:this.dbName,sourceDBPath:sourceDBPath},function(){
		if(successCB){
			successCB();
		}
	},fcb);
};

Easymi.sqlite={
	Connection:__SqliteDB
};


/**
 *  加解密等安全相关类
 */
Easymi.crypto={
    /**
     * 使用密钥对src加密，加密后的内容从successCB中获取
     * @param src
     * @param key
     * @param successCB
     * @param failCB
     */
    encrypt:function(src,key,successCB,failCB){
        var fcb=failCB || Easymi.defaultFailCallback;
        console.debug("[crypto][encrypt]:key="+key+",src="+src);
        Was.exec("crypto","AESEncode",{key:key,text:src},function(args){
            console.debug("[crypto][encrypt]sucessCB:"+JSON.stringify(args));
			if(successCB){
				successCB(args["text"]);
			}
        },fcb);
    },
    decrypt:function(src,key,successCB,failCB){
        var fcb=failCB || Easymi.defaultFailCallback;
        console.debug("[crypto][decrypt]:key="+key+",src="+src);
        Was.exec("crypto","AESDecode",{key:key,text:src},function(args){
            console.debug("[crypto][decrypt]sucessCB:"+JSON.stringify(args));
			if(successCB){
				successCB(args["text"]);
			}
        },fcb);
    },
    /**
     * 混淆文件
     * @param options，参数
     *  {
     *      obscure:混淆因子
     *      sourceFile:源文件路径
     *      outputFile:输出文件路径。
     *  }
     * @param successCB
     *   successCB  成功回调
     * @param failCB
     *  failCB(errorCode,errorMsg)
     *      errorCode:错误代码
     *      errorrMsg:错误信息
     */
    obscureFile:function(options,successCB,failCB){
        var fcb=failCB || Easymi.defaultFailCallback;
        if(!options ||!options.obscure ||!options.sourceFile || !options.outputFile){
            fcb(-1,'必须设置options的obscure,sourceFile,outputFile属性');
            return;
        }
        console.debug("[crypto][obscureFile]:options:"+JSON.stringify(options));
        Was.exec("crypto","obscureFile",options,function(args){
            console.debug("[crypto][obscureFile]successCB:"+JSON.stringify(args));
            if(successCB){
                successCB();
            }
        },fcb);
    },
    /**
     * 恢复文件
     * @param options，参数
     *  {
     *      obscure:混淆因子
     *      sourceFile:源文件路径
     *      outputFile:输出文件路径。
     *  }
     * @param successCB
     *   successCB  成功回调
     * @param failCB
     *  failCB(errorCode,errorMsg)
     *      errorCode:错误代码
     *      errorrMsg:错误信息
     */
    restoreFile:function(options,successCB,failCB){
        var fcb=failCB || Easymi.defaultFailCallback;
        if(!options ||!options.obscure ||!options.sourceFile || !options.outputFile){
            fcb(-1,'必须设置options的obscure,sourceFile,outputFile属性');
            return;
        }
        console.debug("[crypto][restoreFile]:options:"+JSON.stringify(options));
        Was.exec("crypto","restoreFile",options,function(args){
            console.debug("[crypto][restoreFile]successCB:"+JSON.stringify(args));
            if(successCB){
                successCB();
            }
        },fcb);
    }
}
/**
 *  扫描相关
 */
Easymi.scaner={
    /**
     * 扫描条形码
     * @param successCB
     *      successCB(code):code为扫描到的内容
     * @param failCB
     */
    scanBarCode:function(successCB,failCB){
        var fcb=failCB || Easymi.defaultFailCallback;
        Was.exec("barcode","getBarcode",{},function(args){
            console.debug("[barcode][getBarcode]successCB:"+JSON.stringify(args));
            if(successCB){
                successCB(args.code);
            }
        },fcb);
    },
    /**
     * 扫描二维(Two-Dimension)码
     * @param successCB
     *      successCB(code):code为扫描到的内容
     * @param failCB
     */
    scanTDCode:function(successCB,failCB){
        var fcb=failCB || Easymi.defaultFailCallback;
        Was.exec("barcode","getTdBarcode",{},function(args){
            console.debug("[barcode][getTdBarcode]successCB:"+JSON.stringify(args));
            if(successCB){
                successCB(args.code);
            }
        },fcb);
    }
};
/**
 *  定位相关API
 */
Easymi.location={
    /**
     * 获取当前位置(通过wifi/基站)
     * @param successCB，获取成功的回调，参数为JSON对象
     *  {
     *      longitude:经度
     *      latitude:维度
	 *		altitude:海拔
     *  }
     * @param failCB，获取失败的回调，参数为JSON对象
     *  {
     *      errorCode:错误码
     *      errorMsg:错误信息
     *  }
     */
    getCurrentPosition:function(successCB,failCB){
        console.debug("[location][locate]begin...");
        var fcb=failCB || Easymi.defaultFailCallback;
        Was.exec("location","locate",{type:"Cell"},function(args){
            console.debug("[location][locate]success:"+JSON.stringify(args));
            if(successCB){
                successCB(args);
            }
        },fcb);
    },
	/**
     * 获取当前位置(通过GPS)
     * @param successCB，获取成功的回调，参数为JSON对象
     *  {
     *      longitude:经度
     *      latitude:维度
	 *		altitude:海拔
     *  }
     * @param failCB，获取失败的回调，参数为JSON对象
     *  {
     *      errorCode:错误码
     *      errorMsg:错误信息
     *  }
     */
    getCurrentPositionByGPS:function(successCB,failCB){
        console.debug("[location][locateByGPS]begin...");
        var fcb=failCB || Easymi.defaultFailCallback;
        Was.exec("location","locate",{type:"GPS"},function(args){
            console.debug("[location][locateByGPS]success:"+JSON.stringify(args));
            if(successCB){
                successCB(args);
            }
        },fcb);
    }
};

/**
 *  压缩解压相关
 */
Easymi.zip={
    /**
     * 解压缩
     * @param zipFile 要解压的zip文件名
     * @param outPath  解压输出的路径
     * @param successCB  成功后的回调
     * @param failCB   失败回调
     */
    unzip:function(zipFile,outPath,successCB,failCB){
        console.debug("[zip][unzip]param:"+zipFile+','+outPath);
        var fcb=failCB || Easymi.defaultFailCallback;
        Was.exec("zip","unzip",{zipFilePath:zipFile,outPath:outPath},function(){
            console.debug("[zip][unzip]success:"+JSON.stringify(arguments));
            if(successCB){
                successCB();
            }
        },fcb);
    }
}
/**
 * 电话相关API
 */
Easymi.phone={
	/**
     * 拨打电话
     * @param number 要拨号的号码
     * @param confirm 是否进入拨号界面进行确认, 默认为true, 可以不填该参数; 
	 *		如果为true,  则进入到拨号界面,由用户发起拨号;
	 *		如果为false, 则直接进行拨号;
	 *		(注意:  iOS上只能为 true, 不支持false)
     */
    call:function(number, confirm){
        console.debug("[phone][call]number:"+number);
		console.debug("[phone][call]confirm:"+confirm);
		
        Was.exec("phone","call",{number:number, confirm:confirm});
    },
	/**
     * 发送短信
     * @param number 发送给谁
	 * @param content 发送内容
     */
    sms:function(number,content){
		var p={
			number:number,
			content:content?content:''
		};
        console.debug("[phone][sms]param:"+JSON.stringify(p));
        Was.exec("sms","send",p);
    }
};

/**
 * 联系人相关API
 *
 * @param contact 联系人属性:
 * 		id :一个全局的唯一标识
 * 		name :名字
 * 		namePY :名字拼音/音标
 * 		cname :姓氏
 * 		cnamePY :姓氏拼音
 * 		company :公司
 * 		phones :联系人的电话号码列表, 类型是 String, 多个值之间用逗号分隔, 其中每个位置的含义为:
 *				//[0]:  "移动电话",
 *				//[1]:  "住宅电话",
 *				//[2]:  "工作电话",
 *				//[3]:  "主要电话",
 *				//[4]:  "住宅传真",
 *				//[5]:  "工作传真",
 *				//[6]:  "传呼",
 *				//[7]:  "其他电话"
 * 		emails :联系人的邮件地址列表, 类型是 String, 多个值之间用逗号分隔, 其中每个位置的含义为:
 *				//[0]:  "电子邮件",
 *				//[1]:  "工作邮件",
 *				//[2]:  "个人邮件",
 *				//[3]:  "主要邮件",
 *				//[4]:  "其他邮件" (下标4以后的都认为是其他邮件, 包括4)
 * 		addresses :联系人的地址列表, 类型是 String, 多个值之间用逗号分隔, 其中每个位置的含义为:
 *				//[0]:  "主要地址",
 *				//[1]:  "其他地址" (下标1以后的都认为是其他地址 包括1)
 * 		firstLetter :名字的首字母
 * 		prefix :前缀
 * 		middleName :中间名
 * 		suffix :后缀
 * 		nickname :昵称
 * 		jobTitle :职务
 * 		department :部门
 * 		birthday :生日
 * 		notes :备注
 */
Easymi.contact={
	/**
	 * 	新增联系人
	 *  @contact : 其id属性不需要
	**/
	add:function(contact, successCB, failCB){
		var fcb=failCB || Easymi.defaultFailCallback;
		if(!contact){
			fcb(-1,'must set contact');
		}
		console.debug("[contact][add]param:" + JSON.stringify(contact));
		Was.exec('contact','add',contact,function(){
			console.debug("[contact][add]success:"+JSON.stringify(arguments));
            if(successCB){
                successCB();
            }
		},fcb);
	},
	
	/**
	 * 	删除联系人
	 *  @contactId : contactId
	**/
	remove:function(contactId,successCB,failCB){
		var fcb=failCB || Easymi.defaultFailCallback;
		if(!contactId){
			fcb(-1,'must set contactId');
		}
		console.debug("[contact][remove]param:" + contactId);
		Was.exec('contact','delete',{id:contactId},function(){
			console.debug("[contact][remove]success:"+JSON.stringify(arguments));
            if(successCB){
                successCB();
            }
		},fcb);
	},
	
	/**
	 * 	更新联系人
	 *  @contact : 其id 属性是必须的
	**/
	update:function(contact, successCB, failCB){
		var fcb=failCB || Easymi.defaultFailCallback;
		if(!contact){
			fcb(-1,'must set contact');
		}
		console.debug("[contact][update]param:" + JSON.stringify(contact));
		Was.exec('contact','update',contact,function(){
			console.debug("[contact][update]success:"+JSON.stringify(arguments));
            if(successCB){
                successCB();
            }
		},fcb);
	},
	
	/**
	 * 	查找联系人
	 *  @options : 查找条件, 包括
	 * 		name:  联系人姓名, 不指定则表示不根据姓名查找
	 * 		phone: 联系人手机号码, 不指定则表示不根据手机号码查找
	**/
	find:function(options, successCB, failCB){
		var fcb=failCB || Easymi.defaultFailCallback;
		if(!options){
			fcb(-1,'must set options');
		}
		console.debug("[contact][find]param:" + JSON.stringify(options));
		Was.exec('contact','find',options,function(response){
			console.debug("[contact][find]success:"+JSON.stringify(arguments));
			
			var count = response.count;
			var contacts = [];
			for(var i=0;i<count;i++){
				var index = 'record' + i;
				var record_temp = response[index];
				eval('var record = ' + record_temp);

				var contact = {
					id:record.id,
					name:record.name,
					phones:record.phones[0]
				};
				contacts.push(contact);
			}

			var contacts_str = JSON.stringify(contacts);
			
            if(successCB){
                successCB(contacts_str);
            }
		},fcb);
	}
};


/**
 * 微信相关API
 *
 * 	发送一条微信信息
 *  @param content : 微信信息内容， 包含以下属性：
 * 		
 *		scene:	发送场景	
 *				//	"1" : 发送到会话；
 *				//	"2" : 发送到朋友圈, 默认为2；
 *
 *		title： 信息标题, 可选填;
 *
 *		description: 信息描述, 可选填;
 *
 *		thumb: 	信息缩略图文件的 easymi 路径, 可选填;
 *
 *		contentType:	信息内容类型
 *					// "1": 文本;
 *					// "2": 图片;
 *					// "3": 视频;
 *					// "4": 音频;
 *					// "5": 网页;
 *
 *		//当 contentType=="1" 时, 必须指定以下参数:
 *		text: 文本内容;
 *
 *		//当 contentType=="2" 时, 必须指定以下参数之一:
 *		imagePath: 图片文件easymi路径;
 *		imageUrl: 图片文件url;
 *
 *		//当 contentType=="3" 时, 必须指定以下参数之一:
 *		videoUrl: 视频播放页面url;
 *		videoLowBandUrl: 低带宽下视频播放页面url;
 *
 *		//当 contentType=="4" 时, 必须指定以下参数之一:
 *		musicUrl: 音乐播放页面url;
 *		musicLowBandUrl: 低带宽下音乐播放页面url;
 *
 *		//当 contentType=="5" 时, 必须指定以下参数:
 *		webPageUrl: 网页url;
 *
 *
 *	以上所有参数的大小限制为，标题<512B，描述<1KB，缩略图<32KB，url长度<10KB，图片内容<10MB。
 * 		
 */
Easymi.weixin={

	send:function(content, successCB, failCB){
		var fcb=failCB || Easymi.defaultFailCallback;
		if(!content){
			fcb(-1,'must set content');
		}
		
		if(content && content.contentType == '1'){
			if (!content.text){
				fcb(-1,'contentType == 1, must set content.text');
			}
		}
		
		if(content && content.contentType == '2'){
			if (! (content.imagePath || content.imgUrl) ){
				fcb(-1,'contentType == 2, must set content.imagePath or content.imgUrl');
			}
		}
		
		if(content && content.contentType == '3'){
			if (! (content.videoUrl || content.videoLowBandUrl) ){
				fcb(-1,'contentType == 3, must set content.videoUrl or content.videoLowBandUrl');
			}
		}
		
		if(content && content.contentType == '4'){
			if (! (content.musicUrl || content.musicLowBandUrl) ){
				fcb(-1,'contentType == 4, must set content.musicUrl or content.musicLowBandUrl');
			}
		}
		
		if(content && content.contentType == '5'){
			if (!content.webPageUrl){
				fcb(-1,'contentType == 5, must set content.webPageUrl');
			}
		}
		
		console.debug("[weixin][send]param:" + JSON.stringify(content));
		Was.exec('wenxin','send',content,function(){
			console.debug("[weixin][send]success:"+JSON.stringify(arguments));
            if(successCB){
                successCB();
            }
		},fcb);
	}
};

/**
 * 快钱支付API
 *
 * 	调用快钱客户端，发送支付信息
 *
 *  @param content : 快钱支付信息内容， 包含以下属性（JSON对象格式）：
 * 		
 *		orderId:	订单编号	 （必须）
 *		productName:商品名称 （必须）
 *		amount:支付金额，整型，单位为元（必须）
 *		requestId:请求编号
 *		payerId:付款人身份证号
 *		payerName:付款人姓名
 *		payerMobile:付款人手机号(iOS忽略此参数)
 *
 *  @param successCB
 *      successCB:function(args) 此参数JSON对象格式，返回参数，如下：
 *				orderId:订单编号
 *				amount:支付金额，整型，单位为分。
 *				requestId:请求编号
 *				txnReferenceId:快钱系统交易编号（iOS无该参数）
 *
 *  @param failCB
 *      failCB:function(errCode,errMsg)
 *				errCode : errMsg
 *				1       : 设备上未安装快刷客户端
 *				2       : 未支付
 *				9       : 支付失败。
 * 		
 */
Easymi.kuaishua={

	requestPay:function(content, successCB, failCB){
		var fcb = failCB || Easymi.defaultFailCallback;
		if(!content){
			fcb(-1,'content can not be empty');
		}
		
		if(!content.orderId){
			fcb(-1,'orderId can not be empty');
		}
		
		if(!content.productName){
			fcb(-1,'productName can not be empty');
		}
		
		if(!content.amount){
			fcb(-1,'amount can not be empty');
		}else{
			//把元单位转换为分单位
			content.amount = parseFloat(content.amount) * 100;
		}

		console.debug("[kuaishua][requestPay]param:" + JSON.stringify(content));
		Was.exec('kuaishua','requestPay',content,function(args){
			console.debug("[kuaishua][requestPay]success:"+JSON.stringify(args));
			if(successCB){
				var result = {
					orderId : args['orderId'],
					amount : parseFloat(args['amount']) / 100,//把分单位转为元单位
					requestId : args['requestId'],
					txnReferenceId : (Easymi.getDeviceInfo.os != 'iOS') ? args['txnReferenceId'] : null
				};
				successCB(result);
			}
		},fcb);
	}
};

/**
 * 门户通讯录API
 */
Easymi.contactor = (function () {
    /**
     * 扩展object属性, 使用src来扩展dest
     * @param  {Object} dest 扩展的目标对象
     * @param  {Object} src  扩展的属性来源
     * @return {Object}      扩展后的对象
     */
    var extend = function (dest, src) {
        if (arguments.length < 2) {
            src = dest;
            dest = {};
        }
        dest = dest || {};
        if (src) {
            for (key in src) {
                if (src.hasOwnProperty(key)) {
                    dest[ key ] = src[ key ];
                }
            }
        }
        return dest;
    }

    /**
     * 联系人选择API
     * @param  {Object} opts      配置项
     *                  opts 结构为 {
     *                      initList: [], // 初始选中的联系人,可以为数组, 也可以为逗号连接的字符串
     *                                    // 默认为空数组
     *                      isSticky: false, // 被选中的联系人是否被取消选中(可否编辑), 
     *                                       // true为不可取消. 默认为false, 即可以被编辑
     *                      isSimple: true // 返回的联系人数据是否为简单数据, 默认为true
     *                  }
     * @param  {Function} successCB 成功回调
     *                    成功回调接收的参数结构为 {
     *                        retCode: 0,  //成功时该值为0
     *                        selects: [
     *                            {
     *                                loginName: 'zhangming', // 联系人登录名称
     *                                userName: 'ABC89张明',  // 联系人姓名
     *                                position: 'UE工程师',   // 联系人所在部门
     *                                depart: '用户研究'      // 联系人职位
     *                            },
     *                            ...
     *                        ]
     *                    }
     * @param  {Function} failCB    失败回调
     * @return {undefined}           
     */
    var chooseContactors = function ( opts, successCB, failCB ) {
        // 默认选项
        var defaultOpts = {
            initList: [],
            isSticky: false,
            isSimple: true
        };
        opts = opts || {};
        opts = extend(defaultOpts, opts);
        // 将数组类型的用户名变为 ',' 连接的字符串
        if (Easymi.Utils.isArray(opts.initList)) {
            opts.initList = opts.initList.join(',');
        }
        opts.initList += '';
        failCB = failCB || Easymi.defaultFailCallback;
        Was.exec('contactor', 'chooseContactors', opts, function (res) {
            if (res && res.selects) {
                res.selects = Function('return ' + res.selects)();
            }
            successCB && successCB.call(null,res);
        }, failCB);
    }
    return {
        'chooseContactors': chooseContactors
    }
})();


/**
 * 操作历史记录, Webview页面的前进, 后退等
 */

Easymi.history = {
    /**
     * 获取当前页面可以前进及后退的页数
     * @param  {Function}   done  成功回调
     *              成功回调接收一个对象作为参数， 该对象拥有如下字段
     *              canGoBack: 是否能够后退
     *              canGoForward: 是否能能够前进
     */
    canGo: function (done) {
        Was.exec('app','canGo', {}, done, Easymi.defaultFailCallback);
    },

    /**
     * 判断当前页面是否有上一页
     * @param  {Function} done 成功回调
     *              成功回调接收一个布尔型作为参数， 有上一页则为true, 否则为false
     */
    hasPrev: function (done) {
        Easymi.history.canGo(function (res) {
            if (done) {
                done( res.canGoBack );
            }
        });
    },

    /**
     * 返回到上一页
     * @param  {Function} fail 失败回调
     *              如果没有上一页，则会调用该函数， 该函数不接受参数 
     */
    back: function (fail) {
        fail = fail || Easymi.defaultFailCallback;
        Was.exec('app', 'goBack', {}, null, fail);
    },

    /**
     * 前进到下一页
     * @param  {Function} fail 失败回调
     *              如果没有下一页，则会调用该函数， 该函数不接受参数 
     */
    forward: function (fail) {
        fail = fail || Easymi.defaultFailCallback;
        Was.exec('app', 'goForward', {}, null, fail);
    }

};

// 命名KK为Easymi的别名
window.KK = Easymi;
if(window.dojoConfig && window.define) {
	define(function(){
		return KK;
	});
}