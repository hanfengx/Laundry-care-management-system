(function() {
    "use strict";
	var langCollection = ['en','zh-CN'];
	
	var localLang = localStorage['DEFAULTLANG'];
	if (!localLang||(localLang&&langCollection.indexOf(localLang)<0)) { 
		$.ajax({ 
		    type : "get",
		    async: false,
		    url : _contextPath+'/i18n/getLang',
            dataType:'json',
            success: function(data){
            	if(data.state) {
            		localStorage['DEFAULTLANG'] = data.lang;
            	} else {
            		localStorage['DEFAULTLANG'] = 'zh-CN';
            	}
		    },
		    error:function(){
		    	localStorage['DEFAULTLANG'] = 'zh-CN';
		    }
		});
		
	} else {
		$.ajax({ 
		    type : "get",
		    async: false,
		    data:{lang:localLang},
		    url : _contextPath+'/i18n/changeLang',
            dataType:'json',
            success: function(data){
		    }
		});
	}
	
	var LANGURL = window.LANGURL || _contextPath + '/i18n/';
    var DEFAULTLANG = window.DEFAULTLANG || localStorage['DEFAULTLANG'] || 'zh-CN';
    
	var messages = {};
	
	messages['en'] = _.extend(ELEMENT.lang.en, ELEMENTUEX.lang.en);
	messages['zh-CN'] = _.extend(ELEMENT.lang.zhCN, ELEMENTUEX.lang.zhCN);
	
	for(var i in langCollection){
    	$.ajax({
        	type : "get",
        	url: LANGURL + langCollection[i] + ".json",
        	dataType:'json',
        	async: false,
        	success: function(data){
        		messages[langCollection[i]] = _.extend(messages[langCollection[i]], data);
        	},
        	error: function(data){
        		console.error("获取不到"+langCollection[i]+"数据!");
        	}
        });
    }
	
	Vue.use(VueI18n);
	var i18n = new VueI18n({
	    locale: DEFAULTLANG,
	    messages: messages
	})
	
	ELEMENT.locale({el: i18n.vm.messages[DEFAULTLANG].el});
	ELEMENTUEX.locale({el: i18n.vm.messages[DEFAULTLANG].el});
	
	var langStore = new Vue({
		methods: {
			changeLang: function(i18n, lang){
				localStorage['DEFAULTLANG'] = lang
				i18n.locale = lang;
				ELEMENT.locale({el: i18n.vm.messages[lang].el});
				ELEMENTUEX.locale({el: i18n.vm.messages[lang].el});
				$.ajax({ 
				    type : "get",
				    async:false,
				    data:{lang:lang},
				    url : _contextPath+'/i18n/changeLang',
	                dataType:'json',
	                success: function(data){
	                	if(data.state) {
	                		location.reload(); 
	                	}
				    }
				});
			}
		}
	});
	
	window.langStore = langStore;
	window.i18n = i18n
})();