	/*******************************************************************************
	 * 功能：并发分支（开始）节点的节点描述（节点扩展点的nodeJsType项配置此文件的路径）
	  使用：
	  作者：罗荣飞
	 创建时间：2012-06-06
	 ******************************************************************************/
( function(nodedescs) {
	nodedescs['splitNodeDesc'].getLines = getLines;
	//获取即将流向的连线(nodeObj为当前节点对象，nextNodeObj为下一节点对象)
	function getLines(nodeObj,nextNodeObj){
		return nodeObj.endLines;//并行分支节点取下一节点的后续连线
	};
})(lbpm.nodedescs);