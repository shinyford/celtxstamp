// Provide the XMLHttpRequest class for IE 5.x-6.x:
// Other browsers (including IE 7.x-8.x)  ignore this when XMLHttpRequest is predefined
window.onload = function() {
	var e = document.getElementById('user_email');
	var p = document.getElementById('user_password');
	var q = document.getElementById('user_qassword');
	var pw = document.getElementById('pw');
	var qw = document.getElementById('qw');
	var s = document.getElementById('user_salt');
	document.forms[0].onsubmit = function() {
		s.value = fetch('/users/salt?email=' + escape(e.value));
		p.value = hex_sha1(pw.value + s.value);
		q.value = hex_sha1(qw.value + s.value);
		
		var pp = '';
		for (var i = 0; i < pw.value.length; i++) pp += '*';
		pw.value = pp;
		
		pp = '';
		for (var i = 0; i < qw.value.length; i++) pp += '*';
		qw.value = pp;
	}
	p.value = '';
	q.value = '';
}
