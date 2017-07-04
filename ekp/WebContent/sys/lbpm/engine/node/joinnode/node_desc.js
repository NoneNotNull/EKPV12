	/*******************************************************************************
	 * 功能：并发分支（结束）节点的节点描述（节点扩展点的nodeJsType项配置此文件的路径）
	  使用：
	  作者：罗荣飞
	 创建时间：2012-06-06
	 ******************************************************************************/
( function(nodedescs) {
	nodedescs['joinNodeDesc'].getLines = getLines;
	function getLines(nodeObj){
		return nodeObj.endLines;
	};
})(lbpm.nodedescs);