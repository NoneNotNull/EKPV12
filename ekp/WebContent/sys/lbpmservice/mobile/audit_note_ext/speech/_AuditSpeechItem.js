define( [ "dojo/_base/declare", "mui/device/device", "mui/device/adapter", "mui/util" ], 
		function(declare,  device, adapter, util) {

	return declare("sys.lbpmservice.mobile.audit_note_ext.speech._AuditSpeechItem",
			null, {
				
				icon : 'mui-voice',
				
				openFeature:function(evt){
					var url = util.formatUrl(this.href,true);
					if(device.getClientType()>6 && device.getClientType()<11){
						adapter.playSpeech(url);
					}else{
						location = url;
					}
				}
			
		});
});