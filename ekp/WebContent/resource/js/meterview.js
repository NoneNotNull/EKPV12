function MeterView(){
	this.value = new Array(0, 25, 50, 75, 100);
	this.color = new Array("green", "blue", "yellow", "red");
	this.curValue = 46;
	this.title = "Title";
	
	this.width = 120;
	this.top = 20;
	this.left = 20;
	
	this.padding = 10;
	this.titlePadding = 20;
	this.startAngle = -135;
	this.endAngle = 135;
	this.scaleNum = 50;
	this.textNum = 10;
	this.autoSetScale = true;
	this.lineColor = "black";
	this.scaleColor = "white";
	
	this.barWidth = 1500;
	this.lineLength = 4000;
	this.scaleMinlength = 800;
	this.scaleMaxlength = 1200;
	this.scalePosition = 5000;
	
	this.Components = new Array();
	this.DrawLine = MeterView_DrawLine;
	this.DrawOval = MeterView_DrawOval;
	this.DrawScale = MeterView_DrawScale;
	this.DrawSector = MeterView_DrawSector;
	this.DrawText = MeterView_DrawText;
	this.DrawTitle = MeterView_DrawTitle;
	this.Draw = MeterView_Draw;
}

function MeterView_DrawLine(){
	var dt = this.padding;
	var strElement = "<v:group style='position:absolute;width:"+(this.width-2*dt)+
		";height:"+(this.width-2*dt)+
		";top:"+(this.top+dt)+
		";left:"+(this.left+dt)+"' coordsize='10000,10000' />";
	var element = document.createElement(strElement);
	strElement =  "<v:line from='5000, 5000' to='5000, "+(5000-this.lineLength)+"' fillcolor="+this.lineColor+" strokeColor="+this.lineColor+" strokeWeight=2>";
	strElement += "<v:stroke StartArrow=Oval />";
	strElement += "</v:line>";
	element.innerHTML = strElement;
	document.body.appendChild(element);
	element.rotation = (this.curValue-this.value[0])/(this.value[this.value.length-1]-this.value[0])*(this.endAngle-this.startAngle)+this.startAngle;
	this.Components[this.Components.length] = element;
}

function MeterView_DrawOval(){
	var dt = this.padding+this.barWidth*(this.width-this.padding)/10000;
	var strElement = "<v:oval style='position:absolute;width:"+(this.width-2*dt)+
		";height:"+(this.width-2*dt)+
		";top:"+(this.top+dt)+
		";left:"+(this.left+dt)+"' fillcolor=white strokeColor=white />";
	var element = document.createElement(strElement);
	document.body.appendChild(element);
	this.Components[this.Components.length] = element;
}

function MeterView_DrawScale(){
	var dt = this.padding;
	var strElement = "<v:group style='position:absolute;width:"+(this.width-2*dt)+
		";height:"+(this.width-2*dt)+
		";top:"+(this.top+dt)+
		";left:"+(this.left+dt)+"' coordsize='10000,10000' />";
	var di = this.scaleNum/this.textNum;
	var da = (this.endAngle - this.startAngle)/this.scaleNum;
	var position = 5000 - this.scalePosition;
	var maxLength = position + this.scaleMaxlength;
	var minLength = position + this.scaleMinlength;
	for(var i=0; i<=this.scaleNum; i++){
		var element = document.createElement(strElement);
		document.body.appendChild(element);
		element.innerHTML = "<v:line from='5000,"+position+"' to='5000,"+(i%di==0?maxLength:minLength)+"' fillcolor="+this.scaleColor+" strokeColor="+this.scaleColor+" strokeWeight="+(i%di==0?2:1)+" />";
		element.rotation = this.startAngle+da*i;
	}
}

function MeterView_DrawSector(color,  start, value){
	var dt = this.padding;
	var strElement = "<v:group style='position:absolute;width:"+(this.width-2*dt)+
		";height:"+(this.width-2*dt)+
		";top:"+(this.top+dt)+
		";left:"+(this.left+dt)+"' CoordSize='10000,10000' />";
	var element = document.createElement(strElement);
	strElement =  "<v:arc style='position:relative;width:10000;height:10000' fillcolor="+color+"' strokeColor="+color+" startAngle=0 EndAngle="+value+" />";
	if(value!=180){
		if(value>180)
			color = "white";
		var x = 5000+Math.round(5000*Math.sin(Math.PI*value/180));
		var y = 5000-Math.round(5000*Math.cos(Math.PI*value/180));
		strElement +=  "<v:shape style='width:10000;height:10000' fillcolor="+color+" strokeColor="+color+">";
		strElement +=  "<v:Path v='m 5000,0 l "+x+","+y+",5000,5000 x e'/>";
		strElement +=  "</v:shape>";
	}
	element.innerHTML = strElement;	
	document.body.appendChild(element);
	element.rotation = start;
	this.Components[this.Components.length] = element;
}

function MeterView_DrawText(){
	var semidiameter = this.width/2;
	var dv = (this.value[this.value.length-1]-this.value[0])/this.textNum;
	var da = (this.endAngle-this.startAngle)/this.textNum;
	for(var i=0; i<=this.textNum; i++){
		var a = (this.startAngle + i*da)/180*Math.PI;
		var x = this.left + semidiameter*(1+Math.sin(a));
		var y = this.top + semidiameter*(1-Math.cos(a));
		var strElement = "<div style='position:absolute;font-size:12px;'></div>";
		var element = document.createElement(strElement);
		//element.innerHTML = formatFloat(this.value[0]+i*dv);//处理文本内容
		var v_1 =Math.round(i*(dv*10000000));
		var v_2 = Math.round((this.value[0]*10000000+(i*(dv*10000000))));
		element.innerHTML = formatFloat(v_2/10000000);
		//element.innerHTML = formatFloat(((this.value[0]*100000+((i*(dv*100000))))/100000));//处理文本内容
		document.body.appendChild(element);
		element.style.left = x - element.clientWidth/2;
		element.style.top = y - element.clientHeight/2;
	}
}

function formatFloat(x)
{
	//alert(x);	
	var nf = new NumberFormat(x);
	nf.setPlaces(2);	
	nf.setSeparators(false);
	var num = nf.toFormatted();
	var retval = num;
	//alert((this.value[4]+"").indexOf('.'));	
	x += "";
	var rtnVal = "", n = -1, c, c2;
	for(var i = 0; i<x.length; i++)
	{
		c = x.charAt(i);
		if(n==4)
			c2 = "0";
		else
		{
			c2 = c;
			switch(c)
			{
				case ".":
					break;
				case "0":
					if(n>-1)
						n++;
					break;
				default:
					n = 0;
			}
		}
		rtnVal += c2;
	}
	
	var retval = parseFloat(rtnVal);
	return retval;
}
function MeterView_DrawTitle(){
	var strElement = "<div style='position:absolute;font-size:12px;'></div>";
	var element = document.createElement(strElement);
	element.innerHTML = this.title;
	document.body.appendChild(element);
	var r = (this.width-2*this.padding)/2;
	var y = r*Math.cos(this.startAngle/180*Math.PI);
	element.style.top = (y>0?r:r-y)+this.padding+this.top+this.titlePadding;
	element.style.left = this.left + (this.width - element.clientWidth)/2;
	this.Components[this.Components.length] = element;
}

function MeterView_Draw(){
	var dt;
	if(this.autoSetScale){
		dt = Math.round(this.width/100)+2;
		this.scaleNum = this.textNum*dt;
	}
	var start = this.startAngle;
	dt = (this.endAngle - this.startAngle)/(this.value[this.value.length-1]-this.value[0]);
	var value;
	for(var i=0; i<this.color.length; i++){
		value = dt*(this.value[i+1]-this.value[i]);
		this.DrawSector(this.color[i],  start, value);
		start+=value;
	}
	this.DrawOval();
	this.DrawScale();
	this.DrawLine();
	this.DrawText();
	this.DrawTitle();
}


// mredkj.com
function NumberFormat(num, inputDecimal)
{
this.VERSION = 'Number Format v1.5.4';
this.COMMA = ',';
this.PERIOD = '.';
this.DASH = '-'; 
this.LEFT_PAREN = '('; 
this.RIGHT_PAREN = ')'; 
this.LEFT_OUTSIDE = 0; 
this.LEFT_INSIDE = 1;  
this.RIGHT_INSIDE = 2;  
this.RIGHT_OUTSIDE = 3;  
this.LEFT_DASH = 0; 
this.RIGHT_DASH = 1; 
this.PARENTHESIS = 2; 
this.NO_ROUNDING = -1 
this.num;
this.numOriginal;
this.hasSeparators = false;  
this.separatorValue;  
this.inputDecimalValue; 
this.decimalValue;  
this.negativeFormat; 
this.negativeRed; 
this.hasCurrency;  
this.currencyPosition;  
this.currencyValue;  
this.places;
this.roundToPlaces; 
this.truncate; 
this.setNumber = setNumberNF;
this.toUnformatted = toUnformattedNF;
this.setInputDecimal = setInputDecimalNF; 
this.setSeparators = setSeparatorsNF; 
this.setCommas = setCommasNF;
this.setNegativeFormat = setNegativeFormatNF; 
this.setNegativeRed = setNegativeRedNF; 
this.setCurrency = setCurrencyNF;
this.setCurrencyPrefix = setCurrencyPrefixNF;
this.setCurrencyValue = setCurrencyValueNF; 
this.setCurrencyPosition = setCurrencyPositionNF; 
this.setPlaces = setPlacesNF;
this.toFormatted = toFormattedNF;
this.toPercentage = toPercentageNF;
this.getOriginal = getOriginalNF;
this.moveDecimalRight = moveDecimalRightNF;
this.moveDecimalLeft = moveDecimalLeftNF;
this.getRounded = getRoundedNF;
this.preserveZeros = preserveZerosNF;
this.justNumber = justNumberNF;
this.expandExponential = expandExponentialNF;
this.getZeros = getZerosNF;
this.moveDecimalAsString = moveDecimalAsStringNF;
this.moveDecimal = moveDecimalNF;
this.addSeparators = addSeparatorsNF;
if (inputDecimal == null) {
this.setNumber(num, this.PERIOD);
} else {
this.setNumber(num, inputDecimal); 
}
this.setCommas(true);
this.setNegativeFormat(this.LEFT_DASH); 
this.setNegativeRed(false); 
this.setCurrency(false); 
this.setCurrencyPrefix('$');
this.setPlaces(2);
}
function setInputDecimalNF(val)
{
this.inputDecimalValue = val;
}
function setNumberNF(num, inputDecimal)
{
if (inputDecimal != null) {
this.setInputDecimal(inputDecimal); 
}
this.numOriginal = num;
this.num = this.justNumber(num);
}
function toUnformattedNF()
{
return (this.num);
}
function getOriginalNF()
{
return (this.numOriginal);
}
function setNegativeFormatNF(format)
{
this.negativeFormat = format;
}
function setNegativeRedNF(isRed)
{
this.negativeRed = isRed;
}
function setSeparatorsNF(isC, separator, decimal)
{
this.hasSeparators = isC;
if (separator == null) separator = this.COMMA;
if (decimal == null) decimal = this.PERIOD;
if (separator == decimal) {
this.decimalValue = (decimal == this.PERIOD) ? this.COMMA : this.PERIOD;
} else {
this.decimalValue = decimal;
}
this.separatorValue = separator;
}
function setCommasNF(isC)
{
this.setSeparators(isC, this.COMMA, this.PERIOD);
}
function setCurrencyNF(isC)
{
this.hasCurrency = isC;
}
function setCurrencyValueNF(val)
{
this.currencyValue = val;
}
function setCurrencyPrefixNF(cp)
{
this.setCurrencyValue(cp);
this.setCurrencyPosition(this.LEFT_OUTSIDE);
}
function setCurrencyPositionNF(cp)
{
this.currencyPosition = cp
}
function setPlacesNF(p, tr)
{
this.roundToPlaces = !(p == this.NO_ROUNDING); 
this.truncate = (tr != null && tr); 
this.places = (p < 0) ? 0 : p; 
}
function addSeparatorsNF(nStr, inD, outD, sep)
{
nStr += '';
var dpos = nStr.indexOf(inD);
var nStrEnd = '';
if (dpos != -1) {
nStrEnd = outD + nStr.substring(dpos + 1, nStr.length);
nStr = nStr.substring(0, dpos);
}
var rgx = /(\d+)(\d{3})/;
while (rgx.test(nStr)) {
nStr = nStr.replace(rgx, '$1' + sep + '$2');
}
return nStr + nStrEnd;
}
function toFormattedNF()
{	
var pos;
var nNum = this.num; 
var nStr;            
var splitString = new Array(2);   
if (this.roundToPlaces) {
nNum = this.getRounded(nNum);
nStr = this.preserveZeros(Math.abs(nNum)); 
} else {
nStr = this.expandExponential(Math.abs(nNum)); 
}
if (this.hasSeparators) {
nStr = this.addSeparators(nStr, this.PERIOD, this.decimalValue, this.separatorValue);
} else {
nStr = nStr.replace(new RegExp('\\' + this.PERIOD), this.decimalValue); 
}
var c0 = '';
var n0 = '';
var c1 = '';
var n1 = '';
var n2 = '';
var c2 = '';
var n3 = '';
var c3 = '';
var negSignL = (this.negativeFormat == this.PARENTHESIS) ? this.LEFT_PAREN : this.DASH;
var negSignR = (this.negativeFormat == this.PARENTHESIS) ? this.RIGHT_PAREN : this.DASH;
if (this.currencyPosition == this.LEFT_OUTSIDE) {
if (nNum < 0) {
if (this.negativeFormat == this.LEFT_DASH || this.negativeFormat == this.PARENTHESIS) n1 = negSignL;
if (this.negativeFormat == this.RIGHT_DASH || this.negativeFormat == this.PARENTHESIS) n2 = negSignR;
}
if (this.hasCurrency) c0 = this.currencyValue;
} else if (this.currencyPosition == this.LEFT_INSIDE) {
if (nNum < 0) {
if (this.negativeFormat == this.LEFT_DASH || this.negativeFormat == this.PARENTHESIS) n0 = negSignL;
if (this.negativeFormat == this.RIGHT_DASH || this.negativeFormat == this.PARENTHESIS) n3 = negSignR;
}
if (this.hasCurrency) c1 = this.currencyValue;
}
else if (this.currencyPosition == this.RIGHT_INSIDE) {
if (nNum < 0) {
if (this.negativeFormat == this.LEFT_DASH || this.negativeFormat == this.PARENTHESIS) n0 = negSignL;
if (this.negativeFormat == this.RIGHT_DASH || this.negativeFormat == this.PARENTHESIS) n3 = negSignR;
}
if (this.hasCurrency) c2 = this.currencyValue;
}
else if (this.currencyPosition == this.RIGHT_OUTSIDE) {
if (nNum < 0) {
if (this.negativeFormat == this.LEFT_DASH || this.negativeFormat == this.PARENTHESIS) n1 = negSignL;
if (this.negativeFormat == this.RIGHT_DASH || this.negativeFormat == this.PARENTHESIS) n2 = negSignR;
}
if (this.hasCurrency) c3 = this.currencyValue;
}
nStr = c0 + n0 + c1 + n1 + nStr + n2 + c2 + n3 + c3;
if (this.negativeRed && nNum < 0) {
nStr = '<font color="red">' + nStr + '</font>';
}
return (nStr);
}
function toPercentageNF()
{
nNum = this.num * 100;
nNum = this.getRounded(nNum);
return nNum + '%';
}
function getZerosNF(places)
{
var extraZ = '';
var i;
for (i=0; i<places; i++) {
extraZ += '0';
}
return extraZ;
}
function expandExponentialNF(origVal)
{
if (isNaN(origVal)) return origVal;
var newVal = parseFloat(origVal) + ''; 
var eLoc = newVal.toLowerCase().indexOf('e');
if (eLoc != -1) {
var plusLoc = newVal.toLowerCase().indexOf('+');
var negLoc = newVal.toLowerCase().indexOf('-', eLoc); 
var justNumber = newVal.substring(0, eLoc);
if (negLoc != -1) {
var places = newVal.substring(negLoc + 1, newVal.length);
justNumber = this.moveDecimalAsString(justNumber, true, parseInt(places));
} else {
if (plusLoc == -1) plusLoc = eLoc;
var places = newVal.substring(plusLoc + 1, newVal.length);
justNumber = this.moveDecimalAsString(justNumber, false, parseInt(places));
}
newVal = justNumber;
}
return newVal;
} 
function moveDecimalRightNF(val, places)
{
var newVal = '';
if (places == null) {
newVal = this.moveDecimal(val, false);
} else {
newVal = this.moveDecimal(val, false, places);
}
return newVal;
}
function moveDecimalLeftNF(val, places)
{
var newVal = '';
if (places == null) {
newVal = this.moveDecimal(val, true);
} else {
newVal = this.moveDecimal(val, true, places);
}
return newVal;
}
function moveDecimalAsStringNF(val, left, places)
{
var spaces = (arguments.length < 3) ? this.places : places;
if (spaces <= 0) return val; 
var newVal = val + '';
var extraZ = this.getZeros(spaces);
var re1 = new RegExp('([0-9.]+)');
if (left) {
newVal = newVal.replace(re1, extraZ + '$1');
var re2 = new RegExp('(-?)([0-9]*)([0-9]{' + spaces + '})(\\.?)');		
newVal = newVal.replace(re2, '$1$2.$3');
} else {
var reArray = re1.exec(newVal); 
if (reArray != null) {
newVal = newVal.substring(0,reArray.index) + reArray[1] + extraZ + newVal.substring(reArray.index + reArray[0].length); 
}
var re2 = new RegExp('(-?)([0-9]*)(\\.?)([0-9]{' + spaces + '})');
newVal = newVal.replace(re2, '$1$2$4.');
}
newVal = newVal.replace(/\.$/, ''); 
return newVal;
}
function moveDecimalNF(val, left, places)
{
var newVal = '';
if (places == null) {
newVal = this.moveDecimalAsString(val, left);
} else {
newVal = this.moveDecimalAsString(val, left, places);
}
return parseFloat(newVal);
}
function getRoundedNF(val)
{
val = this.moveDecimalRight(val);
if (this.truncate) {
val = val >= 0 ? Math.floor(val) : Math.ceil(val); 
} else {
val = Math.round(val);
}
val = this.moveDecimalLeft(val);
return val;
}
function preserveZerosNF(val)
{
var i;
val = this.expandExponential(val);
if (this.places <= 0) return val; 
var decimalPos = val.indexOf('.');
if (decimalPos == -1) {
val += '.';
for (i=0; i<this.places; i++) {
val += '0';
}
} else {
var actualDecimals = (val.length - 1) - decimalPos;
var difference = this.places - actualDecimals;
for (i=0; i<difference; i++) {
val += '0';
}
}
return val;
}
function justNumberNF(val)
{
newVal = val + '';
var isPercentage = false;
if (newVal.indexOf('%') != -1) {
newVal = newVal.replace(/\%/g, '');
isPercentage = true; 
}
var re = new RegExp('[^\\' + this.inputDecimalValue + '\\d\\-\\+\\(\\)eE]', 'g');	
newVal = newVal.replace(re, '');
var tempRe = new RegExp('[' + this.inputDecimalValue + ']', 'g');
var treArray = tempRe.exec(newVal); 
if (treArray != null) {
var tempRight = newVal.substring(treArray.index + treArray[0].length); 
newVal = newVal.substring(0,treArray.index) + this.PERIOD + tempRight.replace(tempRe, ''); 
}
if (newVal.charAt(newVal.length - 1) == this.DASH ) {
newVal = newVal.substring(0, newVal.length - 1);
newVal = '-' + newVal;
}
else if (newVal.charAt(0) == this.LEFT_PAREN
&& newVal.charAt(newVal.length - 1) == this.RIGHT_PAREN) {
newVal = newVal.substring(1, newVal.length - 1);
newVal = '-' + newVal;
}
newVal = parseFloat(newVal);
if (!isFinite(newVal)) {
newVal = 0;
}
if (isPercentage) {
newVal = this.moveDecimalLeft(newVal, 2);
}
return newVal;
}
