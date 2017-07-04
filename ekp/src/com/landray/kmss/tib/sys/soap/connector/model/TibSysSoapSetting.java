package com.landray.kmss.tib.sys.soap.connector.model;

import java.beans.XMLDecoder;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.IOUtils;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToFormList;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.tib.sys.soap.connector.forms.TibSysSoapSettingForm;
import com.landray.kmss.util.StringUtil;

/**
 * WEBSERVICE服务配置
 * 
 * @author 
 * @version 1.0 2012-08-06
 */
public class TibSysSoapSetting extends BaseModel {

	/**
	 * 加密类型
	 */
	private String passwordType;

	public String getPasswordType() {
		return passwordType;
	}

	public void setPasswordType(String passwordType) {
		this.passwordType = passwordType;
	}
	
	/**
	 * Soap头信息自定义
	 */
	private String soapHeaderCustom;
	
	public String getSoapHeaderCustom() {
		return (String) readLazyField("soapHeaderCustom", soapHeaderCustom);
	}

	public void setSoapHeaderCustom(String soapHeaderCustom) {
		this.soapHeaderCustom = (String) writeLazyField("soapHeaderCustom",
				this.soapHeaderCustom, soapHeaderCustom);
	}
	
	
	/**
	 * 表单扩展字段
	 */
	public String extendInfoXml;
	
	
	public String getExtendInfoXml() {
		return (String) readLazyField("extendInfoXml", extendInfoXml);
	}

	public void setExtendInfoXml(String extendInfoXml) {
		this.extendInfoXml = (String) writeLazyField("soapHeaderCustom",
				this.extendInfoXml, extendInfoXml);
	}
	
	/**
	 * extendInfoXml 字段解析，用来方便使用
	 * @return
	 */
	public Map<String,Object> getExtendInfoMap(){
	    Map<String,Object> rtnMap=null;
		if(StringUtil.isNull(extendInfoXml)){
			return null;
		}
		InputStream is=null;
		try {
			 is = new ByteArrayInputStream(extendInfoXml.getBytes("UTF-8"));
			 XMLDecoder parser = new XMLDecoder(is);
			 rtnMap =( Map<String,Object>)parser.readObject();
			 return rtnMap;
		} catch (Exception e) {
			return rtnMap;
		}finally{
			IOUtils.closeQuietly(is);
		}
	}
	
	
	
	/**
	 * 标题
	 */
	protected String docSubject;
	
	/**
	 * @return 标题
	 */
	public String getDocSubject() {
		return docSubject;
	}
	
	/**
	 * @param docSubject 标题
	 */
	public void setDocSubject(String docSubject) {
		this.docSubject = docSubject;
	}
	
	/**
	 * 创建时间
	 */
	protected Date docCreateTime;
	
	/**
	 * @return 创建时间
	 */
	public Date getDocCreateTime() {
		return docCreateTime;
	}
	
	/**
	 * @param docCreateTime 创建时间
	 */
	public void setDocCreateTime(Date docCreateTime) {
		this.docCreateTime = docCreateTime;
	}
	
	/**
	 * 最后修改时间
	 */
	protected Date docAlterTime;
	
	/**
	 * @return 最后修改时间
	 */
	public Date getDocAlterTime() {
		return docAlterTime;
	}
	
	/**
	 * @param docAlterTime 最后修改时间
	 */
	public void setDocAlterTime(Date docAlterTime) {
		this.docAlterTime = docAlterTime;
	}
	
	/**
	 * WSDL地址
	 */
	protected String fdWsdlUrl;
	
	/**
	 * @return WSDL地址
	 */
	public String getFdWsdlUrl() {
		return fdWsdlUrl;
	}
	
	/**
	 * @param fdWsdlUrl WSDL地址
	 */
	public void setFdWsdlUrl(String fdWsdlUrl) {
		this.fdWsdlUrl = fdWsdlUrl;
	}
	
	/**
	 * 是否启用
	 */
	protected Boolean fdEnable;
	
	/**
	 * @return 是否启用
	 */
	public Boolean getFdEnable() {
		return fdEnable;
	}
	
	/**
	 * @param fdEnable 是否启用
	 */
	public void setFdEnable(Boolean fdEnable) {
		this.fdEnable = fdEnable;
	}
	
	/**
	 * SOAP版本
	 */
	protected String fdSoapVerson;
	
	/**
	 * @return SOAP版本
	 */
	public String getFdSoapVerson() {
		return fdSoapVerson;
	}
	
	/**
	 * @param fdSoapVerson SOAP版本
	 */
	public void setFdSoapVerson(String fdSoapVerson) {
		this.fdSoapVerson = fdSoapVerson;
	}
	
	/**
	 * 登录方式 记录权限扩展点的handlerKey
	 */
	public String fdAuthMethod;
	
	/**
	 * 是否为保护型wsdl
	 */
	public Boolean fdProtectWsdl;
	
	/**
	 * 加载wsdl 时候获取受保护类型的wsdl 用户名
	 */
	public String fdloadUser;
	
	/**
	 * 加载wsdl 时候获取受保护类型的wsdl 密码
	 */
	public String fdloadPwd;
	
	public String portName;
	
	public String getPortName() {
		return portName;
	}

	public void setPortName(String portName) {
		this.portName = portName;
	}

	public String getFdloadUser() {
		return fdloadUser;
	}

	public void setFdloadUser(String fdloadUser) {
		this.fdloadUser = fdloadUser;
	}

	public String getFdloadPwd() {
		return fdloadPwd;
	}

	public void setFdloadPwd(String fdloadPwd) {
		this.fdloadPwd = fdloadPwd;
	}

	public String getFdAuthMethod() {
		return fdAuthMethod;
	}

	public void setFdAuthMethod(String fdAuthMethod) {
		this.fdAuthMethod = fdAuthMethod;
	}

	/**
	 * 是否验证
	 */
	protected Boolean fdCheck;
	
	/**
	 * @return 是否验证
	 */
	public Boolean getFdCheck() {
		return fdCheck;
	}
	
	/**
	 * @param fdCheck 是否验证
	 */
	public void setFdCheck(Boolean fdCheck) {
		this.fdCheck = fdCheck;
	}
	
	/**
	 * 允许分块发送
	 */
	protected Boolean fdAllowBlock;
	
	/**
	 * @return 允许分块发送
	 */
	public Boolean getFdAllowBlock() {
		return fdAllowBlock;
	}
	
	/**
	 * @param fdAllowBlock 允许分块发送
	 */
	public void setFdAllowBlock(Boolean fdAllowBlock) {
		this.fdAllowBlock = fdAllowBlock;
	}
	
	/**
	 * 连接超时
	 */
	protected String fdOverTime;
	
	/**
	 * @return 连接超时
	 */
	public String getFdOverTime() {
		return fdOverTime;
	}
	
	/**
	 * @param fdOverTime 连接超时
	 */
	public void setFdOverTime(String fdOverTime) {
		this.fdOverTime = fdOverTime;
	}
	
	/**
	 * 用户名
	 */
	protected String fdUserName;
	
	/**
	 * @return 用户名
	 */
	public String getFdUserName() {
		return fdUserName;
	}
	
	/**
	 * @param fdUserName 用户名
	 */
	public void setFdUserName(String fdUserName) {
		this.fdUserName = fdUserName;
	}
	
	/**
	 * 密码
	 */
	protected String fdPassword;
	
	/**
	 * @return 密码
	 */
	public String getFdPassword() {
		return fdPassword;
	}
	
	/**
	 * @param fdPassword 密码
	 */
	public void setFdPassword(String fdPassword) {
		this.fdPassword = fdPassword;
	}
	
	/**
	 * 响应超时
	 */
	protected String fdResponseTime;
	
	/**
	 * @return 响应超时
	 */
	public String getFdResponseTime() {
		return fdResponseTime;
	}
	
	/**
	 * @param fdResponseTime 响应超时
	 */
	public void setFdResponseTime(String fdResponseTime) {
		this.fdResponseTime = fdResponseTime;
	}
	
	/**
	 * 备注
	 */
	protected String fdMarks;
	
	/**
	 * @return 备注
	 */
	public String getFdMarks() {
		return fdMarks;
	}
	
	/**
	 * @param fdMarks 备注
	 */
	public void setFdMarks(String fdMarks) {
		this.fdMarks = fdMarks;
	}
	
	/**
	 * WSDL版本
	 */
	protected String fdWsdlVersion;
	
	/**
	 * @return WSDL版本
	 */
	public String getFdWsdlVersion() {
		return fdWsdlVersion;
	}
	
	/**
	 * @param fdWsdlVersion WSDL版本
	 */
	public void setFdWsdlVersion(String fdWsdlVersion) {
		this.fdWsdlVersion = fdWsdlVersion;
	}
	
	/**
	 * 创建者
	 */
	protected SysOrgElement docCreator;
	
	/**
	 * @return 创建者
	 */
	public SysOrgElement getDocCreator() {
		return docCreator;
	}
	
	/**
	 * @param docCreator 创建者
	 */
	public void setDocCreator(SysOrgElement docCreator) {
		this.docCreator = docCreator;
	}
	
	/**
	 * WEBSERVICE服务配置扩展
	 */
	protected List<TibSysSoapSettingExt> fdServerExt;
	
	/**
	 * @return WEBSERVICE服务配置扩展
	 */
	public List<TibSysSoapSettingExt> getFdServerExt() {
		return fdServerExt;
	}
	
	/**
	 * @param fdServerExt WEBSERVICE服务配置扩展
	 */
	public void setFdServerExt(List<TibSysSoapSettingExt> fdServerExt) {
		this.fdServerExt = fdServerExt;
	}
	
	/**
	 * address地址s
	 */
	private String docAddress;
	
	/**
	 * @return the docAddress地址
	 */
	public String getDocAddress() {
		return docAddress;
	}

	/**
	 * @param docAddress the docAddress to set地址
	 */
	public void setDocAddress(String docAddress) {
		this.docAddress = docAddress;
	}
	
	/**
	 * 为后面主文档抽取函数做准备
	 */
	private String serviceName;
	private String bindName;
	
	public String getServiceName() {
		return serviceName;
	}

	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}

	public String getBindName() {
		return bindName;
	}

	public void setBindName(String bindName) {
		this.bindName = bindName;
	}

	public Class getFormClass() {
		return TibSysSoapSettingForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("docCreator.fdId", "docCreatorId");
			toFormPropertyMap.put("docCreator.fdName", "docCreatorName");
			toFormPropertyMap.put("settCategory.fdId", "settCategoryId");
			toFormPropertyMap.put("settCategory.fdName", "settCategoryName");
			toFormPropertyMap.put("fdServerExt",
					new ModelConvertor_ModelListToFormList("fdServerExtForms"));
		}
		return toFormPropertyMap;
	}
	
	// 操作者
	private String docPoolAdmin;

	public String getDocPoolAdmin() {
		return docPoolAdmin;
	}

	public void setDocPoolAdmin(String docPoolAdmin) {
		this.docPoolAdmin = docPoolAdmin;
	}

	public Boolean getFdProtectWsdl() {
		return fdProtectWsdl;
	}

	public void setFdProtectWsdl(Boolean fdProtectWsdl) {
		this.fdProtectWsdl = fdProtectWsdl;
	}
	
	//所属目录
	protected TibSysSoapSettCategory settCategory;

	public TibSysSoapSettCategory getSettCategory() {
		return settCategory;
	}

	public void setSettCategory(TibSysSoapSettCategory settCategory) {
		this.settCategory = settCategory;
	}

	
	
	
}
