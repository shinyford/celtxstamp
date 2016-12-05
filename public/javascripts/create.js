var main_width, main_height, container_height, container_width, thumb_height, thumb_width = 0;
var offset = 50;

var stamp_id = '';
var stamp_page = 0;
var stamp_pages = 0;

var spinner_width = 40;

function update_thumb(e) {
  spin($('#pdf_container'));
	window.frames[0].update_thumb(e);
}

function position_thumb(x, y) {
	var lensoffset = $('#pdf_lens_wrapper').offset();
	var vo = (y - lensoffset.top);
	var voff = -offset + vo * (main_height - thumb_height) / thumb_height;
	var rect = "rect("+Math.floor(voff)+"px, " + container_width + "px, " + Math.floor(thumb_height+voff) + "px, 0px)";
	$('#pdf_image').css({
		width: container_width+"px",
 		height: (container_width*thumb_height/thumb_width)+"px"
	});
	$('#pdf_lens').css({
		top: -voff+"px",
		clip: rect
	});
}

window.onload = function () {
  $('#spinner').width(spinner_width).hide();
	$('#stamp_timezone')[0].value = new Date().getTimezoneOffset();
	$('#pdf_container div').bind('click', function(e) {
		$('#pdf_container').hide();
		$('#pdf_frame').show();
	});
	$('#pdf_navig_back').bind('click', function(e) {
	   if (stamp_page > 0 && stamp_id != '') {
           	load_stamp_image_with_spinner(stamp_id, stamp_page-1, stamp_pages);
	   }
	   e.stopPropagation();
	});
	$('#pdf_navig_next').bind('click', function(e) {
	   if (stamp_page < stamp_pages && stamp_id != '') {
           	load_stamp_image_with_spinner(stamp_id, stamp_page+1, stamp_pages);
	   }
	   e.stopPropagation();
	});
	$('#pdf_lens_wrapper').bind('mouseenter', function(e) {
		$('#pdf_lens').css({
			width: container_width+"px",
			height: (container_width*thumb_height/thumb_width)+"px",
		})
		$('#pdf_lens_wrapper').css({
			width: container_width + "px",
			left: "8px"
		});
		position_thumb(parseInt(e.pageX), parseInt(e.pageY));
	});
	$('#pdf_lens_wrapper').bind('mousemove', function(e) {
		position_thumb(parseInt(e.pageX), parseInt(e.pageY));
	});
	$('#pdf_lens_wrapper').bind('mouseleave', function(e) {
		$('#pdf_image').width(thumb_width+"px");
		$('#pdf_image').height(thumb_height+"px");
		$('#pdf_lens').css({
			top: 0,
			left: 0,
			width: thumb_width+"px",
			height: thumb_height+"px",
			clip: "auto"
		});
		$('#pdf_lens_wrapper').css({
			width: thumb_width + "px",
			left: (((container_width-thumb_width)/2)+8)+"px"
		});
	});

	$('.changeable').bind('change', update_thumb);
}

function load_stamp_image(id, page, pages) {
    $('#pdf_image').attr('src', '/as_jpeg/' + id + '/' + page + '/100.jpg?' + new Date().getTime());

    stamp_id = id;
    stamp_page = page;
    stamp_pages = pages;
}

function load_stamp_image_with_spinner(id, page, pages) {
  spin($('#pdf_container'));
  load_stamp_image(id, page, pages);
}

function spin(container) {
	$('#spinner').css({left: (container.offset().left + (container.width() - spinner_width)/2) + 'px'});
	$('#spinner').css({top: (container.offset().top + (container.height() - spinner_width)/2) + 'px'});
	$('#spinner').show();
}

function update_stamp_id(id, page, pages) {

	load_stamp_image(id, page, pages);

	$('#pdf_image').load(function() {
		$('#pdf_frame').hide();
		$('#spinner').width(spinner_width).hide();
		$('#pdf_container').show();
		$('#pdf_image').width("auto");
		$('#pdf_image').height("auto");
		container_width = $('#pdf_container').width();
		container_height = $('#pdf_container').height();
		thumb_width = 190; //$('#pdf_image').width();
		thumb_height = 190 * $('#pdf_image').height() / $('#pdf_image').width();
		main_height = (container_width * thumb_height / thumb_width) + offset*2;
		main_width = container_width + offset*2;
		$('#pdf_image').css({
			width: thumb_width+"px",
			height: thumb_height+"px"
		});
		$('#pdf_lens').css({
			top: 0,
			left: 0,
			width: thumb_width+"px",
			height: thumb_height+"px",
			clip: "auto"
		});
		$('#pdf_lens_wrapper').css({
			top: $('#pdf_container').offset().top,
			left: (((container_width-thumb_width)/2)+8)+"px",
			width: (thumb_width)+"px",
			height: (thumb_height)+"px",
			clip: "auto"
		});
		$('#pdf_container').height((thumb_height)+"px");
		window.focus();
	});
}
