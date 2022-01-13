(function() {
    "use strict";
    var messageVue,
    	Vue = window.Vue || null,
    	Element = window.Element || null;
    
    if(Vue&&Element){
    	messageVue = new Vue({});
    }
    
    var userAgent = navigator.userAgent.toLowerCase();
    var isIe = /(msie|trident).*?([\d.]+)/.test(userAgent);

    
    
    axios.interceptors.request.use(
    	function (config) {
    		//var a = JSON.stringify({a: 'b'});
    		//config.headers['preTeamName'] = 'LocalTeam';//样例1
    		//config.headers['preTeamName'] = a;//样例2
    		config.headers['X-Requested-With'] = 'XMLHttpRequest';
    		if (isIe) {
    			config.headers.common['Cache-Control'] = 'no-cache';
    			config.cache = false;
    			config.headers.get = config.headers.get || {};
    			config.headers.get['If-Modified-Since'] = '0'; 
    		}
    		return config;
      	}, function (error) {
      		return Promise.reject(error);
      	}
    );
    
    axios.interceptors.response.use(
    	function (response, a, b) {
    		var redirect = response.headers['redirect'];
    		if (redirect == 'true') {
    			var redirectUrl = response.headers['redirecturl'];
    			if (redirectUrl) {
    				window.top.location.href = redirectUrl;
    			}
    		}
			return response;
	    }, 
	    function (error) {
	    	var _message = error.message;
		    if(messageVue){
		    	messageVue.$message({
		            showClose: true,
		            message: _message,
		            type: 'error',
		            duration: 0,
		            iconClass: "el-icon-circle-cross",
		            customClass: 'axios-error-message'
		        });
	    	}else{
	    		console.error(error.response);
	    		console.error(_message);
	    	}
	        return Promise.reject(error);
	    }
	);
})();
