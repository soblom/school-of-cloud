// Foundation JavaScript
// Documentation can be found at: http://foundation.zurb.com/docs
$(document).foundation();

$.getJSON( "content/content.json", function( data ) {
	var theTemplateScript = $("#main_content-template").html(); 

	var theTemplate = Handlebars.compile (theTemplateScript); 
	$(".main-content").append (theTemplate(data)); 
});

Handlebars.registerHelper('if_row_starts', function(index,options) {
	if (index % 4 == 0) {
		return options.fn()
	}
});

Handlebars.registerHelper('if_row_ends', function(index,options) {
	if ((index+1) % 4 == 0) {
		return options.fn()
	}
});


