	/*******************************************************************************
	 * 功能：机器人节点的节点描述（节点扩展点的nodeJsType项配置此文件的路径）
	  使用：
	  作者：罗荣飞
	 创建时间：2012-06-06
	 ******************************************************************************/
( function(nodedescs) {
	nodedescs['robotNodeDesc'].getLines = getLines;
	function getLines(nodeObj){
		return nodeObj.endLines;
	};
})(lbpm.nodedescs);