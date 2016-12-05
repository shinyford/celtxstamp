// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
if ( typeof XMLHttpRequest == "undefined" ) XMLHttpRequest = function() {
  try { return new ActiveXObject("Msxml2.XMLHTTP.6.0") } catch(e) {}
  try { return new ActiveXObject("Msxml2.XMLHTTP.3.0") } catch(e) {}
  try { return new ActiveXObject("Msxml2.XMLHTTP") } catch(e) {}
  try { return new ActiveXObject("Microsoft.XMLHTTP") } catch(e) {}
  throw new Error( "This browser does not support XMLHttpRequest." )
};

function fetch(url) {
	var r = new XMLHttpRequest();
	r.open("GET", url, false);
	r.send("");
	return r.responseText;
}

