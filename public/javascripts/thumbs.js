function initialise_thumb(e) {
	var g = document.forms[0];
	if (stamp_id != '' || g['stamp[pdf]'].value != '') {
		g['stamp[bl]'].value = initvalue;
		g['stamp[bc]'].value = initvalue;
		g['stamp[br]'].value = initvalue;
		g['stamp[tl]'].value = initvalue;
		g['stamp[tc]'].value = initvalue;
		g['stamp[tr]'].value = initvalue;
		g['stamp[timezone]'].value = initvalue;
		g['stamp[start_page]'].value = initvalue;
		//g['stamp[filename]'].value = initvalue;

    if (window.parent && window.parent.spin) window.parent.spin(window.parent.$('#pdf_form_frame'));

		g.submit();
	}
}

function update_thumb(e) {
	var g = document.forms[0];
	if (stamp_id != '' || g['stamp[pdf]'].value != '') {
		var f = window.parent.document.forms[1];

		g['stamp[bl]'].value = f['stamp[bl]'].value;
		g['stamp[bc]'].value = f['stamp[bc]'].value;
		g['stamp[br]'].value = f['stamp[br]'].value;
		g['stamp[tl]'].value = f['stamp[tl]'].value;
		g['stamp[tc]'].value = f['stamp[tc]'].value;
		g['stamp[tr]'].value = f['stamp[tr]'].value;
		g['stamp[timezone]'].value = f['stamp[timezone]'].value;
		g['stamp[start_page]'].value = f['stamp[start_page]'].value;
		//g['stamp[filename]'].value = f['stamp[filename]'].value;

		g.submit();
	}
}

window.onload = function() {
  $('#spinner').hide();
	if (window.parent && stamp_id != '') {
		var f = window.parent.document.forms[1];
		var g = document.forms[0];
		var page = 1 - (g['stamp[start_page]'].value != '' ? parseInt(g['stamp[start_page]'].value) : 0);

    $('#pdf_form').hide();

		if (window.parent.update_stamp_id) window.parent.update_stamp_id(stamp_id, page, stamp_pages);

		f['stamp[filename]'].value = g['stamp[filename]'].value;

		f['stamp[bl]'].value = g['stamp[bl]'].value;
		f['stamp[bc]'].value = g['stamp[bc]'].value;
		f['stamp[br]'].value = g['stamp[br]'].value;
		f['stamp[tl]'].value = g['stamp[tl]'].value;
		f['stamp[tc]'].value = g['stamp[tc]'].value;
		f['stamp[tr]'].value = g['stamp[tr]'].value;
		f['stamp[start_page]'].value = g['stamp[start_page]'].value;
	}


	$('#stamp_pdf').bind('change', initialise_thumb);
}
