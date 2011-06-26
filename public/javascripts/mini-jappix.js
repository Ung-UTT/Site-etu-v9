
(function(global){var SETTIMEOUT=global.setTimeout,doc=global.document,callback_counter=0;global.jXHR=function(){var script_url,script_loaded,jsonp_callback,scriptElem,publicAPI=null;function removeScript(){try{scriptElem.parentNode.removeChild(scriptElem);}catch(err){}}
function reset(){script_loaded=false;script_url="";removeScript();scriptElem=null;fireReadyStateChange(0);}
function ThrowError(msg){try{publicAPI.onerror.call(publicAPI,msg,script_url);}catch(err){}}
function handleScriptLoad(){if((this.readyState&&this.readyState!=="complete"&&this.readyState!=="loaded")||script_loaded){return;}
this.onload=this.onreadystatechange=null;script_loaded=true;if(publicAPI.readyState!==4)ThrowError("handleScriptLoad: Script failed to load ["+script_url+"].");removeScript();}
function parseXMLString(xmlStr){var xmlDoc=null;if(window.DOMParser){var parser=new DOMParser();xmlDoc=parser.parseFromString(xmlStr,"text/xml");}
else{xmlDoc=new ActiveXObject("Microsoft.XMLDOM");xmlDoc.async="false";xmlDoc.loadXML(xmlStr);}
return xmlDoc;}
function fireReadyStateChange(rs,args){args=args||[];publicAPI.readyState=rs;if(rs==4){publicAPI.responseText=args[0].reply;publicAPI.responseXML=parseXMLString(args[0].reply);}
if(typeof publicAPI.onreadystatechange==="function")publicAPI.onreadystatechange.apply(publicAPI,args);}
publicAPI={onerror:null,onreadystatechange:null,readyState:0,status:200,responseBody:null,responseText:null,responseXML:null,open:function(method,url){reset();var internal_callback="cb"+(callback_counter++);(function(icb){global.jXHR[icb]=function(){try{fireReadyStateChange.call(publicAPI,4,arguments);}
catch(err){publicAPI.readyState=-1;ThrowError("Script failed to run ["+script_url+"].");}
global.jXHR[icb]=null;};})(internal_callback);script_url=url+'?callback=?jXHR&data=';script_url=script_url.replace(/=\?jXHR/,"=jXHR."+internal_callback);fireReadyStateChange(1);},send:function(data){script_url=script_url+encodeURIComponent(data);SETTIMEOUT(function(){scriptElem=doc.createElement("script");scriptElem.setAttribute("type","text/javascript");scriptElem.onload=scriptElem.onreadystatechange=function(){handleScriptLoad.call(scriptElem);};scriptElem.setAttribute("src",script_url);doc.getElementsByTagName("head")[0].appendChild(scriptElem);},0);fireReadyStateChange(2);},abort:function(){},setRequestHeader:function(){},getResponseHeader:function(){return"";},getAllResponseHeaders:function(){return[];}};reset();return publicAPI;};})(window);var Base64=(function(){var keyStr="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";var obj={encode:function(input){var output="";var chr1,chr2,chr3;var enc1,enc2,enc3,enc4;var i=0;do{chr1=input.charCodeAt(i++);chr2=input.charCodeAt(i++);chr3=input.charCodeAt(i++);enc1=chr1>>2;enc2=((chr1&3)<<4)|(chr2>>4);enc3=((chr2&15)<<2)|(chr3>>6);enc4=chr3&63;if(isNaN(chr2)){enc3=enc4=64;}else if(isNaN(chr3)){enc4=64;}
output=output+keyStr.charAt(enc1)+keyStr.charAt(enc2)+
keyStr.charAt(enc3)+keyStr.charAt(enc4);}while(i<input.length);return output;},decode:function(input){var output="";var chr1,chr2,chr3;var enc1,enc2,enc3,enc4;var i=0;input=input.replace(/[^A-Za-z0-9\+\/\=]/g,"");do{enc1=keyStr.indexOf(input.charAt(i++));enc2=keyStr.indexOf(input.charAt(i++));enc3=keyStr.indexOf(input.charAt(i++));enc4=keyStr.indexOf(input.charAt(i++));chr1=(enc1<<2)|(enc2>>4);chr2=((enc2&15)<<4)|(enc3>>2);chr3=((enc3&3)<<6)|enc4;output=output+String.fromCharCode(chr1);if(enc3!=64){output=output+String.fromCharCode(chr2);}
if(enc4!=64){output=output+String.fromCharCode(chr3);}}while(i<input.length);return output;}};return obj;})();var JSJaC={Version:'$Rev$',bind:function(fn,obj,optArg){return function(arg){return fn.apply(obj,[arg,optArg]);};}};if(typeof JSJaCConnection=='undefined')
JSJaC.load();function XmlHttp(){}
XmlHttp.create=function(){try{if(((BOSH_PROXY=='on')||(HOST_BOSH_MINI))&&(typeof jXHR=="function")){if(window.XMLHttpRequest){var req=new XMLHttpRequest();if(req.withCredentials!==undefined)
return req;}
return new jXHR();}
if(window.XMLHttpRequest){var req=new XMLHttpRequest();if(req.readyState==null){req.readyState=1;req.addEventListener("load",function(){req.readyState=4;if(typeof req.onreadystatechange=="function")
req.onreadystatechange();},false);}
return req;}
if(window.ActiveXObject){return new ActiveXObject(XmlHttp.getPrefix()+".XmlHttp");}}
catch(ex){}
throw new Error("Your browser does not support XmlHttp objects");};XmlHttp.getPrefix=function(){if(XmlHttp.prefix)
return XmlHttp.prefix;var prefixes=["MSXML2","Microsoft","MSXML","MSXML3"];var o;for(var i=0;i<prefixes.length;i++){try{o=new ActiveXObject(prefixes[i]+".XmlHttp");return XmlHttp.prefix=prefixes[i];}
catch(ex){};}
throw new Error("Could not find an installed XML parser");};function XmlDocument(){}
XmlDocument.create=function(name,ns){name=name||'foo';ns=ns||'';try{var doc;if(document.implementation&&document.implementation.createDocument){doc=document.implementation.createDocument(ns,name,null);if(doc.readyState==null){doc.readyState=1;doc.addEventListener("load",function(){doc.readyState=4;if(typeof doc.onreadystatechange=="function")
doc.onreadystatechange();},false);}}else if(window.ActiveXObject){doc=new ActiveXObject(XmlDocument.getPrefix()+".DomDocument");}
if(!doc.documentElement||doc.documentElement.tagName!=name||(doc.documentElement.namespaceURI&&doc.documentElement.namespaceURI!=ns)){try{if(ns!='')
doc.appendChild(doc.createElement(name)).setAttribute('xmlns',ns);else
doc.appendChild(doc.createElement(name));}catch(dex){doc=document.implementation.createDocument(ns,name,null);if(doc.documentElement==null)
doc.appendChild(doc.createElement(name));if(ns!=''&&doc.documentElement.getAttribute('xmlns')!=ns){doc.documentElement.setAttribute('xmlns',ns);}}}
return doc;}
catch(ex){}
throw new Error("Your browser does not support XmlDocument objects");};XmlDocument.getPrefix=function(){if(XmlDocument.prefix)
return XmlDocument.prefix;var prefixes=["MSXML2","Microsoft","MSXML","MSXML3"];var o;for(var i=0;i<prefixes.length;i++){try{o=new ActiveXObject(prefixes[i]+".DomDocument");return XmlDocument.prefix=prefixes[i];}
catch(ex){};}
throw new Error("Could not find an installed XML parser");};if(typeof(Document)!='undefined'&&window.DOMParser){Document.prototype.loadXML=function(s){var doc2=(new DOMParser()).parseFromString(s,"text/xml");while(this.hasChildNodes())
this.removeChild(this.lastChild);for(var i=0;i<doc2.childNodes.length;i++){this.appendChild(this.importNode(doc2.childNodes[i],true));}};}
if(window.XMLSerializer&&window.Node&&Node.prototype&&Node.prototype.__defineGetter__){XMLDocument.prototype.__defineGetter__("xml",function(){return(new XMLSerializer()).serializeToString(this);});Document.prototype.__defineGetter__("xml",function(){return(new XMLSerializer()).serializeToString(this);});Node.prototype.__defineGetter__("xml",function(){return(new XMLSerializer()).serializeToString(this);});}
String.prototype.htmlEnc=function(){if(!this)
return this;var str=this.replace(/&/g,"&amp;");str=str.replace(/</g,"&lt;");str=str.replace(/>/g,"&gt;");str=str.replace(/\"/g,"&quot;");str=str.replace(/\n/g,"<br />");return str;};String.prototype.revertHtmlEnc=function(){if(!this)
return this;var str=this.replace(/&amp;/gi,'&');str=str.replace(/&lt;/gi,'<');str=str.replace(/&gt;/gi,'>');str=str.replace(/&quot;/gi,'\"');str=str.replace(/<br( )?(\/)?>/gi,'\n');return str;};Date.jab2date=function(ts){var date=new Date(Date.UTC(ts.substr(0,4),ts.substr(5,2)-1,ts.substr(8,2),ts.substr(11,2),ts.substr(14,2),ts.substr(17,2)));if(ts.substr(ts.length-6,1)!='Z'){var date_offset=date.getTimezoneOffset()*60*1000;var offset=new Date();offset.setTime(0);offset.setUTCHours(ts.substr(ts.length-5,2));offset.setUTCMinutes(ts.substr(ts.length-2,2));if(ts.substr(ts.length-6,1)=='+')
date.setTime(date.getTime()+offset.getTime()+date_offset);else if(ts.substr(ts.length-6,1)=='-')
date.setTime(date.getTime()-offset.getTime()+date_offset);}
return date;};Date.hrTime=function(ts){return Date.jab2date(ts).toLocaleString();};Date.prototype.jabberDate=function(){var padZero=function(i){if(i<10)return"0"+i;return i;};var jDate=this.getUTCFullYear()+"-";jDate+=padZero(this.getUTCMonth()+1)+"-";jDate+=padZero(this.getUTCDate())+"T";jDate+=padZero(this.getUTCHours())+":";jDate+=padZero(this.getUTCMinutes())+":";jDate+=padZero(this.getUTCSeconds())+"Z";return jDate;};Number.max=function(A,B){return(A>B)?A:B;};Number.min=function(A,B){return(A<B)?A:B;};var hexcase=0;var b64pad="=";var chrsz=8;function hex_sha1(s){return binb2hex(core_sha1(str2binb(s),s.length*chrsz));}
function b64_sha1(s){return binb2b64(core_sha1(str2binb(s),s.length*chrsz));}
function str_sha1(s){return binb2str(core_sha1(str2binb(s),s.length*chrsz));}
function hex_hmac_sha1(key,data){return binb2hex(core_hmac_sha1(key,data));}
function b64_hmac_sha1(key,data){return binb2b64(core_hmac_sha1(key,data));}
function str_hmac_sha1(key,data){return binb2str(core_hmac_sha1(key,data));}
function sha1_vm_test()
{return hex_sha1("abc")=="a9993e364706816aba3e25717850c26c9cd0d89d";}
function core_sha1(x,len)
{x[len>>5]|=0x80<<(24-len%32);x[((len+64>>9)<<4)+15]=len;var w=Array(80);var a=1732584193;var b=-271733879;var c=-1732584194;var d=271733878;var e=-1009589776;for(var i=0;i<x.length;i+=16)
{var olda=a;var oldb=b;var oldc=c;var oldd=d;var olde=e;for(var j=0;j<80;j++)
{if(j<16)w[j]=x[i+j];else w[j]=rol(w[j-3]^w[j-8]^w[j-14]^w[j-16],1);var t=safe_add(safe_add(rol(a,5),sha1_ft(j,b,c,d)),safe_add(safe_add(e,w[j]),sha1_kt(j)));e=d;d=c;c=rol(b,30);b=a;a=t;}
a=safe_add(a,olda);b=safe_add(b,oldb);c=safe_add(c,oldc);d=safe_add(d,oldd);e=safe_add(e,olde);}
return Array(a,b,c,d,e);}
function sha1_ft(t,b,c,d)
{if(t<20)return(b&c)|((~b)&d);if(t<40)return b^c^d;if(t<60)return(b&c)|(b&d)|(c&d);return b^c^d;}
function sha1_kt(t)
{return(t<20)?1518500249:(t<40)?1859775393:(t<60)?-1894007588:-899497514;}
function core_hmac_sha1(key,data)
{var bkey=str2binb(key);if(bkey.length>16)bkey=core_sha1(bkey,key.length*chrsz);var ipad=Array(16),opad=Array(16);for(var i=0;i<16;i++)
{ipad[i]=bkey[i]^0x36363636;opad[i]=bkey[i]^0x5C5C5C5C;}
var hash=core_sha1(ipad.concat(str2binb(data)),512+data.length*chrsz);return core_sha1(opad.concat(hash),512+160);}
function rol(num,cnt)
{return(num<<cnt)|(num>>>(32-cnt));}
function str2binb(str)
{var bin=Array();var mask=(1<<chrsz)-1;for(var i=0;i<str.length*chrsz;i+=chrsz)
bin[i>>5]|=(str.charCodeAt(i/chrsz)&mask)<<(32-chrsz-i%32);return bin;}
function binb2str(bin)
{var str="";var mask=(1<<chrsz)-1;for(var i=0;i<bin.length*32;i+=chrsz)
str+=String.fromCharCode((bin[i>>5]>>>(32-chrsz-i%32))&mask);return str;}
function binb2hex(binarray)
{var hex_tab=hexcase?"0123456789ABCDEF":"0123456789abcdef";var str="";for(var i=0;i<binarray.length*4;i++)
{str+=hex_tab.charAt((binarray[i>>2]>>((3-i%4)*8+4))&0xF)+
hex_tab.charAt((binarray[i>>2]>>((3-i%4)*8))&0xF);}
return str;}
function binb2b64(binarray)
{var tab="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";var str="";for(var i=0;i<binarray.length*4;i+=3)
{var triplet=(((binarray[i>>2]>>8*(3-i%4))&0xFF)<<16)|(((binarray[i+1>>2]>>8*(3-(i+1)%4))&0xFF)<<8)|((binarray[i+2>>2]>>8*(3-(i+2)%4))&0xFF);for(var j=0;j<4;j++)
{if(i*8+j*6>binarray.length*32)str+=b64pad;else str+=tab.charAt((triplet>>6*(3-j))&0x3F);}}
return str.replace(/AAA\=(\=*?)$/,'$1');}
function hex_md5(s){return binl2hex(core_md5(str2binl(s),s.length*chrsz));}
function b64_md5(s){return binl2b64(core_md5(str2binl(s),s.length*chrsz));}
function str_md5(s){return binl2str(core_md5(str2binl(s),s.length*chrsz));}
function hex_hmac_md5(key,data){return binl2hex(core_hmac_md5(key,data));}
function b64_hmac_md5(key,data){return binl2b64(core_hmac_md5(key,data));}
function str_hmac_md5(key,data){return binl2str(core_hmac_md5(key,data));}
function md5_vm_test()
{return hex_md5("abc")=="900150983cd24fb0d6963f7d28e17f72";}
function core_md5(x,len)
{x[len>>5]|=0x80<<((len)%32);x[(((len+64)>>>9)<<4)+14]=len;var a=1732584193;var b=-271733879;var c=-1732584194;var d=271733878;for(var i=0;i<x.length;i+=16)
{var olda=a;var oldb=b;var oldc=c;var oldd=d;a=md5_ff(a,b,c,d,x[i+0],7,-680876936);d=md5_ff(d,a,b,c,x[i+1],12,-389564586);c=md5_ff(c,d,a,b,x[i+2],17,606105819);b=md5_ff(b,c,d,a,x[i+3],22,-1044525330);a=md5_ff(a,b,c,d,x[i+4],7,-176418897);d=md5_ff(d,a,b,c,x[i+5],12,1200080426);c=md5_ff(c,d,a,b,x[i+6],17,-1473231341);b=md5_ff(b,c,d,a,x[i+7],22,-45705983);a=md5_ff(a,b,c,d,x[i+8],7,1770035416);d=md5_ff(d,a,b,c,x[i+9],12,-1958414417);c=md5_ff(c,d,a,b,x[i+10],17,-42063);b=md5_ff(b,c,d,a,x[i+11],22,-1990404162);a=md5_ff(a,b,c,d,x[i+12],7,1804603682);d=md5_ff(d,a,b,c,x[i+13],12,-40341101);c=md5_ff(c,d,a,b,x[i+14],17,-1502002290);b=md5_ff(b,c,d,a,x[i+15],22,1236535329);a=md5_gg(a,b,c,d,x[i+1],5,-165796510);d=md5_gg(d,a,b,c,x[i+6],9,-1069501632);c=md5_gg(c,d,a,b,x[i+11],14,643717713);b=md5_gg(b,c,d,a,x[i+0],20,-373897302);a=md5_gg(a,b,c,d,x[i+5],5,-701558691);d=md5_gg(d,a,b,c,x[i+10],9,38016083);c=md5_gg(c,d,a,b,x[i+15],14,-660478335);b=md5_gg(b,c,d,a,x[i+4],20,-405537848);a=md5_gg(a,b,c,d,x[i+9],5,568446438);d=md5_gg(d,a,b,c,x[i+14],9,-1019803690);c=md5_gg(c,d,a,b,x[i+3],14,-187363961);b=md5_gg(b,c,d,a,x[i+8],20,1163531501);a=md5_gg(a,b,c,d,x[i+13],5,-1444681467);d=md5_gg(d,a,b,c,x[i+2],9,-51403784);c=md5_gg(c,d,a,b,x[i+7],14,1735328473);b=md5_gg(b,c,d,a,x[i+12],20,-1926607734);a=md5_hh(a,b,c,d,x[i+5],4,-378558);d=md5_hh(d,a,b,c,x[i+8],11,-2022574463);c=md5_hh(c,d,a,b,x[i+11],16,1839030562);b=md5_hh(b,c,d,a,x[i+14],23,-35309556);a=md5_hh(a,b,c,d,x[i+1],4,-1530992060);d=md5_hh(d,a,b,c,x[i+4],11,1272893353);c=md5_hh(c,d,a,b,x[i+7],16,-155497632);b=md5_hh(b,c,d,a,x[i+10],23,-1094730640);a=md5_hh(a,b,c,d,x[i+13],4,681279174);d=md5_hh(d,a,b,c,x[i+0],11,-358537222);c=md5_hh(c,d,a,b,x[i+3],16,-722521979);b=md5_hh(b,c,d,a,x[i+6],23,76029189);a=md5_hh(a,b,c,d,x[i+9],4,-640364487);d=md5_hh(d,a,b,c,x[i+12],11,-421815835);c=md5_hh(c,d,a,b,x[i+15],16,530742520);b=md5_hh(b,c,d,a,x[i+2],23,-995338651);a=md5_ii(a,b,c,d,x[i+0],6,-198630844);d=md5_ii(d,a,b,c,x[i+7],10,1126891415);c=md5_ii(c,d,a,b,x[i+14],15,-1416354905);b=md5_ii(b,c,d,a,x[i+5],21,-57434055);a=md5_ii(a,b,c,d,x[i+12],6,1700485571);d=md5_ii(d,a,b,c,x[i+3],10,-1894986606);c=md5_ii(c,d,a,b,x[i+10],15,-1051523);b=md5_ii(b,c,d,a,x[i+1],21,-2054922799);a=md5_ii(a,b,c,d,x[i+8],6,1873313359);d=md5_ii(d,a,b,c,x[i+15],10,-30611744);c=md5_ii(c,d,a,b,x[i+6],15,-1560198380);b=md5_ii(b,c,d,a,x[i+13],21,1309151649);a=md5_ii(a,b,c,d,x[i+4],6,-145523070);d=md5_ii(d,a,b,c,x[i+11],10,-1120210379);c=md5_ii(c,d,a,b,x[i+2],15,718787259);b=md5_ii(b,c,d,a,x[i+9],21,-343485551);a=safe_add(a,olda);b=safe_add(b,oldb);c=safe_add(c,oldc);d=safe_add(d,oldd);}
return Array(a,b,c,d);}
function md5_cmn(q,a,b,x,s,t)
{return safe_add(bit_rol(safe_add(safe_add(a,q),safe_add(x,t)),s),b);}
function md5_ff(a,b,c,d,x,s,t)
{return md5_cmn((b&c)|((~b)&d),a,b,x,s,t);}
function md5_gg(a,b,c,d,x,s,t)
{return md5_cmn((b&d)|(c&(~d)),a,b,x,s,t);}
function md5_hh(a,b,c,d,x,s,t)
{return md5_cmn(b^c^d,a,b,x,s,t);}
function md5_ii(a,b,c,d,x,s,t)
{return md5_cmn(c^(b|(~d)),a,b,x,s,t);}
function core_hmac_md5(key,data)
{var bkey=str2binl(key);if(bkey.length>16)bkey=core_md5(bkey,key.length*chrsz);var ipad=Array(16),opad=Array(16);for(var i=0;i<16;i++)
{ipad[i]=bkey[i]^0x36363636;opad[i]=bkey[i]^0x5C5C5C5C;}
var hash=core_md5(ipad.concat(str2binl(data)),512+data.length*chrsz);return core_md5(opad.concat(hash),512+128);}
function safe_add(x,y)
{var lsw=(x&0xFFFF)+(y&0xFFFF);var msw=(x>>16)+(y>>16)+(lsw>>16);return(msw<<16)|(lsw&0xFFFF);}
function bit_rol(num,cnt)
{return(num<<cnt)|(num>>>(32-cnt));}
function str2binl(str)
{var bin=Array();var mask=(1<<chrsz)-1;for(var i=0;i<str.length*chrsz;i+=chrsz)
bin[i>>5]|=(str.charCodeAt(i/chrsz)&mask)<<(i%32);return bin;}
function binl2str(bin)
{var str="";var mask=(1<<chrsz)-1;for(var i=0;i<bin.length*32;i+=chrsz)
str+=String.fromCharCode((bin[i>>5]>>>(i%32))&mask);return str;}
function binl2hex(binarray)
{var hex_tab=hexcase?"0123456789ABCDEF":"0123456789abcdef";var str="";for(var i=0;i<binarray.length*4;i++)
{str+=hex_tab.charAt((binarray[i>>2]>>((i%4)*8+4))&0xF)+
hex_tab.charAt((binarray[i>>2]>>((i%4)*8))&0xF);}
return str;}
function binl2b64(binarray)
{var tab="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";var str="";for(var i=0;i<binarray.length*4;i+=3)
{var triplet=(((binarray[i>>2]>>8*(i%4))&0xFF)<<16)|(((binarray[i+1>>2]>>8*((i+1)%4))&0xFF)<<8)|((binarray[i+2>>2]>>8*((i+2)%4))&0xFF);for(var j=0;j<4;j++)
{if(i*8+j*6>binarray.length*32)str+=b64pad;else str+=tab.charAt((triplet>>6*(3-j))&0x3F);}}
return str;}
function utf8t2d(t)
{t=t.replace(/\r\n/g,"\n");var d=new Array;var test=String.fromCharCode(237);if(test.charCodeAt(0)<0)
for(var n=0;n<t.length;n++)
{var c=t.charCodeAt(n);if(c>0)
d[d.length]=c;else{d[d.length]=(((256+c)>>6)|192);d[d.length]=(((256+c)&63)|128);}}
else
for(var n=0;n<t.length;n++)
{var c=t.charCodeAt(n);if(c<128)
d[d.length]=c;else if((c>127)&&(c<2048)){d[d.length]=((c>>6)|192);d[d.length]=((c&63)|128);}
else{d[d.length]=((c>>12)|224);d[d.length]=(((c>>6)&63)|128);d[d.length]=((c&63)|128);}}
return d;}
function utf8d2t(d)
{var r=new Array;var i=0;while(i<d.length)
{if(d[i]<128){r[r.length]=String.fromCharCode(d[i]);i++;}
else if((d[i]>191)&&(d[i]<224)){r[r.length]=String.fromCharCode(((d[i]&31)<<6)|(d[i+1]&63));i+=2;}
else{r[r.length]=String.fromCharCode(((d[i]&15)<<12)|((d[i+1]&63)<<6)|(d[i+2]&63));i+=3;}}
return r.join("");}
function b64arrays(){var b64s='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';b64=new Array();f64=new Array();for(var i=0;i<b64s.length;i++){b64[i]=b64s.charAt(i);f64[b64s.charAt(i)]=i;}}
function b64d2t(d){var r=new Array;var i=0;var dl=d.length;if((dl%3)==1){d[d.length]=0;d[d.length]=0;}
if((dl%3)==2)
d[d.length]=0;while(i<d.length)
{r[r.length]=b64[d[i]>>2];r[r.length]=b64[((d[i]&3)<<4)|(d[i+1]>>4)];r[r.length]=b64[((d[i+1]&15)<<2)|(d[i+2]>>6)];r[r.length]=b64[d[i+2]&63];i+=3;}
if((dl%3)==1)
r[r.length-1]=r[r.length-2]="=";if((dl%3)==2)
r[r.length-1]="=";var t=r.join("");return t;}
function b64t2d(t){var d=new Array;var i=0;t=t.replace(/\n|\r/g,"");t=t.replace(/=/g,"");while(i<t.length)
{d[d.length]=(f64[t.charAt(i)]<<2)|(f64[t.charAt(i+1)]>>4);d[d.length]=(((f64[t.charAt(i+1)]&15)<<4)|(f64[t.charAt(i+2)]>>2));d[d.length]=(((f64[t.charAt(i+2)]&3)<<6)|(f64[t.charAt(i+3)]));i+=4;}
if(t.length%4==2)
d=d.slice(0,d.length-2);if(t.length%4==3)
d=d.slice(0,d.length-1);return d;}
if(typeof(atob)=='undefined'||typeof(btoa)=='undefined')
b64arrays();if(typeof(atob)=='undefined'){atob=function(s){return utf8d2t(b64t2d(s));}}
if(typeof(btoa)=='undefined'){btoa=function(s){return b64d2t(utf8t2d(s));}}
function cnonce(size){var tab="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";var cnonce='';for(var i=0;i<size;i++){cnonce+=tab.charAt(Math.round(Math.random(new Date().getTime())*(tab.length-1)));}
return cnonce;}
JSJAC_HAVEKEYS=true;JSJAC_NKEYS=16;JSJAC_INACTIVITY=300;JSJAC_ERR_COUNT=10;JSJAC_ALLOW_PLAIN=true;JSJAC_CHECKQUEUEINTERVAL=100;JSJAC_CHECKINQUEUEINTERVAL=100;JSJAC_TIMERVAL=2000;JSJACHBC_MAX_HOLD=1;JSJACHBC_MAX_WAIT=20;JSJACHBC_BOSH_VERSION="1.6";JSJACHBC_USE_BOSH_VER=true;JSJACHBC_MAXPAUSE=20;function JSJaCJSON(){}
JSJaCJSON.toString=function(obj){var m={'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','"':'\\"','\\':'\\\\'},s={array:function(x){var a=['['],b,f,i,l=x.length,v;for(i=0;i<l;i+=1){v=x[i];f=s[typeof v];if(f){try{v=f(v);if(typeof v=='string'){if(b){a[a.length]=',';}
a[a.length]=v;b=true;}}catch(e){}}}
a[a.length]=']';return a.join('');},'boolean':function(x){return String(x);},'null':function(x){return"null";},number:function(x){return isFinite(x)?String(x):'null';},object:function(x){if(x){if(x instanceof Array){return s.array(x);}
var a=['{'],b,f,i,v;for(i in x){if(x.hasOwnProperty(i)){v=x[i];f=s[typeof v];if(f){try{v=f(v);if(typeof v=='string'){if(b){a[a.length]=',';}
a.push(s.string(i),':',v);b=true;}}catch(e){}}}}
a[a.length]='}';return a.join('');}
return'null';},string:function(x){if(/["\\\x00-\x1f]/.test(x)){x=x.replace(/([\x00-\x1f\\"])/g,function(a,b){var c=m[b];if(c){return c;}
c=b.charCodeAt();return'\\u00'+
Math.floor(c/16).toString(16)+
(c%16).toString(16);});}
return'"'+x+'"';}};switch(typeof(obj)){case'object':return s.object(obj);case'array':return s.array(obj);}};JSJaCJSON.parse=function(str){try{return!(/[^,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]/.test(str.replace(/"(\\.|[^"\\])*"/g,'')))&&eval('('+str+')');}catch(e){return false;}};var JSJACJID_FORBIDDEN=['"',' ','&','\'','/',':','<','>','@'];function JSJaCJID(jid){this._node='';this._domain='';this._resource='';if(typeof(jid)=='string'){if(jid.indexOf('@')!=-1){this.setNode(jid.substring(0,jid.indexOf('@')));jid=jid.substring(jid.indexOf('@')+1);}
if(jid.indexOf('/')!=-1){this.setResource(jid.substring(jid.indexOf('/')+1));jid=jid.substring(0,jid.indexOf('/'));}
this.setDomain(jid);}else{this.setNode(jid.node);this.setDomain(jid.domain);this.setResource(jid.resource);}}
JSJaCJID.prototype.getNode=function(){return this._node;};JSJaCJID.prototype.getDomain=function(){return this._domain;};JSJaCJID.prototype.getResource=function(){return this._resource;};JSJaCJID.prototype.setNode=function(node){JSJaCJID._checkNodeName(node);this._node=node||'';return this;};JSJaCJID.prototype.setDomain=function(domain){if(!domain||domain=='')
throw new JSJaCJIDInvalidException("domain name missing");JSJaCJID._checkNodeName(domain);this._domain=domain;return this;};JSJaCJID.prototype.setResource=function(resource){this._resource=resource||'';return this;};JSJaCJID.prototype.toString=function(){var jid='';if(this.getNode()&&this.getNode()!='')
jid=this.getNode()+'@';jid+=this.getDomain();if(this.getResource()&&this.getResource()!="")
jid+='/'+this.getResource();return jid;};JSJaCJID.prototype.removeResource=function(){return this.setResource();};JSJaCJID.prototype.clone=function(){return new JSJaCJID(this.toString());};JSJaCJID.prototype.isEntity=function(jid){if(typeof jid=='string')
jid=(new JSJaCJID(jid));jid.removeResource();return(this.clone().removeResource().toString()===jid.toString());};JSJaCJID._checkNodeName=function(nodeprep){if(!nodeprep||nodeprep=='')
return;for(var i=0;i<JSJACJID_FORBIDDEN.length;i++){if(nodeprep.indexOf(JSJACJID_FORBIDDEN[i])!=-1){throw new JSJaCJIDInvalidException("forbidden char in nodename: "+JSJACJID_FORBIDDEN[i]);}}};function JSJaCJIDInvalidException(message){this.message=message;this.name="JSJaCJIDInvalidException";}
var JSJaCBuilder={buildNode:function(doc,elementName){var element,ns=arguments[4];if(arguments[2])
if(JSJaCBuilder._isStringOrNumber(arguments[2])||(arguments[2]instanceof Array)){element=this._createElement(doc,elementName,ns);JSJaCBuilder._children(doc,element,arguments[2]);}else{ns=arguments[2]['xmlns']||ns;element=this._createElement(doc,elementName,ns);for(attr in arguments[2]){if(arguments[2].hasOwnProperty(attr)&&attr!='xmlns')
element.setAttribute(attr,arguments[2][attr]);}}
else
element=this._createElement(doc,elementName,ns);if(arguments[3])
JSJaCBuilder._children(doc,element,arguments[3],ns);return element;},_createElement:function(doc,elementName,ns){try{if(ns)
return doc.createElementNS(ns,elementName);}catch(ex){}
var el=doc.createElement(elementName);if(ns)
el.setAttribute("xmlns",ns);return el;},_text:function(doc,text){return doc.createTextNode(text);},_children:function(doc,element,children,ns){if(typeof children=='object'){for(var i in children){if(children.hasOwnProperty(i)){var e=children[i];if(typeof e=='object'){if(e instanceof Array){var node=JSJaCBuilder.buildNode(doc,e[0],e[1],e[2],ns);element.appendChild(node);}else{element.appendChild(e);}}else{if(JSJaCBuilder._isStringOrNumber(e)){element.appendChild(JSJaCBuilder._text(doc,e));}}}}}else{if(JSJaCBuilder._isStringOrNumber(children)){element.appendChild(JSJaCBuilder._text(doc,children));}}},_attributes:function(attributes){var attrs=[];for(attribute in attributes)
if(attributes.hasOwnProperty(attribute))
attrs.push(attribute+'="'+attributes[attribute].toString().htmlEnc()+'"');return attrs.join(" ");},_isStringOrNumber:function(param){return(typeof param=='string'||typeof param=='number');}};var JSJACPACKET_USE_XMLNS=true;function JSJaCPacket(name){this.name=name;if(typeof(JSJACPACKET_USE_XMLNS)!='undefined'&&JSJACPACKET_USE_XMLNS)
this.doc=XmlDocument.create(name,'jabber:client');else
this.doc=XmlDocument.create(name,'');}
JSJaCPacket.prototype.pType=function(){return this.name;};JSJaCPacket.prototype.getDoc=function(){return this.doc;};JSJaCPacket.prototype.getNode=function(){if(this.getDoc()&&this.getDoc().documentElement)
return this.getDoc().documentElement;else
return null;};JSJaCPacket.prototype.setTo=function(to){if(!to||to=='')
this.getNode().removeAttribute('to');else if(typeof(to)=='string')
this.getNode().setAttribute('to',to);else
this.getNode().setAttribute('to',to.toString());return this;};JSJaCPacket.prototype.setFrom=function(from){if(!from||from=='')
this.getNode().removeAttribute('from');else if(typeof(from)=='string')
this.getNode().setAttribute('from',from);else
this.getNode().setAttribute('from',from.toString());return this;};JSJaCPacket.prototype.setID=function(id){if(!id||id=='')
this.getNode().removeAttribute('id');else
this.getNode().setAttribute('id',id);return this;};JSJaCPacket.prototype.setType=function(type){if(!type||type=='')
this.getNode().removeAttribute('type');else
this.getNode().setAttribute('type',type);return this;};JSJaCPacket.prototype.setXMLLang=function(xmllang){if(BrowserDetect&&(BrowserDetect.browser=='Explorer')&&(BrowserDetect.version>=9))
return this;if(!xmllang||xmllang=='')
this.getNode().removeAttribute('xml:lang');else
this.getNode().setAttribute('xml:lang',xmllang);return this;};JSJaCPacket.prototype.getTo=function(){return this.getNode().getAttribute('to');};JSJaCPacket.prototype.getFrom=function(){return this.getNode().getAttribute('from');};JSJaCPacket.prototype.getToJID=function(){return new JSJaCJID(this.getTo());};JSJaCPacket.prototype.getFromJID=function(){return new JSJaCJID(this.getFrom());};JSJaCPacket.prototype.getID=function(){return this.getNode().getAttribute('id');};JSJaCPacket.prototype.getType=function(){return this.getNode().getAttribute('type');};JSJaCPacket.prototype.getXMLLang=function(){return this.getNode().getAttribute('xml:lang');};JSJaCPacket.prototype.getXMLNS=function(){return this.getNode().namespaceURI||this.getNode().getAttribute('xmlns');};JSJaCPacket.prototype.getChild=function(name,ns){if(!this.getNode()){return null;}
name=name||'*';ns=ns||'*';if(this.getNode().getElementsByTagNameNS){return this.getNode().getElementsByTagNameNS(ns,name).item(0);}
var nodes=this.getNode().getElementsByTagName(name);if(ns!='*'){for(var i=0;i<nodes.length;i++){if(nodes.item(i).namespaceURI==ns||nodes.item(i).getAttribute('xmlns')==ns){return nodes.item(i);}}}else{return nodes.item(0);}
return null;};JSJaCPacket.prototype.getChildVal=function(name,ns){var node=this.getChild(name,ns);var ret='';if(node&&node.hasChildNodes()){for(var i=0;i<node.childNodes.length;i++)
if(node.childNodes.item(i).nodeValue)
ret+=node.childNodes.item(i).nodeValue;}
return ret;};JSJaCPacket.prototype.clone=function(){return JSJaCPacket.wrapNode(this.getNode());};JSJaCPacket.prototype.isError=function(){return(this.getType()=='error');};JSJaCPacket.prototype.errorReply=function(stanza_error){var rPacket=this.clone();rPacket.setTo(this.getFrom());rPacket.setFrom();rPacket.setType('error');rPacket.appendNode('error',{code:stanza_error.code,type:stanza_error.type},[[stanza_error.cond]]);return rPacket;};JSJaCPacket.prototype.xml=typeof XMLSerializer!='undefined'?function(){var r=(new XMLSerializer()).serializeToString(this.getNode());if(typeof(r)=='undefined')
r=(new XMLSerializer()).serializeToString(this.doc);return r}:function(){return this.getDoc().xml};JSJaCPacket.prototype._getAttribute=function(attr){return this.getNode().getAttribute(attr);};if(document.ELEMENT_NODE==null){document.ELEMENT_NODE=1;document.ATTRIBUTE_NODE=2;document.TEXT_NODE=3;document.CDATA_SECTION_NODE=4;document.ENTITY_REFERENCE_NODE=5;document.ENTITY_NODE=6;document.PROCESSING_INSTRUCTION_NODE=7;document.COMMENT_NODE=8;document.DOCUMENT_NODE=9;document.DOCUMENT_TYPE_NODE=10;document.DOCUMENT_FRAGMENT_NODE=11;document.NOTATION_NODE=12;}
JSJaCPacket.prototype._importNode=function(node,allChildren){switch(node.nodeType){case document.ELEMENT_NODE:if(this.getDoc().createElementNS){var newNode=this.getDoc().createElementNS(node.namespaceURI,node.nodeName);}else{var newNode=this.getDoc().createElement(node.nodeName);}
if(node.attributes&&node.attributes.length>0)
for(var i=0,il=node.attributes.length;i<il;i++){var attr=node.attributes.item(i);if(attr.nodeName=='xmlns'&&newNode.getAttribute('xmlns')!=null)continue;if(newNode.setAttributeNS&&attr.namespaceURI){newNode.setAttributeNS(attr.namespaceURI,attr.nodeName,attr.nodeValue);}else{newNode.setAttribute(attr.nodeName,attr.nodeValue);}}
if(allChildren&&node.childNodes&&node.childNodes.length>0){for(var i=0,il=node.childNodes.length;i<il;i++){newNode.appendChild(this._importNode(node.childNodes.item(i),allChildren));}}
return newNode;break;case document.TEXT_NODE:case document.CDATA_SECTION_NODE:case document.COMMENT_NODE:return this.getDoc().createTextNode(node.nodeValue);break;}};JSJaCPacket.prototype._setChildNode=function(nodeName,nodeValue){var aNode=this.getChild(nodeName);var tNode=this.getDoc().createTextNode(nodeValue);if(aNode)
try{aNode.replaceChild(tNode,aNode.firstChild);}catch(e){}
else{try{aNode=this.getDoc().createElementNS(this.getNode().namespaceURI,nodeName);}catch(ex){aNode=this.getDoc().createElement(nodeName)}
this.getNode().appendChild(aNode);aNode.appendChild(tNode);}
return aNode;};JSJaCPacket.prototype.buildNode=function(elementName){return JSJaCBuilder.buildNode(this.getDoc(),elementName,arguments[1],arguments[2]);};JSJaCPacket.prototype.appendNode=function(element){if(typeof element=='object'){return this.getNode().appendChild(element)}else{return this.getNode().appendChild(this.buildNode(element,arguments[1],arguments[2],null,this.getNode().namespaceURI));}};function JSJaCPresence(){this.base=JSJaCPacket;this.base('presence');}
JSJaCPresence.prototype=new JSJaCPacket;JSJaCPresence.prototype.setStatus=function(status){this._setChildNode("status",status);return this;};JSJaCPresence.prototype.setShow=function(show){if(show=='chat'||show=='away'||show=='xa'||show=='dnd')
this._setChildNode("show",show);return this;};JSJaCPresence.prototype.setPriority=function(prio){this._setChildNode("priority",prio);return this;};JSJaCPresence.prototype.setPresence=function(show,status,prio){if(show)
this.setShow(show);if(status)
this.setStatus(status);if(prio)
this.setPriority(prio);return this;};JSJaCPresence.prototype.getStatus=function(){return this.getChildVal('status');};JSJaCPresence.prototype.getShow=function(){return this.getChildVal('show');};JSJaCPresence.prototype.getPriority=function(){return this.getChildVal('priority');};function JSJaCIQ(){this.base=JSJaCPacket;this.base('iq');}
JSJaCIQ.prototype=new JSJaCPacket;JSJaCIQ.prototype.setIQ=function(to,type,id){if(to)
this.setTo(to);if(type)
this.setType(type);if(id)
this.setID(id);return this;};JSJaCIQ.prototype.setQuery=function(xmlns){var query;try{query=this.getDoc().createElementNS(xmlns,'query');}catch(e){query=this.getDoc().createElement('query');query.setAttribute('xmlns',xmlns);}
this.getNode().appendChild(query);return query;};JSJaCIQ.prototype.getQuery=function(){return this.getNode().getElementsByTagName('query').item(0);};JSJaCIQ.prototype.getQueryXMLNS=function(){if(this.getQuery()){return this.getQuery().namespaceURI||this.getQuery().getAttribute('xmlns');}else{return null;}};JSJaCIQ.prototype.reply=function(payload){var rIQ=this.clone();rIQ.setTo(this.getFrom());rIQ.setFrom();rIQ.setType('result');if(payload){if(typeof payload=='string')
rIQ.getChild().appendChild(rIQ.getDoc().loadXML(payload));else if(payload.constructor==Array){var node=rIQ.getChild();for(var i=0;i<payload.length;i++)
if(typeof payload[i]=='string')
node.appendChild(rIQ.getDoc().loadXML(payload[i]));else if(typeof payload[i]=='object')
node.appendChild(payload[i]);}
else if(typeof payload=='object')
rIQ.getChild().appendChild(payload);}
return rIQ;};function JSJaCMessage(){this.base=JSJaCPacket;this.base('message');}
JSJaCMessage.prototype=new JSJaCPacket;JSJaCMessage.prototype.setBody=function(body){this._setChildNode("body",body);return this;};JSJaCMessage.prototype.setSubject=function(subject){this._setChildNode("subject",subject);return this;};JSJaCMessage.prototype.setThread=function(thread){this._setChildNode("thread",thread);return this;};JSJaCMessage.prototype.getThread=function(){return this.getChildVal('thread');};JSJaCMessage.prototype.getBody=function(){return this.getChildVal('body');};JSJaCMessage.prototype.getSubject=function(){return this.getChildVal('subject')};JSJaCPacket.wrapNode=function(node){var oPacket=null;switch(node.nodeName.toLowerCase()){case'presence':oPacket=new JSJaCPresence();break;case'message':oPacket=new JSJaCMessage();break;case'iq':oPacket=new JSJaCIQ();break;}
if(oPacket){oPacket.getDoc().replaceChild(oPacket._importNode(node,true),oPacket.getNode());}
return oPacket;};function JSJaCError(code,type,condition){var xmldoc=XmlDocument.create("error","jsjac");xmldoc.documentElement.setAttribute('code',code);xmldoc.documentElement.setAttribute('type',type);if(condition)
xmldoc.documentElement.appendChild(xmldoc.createElement(condition)).setAttribute('xmlns','urn:ietf:params:xml:ns:xmpp-stanzas');return xmldoc.documentElement;}
function JSJaCKeys(func,oDbg){var seed=Math.random();this._k=new Array();this._k[0]=seed.toString();if(oDbg)
this.oDbg=oDbg;else{this.oDbg={};this.oDbg.log=function(){};}
if(func){for(var i=1;i<JSJAC_NKEYS;i++){this._k[i]=func(this._k[i-1]);oDbg.log(i+": "+this._k[i],4);}}
this._indexAt=JSJAC_NKEYS-1;this.getKey=function(){return this._k[this._indexAt--];};this.lastKey=function(){return(this._indexAt==0);};this.size=function(){return this._k.length;};this._getSuspendVars=function(){return('_k,_indexAt').split(',');}}
function JSJaCConnection(oArg){if(oArg&&oArg.oDbg&&oArg.oDbg.log){this.oDbg=oArg.oDbg;}else{this.oDbg=new Object();this.oDbg.log=function(){};}
if(oArg&&oArg.timerval)
this.setPollInterval(oArg.timerval);else
this.setPollInterval(JSJAC_TIMERVAL);if(oArg&&oArg.httpbase)
this._httpbase=oArg.httpbase;if(oArg&&oArg.allow_plain)
this.allow_plain=oArg.allow_plain;else
this.allow_plain=JSJAC_ALLOW_PLAIN;if(oArg&&oArg.cookie_prefix)
this._cookie_prefix=oArg.cookie_prefix;else
this._cookie_prefix="";this._connected=false;this._events=new Array();this._keys=null;this._ID=0;this._inQ=new Array();this._pQueue=new Array();this._regIDs=new Array();this._req=new Array();this._status='intialized';this._errcnt=0;this._inactivity=JSJAC_INACTIVITY;this._sendRawCallbacks=new Array();}
var STANZA_ID=1;function genID(){return STANZA_ID++;}
JSJaCConnection.prototype.connect=function(oArg){this._setStatus('connecting');this.domain=oArg.domain||'localhost';this.username=oArg.username;this.resource=oArg.resource;this.pass=oArg.pass;this.register=oArg.register;this.authhost=oArg.authhost||this.domain;this.authtype=oArg.authtype||'sasl';if(oArg.xmllang&&oArg.xmllang!='')
this._xmllang=oArg.xmllang;else
this._xmllang='en';this.host=oArg.host||this.domain;this.port=oArg.port||5222;if(oArg.secure)
this.secure='true';else
this.secure='false';if(oArg.wait)
this._wait=oArg.wait;this.jid=this.username+'@'+this.domain;this.fulljid=this.jid+'/'+this.resource;this._rid=Math.round(100000.5+(((900000.49999)-(100000.5))*Math.random()));var slot=this._getFreeSlot();this._req[slot]=this._setupRequest(true);var reqstr=this._getInitialRequestString();this.oDbg.log(reqstr,4);this._req[slot].r.onreadystatechange=JSJaC.bind(function(){var r=this._req[slot].r;if(r.readyState==4){this.oDbg.log("async recv: "+r.responseText,4);this._handleInitialResponse(r);}},this);if(typeof(this._req[slot].r.onerror)!='undefined'){this._req[slot].r.onerror=JSJaC.bind(function(e){this.oDbg.log('XmlHttpRequest error',1);return false;},this);}
this._req[slot].r.send(reqstr);};JSJaCConnection.prototype.connected=function(){return this._connected;};JSJaCConnection.prototype.disconnect=function(){this._setStatus('disconnecting');if(!this.connected())
return;this._connected=false;clearInterval(this._interval);clearInterval(this._inQto);if(this._timeout)
clearTimeout(this._timeout);var slot=this._getFreeSlot();this._req[slot]=this._setupRequest(false);request=this._getRequestString(false,true);this.oDbg.log("Disconnecting: "+request,4);this._req[slot].r.send(request);try{removeDB('jsjac','state');}catch(e){}
this.oDbg.log("Disconnected: "+this._req[slot].r.responseText,2);this._handleEvent('ondisconnect');};JSJaCConnection.prototype.getPollInterval=function(){return this._timerval;};JSJaCConnection.prototype.registerHandler=function(event){event=event.toLowerCase();var eArg={handler:arguments[arguments.length-1],childName:'*',childNS:'*',type:'*'};if(arguments.length>2)
eArg.childName=arguments[1];if(arguments.length>3)
eArg.childNS=arguments[2];if(arguments.length>4)
eArg.type=arguments[3];if(!this._events[event])
this._events[event]=new Array(eArg);else
this._events[event]=this._events[event].concat(eArg);this._events[event]=this._events[event].sort(function(a,b){var aRank=0;var bRank=0;with(a){if(type=='*')
aRank++;if(childNS=='*')
aRank++;if(childName=='*')
aRank++;}
with(b){if(type=='*')
bRank++;if(childNS=='*')
bRank++;if(childName=='*')
bRank++;}
if(aRank>bRank)
return 1;if(aRank<bRank)
return-1;return 0;});this.oDbg.log("registered handler for event '"+event+"'",2);};JSJaCConnection.prototype.unregisterHandler=function(event,handler){event=event.toLowerCase();if(!this._events[event])
return;var arr=this._events[event],res=new Array();for(var i=0;i<arr.length;i++)
if(arr[i].handler!=handler)
res.push(arr[i]);if(arr.length!=res.length){this._events[event]=res;this.oDbg.log("unregistered handler for event '"+event+"'",2);}};JSJaCConnection.prototype.registerIQGet=function(childName,childNS,handler){this.registerHandler('iq',childName,childNS,'get',handler);};JSJaCConnection.prototype.registerIQSet=function(childName,childNS,handler){this.registerHandler('iq',childName,childNS,'set',handler);};JSJaCConnection.prototype.resume=function(){try{var json=getDB('jsjac','state');this.oDbg.log('read cookie: '+json,2);removeDB('jsjac','state');return this.resumeFromData(JSJaCJSON.parse(json));}catch(e){}
return false;};JSJaCConnection.prototype.resumeFromData=function(data){try{this._setStatus('resuming');for(var i in data)
if(data.hasOwnProperty(i))
this[i]=data[i];if(this._keys){this._keys2=new JSJaCKeys();var u=this._keys2._getSuspendVars();for(var i=0;i<u.length;i++)
this._keys2[u[i]]=this._keys[u[i]];this._keys=this._keys2;}
if(this._connected){this._handleEvent('onresume');setTimeout(JSJaC.bind(this._resume,this),this.getPollInterval());this._interval=setInterval(JSJaC.bind(this._checkQueue,this),JSJAC_CHECKQUEUEINTERVAL);this._inQto=setInterval(JSJaC.bind(this._checkInQ,this),JSJAC_CHECKINQUEUEINTERVAL);}
return(this._connected===true);}catch(e){if(e.message)
this.oDbg.log("Resume failed: "+e.message,1);else
this.oDbg.log("Resume failed: "+e,1);return false;}};JSJaCConnection.prototype.send=function(packet,cb,arg){if(!packet||!packet.pType){this.oDbg.log("no packet: "+packet,1);return false;}
if(!this.connected())
return false;if(!packet.getID())
packet.setID(genID());if(!packet.getXMLLang())
packet.setXMLLang(XML_LANG);if(cb)
this._registerPID(packet.getID(),cb,arg);try{this._handleEvent(packet.pType()+'_out',packet);this._handleEvent("packet_out",packet);this._pQueue=this._pQueue.concat(packet.xml());}catch(e){this.oDbg.log(e.toString(),1);return false;}
return true;};JSJaCConnection.prototype.sendIQ=function(iq,handlers,arg){if(!iq||iq.pType()!='iq'){return false;}
handlers=handlers||{};var error_handler=handlers.error_handler||JSJaC.bind(function(aIq){this.oDbg.log(aIq.xml(),1);},this);var result_handler=handlers.result_handler||JSJaC.bind(function(aIq){this.oDbg.log(aIq.xml(),2);},this);var iqHandler=function(aIq,arg){switch(aIq.getType()){case'error':error_handler(aIq);break;case'result':result_handler(aIq,arg);break;}};return this.send(iq,iqHandler,arg);};JSJaCConnection.prototype.setPollInterval=function(timerval){if(timerval&&!isNaN(timerval))
this._timerval=timerval;return this._timerval;};JSJaCConnection.prototype.status=function(){return this._status;};JSJaCConnection.prototype.suspend=function(has_pause){var data=this.suspendToData(has_pause);try{var c=setDB('jsjac','state',JSJaCJSON.toString(data));return c;}catch(e){this.oDbg.log("Failed creating cookie '"+this._cookie_prefix+"JSJaC_State': "+e.message,1);}
return false;};JSJaCConnection.prototype.suspendToData=function(has_pause){if(has_pause){clearTimeout(this._timeout);clearInterval(this._interval);clearInterval(this._inQto);this._suspend();}
var u=('_connected,_keys,_ID,_inQ,_pQueue,_regIDs,_errcnt,_inactivity,domain,username,resource,jid,fulljid,_sid,_httpbase,_timerval,_is_polling').split(',');u=u.concat(this._getSuspendVars());var s=new Object();for(var i=0;i<u.length;i++){if(!this[u[i]])continue;if(this[u[i]]._getSuspendVars){var uo=this[u[i]]._getSuspendVars();var o=new Object();for(var j=0;j<uo.length;j++)
o[uo[j]]=this[u[i]][uo[j]];}else
var o=this[u[i]];s[u[i]]=o;}
if(has_pause){this._connected=false;this._setStatus('suspending');}
return s;};JSJaCConnection.prototype._abort=function(){clearTimeout(this._timeout);clearInterval(this._inQto);clearInterval(this._interval);this._connected=false;this._setStatus('aborted');this.oDbg.log("Disconnected.",1);this._handleEvent('ondisconnect');this._handleEvent('onerror',JSJaCError('500','cancel','service-unavailable'));};JSJaCConnection.prototype._checkInQ=function(){for(var i=0;i<this._inQ.length&&i<10;i++){var item=this._inQ[0];this._inQ=this._inQ.slice(1,this._inQ.length);var packet=JSJaCPacket.wrapNode(item);if(!packet)
return;this._handleEvent("packet_in",packet);if(packet.pType&&!this._handlePID(packet)){this._handleEvent(packet.pType()+'_in',packet);this._handleEvent(packet.pType(),packet);}}};JSJaCConnection.prototype._checkQueue=function(){if(this._pQueue.length!=0)
this._process();return true;};JSJaCConnection.prototype._doAuth=function(){if(this.has_sasl&&this.authtype=='nonsasl')
this.oDbg.log("Warning: SASL present but not used",1);if(!this._doSASLAuth()&&!this._doLegacyAuth()){this.oDbg.log("Auth failed for authtype "+this.authtype,1);this.disconnect();return false;}
return true;};JSJaCConnection.prototype._doInBandReg=function(){if(this.authtype=='saslanon'||this.authtype=='anonymous')
return;var iq=new JSJaCIQ();iq.setType('set');iq.setID('reg1');iq.appendNode("query",{xmlns:"jabber:iq:register"},[["username",this.username],["password",this.pass]]);this.send(iq,this._doInBandRegDone);};JSJaCConnection.prototype._doInBandRegDone=function(iq){if(iq&&iq.getType()=='error'){this.oDbg.log("registration failed for "+this.username,0);this._handleEvent('onerror',iq.getChild('error'));return;}
this.oDbg.log(this.username+" registered succesfully",0);this._doAuth();};JSJaCConnection.prototype._doLegacyAuth=function(){if(this.authtype!='nonsasl'&&this.authtype!='anonymous')
return false;var iq=new JSJaCIQ();iq.setIQ(null,'get','auth1');iq.appendNode('query',{xmlns:'jabber:iq:auth'},[['username',this.username]]);this.send(iq,this._doLegacyAuth2);return true;};JSJaCConnection.prototype._doLegacyAuth2=function(iq){if(!iq||iq.getType()!='result'){if(iq&&iq.getType()=='error')
this._handleEvent('onerror',iq.getChild('error'));this.disconnect();return;}
var use_digest=(iq.getChild('digest')!=null);var iq=new JSJaCIQ();iq.setIQ(null,'set','auth2');query=iq.appendNode('query',{xmlns:'jabber:iq:auth'},[['username',this.username],['resource',this.resource]]);if(use_digest){query.appendChild(iq.buildNode('digest',{xmlns:'jabber:iq:auth'},hex_sha1(this.streamid+this.pass)));}else if(this.allow_plain){query.appendChild(iq.buildNode('password',{xmlns:'jabber:iq:auth'},this.pass));}else{this.oDbg.log("no valid login mechanism found",1);this.disconnect();return false;}
this.send(iq,this._doLegacyAuthDone);};JSJaCConnection.prototype._doLegacyAuthDone=function(iq){if(iq.getType()!='result'){if(iq.getType()=='error')
this._handleEvent('onerror',iq.getChild('error'));this.disconnect();}else
this._handleEvent('onconnect');};JSJaCConnection.prototype._doSASLAuth=function(){if(this.authtype=='nonsasl'||this.authtype=='anonymous')
return false;if(this.authtype=='saslanon'){if(this.mechs['ANONYMOUS']){this.oDbg.log("SASL using mechanism 'ANONYMOUS'",2);return this._sendRaw("<auth xmlns='urn:ietf:params:xml:ns:xmpp-sasl' mechanism='ANONYMOUS'/>",this._doSASLAuthDone);}
this.oDbg.log("SASL ANONYMOUS requested but not supported",1);}else{if(this.mechs['DIGEST-MD5']){this.oDbg.log("SASL using mechanism 'DIGEST-MD5'",2);return this._sendRaw("<auth xmlns='urn:ietf:params:xml:ns:xmpp-sasl' mechanism='DIGEST-MD5'/>",this._doSASLAuthDigestMd5S1);}else if(this.allow_plain&&this.mechs['PLAIN']){this.oDbg.log("SASL using mechanism 'PLAIN'",2);var authStr=this.username+'@'+
this.domain+String.fromCharCode(0)+
this.username+String.fromCharCode(0)+
this.pass;this.oDbg.log("authenticating with '"+authStr+"'",2);authStr=btoa(authStr);return this._sendRaw("<auth xmlns='urn:ietf:params:xml:ns:xmpp-sasl' mechanism='PLAIN'>"+authStr+"</auth>",this._doSASLAuthDone);}
this.oDbg.log("No SASL mechanism applied",1);this.authtype='nonsasl';}
return false;};JSJaCConnection.prototype._doSASLAuthDigestMd5S1=function(el){if(el.nodeName!="challenge"){this.oDbg.log("challenge missing",1);this._handleEvent('onerror',JSJaCError('401','auth','not-authorized'));this.disconnect();}else{var challenge=atob(el.firstChild.nodeValue);this.oDbg.log("got challenge: "+challenge,2);this._nonce=challenge.substring(challenge.indexOf("nonce=")+7);this._nonce=this._nonce.substring(0,this._nonce.indexOf("\""));this.oDbg.log("nonce: "+this._nonce,2);if(this._nonce==''||this._nonce.indexOf('\"')!=-1){this.oDbg.log("nonce not valid, aborting",1);this.disconnect();return;}
this._digest_uri="xmpp/";this._digest_uri+=this.domain;this._cnonce=cnonce(14);this._nc='00000001';var A1=str_md5(this.username+':'+this.domain+':'+this.pass)+':'+this._nonce+':'+this._cnonce;var A2='AUTHENTICATE:'+this._digest_uri;var response=hex_md5(hex_md5(A1)+':'+this._nonce+':'+this._nc+':'+
this._cnonce+':auth:'+hex_md5(A2));var rPlain='username="'+this.username+'",realm="'+this.domain+'",nonce="'+this._nonce+'",cnonce="'+this._cnonce+'",nc="'+this._nc+'",qop=auth,digest-uri="'+this._digest_uri+'",response="'+response+'",charset="utf-8"';this.oDbg.log("response: "+rPlain,2);this._sendRaw("<response xmlns='urn:ietf:params:xml:ns:xmpp-sasl'>"+
Base64.encode(rPlain)+"</response>",this._doSASLAuthDigestMd5S2);}};JSJaCConnection.prototype._doSASLAuthDigestMd5S2=function(el){if(el.nodeName=='failure'){if(el.xml)
this.oDbg.log("auth error: "+el.xml,1);else
this.oDbg.log("auth error",1);this._handleEvent('onerror',JSJaCError('401','auth','not-authorized'));this.disconnect();return;}
var response=atob(el.firstChild.nodeValue);this.oDbg.log("response: "+response,2);var rspauth=response.substring(response.indexOf("rspauth=")+8);this.oDbg.log("rspauth: "+rspauth,2);var A1=str_md5(this.username+':'+this.domain+':'+this.pass)+':'+this._nonce+':'+this._cnonce;var A2=':'+this._digest_uri;var rsptest=hex_md5(hex_md5(A1)+':'+this._nonce+':'+this._nc+':'+
this._cnonce+':auth:'+hex_md5(A2));this.oDbg.log("rsptest: "+rsptest,2);if(rsptest!=rspauth){this.oDbg.log("SASL Digest-MD5: server repsonse with wrong rspauth",1);this.disconnect();return;}
if(el.nodeName=='success'){this._reInitStream(JSJaC.bind(this._doStreamBind,this));}else{this._sendRaw("<response xmlns='urn:ietf:params:xml:ns:xmpp-sasl'/>",this._doSASLAuthDone);}};JSJaCConnection.prototype._doSASLAuthDone=function(el){if(el.nodeName!='success'){this.oDbg.log("auth failed",1);this._handleEvent('onerror',JSJaCError('401','auth','not-authorized'));this.disconnect();}else{this._reInitStream(JSJaC.bind(this._doStreamBind,this));}};JSJaCConnection.prototype._doStreamBind=function(){var iq=new JSJaCIQ();iq.setIQ(null,'set','bind_1');iq.appendNode("bind",{xmlns:"urn:ietf:params:xml:ns:xmpp-bind"},[["resource",this.resource]]);this.oDbg.log(iq.xml());this.send(iq,this._doXMPPSess);};JSJaCConnection.prototype._doXMPPSess=function(iq){if(iq.getType()!='result'||iq.getType()=='error'){this.disconnect();if(iq.getType()=='error')
this._handleEvent('onerror',iq.getChild('error'));return;}
this.fulljid=iq.getChildVal("jid");this.jid=this.fulljid.substring(0,this.fulljid.lastIndexOf('/'));iq=new JSJaCIQ();iq.setIQ(null,'set','sess_1');iq.appendNode("session",{xmlns:"urn:ietf:params:xml:ns:xmpp-session"},[]);this.oDbg.log(iq.xml());this.send(iq,this._doXMPPSessDone);};JSJaCConnection.prototype._doXMPPSessDone=function(iq){if(iq.getType()!='result'||iq.getType()=='error'){this.disconnect();if(iq.getType()=='error')
this._handleEvent('onerror',iq.getChild('error'));return;}else
this._handleEvent('onconnect');};JSJaCConnection.prototype._handleEvent=function(event,arg){event=event.toLowerCase();this.oDbg.log("incoming event '"+event+"'",3);if(!this._events[event])
return;this.oDbg.log("handling event '"+event+"'",2);for(var i=0;i<this._events[event].length;i++){var aEvent=this._events[event][i];if(typeof aEvent.handler=='function'){try{if(arg){if(arg.pType){if((!arg.getNode().hasChildNodes()&&aEvent.childName!='*')||(arg.getNode().hasChildNodes()&&!arg.getChild(aEvent.childName,aEvent.childNS)))
continue;if(aEvent.type!='*'&&arg.getType()!=aEvent.type)
continue;this.oDbg.log(aEvent.childName+"/"+aEvent.childNS+"/"+aEvent.type+" => match for handler "+aEvent.handler,3);}
if(aEvent.handler(arg)){break;}}
else
if(aEvent.handler()){break;}}catch(e){if(e.fileName&&e.lineNumber){this.oDbg.log(aEvent.handler+"\n>>>"+e.name+": "+e.message+' in '+e.fileName+' line '+e.lineNumber,1);}else{this.oDbg.log(aEvent.handler+"\n>>>"+e.name+": "+e.message,1);}}}}};JSJaCConnection.prototype._handlePID=function(aJSJaCPacket){if(!aJSJaCPacket.getID())
return false;for(var i in this._regIDs){if(this._regIDs.hasOwnProperty(i)&&this._regIDs[i]&&i==aJSJaCPacket.getID()){var pID=aJSJaCPacket.getID();this.oDbg.log("handling "+pID,3);try{if(this._regIDs[i].cb.call(this,aJSJaCPacket,this._regIDs[i].arg)===false){return false;}else{this._unregisterPID(pID);return true;}}catch(e){this.oDbg.log(e.name+": "+e.message,1);this._unregisterPID(pID);return true;}}}
return false;};JSJaCConnection.prototype._handleResponse=function(req){var rootEl=this._parseResponse(req);if(!rootEl)
return;for(var i=0;i<rootEl.childNodes.length;i++){if(this._sendRawCallbacks.length){var cb=this._sendRawCallbacks[0];this._sendRawCallbacks=this._sendRawCallbacks.slice(1,this._sendRawCallbacks.length);cb.fn.call(this,rootEl.childNodes.item(i),cb.arg);continue;}
this._inQ=this._inQ.concat(rootEl.childNodes.item(i));}};JSJaCConnection.prototype._parseStreamFeatures=function(doc){if(!doc){this.oDbg.log("nothing to parse ... aborting",1);return false;}
var errorTag;if(doc.getElementsByTagNameNS){errorTag=doc.getElementsByTagNameNS("http://etherx.jabber.org/streams","error").item(0);}else{var errors=doc.getElementsByTagName("error");for(var i=0;i<errors.length;i++)
if(errors.item(i).namespaceURI=="http://etherx.jabber.org/streams"||errors.item(i).getAttribute('xmlns')=="http://etherx.jabber.org/streams"){errorTag=errors.item(i);break;}}
if(errorTag){this._setStatus("internal_server_error");clearTimeout(this._timeout);clearInterval(this._interval);clearInterval(this._inQto);this._handleEvent('onerror',JSJaCError('503','cancel','session-terminate'));this._connected=false;this.oDbg.log("Disconnected.",1);this._handleEvent('ondisconnect');return false;}
this.mechs=new Object();var lMec1=doc.getElementsByTagName("mechanisms");this.has_sasl=false;for(var i=0;i<lMec1.length;i++)
if(lMec1.item(i).getAttribute("xmlns")=="urn:ietf:params:xml:ns:xmpp-sasl"){this.has_sasl=true;var lMec2=lMec1.item(i).getElementsByTagName("mechanism");for(var j=0;j<lMec2.length;j++)
this.mechs[lMec2.item(j).firstChild.nodeValue]=true;break;}
if(this.has_sasl)
this.oDbg.log("SASL detected",2);else{this.oDbg.log("No support for SASL detected",2);return false;}
this.server_caps=null;var sCaps=doc.getElementsByTagName("c");for(var i=0;i<sCaps.length;i++){var c_sCaps=sCaps.item(i);var x_sCaps=c_sCaps.getAttribute("xmlns");var v_sCaps=c_sCaps.getAttribute("ver");if((x_sCaps==NS_CAPS)&&v_sCaps){this.server_caps=v_sCaps;break;}}
return true;};JSJaCConnection.prototype._process=function(timerval){if(!this.connected()){this.oDbg.log("Connection lost ...",1);if(this._interval)
clearInterval(this._interval);return;}
this.setPollInterval(timerval);if(this._timeout)
clearTimeout(this._timeout);var slot=this._getFreeSlot();if(slot<0)
return;if(typeof(this._req[slot])!='undefined'&&typeof(this._req[slot].r)!='undefined'&&this._req[slot].r.readyState!=4){this.oDbg.log("Slot "+slot+" is not ready");return;}
if(!this.isPolling()&&this._pQueue.length==0&&this._req[(slot+1)%2]&&this._req[(slot+1)%2].r.readyState!=4){this.oDbg.log("all slots busy, standby ...",2);return;}
if(!this.isPolling())
this.oDbg.log("Found working slot at "+slot,2);this._req[slot]=this._setupRequest(true);this._req[slot].r.onreadystatechange=JSJaC.bind(function(){if(this._req[slot].r.readyState==4){this._setStatus('processing');this.oDbg.log("async recv: "+this._req[slot].r.responseText,4);this._handleResponse(this._req[slot]);if(!this.connected())
return;if(this._pQueue.length){this._timeout=setTimeout(JSJaC.bind(this._process,this),100);}else{this.oDbg.log("scheduling next poll in "+this.getPollInterval()+" msec",4);this._timeout=setTimeout(JSJaC.bind(this._process,this),this.getPollInterval());}}},this);try{this._req[slot].r.onerror=JSJaC.bind(function(){if(!this.connected())
return;this._errcnt++;this.oDbg.log('XmlHttpRequest error ('+this._errcnt+')',1);if(this._errcnt>JSJAC_ERR_COUNT){this._abort();return false;}
this._setStatus('onerror_fallback');setTimeout(JSJaC.bind(this._resume,this),this.getPollInterval());return false;},this);}catch(e){}
var reqstr=this._getRequestString();if(typeof(this._rid)!='undefined')
this._req[slot].rid=this._rid;this.oDbg.log("sending: "+reqstr,4);this._req[slot].r.send(reqstr);};JSJaCConnection.prototype._registerPID=function(pID,cb,arg){if(!pID||!cb)
return false;this._regIDs[pID]=new Object();this._regIDs[pID].cb=cb;if(arg)
this._regIDs[pID].arg=arg;this.oDbg.log("registered "+pID,3);return true;};JSJaCConnection.prototype._prepSendEmpty=function(cb,ctx){return function(){ctx._sendEmpty(JSJaC.bind(cb,ctx));};};JSJaCConnection.prototype._sendEmpty=function(cb){var slot=this._getFreeSlot();this._req[slot]=this._setupRequest(true);this._req[slot].r.onreadystatechange=JSJaC.bind(function(){if(this._req[slot].r.readyState==4){this.oDbg.log("async recv: "+this._req[slot].r.responseText,4);cb(this._req[slot].r);}},this);if(typeof(this._req[slot].r.onerror)!='undefined'){this._req[slot].r.onerror=JSJaC.bind(function(e){this.oDbg.log('XmlHttpRequest error',1);return false;},this);}
var reqstr=this._getRequestString();this.oDbg.log("sending: "+reqstr,4);this._req[slot].r.send(reqstr);};JSJaCConnection.prototype._sendRaw=function(xml,cb,arg){if(cb)
this._sendRawCallbacks.push({fn:cb,arg:arg});this._pQueue.push(xml);this._process();return true;};JSJaCConnection.prototype._setStatus=function(status){if(!status||status=='')
return;if(status!=this._status){this._status=status;this._handleEvent('onstatuschanged',status);this._handleEvent('status_changed',status);}};JSJaCConnection.prototype._unregisterPID=function(pID){if(!this._regIDs[pID])
return false;this._regIDs[pID]=null;this.oDbg.log("unregistered "+pID,3);return true;};function JSJaCHttpBindingConnection(oArg){this.base=JSJaCConnection;this.base(oArg);this._hold=JSJACHBC_MAX_HOLD;this._inactivity=0;this._last_requests=new Object();this._last_rid=0;this._min_polling=0;this._pause=0;this._wait=JSJACHBC_MAX_WAIT;}
JSJaCHttpBindingConnection.prototype=new JSJaCConnection();JSJaCHttpBindingConnection.prototype.inherit=function(oArg){if(oArg.jid){var oJid=new JSJaCJID(oArg.jid);this.domain=oJid.getDomain();this.username=oJid.getNode();this.resource=oJid.getResource();}else{this.domain=oArg.domain||'localhost';this.username=oArg.username;this.resource=oArg.resource;}
this._sid=oArg.sid;this._rid=oArg.rid;this._min_polling=oArg.polling;this._inactivity=oArg.inactivity;this._setHold(oArg.requests-1);this.setPollInterval(this._timerval);if(oArg.wait)
this._wait=oArg.wait;this._connected=true;this._handleEvent('onconnect');this._interval=setInterval(JSJaC.bind(this._checkQueue,this),JSJAC_CHECKQUEUEINTERVAL);this._inQto=setInterval(JSJaC.bind(this._checkInQ,this),JSJAC_CHECKINQUEUEINTERVAL);this._timeout=setTimeout(JSJaC.bind(this._process,this),this.getPollInterval());};JSJaCHttpBindingConnection.prototype.setPollInterval=function(timerval){if(timerval&&!isNaN(timerval)){if(!this.isPolling())
this._timerval=100;else if(this._min_polling&&timerval<this._min_polling*1000)
this._timerval=this._min_polling*1000;else if(this._inactivity&&timerval>this._inactivity*1000)
this._timerval=this._inactivity*1000;else
this._timerval=timerval;}
return this._timerval;};JSJaCHttpBindingConnection.prototype.isPolling=function(){return(this._hold==0)};JSJaCHttpBindingConnection.prototype._getFreeSlot=function(){for(var i=0;i<this._hold+1;i++)
if(typeof(this._req[i])=='undefined'||typeof(this._req[i].r)=='undefined'||this._req[i].r.readyState==4)
return i;return-1;};JSJaCHttpBindingConnection.prototype._getHold=function(){return this._hold;};JSJaCHttpBindingConnection.prototype._getRequestString=function(raw,last){raw=raw||'';var reqstr='';if(this._rid<=this._last_rid&&typeof(this._last_requests[this._rid])!='undefined')
reqstr=this._last_requests[this._rid].xml;else{var xml='';while(this._pQueue.length){var curNode=this._pQueue[0];xml+=curNode;this._pQueue=this._pQueue.slice(1,this._pQueue.length);}
reqstr="<body xml:lang='"+XML_LANG+"' rid='"+this._rid+"' sid='"+this._sid+"' xmlns='http://jabber.org/protocol/httpbind' ";if(JSJAC_HAVEKEYS){reqstr+="key='"+this._keys.getKey()+"' ";if(this._keys.lastKey()){this._keys=new JSJaCKeys(hex_sha1,this.oDbg);reqstr+="newkey='"+this._keys.getKey()+"' ";}}
if(last)
reqstr+="type='terminate'";else if(this._reinit){if(JSJACHBC_USE_BOSH_VER)
reqstr+="xmpp:restart='true' xmlns:xmpp='urn:xmpp:xbosh' to='"+this.domain+"'";this._reinit=false;}
if(xml!=''||raw!=''){reqstr+=">"+raw+xml+"</body>";}else{reqstr+="/>";}
this._last_requests[this._rid]=new Object();this._last_requests[this._rid].xml=reqstr;this._last_rid=this._rid;for(var i in this._last_requests)
if(this._last_requests.hasOwnProperty(i)&&i<this._rid-this._hold)
delete(this._last_requests[i]);}
return reqstr;};JSJaCHttpBindingConnection.prototype._getInitialRequestString=function(){var reqstr="<body xml:lang='"+XML_LANG+"' content='text/xml; charset=utf-8' hold='"+this._hold+"' xmlns='http://jabber.org/protocol/httpbind' to='"+this.authhost+"' wait='"+this._wait+"' rid='"+this._rid+"'";if(this.secure)
reqstr+=" secure='"+this.secure+"'";if(JSJAC_HAVEKEYS){this._keys=new JSJaCKeys(hex_sha1,this.oDbg);key=this._keys.getKey();reqstr+=" newkey='"+key+"'";}
if(JSJACHBC_USE_BOSH_VER){reqstr+=" ver='"+JSJACHBC_BOSH_VERSION+"'";reqstr+=" xmlns:xmpp='urn:xmpp:xbosh'";if(this.authtype=='sasl'||this.authtype=='saslanon')
reqstr+=" xmpp:version='1.0'";}
reqstr+="/>";return reqstr;};JSJaCHttpBindingConnection.prototype._getStreamID=function(req){this.oDbg.log(req.responseText,4);if(!req.responseXML||!req.responseXML.documentElement){this._handleEvent('onerror',JSJaCError('503','cancel','service-unavailable'));return;}
var body=req.responseXML.documentElement;if(body.getAttribute('type')=='terminate'){this._handleEvent('onerror',JSJaCError('503','cancel','service-unavailable'));return;}
if(body.getAttribute('authid')){this.streamid=body.getAttribute('authid');this.oDbg.log("got streamid: "+this.streamid,2);}
if(!this._parseStreamFeatures(body)){this._sendEmpty(JSJaC.bind(this._getStreamID,this));return;}
this._timeout=setTimeout(JSJaC.bind(this._process,this),this.getPollInterval());if(this.register)
this._doInBandReg();else
this._doAuth();};JSJaCHttpBindingConnection.prototype._getSuspendVars=function(){return('host,port,secure,_rid,_last_rid,_wait,_min_polling,_inactivity,_hold,_last_requests,_pause').split(',');};JSJaCHttpBindingConnection.prototype._handleInitialResponse=function(req){try{this.oDbg.log(req.getAllResponseHeaders(),4);this.oDbg.log(req.responseText,4);}catch(ex){this.oDbg.log("No response",4);}
if(req.status!=200||!req.responseXML){this.oDbg.log("initial response broken (status: "+req.status+")",1);this._handleEvent('onerror',JSJaCError('503','cancel','service-unavailable'));return;}
var body=req.responseXML.documentElement;if(!body||body.tagName!='body'||body.namespaceURI!='http://jabber.org/protocol/httpbind'){this.oDbg.log("no body element or incorrect body in initial response",1);this._handleEvent("onerror",JSJaCError("500","wait","internal-service-error"));return;}
if(body.getAttribute("type")=="terminate"){this.oDbg.log("invalid response:\n"+req.responseText,1);clearTimeout(this._timeout);this._connected=false;this.oDbg.log("Disconnected.",1);this._handleEvent('ondisconnect');this._handleEvent('onerror',JSJaCError('503','cancel','service-unavailable'));return;}
this._sid=body.getAttribute('sid');this.oDbg.log("got sid: "+this._sid,2);if(body.getAttribute('polling'))
this._min_polling=body.getAttribute('polling');if(body.getAttribute('inactivity'))
this._inactivity=body.getAttribute('inactivity');if(body.getAttribute('requests'))
this._setHold(body.getAttribute('requests')-1);this.oDbg.log("set hold to "+this._getHold(),2);if(body.getAttribute('ver'))
this._bosh_version=body.getAttribute('ver');if(body.getAttribute('maxpause'))
this._pause=Number.min(body.getAttribute('maxpause'),JSJACHBC_MAXPAUSE);this.setPollInterval(this._timerval);this._connected=true;this._inQto=setInterval(JSJaC.bind(this._checkInQ,this),JSJAC_CHECKINQUEUEINTERVAL);this._interval=setInterval(JSJaC.bind(this._checkQueue,this),JSJAC_CHECKQUEUEINTERVAL);this._getStreamID(req);};JSJaCHttpBindingConnection.prototype._parseResponse=function(req){if(!this.connected()||!req)
return null;var r=req.r;try{if(r.status==404||r.status==403){this._abort();return null;}
if(r.status!=200||!r.responseXML){this._errcnt++;var errmsg="invalid response ("+r.status+"):\n"+r.getAllResponseHeaders()+"\n"+r.responseText;if(!r.responseXML)
errmsg+="\nResponse failed to parse!";this.oDbg.log(errmsg,1);if(this._errcnt>JSJAC_ERR_COUNT){this._abort();return null;}
if(this.connected()){this.oDbg.log("repeating ("+this._errcnt+")",1);this._setStatus('proto_error_fallback');setTimeout(JSJaC.bind(this._resume,this),this.getPollInterval());}
return null;}}catch(e){this.oDbg.log("XMLHttpRequest error: status not available",1);this._errcnt++;if(this._errcnt>JSJAC_ERR_COUNT){this._abort();}else{if(this.connected()){this.oDbg.log("repeating ("+this._errcnt+")",1);this._setStatus('proto_error_fallback');setTimeout(JSJaC.bind(this._resume,this),this.getPollInterval());}}
return null;}
var body=r.responseXML.documentElement;if(!body||body.tagName!='body'||body.namespaceURI!='http://jabber.org/protocol/httpbind'){this.oDbg.log("invalid response:\n"+r.responseText,1);clearTimeout(this._timeout);clearInterval(this._interval);clearInterval(this._inQto);this._connected=false;this.oDbg.log("Disconnected.",1);this._handleEvent('ondisconnect');this._setStatus('internal_server_error');this._handleEvent('onerror',JSJaCError('500','wait','internal-server-error'));return null;}
if(typeof(req.rid)!='undefined'&&this._last_requests[req.rid]){if(this._last_requests[req.rid].handled){this.oDbg.log("already handled "+req.rid,2);return null;}else
this._last_requests[req.rid].handled=true;}
if(body.getAttribute("type")=="terminate"){var condition=body.getAttribute('condition');if(condition!="item-not-found"){this.oDbg.log("session terminated:\n"+r.responseText,1);clearTimeout(this._timeout);clearInterval(this._interval);clearInterval(this._inQto);try{removeDB('jsjac','state');}catch(e){}
this._connected=false;if(condition=="remote-stream-error")
if(body.getElementsByTagName("conflict").length>0)
this._setStatus("session-terminate-conflict");if(condition==null)
condition='session-terminate';this._handleEvent('onerror',JSJaCError('503','cancel',condition));this.oDbg.log("Aborting remaining connections",4);for(var i=0;i<this._hold+1;i++){try{this._req[i].r.abort();}catch(e){this.oDbg.log(e,1);}}
this.oDbg.log("parseResponse done with terminating",3);this.oDbg.log("Disconnected.",1);this._handleEvent('ondisconnect');}else{this._errcnt++;if(this._errcnt>JSJAC_ERR_COUNT)
this._abort();}
return null;}
this._errcnt=0;return r.responseXML.documentElement;};JSJaCHttpBindingConnection.prototype._reInitStream=function(cb){this._reinit=true;this._sendEmpty(this._prepReInitStreamWait(cb));};JSJaCHttpBindingConnection.prototype._prepReInitStreamWait=function(cb){return JSJaC.bind(function(req){this._reInitStreamWait(req,cb);},this);};JSJaCHttpBindingConnection.prototype._reInitStreamWait=function(req,cb){this.oDbg.log("checking for stream features");var doc=req.responseXML.documentElement;this.oDbg.log(doc);if(doc.getElementsByTagNameNS){this.oDbg.log("checking with namespace");var features=doc.getElementsByTagNameNS('http://etherx.jabber.org/streams','features').item(0);if(features){var bind=features.getElementsByTagNameNS('urn:ietf:params:xml:ns:xmpp-bind','bind').item(0);}}else{var featuresNL=doc.getElementsByTagName('stream:features');for(var i=0,l=featuresNL.length;i<l;i++){if(featuresNL.item(i).namespaceURI=='http://etherx.jabber.org/streams'||featuresNL.item(i).getAttribute('xmlns')=='http://etherx.jabber.org/streams'){var features=featuresNL.item(i);break;}}
if(features){var bind=features.getElementsByTagName('bind');for(var i=0,l=bind.length;i<l;i++){if(bind.item(i).namespaceURI=='urn:ietf:params:xml:ns:xmpp-bind'||bind.item(i).getAttribute('xmlns')=='urn:ietf:params:xml:ns:xmpp-bind'){bind=bind.item(i);break;}}}}
this.oDbg.log(features);this.oDbg.log(bind);if(features){if(bind){cb();}else{this.oDbg.log("no bind feature - giving up",1);this._handleEvent('onerror',JSJaCError('503','cancel',"service-unavailable"));this._connected=false;this.oDbg.log("Disconnected.",1);this._handleEvent('ondisconnect');}}else{this._sendEmpty(this._prepReInitStreamWait(cb));}};JSJaCHttpBindingConnection.prototype._resume=function(){if(this._pause==0&&this._rid>=this._last_rid)
this._rid=this._last_rid-1;this._process();};JSJaCHttpBindingConnection.prototype._setHold=function(hold){if(!hold||isNaN(hold)||hold<0)
hold=0;else if(hold>JSJACHBC_MAX_HOLD)
hold=JSJACHBC_MAX_HOLD;this._hold=hold;return this._hold;};JSJaCHttpBindingConnection.prototype._setupRequest=function(async){var req=new Object();var r=XmlHttp.create();try{r.open("POST",this._httpbase,async);r.setRequestHeader('Content-Type','text/xml; charset=utf-8');}catch(e){this.oDbg.log(e,1);}
req.r=r;this._rid++;req.rid=this._rid;return req;};JSJaCHttpBindingConnection.prototype._suspend=function(){if(this._pause==0)
return;var slot=this._getFreeSlot();this._req[slot]=this._setupRequest(false);var reqstr="<body xml:lang='"+XML_LANG+"' pause='"+this._pause+"' xmlns='http://jabber.org/protocol/httpbind' sid='"+this._sid+"' rid='"+this._rid+"'";if(JSJAC_HAVEKEYS){reqstr+=" key='"+this._keys.getKey()+"'";if(this._keys.lastKey()){this._keys=new JSJaCKeys(hex_sha1,this.oDbg);reqstr+=" newkey='"+this._keys.getKey()+"'";}}
reqstr+=">";while(this._pQueue.length){var curNode=this._pQueue[0];reqstr+=curNode;this._pQueue=this._pQueue.slice(1,this._pQueue.length);}
reqstr+="</body>";this.oDbg.log("Disconnecting: "+reqstr,4);this._req[slot].r.send(reqstr);};jQuery.fn.extend({everyTime:function(interval,label,fn,times){return this.each(function(){jQuery.timer.add(this,interval,label,fn,times);});},oneTime:function(interval,label,fn){return this.each(function(){jQuery.timer.add(this,interval,label,fn,1);});},stopTime:function(label,fn){return this.each(function(){jQuery.timer.remove(this,label,fn);});}});jQuery.extend({timer:{global:[],guid:1,dataKey:"jQuery.timer",regex:/^([0-9]+(?:\.[0-9]*)?)\s*(.*s)?$/,powers:{'ms':1,'cs':10,'ds':100,'s':1000,'das':10000,'hs':100000,'ks':1000000},timeParse:function(value){if(value==undefined||value==null)
return null;var result=this.regex.exec(jQuery.trim(value.toString()));if(result[2]){var num=parseFloat(result[1]);var mult=this.powers[result[2]]||1;return num*mult;}else{return value;}},add:function(element,interval,label,fn,times){var counter=0;if(jQuery.isFunction(label)){if(!times)
times=fn;fn=label;label=interval;}
interval=jQuery.timer.timeParse(interval);if(typeof interval!='number'||isNaN(interval)||interval<0)
return;if(typeof times!='number'||isNaN(times)||times<0)
times=0;times=times||0;var timers=jQuery.data(element,this.dataKey)||jQuery.data(element,this.dataKey,{});if(!timers[label])
timers[label]={};fn.timerID=fn.timerID||this.guid++;var handler=function(){if((++counter>times&&times!==0)||fn.call(element,counter)===false)
jQuery.timer.remove(element,label,fn);};handler.timerID=fn.timerID;if(!timers[label][fn.timerID])
timers[label][fn.timerID]=window.setInterval(handler,interval);this.global.push(element);},remove:function(element,label,fn){var timers=jQuery.data(element,this.dataKey),ret;if(timers){if(!label){for(label in timers)
this.remove(element,label,fn);}else if(timers[label]){if(fn){if(fn.timerID){window.clearInterval(timers[label][fn.timerID]);delete timers[label][fn.timerID];}}else{for(var fn in timers[label]){window.clearInterval(timers[label][fn]);delete timers[label][fn];}}
for(ret in timers[label])break;if(!ret){ret=null;delete timers[label];}}
for(ret in timers)break;if(!ret)
jQuery.removeData(element,this.dataKey);}}}});jQuery(window).bind("unload",function(){jQuery.each(jQuery.timer.global,function(index,item){jQuery.timer.remove(item);});});var NS_PROTOCOL='http://jabber.org/protocol/';var NS_FEATURES='http://jabber.org/features/';var NS_CLIENT='jabber:client';var NS_IQ='jabber:iq:';var NS_X='jabber:x:';var NS_IETF='urn:ietf:params:xml:ns:xmpp-';var NS_XMPP='urn:xmpp:';var NS_STORAGE='storage:';var NS_BOOKMARKS=NS_STORAGE+'bookmarks';var NS_ROSTERNOTES=NS_STORAGE+'rosternotes';var NS_JAPPIX='jappix:';var NS_INBOX=NS_JAPPIX+'inbox';var NS_OPTIONS=NS_JAPPIX+'options';var NS_DISCO_ITEMS=NS_PROTOCOL+'disco#items';var NS_DISCO_INFO=NS_PROTOCOL+'disco#info';var NS_VCARD='vcard-temp';var NS_VCARD_P=NS_VCARD+':x:update';var NS_AUTH=NS_IQ+'auth';var NS_AUTH_ERROR=NS_IQ+'auth:error';var NS_REGISTER=NS_IQ+'register';var NS_SEARCH=NS_IQ+'search';var NS_ROSTER=NS_IQ+'roster';var NS_PRIVACY=NS_IQ+'privacy';var NS_PRIVATE=NS_IQ+'private';var NS_VERSION=NS_IQ+'version';var NS_TIME=NS_IQ+'time';var NS_LAST=NS_IQ+'last';var NS_IQDATA=NS_IQ+'data';var NS_XDATA=NS_X+'data';var NS_DELAY=NS_X+'delay';var NS_EXPIRE=NS_X+'expire';var NS_EVENT=NS_X+'event';var NS_XCONFERENCE=NS_X+'conference';var NS_STATS=NS_PROTOCOL+'stats';var NS_MUC=NS_PROTOCOL+'muc';var NS_MUC_USER=NS_MUC+'#user';var NS_MUC_ADMIN=NS_MUC+'#admin';var NS_MUC_OWNER=NS_MUC+'#owner';var NS_MUC_CONFIG=NS_MUC+'#roomconfig';var NS_PUBSUB=NS_PROTOCOL+'pubsub';var NS_PUBSUB_EVENT=NS_PUBSUB+'#event';var NS_PUBSUB_OWNER=NS_PUBSUB+'#owner';var NS_PUBSUB_NMI=NS_PUBSUB+'#node-meta-info';var NS_PUBSUB_NC=NS_PUBSUB+'#node_config';var NS_PUBSUB_RI=NS_PUBSUB+'#retrieve-items';var NS_COMMANDS=NS_PROTOCOL+'commands';var NS_BOSH=NS_PROTOCOL+'httpbind';var NS_STREAM='http://etherx.jabber.org/streams';var NS_URN_TIME=NS_XMPP+'time';var NS_URN_PING=NS_XMPP+'ping';var NS_URN_ADATA=NS_XMPP+'avatar:data';var NS_URN_AMETA=NS_XMPP+'avatar:metadata';var NS_URN_MBLOG=NS_XMPP+'microblog:0';var NS_URN_INBOX=NS_XMPP+'inbox';var NS_URN_ARCHIVE=NS_XMPP+'archive';var NS_URN_AR_PREF=NS_URN_ARCHIVE+':pref';var NS_URN_AR_AUTO=NS_URN_ARCHIVE+':auto';var NS_URN_AR_MANUAL=NS_URN_ARCHIVE+':manual';var NS_URN_AR_MANAGE=NS_URN_ARCHIVE+':manage';var NS_URN_DELAY=NS_XMPP+'delay';var NS_URN_RECEIPTS=NS_XMPP+'receipts';var NS_RSM=NS_PROTOCOL+'rsm';var NS_IPV6='ipv6';var NS_XHTML='http://www.w3.org/1999/xhtml';var NS_XHTML_IM=NS_PROTOCOL+'xhtml-im';var NS_CHATSTATES=NS_PROTOCOL+'chatstates';var NS_HTTP_AUTH=NS_PROTOCOL+'http-auth';var NS_ROSTERX=NS_PROTOCOL+'rosterx';var NS_MOOD=NS_PROTOCOL+'mood';var NS_ACTIVITY=NS_PROTOCOL+'activity';var NS_TUNE=NS_PROTOCOL+'tune';var NS_GEOLOC=NS_PROTOCOL+'geoloc';var NS_NICK=NS_PROTOCOL+'nick';var NS_NOTIFY='+notify';var NS_CAPS=NS_PROTOCOL+'caps';var NS_ATOM='http://www.w3.org/2005/Atom';var NS_STANZAS=NS_IETF+'stanzas';var NS_STREAMS=NS_IETF+'streams';var NS_TLS=NS_IETF+'tls';var NS_SASL=NS_IETF+'sasl';var NS_SESSION=NS_IETF+'session';var NS_BIND=NS_IETF+'bind';var NS_FEATURE_IQAUTH=NS_FEATURES+'iq-auth';var NS_FEATURE_IQREGISTER=NS_FEATURES+'iq-register';var NS_FEATURE_COMPRESS=NS_FEATURES+'compress';var NS_COMPRESS=NS_PROTOCOL+'compress';var LOCALES_AVAILABLE_ID=new Array('ar', 'bg', 'cs', 'de', 'en', 'eo', 'es', 'it', 'ja', 'nl', 'oc', 'pl', 'ru', 'sk', 'uk', 'zh');var LOCALES_AVAILABLE_NAMES=new Array('العربية', 'български', 'Česky', 'Deutsch', 'English', 'Esperanto', 'Español', 'Italiano', '日本語', 'Nederlands', 'Occitan', 'Polski', 'Русский', 'Slovenčina', 'українська', '中文');var XML_LANG='fr';var JAPPIX_STATIC='https://static.jappix.com/';var JAPPIX_VERSION='Stelo [0.7]';var JAPPIX_MAX_FILE_SIZE='8000000';var JAPPIX_MAX_UPLOAD='7.63 MB';var SERVICE_NAME='Jappix';var SERVICE_DESC='a free social network';var JAPPIX_RESOURCE='Jappix';var LOCK_HOST='off';var ANONYMOUS='on';var REGISTRATION='on';var BOSH_PROXY='off';var MANAGER_LINK='off';var ENCRYPTION='on';var HTTPS_STORAGE='on';var HTTPS_FORCE='on';var COMPRESSION='on';var MULTI_FILES='off';var DEVELOPER='off';var HOST_MAIN='jappix.com';var HOST_MUC='muc.jappix.com';var HOST_PUBSUB='pubsub.jappix.com';var HOST_VJUD='vjud.jappix.com';var HOST_ANONYMOUS='anonymous.jappix.com';var HOST_BOSH='http://127.0.0.1:5280/http-bind';var HOST_BOSH_MAIN='/bind';var HOST_BOSH_MINI='https://bind.jappix.com/';var HOST_STATIC='https://static.jappix.com';var HOST_UPLOAD='https://upload.jappix.com/';var ANONYMOUS_ROOM=null;var ANONYMOUS_NICK=null;var JAPPIX_LOCATION=getJappixLocation();function STANZA_ERROR(code,type,cond){if(window==this)
return new STANZA_ERROR(code,type,cond);this.code=code;this.type=type;this.cond=cond;}
var ERR_BAD_REQUEST=STANZA_ERROR('400','modify','bad-request');var ERR_CONFLICT=STANZA_ERROR('409','cancel','conflict');var ERR_FEATURE_NOT_IMPLEMENTED=STANZA_ERROR('501','cancel','feature-not-implemented');var ERR_FORBIDDEN=STANZA_ERROR('403','auth','forbidden');var ERR_GONE=STANZA_ERROR('302','modify','gone');var ERR_INTERNAL_SERVER_ERROR=STANZA_ERROR('500','wait','internal-server-error');var ERR_ITEM_NOT_FOUND=STANZA_ERROR('404','cancel','item-not-found');var ERR_JID_MALFORMED=STANZA_ERROR('400','modify','jid-malformed');var ERR_NOT_ACCEPTABLE=STANZA_ERROR('406','modify','not-acceptable');var ERR_NOT_ALLOWED=STANZA_ERROR('405','cancel','not-allowed');var ERR_NOT_AUTHORIZED=STANZA_ERROR('401','auth','not-authorized');var ERR_PAYMENT_REQUIRED=STANZA_ERROR('402','auth','payment-required');var ERR_RECIPIENT_UNAVAILABLE=STANZA_ERROR('404','wait','recipient-unavailable');var ERR_REDIRECT=STANZA_ERROR('302','modify','redirect');var ERR_REGISTRATION_REQUIRED=STANZA_ERROR('407','auth','registration-required');var ERR_REMOTE_SERVER_NOT_FOUND=STANZA_ERROR('404','cancel','remote-server-not-found');var ERR_REMOTE_SERVER_TIMEOUT=STANZA_ERROR('504','wait','remote-server-timeout');var ERR_RESOURCE_CONSTRAINT=STANZA_ERROR('500','wait','resource-constraint');var ERR_SERVICE_UNAVAILABLE=STANZA_ERROR('503','cancel','service-unavailable');var ERR_SUBSCRIPTION_REQUIRED=STANZA_ERROR('407','auth','subscription-required');var ERR_UNEXPECTED_REQUEST=STANZA_ERROR('400','wait','unexpected-request');function hasDB(){if(window.sessionStorage)
return true;return false;}
function getDB(type,id){try{return sessionStorage.getItem(type+'_'+id);}
catch(e){logThis('Error while getting a temporary database entry ('+type+' -> '+id+'): '+e,1);return null;}}
function setDB(type,id,value){try{sessionStorage.setItem(type+'_'+id,value);return true;}
catch(e){logThis('Error while writing a temporary database entry ('+type+' -> '+id+'): '+e,1);return false;}}
function removeDB(type,id){try{sessionStorage.removeItem(type+'_'+id);return true;}
catch(e){logThis('Error while removing a temporary database entry ('+type+' -> '+id+'): '+e,1);return false;}}
function existDB(type,id){var read=getDB(type,id);if(read!=null)
return true;return false;}
function resetDB(){try{sessionStorage.clear();logThis('Temporary database cleared.',3);return true;}
catch(e){logThis('Error while clearing temporary database: '+e,1);return false;}}
function hasPersistent(){if(window.localStorage)
return true;return false;}
function getPersistent(type,id){try{return localStorage.getItem(type+'_'+id);}
catch(e){logThis('Error while getting a persistent database entry ('+type+' -> '+id+'): '+e,1);return null;}}
function setPersistent(type,id,value){try{localStorage.setItem(type+'_'+id,value);return true;}
catch(e){logThis('Retrying: could not write a persistent database entry ('+type+' -> '+id+'): '+e,2);flushPersistent();try{localStorage.setItem(type+'_'+id,value);return true;}
catch(e){logThis('Aborted: error while writing a persistent database entry ('+type+' -> '+id+'): '+e,1);return false;}}}
function removePersistent(type,id){try{localStorage.removeItem(type+'_'+id);return true;}
catch(e){logThis('Error while removing a persistent database entry ('+type+' -> '+id+'): '+e,1);return false;}}
function existPersistent(type,id){var read=getPersistent(type,id);if(read!=null)
return true;return false;}
function resetPersistent(){try{localStorage.clear();logThis('Persistent database cleared.',3);return true;}
catch(e){logThis('Error while clearing persistent database: '+e,1);return false;}}
function flushPersistent(){try{var session=getPersistent('session',1);localStorage.clear();if(session)
setPersistent('session',1,session);logThis('Persistent database flushed.',3);return true;}
catch(e){logThis('Error while flushing persistent database: '+e,1);return false;}}
var BrowserDetect={init:function(){this.browser=this.searchString(this.dataBrowser)||"An unknown browser";this.version=this.searchVersion(navigator.userAgent)||this.searchVersion(navigator.appVersion)||"an unknown version";this.OS=this.searchString(this.dataOS)||"an unknown OS";},searchString:function(data){for(var i=0;i<data.length;i++){var dataString=data[i].string;var dataProp=data[i].prop;this.versionSearchString=data[i].versionSearch||data[i].identity;if(dataString){if(dataString.indexOf(data[i].subString)!=-1)
return data[i].identity;}
else if(dataProp)
return data[i].identity;}},searchVersion:function(dataString){var index=dataString.indexOf(this.versionSearchString);if(index==-1)return;return parseFloat(dataString.substring(index+this.versionSearchString.length+1));},dataBrowser:[{string:navigator.userAgent,subString:"Chrome",identity:"Chrome"},{string:navigator.userAgent,subString:"OmniWeb",versionSearch:"OmniWeb/",identity:"OmniWeb"},{string:navigator.vendor,subString:"Apple",identity:"Safari",versionSearch:"Version"},{prop:window.opera,identity:"Opera"},{string:navigator.vendor,subString:"iCab",identity:"iCab"},{string:navigator.vendor,subString:"KDE",identity:"Konqueror"},{string:navigator.userAgent,subString:"Firefox",identity:"Firefox"},{string:navigator.vendor,subString:"Camino",identity:"Camino"},{string:navigator.userAgent,subString:"Netscape",identity:"Netscape"},{string:navigator.userAgent,subString:"MSIE",identity:"Explorer",versionSearch:"MSIE"},{string:navigator.userAgent,subString:"Gecko",identity:"Mozilla",versionSearch:"rv"},{string:navigator.userAgent,subString:"Mozilla",identity:"Netscape",versionSearch:"Mozilla"}],dataOS:[{string:navigator.platform,subString:"Win",identity:"Windows"},{string:navigator.platform,subString:"Mac",identity:"Mac"},{string:navigator.userAgent,subString:"iPhone",identity:"iPhone/iPod"},{string:navigator.platform,subString:"Linux",identity:"Linux"}]};BrowserDetect.init();function exists(selector){if(jQuery(selector).size()>0)
return true;else
return false;}
function isConnected(){if((typeof con!='undefined')&&con&&con.connected())
return true;return false;}
function isFocused(){try{if(document.hasFocus())
return true;return false;}
catch(e){return true;}}
function generateXID(xid,type){if(xid&&(xid.indexOf('@')==-1)){if(type=='groupchat')
return xid+'@'+HOST_MUC;if(xid.indexOf('.')==-1)
return xid+'@'+HOST_MAIN;return xid;}
return xid;}
function _e(string){return string;}
function printf(string,value){return string.replace('%s',value);}
function explodeThis(toEx,toStr,i){var index=toStr.indexOf(toEx);if(index!=-1){if(i==0)
toStr=toStr.substr(0,index);else
toStr=toStr.substr(index+1);}
return toStr;}
function cutResource(aXID){return explodeThis('/',aXID,0);}
function thisResource(aXID){if(aXID.indexOf('/')!=-1)
return explodeThis('/',aXID,1);return'';}
function stringPrep(string){var invalid=new Array('Š','š','Đ','đ','Ž','ž','Č','č','Ć','ć','À','Á','Â','Ã','Ä','Å','Æ','Ç','È','É','Ê','Ë','Ì','Í','Î','Ï','Ñ','Ò','Ó','Ô','Õ','Ö','Ø','Ù','Ú','Û','Ü','Ý','Þ','ß','à','á','â','ã','ä','å','æ','ç','è','é','ê','ë','ì','í','î','ï','ð','ñ','ò','ó','ô','õ','ö','ø','ù','ú','û','ý','þ','ÿ','Ŕ','ŕ');var valid=new Array('S','s','Dj','dj','Z','z','C','c','C','c','A','A','A','A','A','A','A','C','E','E','E','E','I','I','I','I','N','O','O','O','O','O','O','U','U','U','U','Y','B','Ss','a','a','a','a','a','a','a','c','e','e','e','e','i','i','i','i','o','n','o','o','o','o','o','o','u','u','u','y','b','y','R','r');for(i in invalid)
string=string.replace(invalid[i],valid[i]);return string;}
function encodeQuotes(str){return(str+'').replace(/"/g,'&quot;');}
function bareXID(xid){xid=cutResource(xid);xid=stringPrep(xid);xid=xid.toLowerCase();return xid;}
function fullXID(xid){var full=bareXID(xid);var resource=thisResource(xid);if(resource)
full+='/'+resource;return full;}
function getXIDNick(aXID){return explodeThis('@',aXID,0);}
function getXIDHost(aXID){return explodeThis('@',aXID,1);}
function isDeveloper(){if(DEVELOPER=='on')
return true;return false;}
function allowedAnonymous(){if(ANONYMOUS=='on')
return true;return false;}
function lockHost(){if(LOCK_HOST=='on')
return true;return false;}
function getXID(){if(con.username&&con.domain)
return con.username+'@'+con.domain;return'';}
function generateColor(xid){var colors=new Array('ac0000','a66200','007703','00705f','00236b','4e005c');var number=0;for(var i=0;i<xid.length;i++)
number+=xid.charCodeAt(i);var color='#'+colors[number%(colors.length)];return color;}
function isGateway(xid){if(xid.indexOf('@')!=-1)
return false;return true;}
function getStanzaFrom(stanza){var from=stanza.getFrom();if(!from)
from=getXID();return from;}
function logThis(data,level){if(!isDeveloper()||(typeof(console)=='undefined'))
return false;switch(level){case 0:console.debug(data);break;case 1:console.error(data);break;case 2:console.warn(data);break;case 3:console.info(data);break;default:console.log(data);break;}
return true;}
function getJappixLocation(){var url=window.location.href;if(url.indexOf('?')!=-1)
url=url.split('?')[0];if(url.indexOf('#')!=-1)
url=url.split('#')[0];if(!url.match(/(.+)\/$/))
url+='/';return url;}
function trim(str){return str.replace(/^\s+/g,'').replace(/\s+$/g,'');}
function padZero(i){if(i>-10&&i<0)
return'-0'+(i*-1);if(i<10&&i>=0)
return'0'+i;return i;}
function extractStamp(date){return Math.round(date.getTime()/1000);}
function extractTime(date){return date.toLocaleTimeString();}
function getTimeStamp(){return extractStamp(new Date());}
var LAST_ACTIVITY=0;function getLastActivity(){if(LAST_ACTIVITY==0)
return 0;return getTimeStamp()-LAST_ACTIVITY;}
var PRESENCE_LAST_ACTIVITY=0;function getPresenceLast(){if(PRESENCE_LAST_ACTIVITY==0)
return 0;return getTimeStamp()-PRESENCE_LAST_ACTIVITY;}
function getXMPPTime(location){var jInit=new Date();var year,month,day,hours,minutes,seconds;if(location=='utc'){year=jInit.getUTCFullYear();month=jInit.getUTCMonth();day=jInit.getUTCDate();hours=jInit.getUTCHours();minutes=jInit.getUTCMinutes();seconds=jInit.getUTCSeconds();}
else{year=jInit.getFullYear();month=jInit.getMonth();day=jInit.getDate();hours=jInit.getHours();minutes=jInit.getMinutes();seconds=jInit.getSeconds();}
var jDate=year+'-';jDate+=padZero(month+1)+'-';jDate+=padZero(day)+'T';jDate+=padZero(hours)+':';jDate+=padZero(minutes)+':';jDate+=padZero(seconds)+'Z';return jDate;}
function getCompleteTime(){var init=new Date();var time=padZero(init.getHours())+':';time+=padZero(init.getMinutes())+':';time+=padZero(init.getSeconds());return time;}
function getDateTZO(){var date=new Date();var offset=date.getTimezoneOffset();var sign='';var hours=0;var minutes=0;if(offset<0){offset=offset*-1;sign='+';}
var n_date=new Date(offset*60*1000);hours=n_date.getHours()-1;minutes=n_date.getMinutes();tzo=sign+padZero(hours)+':'+padZero(minutes);return tzo;}
function parseDate(to_parse){var date=Date.jab2date(to_parse);var parsed=date.toLocaleDateString()+' ('+date.toLocaleTimeString()+')';return parsed;}
function parseDay(to_parse){var date=Date.jab2date(to_parse);var parsed=date.toLocaleDateString();return parsed;}
function parseTime(to_parse){var date=Date.jab2date(to_parse);var parsed=date.toLocaleTimeString();return parsed;}
function relativeDate(to_parse){var current_date=Date.jab2date(getXMPPTime('utc'));var current_stamp=current_date.getTime();var old_date=Date.jab2date(to_parse);var old_stamp=old_date.getTime();var old_time=old_date.toLocaleTimeString();var days=Math.round((current_stamp-old_stamp)/86400000);if(isNaN(old_stamp)||isNaN(days))
return getCompleteTime();if(days<=0)
return old_time;if(days==1)
return _e("Hier")+' - '+old_time;if(days<=7)
return printf(_e("Il y a %s jours"),days)+' - '+old_time;return old_date.toLocaleDateString()+' - '+old_time;}
function readMessageDelay(node){var delay,d_delay;d_delay=jQuery(node).find('delay[xmlns='+NS_URN_DELAY+']:first').attr('stamp');if(d_delay)
delay=d_delay;else{var x_delay=jQuery(node).find('x[xmlns='+NS_DELAY+']:first').attr('stamp');if(x_delay)
delay=x_delay.replace(/^(\w{4})(\w{2})(\w{2})T(\w{2}):(\w{2}):(\w{2})Z?(\S+)?/,'$1-$2-$3T$4:$5:$6Z$7');}
return delay;}
function applyLinks(string,mode,style){var style,target;if(!style)
style='';else
style=' style="'+style+'"';if(mode!='xhtml-im')
target=' target="_blank"';else
target='';string=string.replace(/(\s|<br \/>|^)(([a-zA-Z0-9\._-]+)@([a-zA-Z0-9\.\/_-]+))(\s|$)/gi,'$1<a href="xmpp:$2" target="_blank"'+style+'>$2</a>$5');string=string.replace(/(\s|<br \/>|^|\()((https?|ftp|file|xmpp|irc|mailto|vnc|webcal|ssh|ldap|smb|magnet|spotify)(:)([^<>'"\s\)]+))/gim,'$1<a href="$2"'+target+style+'>$2</a>');return string;}
var MINI_DISCONNECT=false;var MINI_AUTOCONNECT=false;var MINI_SHOWPANE=false;var MINI_INITIALIZED=false;var MINI_ANONYMOUS=false;var MINI_ANIMATE=false;var MINI_NICKNAME=null;var MINI_TITLE=null;var MINI_DOMAIN=null;var MINI_USER=null;var MINI_PASSWORD=null;var MINI_RECONNECT=0;var MINI_GROUPCHATS=[];var MINI_PASSWORDS=[];var MINI_RESOURCE=JAPPIX_RESOURCE+' Mini';function setupConMini(con){con.registerHandler('message',handleMessageMini);con.registerHandler('presence',handlePresenceMini);con.registerHandler('iq',handleIQMini);con.registerHandler('onerror',handleErrorMini);con.registerHandler('onconnect',connectedMini);}
function connectMini(domain,user,password){try{oArgs=new Object();if(HOST_BOSH_MINI)
oArgs.httpbase=HOST_BOSH_MINI;else
oArgs.httpbase=HOST_BOSH;con=new JSJaCHttpBindingConnection(oArgs);setupConMini(con);var random_resource=getDB('jappix-mini','resource');if(!random_resource)
random_resource=MINI_RESOURCE+' ('+(new Date()).getTime()+')';oArgs=new Object();oArgs.secure=true;oArgs.xmllang=XML_LANG;oArgs.resource=random_resource;oArgs.domain=domain;setDB('jappix-mini','resource',random_resource);if(MINI_ANONYMOUS){if(!allowedAnonymous()){logThis('Not allowed to use anonymous mode.',2);notifyErrorMini();return false;}
else if(lockHost()&&(domain!=HOST_ANONYMOUS)){logThis('Not allowed to connect to this anonymous domain: '+domain,2);notifyErrorMini();return false;}
oArgs.authtype='saslanon';}
else{if(lockHost()&&(domain!=HOST_MAIN)){logThis('Not allowed to connect to this main domain: '+domain,2);notifyErrorMini();return false;}
if(!MINI_NICKNAME)
MINI_NICKNAME=user;oArgs.username=user;oArgs.pass=password;}
con.connect(oArgs);logThis('Jappix Mini is connecting...',3);}
catch(e){logThis('Error while logging in: '+e,1);disconnectedMini();}
finally{return false;}}
function connectedMini(){jQuery('#jappix_mini a.jm_pane.jm_button span.jm_counter').text('0');if(MINI_ANONYMOUS)
initializeMini();else
getRosterMini();if(MINI_RECONNECT)
logThis('Jappix Mini is now reconnected.',3);else
logThis('Jappix Mini is now connected.',3);MINI_RECONNECT=0;}
function saveSessionMini(){if(!isConnected())
return;setDB('jappix-mini','dom',jQuery('#jappix_mini').html());setDB('jappix-mini','nickname',MINI_NICKNAME);var scroll_position='';var scroll_hash=jQuery('#jappix_mini div.jm_conversation:has(a.jm_pane.jm_clicked)').attr('data-hash');if(scroll_hash)
scroll_position=document.getElementById('received-'+scroll_hash).scrollTop+'';setDB('jappix-mini','scroll',scroll_position);setDB('jappix-mini','stamp',getTimeStamp());con.suspend(false);logThis('Jappix Mini session save tool launched.',3);}
function disconnectMini(){if(!isConnected())
return false;MINI_DISCONNECT=true;MINI_INITIALIZED=false;con.registerHandler('ondisconnect',disconnectedMini);con.disconnect();logThis('Jappix Mini is disconnecting...',3);return false;}
function disconnectedMini(){removeDB('jappix-mini','dom');removeDB('jappix-mini','nickname');removeDB('jappix-mini','scroll');removeDB('jappix-mini','stamp');if(!MINI_DISCONNECT||MINI_INITIALIZED){notifyErrorMini();jQuery('#jappix_mini').stopTime();if(MINI_INITIALIZED&&(MINI_RECONNECT<5)){var reconnect_interval=10;if(MINI_RECONNECT)
reconnect_interval=(5+(5*MINI_RECONNECT))*1000;MINI_RECONNECT++;jQuery('#jappix_mini').oneTime(reconnect_interval,function(){launchMini(true,MINI_SHOWPANE,MINI_DOMAIN,MINI_USER,MINI_PASSWORD);});}}
else
launchMini(false,MINI_SHOWPANE,MINI_DOMAIN,MINI_USER,MINI_PASSWORD);MINI_DISCONNECT=false;MINI_INITIALIZED=false;logThis('Jappix Mini is now disconnected.',3);}
function handleMessageMini(msg){var type=msg.getType();if((type=='chat')||(type=='normal')||(type=='groupchat')||!type){var body=trim(msg.getBody());var subject=trim(msg.getSubject());if(subject)
body=subject;if(body){var from=fullXID(getStanzaFrom(msg));var xid=bareXID(from);var use_xid=xid;var hash=hex_md5(xid);var nick=thisResource(from);var delay=readMessageDelay(msg.getNode());var d_stamp;if(delay){time=relativeDate(delay);d_stamp=Date.jab2date(delay);}
else{time=getCompleteTime();d_stamp=new Date();}
var stamp=extractStamp(d_stamp);if(exists('#jappix_mini #chat-'+hash+'[data-type=groupchat]')){if((type=='chat')||!type){xid=from;hash=hex_md5(xid);}
else
use_xid=from;}
var message_type='user-message';if(type=='groupchat'){if(msg.getChild('delay',NS_URN_DELAY)||msg.getChild('x',NS_DELAY))
message_type='old-message';if(!nick||subject){nick='';message_type='system-message';}}
else{nick=jQuery('#jappix_mini a#friend-'+hash).text().revertHtmlEnc();if(!nick)
nick=getXIDNick(xid);}
var target='#jappix_mini #chat-'+hash;if(!exists(target)&&(type!='groupchat'))
chatMini(type,xid,nick,hash);displayMessageMini(type,body,use_xid,nick,hash,time,stamp,message_type);if((!jQuery(target+' a.jm_chat-tab').hasClass('jm_clicked')||!isFocused())&&(message_type=='user-message'))
notifyMessageMini(hash);logThis('Message received from: '+from);}}}
function handleIQMini(iq){var iqFrom=fullXID(getStanzaFrom(iq));var iqID=iq.getID();var iqQueryXMLNS=iq.getQueryXMLNS();var iqType=iq.getType();var iqNode=iq.getNode();var iqResponse=new JSJaCIQ();iqResponse.setID(iqID);iqResponse.setTo(iqFrom);iqResponse.setType('result');if((iqQueryXMLNS==NS_VERSION)&&(iqType=='get')){var iqQuery=iqResponse.setQuery(NS_VERSION);iqQuery.appendChild(iq.buildNode('name',{'xmlns':NS_VERSION},'Jappix Mini'));iqQuery.appendChild(iq.buildNode('version',{'xmlns':NS_VERSION},JAPPIX_VERSION));iqQuery.appendChild(iq.buildNode('os',{'xmlns':NS_VERSION},BrowserDetect.OS));con.send(iqResponse);logThis('Received software version query: '+iqFrom);}
else if((iqQueryXMLNS==NS_ROSTER)&&(iqType=='set')){handleRosterMini(iq);con.send(iqResponse);logThis('Received a roster push.');}
else if((iqQueryXMLNS==NS_DISCO_INFO)&&(iqType=='get')){var iqQuery=iqResponse.setQuery(NS_DISCO_INFO);iqQuery.appendChild(iq.appendNode('identity',{'category':'client','type':'web','name':'Jappix Mini','xmlns':NS_DISCO_INFO}));var fArray=new Array(NS_DISCO_INFO,NS_VERSION,NS_ROSTER,NS_MUC,NS_VERSION,NS_URN_TIME);for(i in fArray)
iqQuery.appendChild(iq.buildNode('feature',{'var':fArray[i],'xmlns':NS_DISCO_INFO}));con.send(iqResponse);logThis('Received a disco#infos query.');}
else if(jQuery(iqNode).find('time').size()&&(iqType=='get')){var iqTime=iqResponse.appendNode('time',{'xmlns':NS_URN_TIME});iqTime.appendChild(iq.buildNode('tzo',{'xmlns':NS_URN_TIME},getDateTZO()));iqTime.appendChild(iq.buildNode('utc',{'xmlns':NS_URN_TIME},getXMPPTime('utc')));con.send(iqResponse);logThis('Received local time query: '+iqFrom);}}
function handleErrorMini(err){if(jQuery(err).is('error')){disconnectedMini();logThis('First level error received.',1);}}
function handlePresenceMini(pr){var from=fullXID(getStanzaFrom(pr));var xid=bareXID(from);var resource=thisResource(from);var hash=hex_md5(xid);var type=pr.getType();var show=pr.getShow();if((type=='error')||(type=='unavailable'))
show='unavailable';else{switch(show){case'chat':case'away':case'xa':case'dnd':break;default:show='available';break;}}
var groupchat_path='#jappix_mini #chat-'+hash+'[data-type=groupchat]';if(exists(groupchat_path)){if(resource!=unescape(jQuery(groupchat_path).attr('data-nick'))){var groupchat=xid;xid=from;hash=hex_md5(xid);if(show=='unavailable')
removeBuddyMini(hash,groupchat);else
addBuddyMini(xid,hash,resource,groupchat);}}
var chat='#jappix_mini #chat-'+hash;var friend='#jappix_mini a#friend-'+hash;var send_input=chat+' input.jm_send-messages';if(show=='unavailable'){jQuery(friend).addClass('jm_offline').removeClass('jm_online');jQuery(chat).addClass('jm_disabled');jQuery(send_input).attr('disabled',true).attr('data-value',_e("Déconnecté(e)")).val(_e("Déconnecté(e)"));}
else{jQuery(friend).removeClass('jm_offline').addClass('jm_online');jQuery(chat).removeClass('jm_disabled');jQuery(send_input).removeAttr('disabled').val('');}
jQuery(friend+' span.jm_presence, '+chat+' span.jm_presence').attr('class','jm_presence jm_images jm_'+show);updateRosterMini();logThis('Presence received from: '+from);}
function handleMUCMini(pr){var xml=pr.getNode();var from=fullXID(getStanzaFrom(pr));var room=bareXID(from);var hash=hex_md5(room);var resource=thisResource(from);var valid=false;if(!resource||(resource==unescape(jQuery('#jappix_mini #chat-'+hash+'[data-type=groupchat]').attr('data-nick'))))
valid=true;if(valid&&jQuery(xml).find('error[type=auth] not-authorized').size()){openPromptMini(printf(_e("Ce salon (%s) est protégé par un mot de passe."),room));jQuery('#jappix_popup div.jm_prompt form').submit(function(){try{var password=closePromptMini();if(password){presenceMini('','','','',from,password,true,handleMUCMini);switchPaneMini('chat-'+hash,hash);}}
catch(e){}
finally{return false;}});return;}
else if(valid&&jQuery(xml).find('error[type=cancel] conflict').size()){var nickname=resource+'_';presenceMini('','','','',room+'/'+nickname,'',true,handleMUCMini);jQuery('#jappix_mini #chat-'+hash).attr('data-nick',escape(nickname));}
else
handlePresenceMini(pr);}
function presenceMini(type,show,priority,status,to,password,limit_history,handler){var pr=new JSJaCPresence();if(to)
pr.setTo(to);if(type)
pr.setType(type);if(show)
pr.setShow(show);if(priority)
pr.setPriority(priority);if(status)
pr.setStatus(status);if(password||limit_history){var x=pr.appendNode('x',{'xmlns':NS_MUC});if(password)
x.appendChild(pr.buildNode('password',{'xmlns':NS_MUC},password));if(limit_history)
x.appendChild(pr.buildNode('history',{'maxstanzas':10,'seconds':86400,'xmlns':NS_MUC}));}
if(handler)
con.send(pr,handler);else
con.send(pr);if(!type)
type='available';logThis('Presence sent: '+type,3);}
function sendMessageMini(aForm){try{var body=trim(aForm.body.value);var xid=aForm.xid.value;var type=aForm.type.value;var hash=hex_md5(xid);if(body&&xid){var aMsg=new JSJaCMessage();aMsg.setTo(xid);aMsg.setType(type);aMsg.setBody(body);con.send(aMsg);aForm.body.value='';if(type!='groupchat')
displayMessageMini(type,body,getXID(),'me',hash,getCompleteTime(),getTimeStamp(),'user-message');logThis('Message ('+type+') sent to: '+xid);}}
catch(e){}
finally{return false;}}
function smileyMini(image,text){return' <img class="jm_smiley jm_smiley-'+image+' jm_images" alt="'+encodeQuotes(text)+'" src="'+JAPPIX_STATIC+'php/get.php?t=img&amp;f=others/blank.gif" /> ';}
function notifyMessageMini(hash){var tab='#jappix_mini #chat-'+hash+' a.jm_chat-tab';var notify=tab+' span.jm_notify';var notify_middle=notify+' span.jm_notify_middle';if(!exists(notify))
jQuery(tab).append('<span class="jm_notify">'+'<span class="jm_notify_left jm_images"></span>'+'<span class="jm_notify_middle">0</span>'+'<span class="jm_notify_right jm_images"></span>'+'</span>');var number=parseInt(jQuery(notify_middle).text());jQuery(notify_middle).text(number+1);notifyTitleMini();}
function notifyErrorMini(){jQuery('#jappix_mini').html('<div class="jm_starter">'+'<a class="jm_pane jm_button jm_images" href="https://mini.jappix.com/issues" target="_blank" title="'+_e("Cliquez ici pour résoudre l\'erreur")+'">'+'<span class="jm_counter jm_error jm_images">'+_e("Erreur")+'</span>'+'</a>'+'</div>');}
function notifyTitleMini(){if(MINI_TITLE==null)
return false;var title=MINI_TITLE;var number=0;jQuery('#jappix_mini span.jm_notify span.jm_notify_middle').each(function(){number=number+parseInt(jQuery(this).text());});if(number)
title='['+number+'] '+title;document.title=title;return true;}
function clearNotificationsMini(hash){if(!isFocused())
return false;jQuery('#jappix_mini #chat-'+hash+' span.jm_notify').remove();notifyTitleMini();return true;}
function updateRosterMini(){jQuery('#jappix_mini a.jm_button span.jm_counter').text(jQuery('#jappix_mini a.jm_online').size());}
function createMini(domain,user,password){var dom=getDB('jappix-mini','dom');var stamp=parseInt(getDB('jappix-mini','stamp'));var suspended=false;if(dom&&isNaN(jQuery(dom).find('a.jm_pane.jm_button span.jm_counter').text()))
dom=null;con=new JSJaCHttpBindingConnection();setupConMini(con);if(dom&&((getTimeStamp()-stamp)<JSJACHBC_MAX_WAIT)&&con.resume()){MINI_NICKNAME=getDB('jappix-mini','nickname');suspended=true;}
else{dom='<div class="jm_position">'+'<div class="jm_conversations"></div>'+'<div class="jm_starter">'+'<div class="jm_roster">'+'<div class="jm_actions">'+'<a class="jm_logo jm_images" href="https://mini.jappix.com/" target="_blank"></a>'+'<a class="jm_one-action jm_join jm_images" title="'+_e("Rejoindre une discussion")+'" href="#"></a>'+'</div>'+'<div class="jm_buddies"></div>'+'</div>'+'<a class="jm_pane jm_button jm_images" href="#">'+'<span class="jm_counter jm_images">'+_e("Patientez...")+'</span>'+'</a>'+'</div>'+'</div>';}
jQuery('body').append('<div id="jappix_mini">'+dom+'</div>');adaptRosterMini();jQuery('#jappix_mini a.jm_button').click(function(){try{var counter='#jappix_mini a.jm_pane.jm_button span.jm_counter';if(jQuery(counter).text()==_e("Patientez..."))
return false;if(jQuery(counter).text()==_e("Discussion")){jQuery('#jappix_mini div.jm_starter span.jm_animate').stopTime().remove();jQuery(counter).text(_e("Patientez..."));connectMini(domain,user,password);return false;}
if(!jQuery(this).hasClass('jm_clicked'))
showRosterMini();else
hideRosterMini();}
catch(e){}
finally{return false;}});jQuery('#jappix_mini div.jm_actions a.jm_join').click(function(){try{openPromptMini(_e("Veuillez entrer l\'adresse du salon à rejoindre."));jQuery('#jappix_popup div.jm_prompt form').submit(function(){try{var join_this=closePromptMini();if(join_this){chat_room=bareXID(generateXID(join_this,'groupchat'));chatMini('groupchat',chat_room,getXIDNick(chat_room),hex_md5(chat_room));}}
catch(e){}
finally{return false;}});}
catch(e){}
finally{return false;}});jQuery(document).click(function(evt){if(!jQuery(evt.target).parents('#jappix_mini').size()&&!exists('#jappix_popup'))
hideRosterMini();});jQuery(document).dblclick(function(evt){if(!jQuery(evt.target).parents('#jappix_mini').size()&&!exists('#jappix_popup'))
switchPaneMini();});if(suspended){MINI_INITIALIZED=true;jQuery('#jappix_mini div.jm_conversation input.jm_send-messages').each(function(){var chat_value=jQuery(this).attr('data-value');if(chat_value)
jQuery(this).val(chat_value);});jQuery('#jappix_mini a.jm_friend').click(function(){try{chatMini('chat',unescape(jQuery(this).attr('data-xid')),unescape(jQuery(this).attr('data-nick')),jQuery(this).attr('data-hash'));}
catch(e){}
finally{return false;}});jQuery('#jappix_mini div.jm_conversation').each(function(){chatEventsMini(jQuery(this).attr('data-type'),unescape(jQuery(this).attr('data-xid')),jQuery(this).attr('data-hash'));});var scroll_hash=jQuery('#jappix_mini div.jm_conversation:has(a.jm_pane.jm_clicked)').attr('data-hash');var scroll_position=getDB('jappix-mini','scroll');if(scroll_position)
scroll_position=parseInt(scroll_position);if(scroll_hash){jQuery(document).oneTime(200,function(){messageScrollMini(scroll_hash,scroll_position);});}
notifyTitleMini();}
else if(MINI_AUTOCONNECT)
connectMini(domain,user,password);else{jQuery('#jappix_mini a.jm_pane.jm_button span.jm_counter').text(_e("Discussion"));if(MINI_ANIMATE){jQuery('#jappix_mini div.jm_starter').prepend('<span class="jm_animate jm_images_animate"></span>');if((BrowserDetect.browser=='Explorer')&&(BrowserDetect.version<7))
return;var anim_i=0;jQuery('#jappix_mini div.jm_starter span.jm_animate').everyTime(10,function(){anim_i++;var m_top=Math.cos(anim_i*0.02)*3;var m_left=Math.sin(anim_i*0.02)*3;jQuery(this).css('margin-top',m_top+'px').css('margin-left',m_left+'px');});}}}
function displayMessageMini(type,body,xid,nick,hash,time,stamp,message_type){var path='#chat-'+hash;var cont_scroll=document.getElementById('received-'+hash);var can_scroll=false;if(!cont_scroll.scrollTop||((cont_scroll.clientHeight+cont_scroll.scrollTop)==cont_scroll.scrollHeight))
can_scroll=true;var last=jQuery(path+' div.jm_group:last');var last_stamp=parseInt(last.attr('data-stamp'));var last_b=jQuery(path+' b:last');var last_xid=last_b.attr('data-xid');var last_type=last.attr('data-type');var grouped=false;var header='';if((last_xid==xid)&&(message_type==last_type)&&((stamp-last_stamp)<=1800))
grouped=true;else{if(nick)
header+='<span class="jm_date">'+time+'</span>';if(type=='groupchat')
header+='<b style="color: '+generateColor(nick)+';" data-xid="'+encodeQuotes(xid)+'">'+nick.htmlEnc()+'</b>';else if(nick=='me')
header+='<b class="jm_me" data-xid="'+encodeQuotes(xid)+'">'+_e("Vous")+'</b>';else
header+='<b class="jm_him" data-xid="'+encodeQuotes(xid)+'">'+nick.htmlEnc()+'</b>';}
var me_command=false;if(body.match(/^\/me /i)){body=body.replace(/^\/me /i,nick+' ');me_command=true;}
body=body.htmlEnc();body=body.replace(/(;\)|;-\))(\s|$)/gi,smileyMini('wink','$1')).replace(/(:3|:-3)(\s|$)/gi,smileyMini('waii','$1')).replace(/(:\(|:-\()(\s|$)/gi,smileyMini('unhappy','$1')).replace(/(:P|:-P)(\s|$)/gi,smileyMini('tongue','$1')).replace(/(:O|:-O)(\s|$)/gi,smileyMini('surprised','$1')).replace(/(:\)|:-\))(\s|$)/gi,smileyMini('smile','$1')).replace(/(\^\^|\^_\^)(\s|$)/gi,smileyMini('happy','$1')).replace(/(:D|:-D)(\s|$)/gi,smileyMini('grin','$1'));body=applyLinks(body,'mini');if(me_command)
body='<em>'+body+'</em>';body='<p>'+body+'</p>';if(grouped)
jQuery('#jappix_mini #chat-'+hash+' div.jm_received-messages div.jm_group:last').append(body);else
jQuery('#jappix_mini #chat-'+hash+' div.jm_received-messages').append('<div class="jm_group jm_'+message_type+'" data-type="'+message_type+'" data-stamp="'+stamp+'">'+header+body+'</div>');if(can_scroll)
messageScrollMini(hash);}
function switchPaneMini(element,hash){jQuery('#jappix_mini a.jm_pane').removeClass('jm_clicked');jQuery('#jappix_mini div.jm_roster, #jappix_mini div.jm_chat-content').hide();if(element&&(element!='roster')){var current='#jappix_mini #'+element;jQuery(current+' a.jm_pane').addClass('jm_clicked');jQuery(current+' div.jm_chat-content').show();jQuery(document).oneTime(10,function(){jQuery(current+' input.jm_send-messages').focus();});if(hash)
messageScrollMini(hash);}}
function messageScrollMini(hash,position){var id=document.getElementById('received-'+hash);if(!position)
position=id.scrollHeight;id.scrollTop=position;}
function openPromptMini(text,value){var prompt='#jappix_popup div.jm_prompt';var input=prompt+' form input';var value_input=input+'[type=text]';closePromptMini();jQuery('body').append('<div id="jappix_popup">'+'<div class="jm_prompt">'+'<form>'+
text+'<input class="jm_text" type="text" value="" />'+'<input class="jm_submit" type="submit" value="'+_e("Soumettre")+'" />'+'<input class="jm_submit" type="reset" value="'+_e("Annuler")+'" />'+'<div class="jm_clear"></div>'+'</form>'+'</div>'+'</div>');var vert_pos='-'+((jQuery(prompt).height()/2)+10)+'px';jQuery(prompt).css('margin-top',vert_pos);if(value)
jQuery(value_input).val(value);jQuery(document).oneTime(10,function(){jQuery(value_input).focus();});jQuery(input+'[type=reset]').click(function(){try{closePromptMini();}
catch(e){}
finally{return false;}});}
function closePromptMini(){var value=jQuery('#jappix_popup div.jm_prompt form input').val();jQuery('#jappix_popup').remove();return value;}
function chatMini(type,xid,nick,hash,pwd,show_pane){var current='#jappix_mini #chat-'+hash;if(!exists(current)){if(type=='groupchat'){var nickname=MINI_NICKNAME;if(!nickname){openPromptMini(printf(_e("Veuillez entrer votre pseudonyme pour rejoindre %s."),xid));jQuery('#jappix_popup div.jm_prompt form').submit(function(){try{var nickname=closePromptMini();if(nickname)
MINI_NICKNAME=nickname;chatMini(type,xid,nick,hash,pwd);}
catch(e){}
finally{return false;}});return;}}
var html='<div class="jm_conversation jm_type_'+type+'" id="chat-'+hash+'" data-xid="'+escape(xid)+'" data-type="'+type+'" data-nick="'+escape(nick)+'" data-hash="'+hash+'" data-origin="'+escape(cutResource(xid))+'">'+'<div class="jm_chat-content">'+'<div class="jm_actions">'+'<span class="jm_nick">'+nick+'</span>';var groupchat_exists=false;if(MINI_GROUPCHATS&&MINI_GROUPCHATS.length){for(g in MINI_GROUPCHATS){if(xid==bareXID(generateXID(MINI_GROUPCHATS[g],'groupchat'))){groupchat_exists=true;break;}}}
if(((type=='groupchat')&&!groupchat_exists)||(type!='groupchat'))
html+='<a class="jm_one-action jm_close jm_images" title="'+_e("Fermer")+'" href="#"></a>';html+='</div>'+'<div class="jm_received-messages" id="received-'+hash+'"></div>'+'<form action="#" method="post">'+'<input type="text" class="jm_send-messages" name="body" autocomplete="off" />'+'<input type="hidden" name="xid" value="'+xid+'" />'+'<input type="hidden" name="type" value="'+type+'" />'+'</form>'+'</div>'+'<a class="jm_pane jm_chat-tab jm_images" href="#">'+'<span class="jm_name">'+nick.htmlEnc()+'</span>'+'</a>'+'</div>';jQuery('#jappix_mini div.jm_conversations').prepend(html);if(type!='groupchat'){var selector=jQuery('#jappix_mini a#friend-'+hash+' span.jm_presence');var show='available';if(selector.hasClass('jm_unavailable'))
show='unavailable';else if(selector.hasClass('jm_chat'))
show='chat';else if(selector.hasClass('jm_away'))
show='away';else if(selector.hasClass('jm_xa'))
show='xa';else if(selector.hasClass('jm_dnd'))
show='dnd';jQuery(current+' a.jm_chat-tab').prepend('<span class="jm_presence jm_images jm_'+show+'"></span>');}
chatEventsMini(type,xid,hash);if(type=='groupchat'){jQuery(current).attr('data-nick',escape(nickname));presenceMini('','','','',xid+'/'+nickname,pwd,true,handleMUCMini);}}
if(show_pane!=false)
jQuery(document).oneTime(10,function(){switchPaneMini('chat-'+hash,hash);});return false;}
function chatEventsMini(type,xid,hash){var current='#jappix_mini #chat-'+hash;jQuery(current+' form').submit(function(){return sendMessageMini(this);});jQuery(current+' a.jm_chat-tab').click(function(){try{if(!jQuery(this).hasClass('jm_clicked')){switchPaneMini('chat-'+hash,hash);clearNotificationsMini(hash);}
else
switchPaneMini();}
catch(e){}
finally{return false;}});jQuery(current+' a.jm_close').click(function(){try{jQuery(current).remove();if(type=='groupchat'){presenceMini('unavailable','','','',xid+'/'+unescape(jQuery(current).attr('data-nick')));removeGroupchatMini(xid);}}
catch(e){}
finally{return false;}});jQuery(current+' div.jm_received-messages').click(function(){try{jQuery(document).oneTime(10,function(){jQuery(current+' input.jm_send-messages').focus();});}
catch(e){}});jQuery(current+' input.jm_send-messages').focus(function(){clearNotificationsMini(hash);}).keyup(function(){jQuery(this).attr('data-value',jQuery(this).val());});}
function showRosterMini(){switchPaneMini('roster');jQuery('#jappix_mini div.jm_roster').show();jQuery('#jappix_mini a.jm_button').addClass('jm_clicked');}
function hideRosterMini(){jQuery('#jappix_mini div.jm_roster').hide();jQuery('#jappix_mini a.jm_button').removeClass('jm_clicked');}
function removeGroupchatMini(xid){jQuery('#jappix_mini div.jm_conversation[data-origin='+escape(cutResource(xid))+'], #jappix_mini div.jm_roster div.jm_grouped[data-xid='+escape(xid)+']').remove();updateRosterMini();}
function initializeMini(){MINI_INITIALIZED=true;if(!MINI_ANONYMOUS)
presenceMini();for(var i=0;i<MINI_GROUPCHATS.length;i++){if(!MINI_GROUPCHATS[i])
continue;try{var chat_room=bareXID(generateXID(MINI_GROUPCHATS[i],'groupchat'));chatMini('groupchat',chat_room,getXIDNick(chat_room),hex_md5(chat_room),MINI_PASSWORDS[i],MINI_SHOWPANE);}
catch(e){}}
if(!MINI_AUTOCONNECT&&!MINI_GROUPCHATS.length)
jQuery(document).oneTime(10,function(){showRosterMini();});}
function addBuddyMini(xid,hash,nick,groupchat){var element='#jappix_mini a.jm_friend#friend-'+hash;if(exists(element))
return false;var path='#jappix_mini div.jm_roster div.jm_buddies';if(groupchat){path='#jappix_mini div.jm_roster div.jm_grouped[data-xid='+escape(groupchat)+']';if(!exists(path)){jQuery('#jappix_mini div.jm_roster div.jm_buddies').append('<div class="jm_grouped" data-xid="'+escape(groupchat)+'">'+'<div class="jm_name">'+getXIDNick(groupchat).htmlEnc()+'</div>'+'</div>');}}
var code='<a class="jm_friend jm_offline" id="friend-'+hash+'" data-xid="'+escape(xid)+'" data-nick="'+escape(nick)+'" data-hash="'+hash+'" href="#"><span class="jm_presence jm_images jm_unavailable"></span>'+nick.htmlEnc()+'</a>';if(groupchat)
jQuery(path).append(code);else
jQuery(path).prepend(code);jQuery(element).click(function(){try{chatMini('chat',xid,nick,hash);}
catch(e){}
finally{return false;}});return true;}
function removeBuddyMini(hash,groupchat){jQuery('#jappix_mini a.jm_friend#friend-'+hash).remove();var group='#jappix_mini div.jm_roster div.jm_grouped[data-xid='+escape(groupchat)+']';if(groupchat&&!jQuery(group+' a.jm_friend').size())
jQuery(group).remove();return true;}
function getRosterMini(){var iq=new JSJaCIQ();iq.setType('get');iq.setQuery(NS_ROSTER);con.send(iq,handleRosterMini);logThis('Getting roster...',3);}
function handleRosterMini(iq){jQuery(iq.getQuery()).find('item').each(function(){var current=jQuery(this);var xid=current.attr('jid');var subscription=current.attr('subscription');if(!isGateway(xid)){var nick=current.attr('name');var hash=hex_md5(xid);if(!nick)
nick=getXIDNick(xid);if(subscription=='remove')
removeBuddyMini(hash);else
addBuddyMini(xid,hash,nick);}});if(!MINI_INITIALIZED)
initializeMini();logThis('Roster got.',3);}
function adaptRosterMini(){var height=jQuery(window).height()-70;jQuery('#jappix_mini div.jm_roster div.jm_buddies').css('max-height',height);}
function launchMini(autoconnect,show_pane,domain,user,password){MINI_DOMAIN=domain;MINI_USER=user;MINI_PASSWORD=password;if(!user||!password)
MINI_ANONYMOUS=true;else
MINI_ANONYMOUS=false;if(autoconnect&&hasDB())
MINI_AUTOCONNECT=true;else
MINI_AUTOCONNECT=false;if(show_pane)
MINI_SHOWPANE=true;else
MINI_SHOWPANE=false;jQuery('#jappix_mini').remove();if(MINI_RECONNECT){logThis('Trying to reconnect (try: '+MINI_RECONNECT+')!');return createMini(domain,user,password);}
jQuery('head').append('<link rel="stylesheet" href="'+JAPPIX_STATIC+'php/get.php?t=css&amp;g=mini.xml" type="text/css" media="all" />');if((BrowserDetect.browser=='Explorer')&&(BrowserDetect.version<7))
jQuery('head').append('<link rel="stylesheet" href="'+JAPPIX_STATIC+'php/get.php?t=css&amp;f=mini-ie.css" type="text/css" media="all" />');jQuery(document).keydown(function(e){if((e.keyCode==27)&&!isDeveloper())
return false;});MINI_TITLE=document.title;jQuery(window).resize(adaptRosterMini);if(BrowserDetect.browser=='Opera'){jQuery('a[href]:not([onclick])').click(function(){var href=jQuery(this).attr('href')||'';var target=jQuery(this).attr('target')||'';if(href&&!href.match(/^#/i)&&!target.match(/_blank|_new/i))
saveSessionMini();});jQuery('form:not([onsubmit])').submit(saveSessionMini);}
jQuery(window).bind('beforeunload',saveSessionMini);createMini(domain,user,password);logThis('Welcome to Jappix Mini! Happy coding in developer mode!');}