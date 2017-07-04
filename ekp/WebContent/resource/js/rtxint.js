//*************************************************
//
//	Author: Yu Zhang
//	Created Date: 2004-03-08
//	Version: 1.0.0.2 (the same with RTXName.dll)
//
//*************************************************

var RTX_STATUS_UNKNOWN = -1;
var RTX_STATUS_OFFLINE = 0;
var RTX_STATUS_ONLINE = 1;
var RTX_STATUS_AWAY = 2;

var RTX_DOWNLOAD_TIMEOUT_TRYCOUNT = 300; // 30s = 300 * 100
var rtx_downloadTryCount = 0;

var rtx_oldWinOnload = null;
var rtx_isFirstLoad = false;
var rtx_oldWinScroll = null;
var rtx_isInWinScroll = false;

var rtx_needDownload = false;
var rtx_codebase = null;

if(rtx_codebase == null)
{
	RDL("cab");
}

var rtx_nameControlID = "RTXNameControlID";
var rtx_nameControlHTMLFormat = "<object classid='clsid:8F8086BE-0925-481D-B3C1-06BCB4121A5E' codebase='%CODEBASE%/RTXName.dll#version=1,0,0,9' id='" + rtx_nameControlID + "' onerror='rtx_nameControlOnError();' style='display:none;'></object>";
var rtx_namePrefix = "rtxname";
var rtx_nameIndex = 0;
var rtx_nameControl = null;
var rtx_isNameControlInited = false;
var rtx_isNameControlLoadError = false;
var rtx_idDictionary = null;
var rtx_stateDictionary = null;
var rtx_nickDictionary = null;
var rtx_showOfflineDictionary = null;
var rtx_groupidDictionary = null;
var rtx_pageGroupNicks = "";

var m_isLogout = false;
var rtx_updateAllStatusCallInfo = null;
var rtx_frameRandom = 0;

// Functions go from here.

function RAGP(nicks, isPageGroup)
{
	rtx_addGroupPresence(nicks, isPageGroup);
}

function rtx_addGroupPresence(nicks, isPageGroup)
{
    var src = event.srcElement;
	var id;
	
	rtx_register_winOnload();
	
	if(!rtx_groupidDictionary)
	{
		rtx_groupidDictionary = new Object();
	}
	
	if(rtx_groupidDictionary && src && typeof(nicks) == "string")
	{
		id = rtx_namePrefix + (rtx_nameIndex++);
		src.id = id;
		src.isGroup = true;
		
		if(isPageGroup)
		{
			src.isPageGroup = true;
		}

		rtx_groupidDictionary[id] = nicks;

		src.onload = null;
	}
}

function rtx_updateGroupImages()
{
	var id;
	var obj;
	var img;
	
	for(id in rtx_groupidDictionary)
	{
		obj = document.images(id);
		
		if(obj && obj.isGroup)
		{
			obj.onmouseover = rtx_showUIMouse;
			obj.onmouseout = rtx_hideUI;

			img = "rtxgrp.gif";
			window.setTimeout("rtx_updateImage('" + id + "', '" + img + "');", 1);
		}
	}
}

function RAP(nick)
{
	rtx_addPresence(nick);
}

function rtx_addPresence(nick)
{
    var src = event.srcElement;
	var id;
	
	rtx_register_winOnload();
	
	if(!rtx_idDictionary)
	{
		rtx_idDictionary = new Object();
		rtx_stateDictionary = new Object();
		rtx_nickDictionary = new Object();
		rtx_showOfflineDictionary = new Object();
	}
	
	if(rtx_idDictionary && src)
	{
		id = rtx_namePrefix + (rtx_nameIndex++);
		src.id = id;
		rtx_idDictionary[id] = nick;
		
		rtx_stateDictionary[id] = RTX_STATUS_UNKNOWN;
		
		if(typeof(rtx_nickDictionary[nick]) == "undefined")
		{
			rtx_nickDictionary[nick] = new Array();
			rtx_pageGroupNicks += nick + '\0';
		}

		var idArray = rtx_nickDictionary[nick];
		
		if(typeof(idArray) == "object")
		{
			idArray[idArray.length] = id;
		}

		if(typeof(src.showOffline) != "undefined")
		{
			rtx_showOfflineDictionary[id] = true;
		}
		
		src.onload = null;
        src.onmouseover = rtx_showUIMouse;
        src.onmouseout = rtx_hideUI;
	}
}

function rtx_showUIMouse()
{
    rtx_showUI(0);
}

function rtx_showUI(inputType)
{
	var obj =  event.srcElement;

	if(obj && rtx_nameControl)
	{
		var uiLocation = rtx_getUILocation(obj);

		if(obj.isGroup)
		{
			var nicks = null;
			
			if(obj.isPageGroup)
			{
				nicks = rtx_pageGroupNicks;
			}
			else if(rtx_groupidDictionary)
			{
				nicks = rtx_groupidDictionary[obj.id];
			}

			if(typeof(nicks) == "string" && nicks.length > 0)
			{
				rtx_nameControl.ShowGroupUI(nicks, inputType, uiLocation.uiX, uiLocation.uiY);
			}
		}
		else
		{
			if(rtx_idDictionary)
			{
				var nick = rtx_idDictionary[obj.id];

				rtx_nameControl.ShowOOUI(nick, inputType, uiLocation.uiX, uiLocation.uiY);
			}
		}
	}
}

function rtx_getUILocation(objSrc)
{
	var obj = objSrc;
	var uiLocation = new Object();
	var uiX = 0;
	var uiY = 0
	var objDX = 0;
	var fRtl = (document.dir == "rtl");
	var parentWindow = window;
	
	if(rtx_frameRandom == 0)
	{
		var dt = new Date();

		rtx_frameRandom = dt.getSeconds() * 1000 + dt.getMilliseconds();
	}

	rtx_frameRandom++;

	while(obj && obj.rtxframeRandom != rtx_frameRandom)
	{
		obj.rtxframeRandom = rtx_frameRandom;

		if(fRtl)
		{
			if(obj.scrollWidth >= obj.clientWidth + obj.scrollLeft)        
			{
				objDX = obj.scrollWidth - obj.clientWidth - obj.scrollLeft;
			}
			else
			{
				objDX = obj.clientWidth + obj.scrollLeft - obj.scrollWidth;
			}

			uiX += obj.offsetLeft + objDX;
		}
		else
		{
			uiX += obj.offsetLeft - obj.scrollLeft;
		}

		uiY += obj.offsetTop - obj.scrollTop;
		obj = obj.offsetParent;            

		
	}

	if(parentWindow)
	{
		uiX += parentWindow.screenLeft;
		uiY += parentWindow.screenTop;
	}

	uiLocation.uiX = uiX;
	uiLocation.uiY = uiY;

	if(fRtl)
	{
		uiLocation.uiX += objSrc.offsetWidth;
	}

	return uiLocation;
}

function rtx_hideUI()
{
	if(rtx_nameControl)
	{
		rtx_nameControl.HideOOUI();
		return false;
	}

	return true;
}

function rtx_register_winScroll()
{
	rtx_oldWinScroll = window.onscroll;
	window.onscroll = rtx_winScroll;
}

function rtx_winScroll()
{
	if(!rtx_isInWinScroll)
	{
		rtx_isInWinScroll = true;
		rtx_hideUI();
	}

	rtx_isInWinScroll = false;

	return typeof(rtx_oldWinScroll) == "function" ? rtx_oldWinScroll() : true;   
}

function RDL(codebase)
{
	rtx_download(codebase);
}

function rtx_download(codebase)
{
	if(typeof(codebase) == "string")
	{
		rtx_needDownload = true;
		rtx_codebase = codebase;
	}
}

function rtx_downloadNameControl()
{
	var strHTML = rtx_nameControlHTMLFormat.replace(/%CODEBASE%/g, rtx_codebase);

	document.body.insertAdjacentHTML("beforeEnd", strHTML);
	
	rtx_nameControlLoadTimer();
}

function rtx_createNameControl()
{
	if(rtx_needDownload)
	{
		rtx_downloadNameControl();
	}
	else
	{
		rtx_ensureNameControl();
	}
}

function rtx_nameControlOnload()
{
	rtx_ensureNameControl();
}

function rtx_nameControlLoadTimer()
{
	if(!rtx_isNameControlLoadError)
	{
		var obj = document.all(rtx_nameControlID);

		if(obj && typeof(obj.PresenceEnabled) != "undefined")
		{
			if(obj.PresenceEnabled)
			{
				rtx_nameControlOnload();
			}
		}
		else
		{
			if(rtx_downloadTryCount < RTX_DOWNLOAD_TIMEOUT_TRYCOUNT)
			{
				rtx_downloadTryCount++;
				window.setTimeout("rtx_nameControlLoadTimer();", 100);
			}
			else
			{
				rtx_ensureNameControl(); // Advanced try.
			}
		}
	}
	else
	{
		rtx_ensureNameControl(); // Advanced try.
	}
}

function rtx_nameControlOnError()
{
	rtx_isNameControlLoadError = true;
}

function rtx_ensureNameControl()
{
    if(!rtx_isNameControlInited)
    {
		if(rtx_browserInfo.ie5up && rtx_browserInfo.win32)
		{
//@cc_on
//@if(@_jscript_version >= 5)
//@			try
//@			{
//@				rtx_nameControl = new ActiveXObject("RTXName.NameCtrl");
//@			}
//@			catch(e)
//@			{
//@			};
//@else
//@end
		}
        
		rtx_isNameControlInited = true;

		if(rtx_nameControl)
		{
			if(rtx_nameControl.PresenceEnabled)
			{
				rtx_register_winScroll();
				
				if(rtx_nameControl.SupportGroup)
				{
					rtx_updateGroupImages();
				}
				
				rtx_nameControl.OnStatusChange = rtx_OnStatusChange;
				rtx_updateAllStatus(2);
			}
			else
			{
				rtx_nameControl = null;
			}
		}
	}
	
	return rtx_nameControl;
}

function rtx_OnStatusChange(nick, state, file, rtxNum)
{
//    window.status = nick + ":" + state + ":" + file + ":" + rtxNum;

    if(rtx_idDictionary)
    {
		if(state >= 0)
		{
			var idArray = rtx_getIDArrayFromNick(nick);
			var index;

			if(idArray)
			{
				for(index in idArray)
				{
					rtx_updateImageOfID(idArray[index], state, file);
				}
			}

			rtx_onlogin();
        }
        else
        {
			switch(state)
			{
			case -1:
				m_isLogout = true;
			
				window.setTimeout("rtx_allOffline();", 1000);
				break;
			case -2:
				rtx_onlogin();
				break;
			default:
				break;
			}
        }
    }
}

function rtx_winOnload()
{
	if(typeof(rtx_oldWinOnload) == "function")
	{
		rtx_oldWinOnload();
	}
	
	rtx_createNameControl();
}

function rtx_register_winOnload()
{
	if(!rtx_isFirstLoad)
	{
		rtx_isFirstLoad = true;
		
		rtx_oldWinOnload = window.onload;
		window.onload = rtx_winOnload;
	}
}

function rtx_getIDArrayFromNick(nick)
{
    var idArray = null;

    if(typeof(nick) == "string" && typeof(rtx_nickDictionary[nick]) == "object")
    {
        idArray = rtx_nickDictionary[nick];
    }

    return idArray;
}

function rtx_allOffline()
{
	var state = RTX_STATUS_OFFLINE;
	var nick;
	var idArray;
	var index;
	
	if(rtx_nickDictionary)
	{
		for(nick in rtx_nickDictionary)
		{
			idArray = rtx_getIDArrayFromNick(nick);

			if(idArray)
			{
				for(index in idArray)
				{
					rtx_updateImageOfID(idArray[index], state, "");
				}
			}
		}
	}

	m_retryCount = 0;
}

function rtx_isOnlineState(state)
{
	return state == RTX_STATUS_ONLINE || state == RTX_STATUS_AWAY;
}

function rtx_onlogin()
{
	if(m_isLogout)
	{
		m_isLogout = false;

		if(!rtx_updateAllStatusCallInfo)
		{
			window.setTimeout("rtx_updateAllStatus(5);",6000);
		}
	}
}

function rtx_updateAllStatus(retryCount)
{
	var updateCount;
	var state = 0;
	var stateImage;
	var nick;
	var id;
	var dict;
	var i;
	var idArray;
	var maxLoopCount = 10;
	
	if(!rtx_updateAllStatusCallInfo)
	{
		rtx_updateAllStatusCallInfo = new Object();
		
		updateCount = 0;
		
		dict = new Object();
		rtx_updateAllStatusCallInfo.dict = dict;

		i = 0;
		idArray = new Array();
		for(id in rtx_idDictionary)
		{
			idArray[i++] = id;
		}
		rtx_updateAllStatusCallInfo.idArray = idArray;

		rtx_updateAllStatusCallInfo.index = 0;
	}
	else
	{
		updateCount = rtx_updateAllStatusCallInfo.updateCount;
		dict = rtx_updateAllStatusCallInfo.dict;
		idArray = rtx_updateAllStatusCallInfo.idArray;
	}

	if(rtx_idDictionary && rtx_nameControl && dict && idArray)
	{
		var loopCount = idArray.length < (rtx_updateAllStatusCallInfo.index + maxLoopCount) ? idArray.length : (rtx_updateAllStatusCallInfo.index + maxLoopCount); 

		for(i = rtx_updateAllStatusCallInfo.index; i < loopCount; i++)
		{
			id = idArray[i];
			nick = rtx_idDictionary[id];

			if(dict[nick])
			{
				stateImage = dict[nick].stateImage;
				state = dict[nick].state;
			}
			else
			{
				stateImage = rtx_nameControl.GetStatusImage(nick, id);
				state = rtx_getStatusFromImage(stateImage);
				
				dict[nick] = new Object();
				dict[nick].stateImage = stateImage;
				dict[nick].state = state;

				if(rtx_isOnlineState(state))
				{
					updateCount++;
				}
			}
			
			if(rtx_updateImageOfID(id, state, stateImage))
			{
			}
		}
		
		if(!m_isLogout)
		{
			if(i < idArray.length)
			{
				rtx_updateAllStatusCallInfo.index = i;
				rtx_updateAllStatusCallInfo.updateCount = updateCount;
				window.setTimeout("rtx_updateAllStatus(" + retryCount + ");", 10);
			}
			else
			{
				rtx_updateAllStatusCallInfo = null;
				
				if(updateCount < 2)
				{
					retryCount--;
					
					if(retryCount > 0)
					{
						window.setTimeout("rtx_updateAllStatus(" + retryCount + ");", 6000);
					}
				}
			}
		}
		else
		{
			rtx_updateAllStatusCallInfo = null;
		}
	}
}

function rtx_getStatusImage(state, stateImage, showOffline)
{
	var img = "blank.gif";

	if(stateImage == "")
	{
		switch(state)
		{
		case RTX_STATUS_OFFLINE:
			if(showOffline)
			{
				img = "rtxoff.gif";
			}
			else
			{
				img = "blank.gif";
			}
			break;      
		case RTX_STATUS_ONLINE:
			img = "rtxon.gif";
			break;  
		case RTX_STATUS_AWAY:
			img = "rtxaway.gif";
			break;
		default:
			break;
		}
	}
	else
	{
		if(state == RTX_STATUS_UNKNOWN || (state == RTX_STATUS_OFFLINE && !showOffline))
		{
			img = "blank.gif";
		}
		else
		{
			img = stateImage;
		}
	}

	return img;
}
function rtx_getStatusFromImage(stateImage)
{
	var state = RTX_STATUS_UNKNOWN;
	var stateFromImage;
	var ext = "";

	if(typeof(stateImage) == "string" && stateImage.length >= 5)
	{
		ext = stateImage.substring(stateImage.length - 4, stateImage.length);

		if(ext == ".bmp")
		{
			stateFromImage = stateImage.substring(stateImage.length - 5, stateImage.length - 4);
			
			stateFromImage = parseInt(stateFromImage, 10);
			
			if(isNaN(stateFromImage))
			{
				stateFromImage = 0;
			}
			
			switch(stateFromImage)
			{
			case 1:
				state = RTX_STATUS_ONLINE;
				break;
			case 2:
				state = RTX_STATUS_OFFLINE;
				break;
			case 3:
				state = RTX_STATUS_AWAY;
				break;
			default:
				state = RTX_STATUS_UNKNOWN;
				break;
			}
		}
	}

	return state;
}

function rtx_updateImageOfID(id, state, stateImage)
{
	var isUpdate = false;

	if(rtx_idDictionary && id != null)
	{
		var img = rtx_getStatusImage(state, stateImage, rtx_showOfflineDictionary[id]);

		if(rtx_stateDictionary[id] != state)
		{
			img = img.replace(/\\/g, "\\\\");
			window.setTimeout("rtx_updateImage('" + id + "', '" + img + "');rtx_stateDictionary['" + id + "'] = " + state + ";", 1);

			isUpdate = true;
		}
	}

	return isUpdate;
}

function rtx_updateImage(id, img)
{
	var obj = document.images(id);

	if(obj && typeof(img) == "string")
	{
		var oldImg = obj.src;
		var index;
		var newImg;

		if(!obj.imageBaseURL)
		{
			index = oldImg.lastIndexOf("/");
			obj.imageBaseURL = oldImg.slice(0, index + 1);
		}

		index = img.lastIndexOf("\\");

		if(index == -1)
		{
			newImg = obj.imageBaseURL + img;
		}
		else
		{
			newImg = img;
		}

		if(oldImg != newImg)
		{
			obj.style.filter = "Chroma(Color = '#00008080', Enable = true)";
			obj.src = newImg;
		}
	}
}
