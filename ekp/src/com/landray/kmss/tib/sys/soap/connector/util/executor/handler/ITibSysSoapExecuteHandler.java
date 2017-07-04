package com.landray.kmss.tib.sys.soap.connector.util.executor.handler;

import org.w3c.dom.Document;

import com.eviware.soapui.impl.wsdl.WsdlInterface;
import com.eviware.soapui.impl.wsdl.WsdlOperation;
import com.eviware.soapui.impl.wsdl.WsdlRequest;
import com.eviware.soapui.model.iface.Response;
import com.eviware.soapui.model.iface.SubmitContext;
import com.landray.kmss.tib.sys.soap.connector.util.executor.vo.ITibSysSoapRtn;

/**
 * soapui执行webservice时候控制类
 * @author zhangtian
 * date :2013-1-14 上午11:31:09
 */
public interface ITibSysSoapExecuteHandler {
	
	/**
	 * 初始化SubmitContext
	 * @return
	 */
	public SubmitContext getInitSubmitContext();
	
	/**
	 * 初始化WsdlRequest
	 * @return
	 * @throws Exception
	 */
	public WsdlRequest getInitWsdlRequest() throws Exception;
	
	/**
	 * 获取WsdlInterface
	 * WsdlInterface：soapui提供已经组装好的Definition,传入模板数据，传出数据集合体
	 * @return
	 * @throws Exception
	 */
	public WsdlInterface getTargetWsdlFace()throws Exception;
	
	/**
	 * 获取需要执行的方法
	 * @return
	 * @throws Exception
	 */
	public WsdlOperation getExecuteOperation() throws Exception;
	
	/**
	 * 执行前动作,可以在这里干预传入参数，设置request,context等等
	 * @param submitContext
	 * @param wsdlRequest
	 */
	public void beforeExecute(SubmitContext submitContext,WsdlRequest wsdlRequest,Document document )throws Exception ;
	
	/**
	 * 执行后动作,可以干预返回数据,传入数据,传出数据
	 * @param submitContext 
	 * @param wsdlRequest 传入参数数据
	 * @param response  传出参数数据
	 */
	public Document afterExecute(SubmitContext submitContext,WsdlRequest wsdlRequest,Response response,Document document );
	
	/**
	 * 组装执行webservice以后返回的数据
	 * @param response 原始返回值
	 * @param document 经过afterExecute 控制过的返回值
	 * @return 返回一个带有返回数据，返回数据状态(程序异常，业务异常等等判断)
	 */
	public ITibSysSoapRtn parseResponse(Response response,Document document);


	
}
