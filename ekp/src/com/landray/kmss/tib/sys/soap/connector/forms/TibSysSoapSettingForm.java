package com.landray.kmss.tib.sys.soap.connector.forms;

import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_FormListToModelList;
import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSettCategory;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSetting;
import com.landray.kmss.tib.sys.soap.connector.util.header.licence.ITibSysSoapParamsParser;
import com.landray.kmss.tib.sys.soap.connector.util.header.licence.LicenceHeaderPlugin;
import com.landray.kmss.util.AutoArrayList;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;


/**
 * WEBSERVICE服务配置 Form
 * 
 * @author 
 * @version 1.0 2012-08-06
 */
public class TibSysSoapSettingForm extends ExtendForm {
	
	public String portName;
	
	
	public String getPortName() {
		return portName;
	}

	public void setPortName(String portName) {
		this.portName = portName;
	}

	/**
	 * 保护型wsdl
	 */
	public String fdProtectWsdl;
	
	/**
	 * 加载wsdl用户名
	 */
	protected String fdloadUser = null;
	
	/**
	 * 加载wsdl密码
	 */
	protected String fdloadPwd = null;

	/**
	 * 标题
	 */
	protected String docSubject = null;
	
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
	protected String docCreateTime = null;
	
	/**
	 * @return 创建时间
	 */
	public String getDocCreateTime() {
		return docCreateTime;
	}
	
	/**
	 * @param docCreateTime 创建时间
	 */
	public void setDocCreateTime(String docCreateTime) {
		this.docCreateTime = docCreateTime;
	}
	
	/**
	 * 最后修改时间
	 */
	protected String docAlterTime = null;
	
	/**
	 * @return 最后修改时间
	 */
	public String getDocAlterTime() {
		return docAlterTime;
	}
	
	/**
	 * @param docAlterTime 最后修改时间
	 */
	public void setDocAlterTime(String docAlterTime) {
		this.docAlterTime = docAlterTime;
	}
	
	/**
	 * WSDL地址
	 */
	protected String fdWsdlUrl = null;
	
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
	protected String fdEnable = null;
	
	/**
	 * @return 是否启用
	 */
	public String getFdEnable() {
		return fdEnable;
	}
	
	/**
	 * @param fdEnable 是否启用
	 */
	public void setFdEnable(String fdEnable) {
		this.fdEnable = fdEnable;
	}
	
	/**
	 * SOAP版本
	 */
	protected String fdSoapVerson = null;
	
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
	 * 是否验证
	 */
	protected String fdCheck = null;
	
	/**
	 * @return 是否验证
	 */
	public String getFdCheck() {
		return fdCheck;
	}
	
	/**
	 * @param fdCheck 是否验证
	 */
	public void setFdCheck(String fdCheck) {
		this.fdCheck = fdCheck;
	}
	
	/**
	 * 允许分块发送
	 */
	protected String fdAllowBlock = null;
	
	/**
	 * @return 允许分块发送
	 */
	public String getFdAllowBlock() {
		return fdAllowBlock;
	}
	
	/**
	 * @param fdAllowBlock 允许分块发送
	 */
	public void setFdAllowBlock(String fdAllowBlock) {
		this.fdAllowBlock = fdAllowBlock;
	}
	
	/**
	 * 连接超时
	 */
	protected String fdOverTime = null;
	
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
	protected String fdUserName = null;
	
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
	protected String fdPassword = null;
	
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
	protected String fdResponseTime = null;
	
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
	protected String fdMarks = null;
	
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
	protected String fdWsdlVersion = null;
	
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
	 * 创建者的ID
	 */
	protected String docCreatorId = null;
	
	/**
	 * @return 创建者的ID
	 */
	public String getDocCreatorId() {
		return docCreatorId;
	}
	
	/**
	 * @param docCreatorId 创建者的ID
	 */
	public void setDocCreatorId(String docCreatorId) {
		this.docCreatorId = docCreatorId;
	}
	
	/**
	 * 创建者的名称
	 */
	protected String docCreatorName = null;
	
	/**
	 * @return 创建者的名称
	 */
	public String getDocCreatorName() {
		return docCreatorName;
	}
	
	/**
	 * @param docCreatorName 创建者的名称
	 */
	public void setDocCreatorName(String docCreatorName) {
		this.docCreatorName = docCreatorName;
	}
	
	/**
	 * WEBSERVICE服务配置的表单
	 */
	protected AutoArrayList fdServerExtForms = new AutoArrayList(TibSysSoapSettingExtForm.class);
	
	/**
	 * @return WEBSERVICE服务配置的表单
	 */
	public AutoArrayList getFdServerExtForms() {
		return fdServerExtForms;
	}
	
	/**
	 * @param fdServerExtForms WEBSERVICE服务配置的表单
	 */
	public void setFdServerExtForms(AutoArrayList fdServerExtForms) {
		this.fdServerExtForms = fdServerExtForms;
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
	 * 登录方式 记录权限扩展点的handlerKey
	 */
	public String fdAuthMethod;
	
	
	
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
		return soapHeaderCustom;
	}

	public void setSoapHeaderCustom(String soapHeaderCustom) {
		this.soapHeaderCustom = soapHeaderCustom;
	}
	
	
	private String extendInfoXml; 
	
	public String getExtendInfoXml() {
		return extendInfoXml;
	}

	public void setExtendInfoXml(String extendInfoXml) {
		if(extendInfoList.isEmpty()){
		this.extendInfoXml = extendInfoXml;
		}
		}
	
	public transient AutoArrayList extendInfoList=new AutoArrayList(MapVo.class);

	public AutoArrayList getExtendInfoList() {
//		字符串转list 
		Map<String,Object> rtnMap=null;
			if(StringUtil.isNull(extendInfoXml)){
				return null;
			}
			InputStream is=null;
			try {
				 is = new ByteArrayInputStream(extendInfoXml.getBytes("UTF-8"));
				 XMLDecoder parser = new XMLDecoder(is);
				 rtnMap =( Map<String,Object>)parser.readObject();
				 extendInfoList.clear();//对于页面有多次调用该方法时，需先清空掉以前的值
				 for(String s:rtnMap.keySet()){
					 MapVo mv= new MapVo(s,rtnMap.get(s));
					 extendInfoList.add(mv);
				 }
				 return extendInfoList;
			} catch (Exception e) {
				return extendInfoList;
			}finally{
				IOUtils.closeQuietly(is);
			}
	}

	public void setExtendInfoList(List extendInfoList) {
		
		//List 转字符串
		Map<String, Object> sm=new HashMap<String, Object>();
		String result="";
		for(Object obj: extendInfoList){
			String key=((MapVo)obj).getKey();
			Object val=((MapVo)obj).getValue();
			sm.put(key, val);
		} 
		ByteArrayOutputStream os=new  ByteArrayOutputStream();
		XMLEncoder encoder=new XMLEncoder(os);
		try {
			encoder.writeObject(sm);
			
		} catch (Exception e) {
			// TODO 自动生成 catch 块
//			e.printStackTrace();
		} finally {
			encoder.close();
			try {
				result=os.toString("UTF-8");
				IOUtils.closeQuietly(os);
			} catch (UnsupportedEncodingException e) {
				// TODO 自动生成 catch 块
				e.printStackTrace();
			}
		
		}
		extendInfoXml=result;
	}
	

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		docSubject = null;
		docCreateTime = null;
		docAlterTime = null;
		fdWsdlUrl = null;
		fdEnable = null;
		fdSoapVerson = null;
		fdCheck = "false";
		fdAllowBlock = null;
		fdOverTime = "3000";
		fdUserName = null;
		fdPassword = null;
		fdResponseTime = "3000";
		fdMarks = null;
		fdWsdlVersion = null;
		docCreatorId = null;
		docCreatorName = null;
		fdServerExtForms = new AutoArrayList(TibSysSoapSettingExtForm.class);
		docAddress = null;
		fdAuthMethod=null;
		fdloadUser=null;
		fdloadPwd=null;
		fdProtectWsdl="false";
		portName=null;
		passwordType = null;
		soapHeaderCustom = null;
		extendInfoXml=null;
		settCategoryId=null;
		settCategoryName=null;
		executePluginInfo(request);
		super.reset(mapping, request);
	}
	
	public void executePluginInfo(HttpServletRequest request){
		//加入扩展
		String fdAuthMehtod=request.getParameter("fdAuthMethod");
		if(StringUtil.isNull(fdAuthMehtod)){
			return ;
		}
		Map<String, String>  authInfo=LicenceHeaderPlugin.getConfigByKey(fdAuthMehtod);
		if(authInfo==null){
			return ;
		}
		String beanName=authInfo.get(LicenceHeaderPlugin.paramsParser);
		if(StringUtil.isNotNull(beanName)){
			try{
			Object serviceBean=SpringBeanUtil.getBean(beanName);
			if(serviceBean==null){ return ;};
			if(serviceBean instanceof ITibSysSoapParamsParser){
				List<MapVo> mpvs=((ITibSysSoapParamsParser)serviceBean).paramsParse(request);
				AutoArrayList res=new AutoArrayList(MapVo.class);
				res.addAll(mpvs);
				extendInfoList=res;
				setExtendInfoList(mpvs);
			}
			}catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}
		}
	}

	public String getFdAuthMethod() {
		return fdAuthMethod;
	}

	public void setFdAuthMethod(String fdAuthMethod) {
		this.fdAuthMethod = fdAuthMethod;
	}

	public Class getModelClass() {
		return TibSysSoapSetting.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("docCreatorId",
					new FormConvertor_IDToModel("docCreator",
						SysOrgElement.class));
			toModelPropertyMap.put("settCategoryId",
					new FormConvertor_IDToModel("settCategory",
							TibSysSoapSettCategory.class));
			toModelPropertyMap.put("fdServerExtForms", new FormConvertor_FormListToModelList(
					"fdServerExt", "fdServer"));
		}
		return toModelPropertyMap;
	}
	
	// 操作者
	private String docPoolAdmin;

	public String getDocPoolAdmin() {
		return docPoolAdmin;
	}

	public void setDocPoolAdmin(String docPoolAdmin) {
		this.docPoolAdmin = docPoolAdmin;
	}

	public String getFdProtectWsdl() {
		return fdProtectWsdl;
	}

	public void setFdProtectWsdl(String fdProtectWsdl) {
		this.fdProtectWsdl = fdProtectWsdl;
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
	
	//所属目录ID
	protected String settCategoryId=null;

	public String getSettCategoryId() {
		return settCategoryId;
	}

	public void setSettCategoryId(String settCategoryId) {
		this.settCategoryId = settCategoryId;
	}

	//所属目录Name
	protected String settCategoryName=null;

	public String getSettCategoryName() {
		return settCategoryName;
	}

	public void setSettCategoryName(String settCategoryName) {
		this.settCategoryName = settCategoryName;
	}
	
}
