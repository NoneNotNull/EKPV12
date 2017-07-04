// 扩展js函数
/*
 * 传入BAPI的名称;JSON格式的字段、表、结构;连接池名称 返回成功标示：1成功，0失败;JSON格式的字段、表、结构
 */
// 在这里定义一个全局变量用保存rtnData
var ESAP_RFC_rtnData;

/**
 * @deprecated
 * @description SAP Js扩展,提供根据bapi名称跟数据直接调用的JS方法(old)
 * @param FUNC_NAME
 *            调用SAP BAPI名称
 * @param BAPI_CONTENT
 *            传入参数
 * @return
 * @see BAPI_CONTENT 参数格式《ERP中间件.doc-3.3.JSON模版-SAP组件》
 */
function ESAP_RFC(FUNC_NAME, BAPI_CONTENT) {
	var data = new KMSSData();
	data.SendToBean("tibSapRFCJSFunctionService&BAPI_NAME=" + FUNC_NAME
					+ "&BAPI_CONTENT=" + BAPI_CONTENT, changeRtnData);
}

// (新)回调函数,自己处理回调函数,可以回调一组function,也可以回调单个function notes：只有function才可以回调处理
/**
 * @class sapRfcFormJS
 * @function ESAP_RFC_MYSelf
 * @description SAP Js扩展,提供根据bapi名称跟数据直接调用的JS方法
 * @param {}
 *            FUNC_NAME 调用SAP BAPI名称
 * @param {}
 *            BAPI_CONTENT 传入参数
 * 
 * @param {}
 *            RTN_FUNCS 回调函数,可以是function数组或者function
 * 
 * @see BAPI_CONTENT 参数格式《ERP中间件.doc-3.3.JSON模版-SAP组件》
 * 
 * @example
 * 样例：
 * ========================================
 * 
 * 定义调用完以后回调的函数myfunc1
 * function myfunc1(rtnData){
 * 		业务代码。。。。。
 * 		...
 * }
 * 
 * 定义调用完以后回调的函数myfunc2
 * function myfunc2(rtnData){
 * 		业务代码。。。。。
 * 		...
 * }
 * 
 * 把回调函数放到数组中
 * var rtnFunc=[myfunc1,myfunc2];
 * 
 * 调用方法，当执行完bapi以后会触发rtnFunc的回调函数
 * ESAP_RFC_MYSelf('函数名字',json字符串,rtnFunc)
 * 
 */

function ESAP_RFC_MYSelf(FUNC_NAME, BAPI_CONTENT, RTN_FUNCS) {
	var data = new KMSSData();
	data.SendToBean("tibSapRFCJSFunctionService&BAPI_NAME=encodeURIComponent('" + FUNC_NAME
					+ "')&BAPI_CONTENT=" + BAPI_CONTENT, function(mydata) {
				if (!RTN_FUNCS) {
					return;
				}
				if (Object.prototype.toString.call(RTN_FUNCS) == '[object Array]') {
					for (var i = 0, len = RTN_FUNCS.length; i < len; i++) {
						if ('[object Function]' == Object.prototype.toString
								.call(RTN_FUNCS[i])) {
							RTN_FUNCS[i].call(this, mydata);
						}
					}
				} else {
					if ('[object Function]' == Object.prototype.toString
							.call(RTN_FUNCS)) {
						RTN_FUNCS.call(this, mydata);
					}
				}
			});
}
