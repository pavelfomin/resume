$(document).ready(function() {

    const $container = $("#result-container");
    $container.empty();

    $.when(
        $.get("resume.xml"),
        $.get("resume.xsl")
    ).done(function(xmlResponse, xslResponse) {
        const xml = xmlResponse[0];
        const xsl = xslResponse[0];

        // Use the native browser XSLT processor
        const xsltProcessor = new XSLTProcessor();
        xsltProcessor.importStylesheet(xsl);

        // Transform XML to a document fragment
        const resultFragment = xsltProcessor.transformToFragment(xml, document);

        $container.html(resultFragment);

        //Set the email text based on the data attributes.
        $container.find('.email').each(function() {
            var user = $(this).data("user");
            var domain = $(this).data("domain");
            $(this).text(user + "@" + domain);
        });
    }).fail(function() {
        $container.html("<p>Error loading data.</p>");
    });

	//Shows the element defined by the data attribute, then hides itself.
	$("#result-container").on("click", ".action-show", function() {
//	$(".action-show").click(function() {
		var id = $(this).data("elementId");
		$("."+ id).show();
		$(this).hide();
		return false; //to avoid href action
	});

	//Hides the element defined by the data attribute, then restores the corresponding link to show details.
	$("#result-container").on("click", ".action-hide", function() {
//	$(".action-hide").click(function() {
		var id = $(this).data("elementId");
		$("."+ id).hide();
		$("a.action-show."+ id).show();
		return false; //to avoid href action
	});

//    $.ajax({
//        type: "GET",
//        url: "resume.xml",
//        dataType: "xml",
//        success: function(xml) {
//            // 'xml' is now a parsed XML Document object
//            // You can use to find data
//
////            var title = $(xml).find("yourTagName").text();
//            console.log("Data loaded:", xml);
//        },
//        error: function() {
//            alert("The XML file could not be loaded.");
//        }
//    });


});