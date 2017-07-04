<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
	<ul class="tab_header auditNoteHandlerHeader">
               <li>笔触：</li>
               <li><select name="selectPenWidth">
                    <option value="1">1</option>   
                    <option value="2">2</option>   
                    <option value="3">3</option>   
                    <option value="4">4</option>   
                    <option value="5">5</option> 
                    <option value="6">6</option> 
                    <option value="7">7</option> 
                    <option value="8" selected>8</option> 
                    <option value="9">9</option> 
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                    <option value="13">13</option>
                    <option value="14">14</option>
                    <option value="15">15</option>
                  </select>
               </li>
               <li>颜色：</li>
               <li><select name="selectPenColor"> 
                      <option value="black" selected>黑色</option>  
				   <option value="red">红色</option> 
				   <option value="blue">蓝色</option>
                 </select>
            </li>
        </ul>
        <div class="popup_floatLayer_content canvasDiv"></div>
        <div data-dojo-type="mui/tabbar/TabBar" class="auditNoteHandlerToolbar" fixed="bottom" data-dojo-props='fill:"grid"'>
			<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnDefault auditNoteHandlerCancel">
				<i class="mui mui-cancel"></i>取消</li>
			<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnSubmit auditNoteHandlerSave" 
			data-dojo-props='colSize:2'>
				<i class="mui mui-confirm"></i>确定</li>
			<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnDefault auditNoteHandlerClear">
				<i class="mui mui-clear"></i>清除</li>
		</div>
