package com.landray.kmss.common.convertor;

import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IBaseService;

/**
 * 域模型与Form模型转换的上下文
 * 
 * @author 叶中奇
 */
public class ConvertorContext {
	public ConvertorContext() {
	}

	public ConvertorContext(ConvertorContext context) {
		baseService = context.getBaseService();
		objMap = context.getObjMap();
		requestContext = context.getRequestContext();
		isClone = context.getIsClone();
	}

	private boolean isClone = false;

	private IBaseService baseService;

	private Map objMap;

	private RequestContext requestContext;

	private Object sObject;

	private String sPropertyName;

	private Object tObject;

	/**
	 * @return Service的实体
	 */
	public IBaseService getBaseService() {
		return baseService;
	}

	/**
	 * @return 曾经完成转换的对象映射表：key=源对象,value=目标对象
	 */
	public Map getObjMap() {
		return objMap;
	}

	/**
	 * @return RequestContext
	 */
	public RequestContext getRequestContext() {
		return requestContext;
	}

	/**
	 * @return 源对象
	 */
	public Object getSObject() {
		return sObject;
	}

	/**
	 * @return 需要转换的源属性名
	 */
	public String getSPropertyName() {
		return sPropertyName;
	}

	/**
	 * @return 目标对象
	 */
	public Object getTObject() {
		return tObject;
	}

	public void setBaseService(IBaseService baseService) {
		this.baseService = baseService;
	}

	public void setObjMap(Map objMap) {
		this.objMap = objMap;
	}

	public void setRequestContext(RequestContext requestContext) {
		this.requestContext = requestContext;
	}

	public void setSObject(Object object) {
		sObject = object;
	}

	public void setSPropertyName(String propertyName) {
		sPropertyName = propertyName;
	}

	public void setTObject(Object object) {
		tObject = object;
	}

	public boolean getIsClone() {
		return isClone;
	}

	public void setIsClone(boolean isClone) {
		this.isClone = isClone;
	}
}
