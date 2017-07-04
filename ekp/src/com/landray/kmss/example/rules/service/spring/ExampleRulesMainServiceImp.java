package com.landray.kmss.example.rules.service.spring;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.example.rules.service.IExampleRulesMainService;
import com.landray.kmss.sys.metadata.interfaces.ExtendDataServiceImp;
import com.landray.kmss.example.rules.model.ExampleRulesMain;
/**
 * 最新案例业务接口实现
 * 
 * @author 戴云
 * @version 1.0 2017-07-04
 */
public class ExampleRulesMainServiceImp extends ExtendDataServiceImp implements IExampleRulesMainService {

	@Override
	public String add(IBaseModel modelObj) throws Exception {
		ExampleRulesMain main = (ExampleRulesMain) modelObj;
		return super.add(modelObj);
	}
}
