/*JS和Objc之间的桥接*/
var jQuery = $;
var Js = {
	setReadonly: function(name, read)
	{
		jQuery('input[name=' + name + ']')
		.attr('readonly', read);
	},
	setInitFileValue:function(value, field)
	{
		if (jQuery('#' + field).length == 1) {
			jQuery('#' + field).val(value);
		}
		if (jQuery('input[name=' + field + ']').length == 1) {
			jQuery('input[name=' + field + ']').val(value);
		}
		if (jQuery('select[name=' + field + ']').length == 1) {
			jQuery('select[name=' + field + ']').val(value);
		}
	},
	formValue: function(){
		var values = jQuery('form').serializeArray();
        var result = {};
        for(var i=0;i<values.length;i++){
            result[values[i].name] = values[i].value;
        }
		return JSON.stringify(result);
	},
	call: function(functionName, args)
	{
		var iframe = document.createElement("IFRAME");
		var argtype = jQuery.type(args);
		if (argtype === 'object') {
			args = encodeURIComponent(JSON.stringify(args));
		}
		iframe.setAttribute("src", "objc-call:" + functionName + ":" + args);
		document.documentElement.appendChild(iframe);
		iframe.parentNode.removeChild(iframe);
		iframe = null;
	},
	setValue: function(value) {
		var kvs = value;
		if (!jQuery.isPlainObject(value)) {
			kvs = JSON.parse(value);
		}
		for (var key in kvs) {
			Js.setInitFileValue(kvs[key], key);
		}
	},
	getFiled: function(fname) {
		return jQuery('input[name="' + fname + '"]').val();
	},
	alert: function(title, content)
	{
		Js.call('_system_alert_msg', {
		            "title": title,
		            "content": content
				});
	},
	hideKeyboard : function()
	{
		$(":input").blur();
	},
};

//jQuery(function(){
//    $('form').append('<button id="submitButton" style="width:0;height:0;background:transparent;border:none;" ></button');
//});
