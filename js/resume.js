$(document).ready(function() {

    $.ajax({
        type: "GET",
        url: "resume.xml",
        dataType: "xml",
        success: function(xml) {
            const $xml = $(xml);
            renderProfile($xml);
            renderSkills($xml);
            renderWorkHistory($xml);
            renderEducation($xml);
        }
    });

	//Set the email text based on the data attributes.
	$(document).find('.email').each (function() {
		var user = $(this).data("user");
		var domain = $(this).data("domain");
		$(this).text(user +"@"+ domain);
	});
	
	//Shows the element defined by the data attribute, then hides itself.
	$("#result-container").on("click", ".action-show", function() {
		var id = $(this).data("elementId");
		$("."+ id).show();
		$(this).hide();
		return false; //to avoid href action
	});

	//Hides the element defined by the data attribute, then restores the corresponding link to show details.
	$("#result-container").on("click", ".action-hide", function() {
		var id = $(this).data("elementId");
		$("."+ id).hide();
		$("a.action-show."+ id).show();
		return false; //to avoid href action
	});
});

function renderProfile($xml) {
    const $list = $("#profile-container .client");
    // Find our template and keep a reference to it
    const $template = $list.find("li.profile-entry").first();

    $xml.find("profile entry").each(function() {
        const entryText = $(this).text().trim();

        if (entryText) {
            // 1. Clone the template
            const $newEntry = $template.clone();

            // 2. Set the text and remove the 'display:none' style
            $newEntry.text(entryText).show();

            // 3. Append it to the list
            $list.append($newEntry);
        }
    });
}

function renderSkills($xml) {
    const $table = $("#skills-container table");
    const $rowTemplate = $table.find(".skill-row");

    $xml.find("skill-list skill").each(function() {
        const $skill = $(this);
        const id = $skill.attr("id");
        const type = $skill.find("type").text().trim();

        // Clone the row
        const $row = $rowTemplate.clone().show();
        $row.find(".skill-type").text(type);
        const $content = $row.find(".skill-content");

        // Process top-level 'value' tags (not inside skill-details)
        $skill.children("value").each(function() {
            $content.append(formatDetail($(this)));
        });

        // 3. Process 'skill-details'
        $skill.find("skill-details").each(function() {
            const $details = $(this);

            // Render main-details (always visible)
            $details.find("main-detail").each(function() {
                $content.append(formatDetail($(this)));
            });

            // Render "More details" toggle section
            const $moreDetails = $("#more-details-template").clone().children();
            const detailsId = id + "-details";

            // Setup Show Link
            $moreDetails.filter(".action-show")
                .addClass(detailsId)
                .attr("data-element-id", detailsId);

            // Setup Hidden Body
            const $body = $moreDetails.filter(".details-body")
                .addClass(detailsId)
                .attr("id", detailsId);

            $details.find("value").each(function() {
                $body.find(".details-content").append(formatDetail($(this)));
            });

            // Setup Hide Link
            $body.find(".action-hide").attr("data-element-id", detailsId);

            $content.append($moreDetails);
        });

        $table.append($row);
    });
}

/**
 * Helper to handle description attributes and embedded HTML
 */
function formatDetail($node) {
    const desc = $node.attr("description");
    const htmlContent = $node.html().trim(); // preserves <a> tags
    const $item = $("#detail-template").clone().children();
    const prefix = desc ? "<b>" + desc + ":</b> " : "";
    return prefix + htmlContent + "<br/>";
}

function renderWorkHistory($xml) {
    processCompanyNodes($xml.find("work-history > company"), $("#main-work"));
    const $more = $xml.find("work-history-more > company");
    if ($more.length > 0) {
        $("#more-work-section").show();
        processCompanyNodes($more, $("#work-history-more"));
    }
}

function processCompanyNodes($nodes, $target) {
    $nodes.each(function() {
        const $comp = $(this);
        const $c = $("#company-template").clone().removeAttr('id');

        let head = formatURL($comp.attr("url"), $comp.attr("name"));
        if ($comp.attr("department")) head += `, ${$comp.attr("department")}`;
        $c.find(".comp-header").html(head);
        $c.find(".comp-pos").text($comp.attr("position"));
        $c.find(".comp-date").text(`${$comp.attr("startDate")} - ${$comp.attr("endDate")}`);

        $comp.find("assignment").each(function() {
            const $a = $("#assignment-template").clone().removeAttr('id');
            const aid = $(this).attr("id");
            let aHead = formatURL($(this).attr("url"), $(this).attr("name"));
            if ($(this).attr("department")) aHead += `, ${$(this).attr("department")}`;

            $a.find(".asgn-header").html(aHead);
            $a.find(".env-val").text($(this).find("assignment-environment").text().trim());
            $a.find(".tools-val").text($(this).find("assignment-tools").text().trim());

            const $desc = $a.find(".asgn-desc").html($(this).find("assignment-description").html());
            const $details = $(this).find("assignment-details");
            if ($details.length > 0) {
                const did = aid + "-details";
                $desc.append(` <a href="#" class="action-show" data-element-id="${did}">More details</a>`);
                const $box = $a.find(".asgn-details-box").attr("id", did).addClass(did);
                $details.find("detail").each(function() {
                    $box.append($('<div class="level3">').html($(this).html()));
                });
                $box.append(`<div class="level3"><a href="#" class="action-hide" data-element-id="${did}">Hide details</a></div>`);
            }
            $c.find(".assignments-container").append($a);
        });
        $target.append($c);
    });
}

function renderEducation($xml) {
    const $target = $("#education-container .education-list");
    $xml.find("education degree").each(function() {
        const $e = $("#edu-template").clone().removeAttr('id');
        $e.find(".edu-school").html(formatURL($(this).attr("url"), $(this).attr("school")));
        $e.find(".edu-award").text($(this).attr("award") + ($(this).attr("year") ? `, ${$(this).attr("year")}` : ""));
        $e.find(".edu-desc").text($(this).text().trim());
        $target.append($e);
    });
}

function formatDetailNode($node) {
    const desc = $node.attr("description");
    const prefix = desc ? `<b>${desc}:</b> ` : "";
    return $(`<div class="detail-line">${prefix}${$node.html()}</div>`);
}

function formatURL(url, name) {
    if (!url) return name || "";
    return `<a href="${url.startsWith('http') ? url : 'http://'+url}" target="_blank">${name || url}</a>`;
}
