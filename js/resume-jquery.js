$(document).ready(function() {

    $.ajax({
        type: "GET",
        url: "resume.xml",
        dataType: "xml",
        success: function(xml) {
            const $xml = $(xml);
            renderHeader($xml);
            renderProfile($xml);
            renderSkills($xml);
            renderWorkHistory($xml);
            renderEducation($xml);
            renderFooter($xml);
        }
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

function renderHeader($xml) {
    const $header = $("#header-container");
    const $resume = $xml.find("resume")

    // 1. Set Name and Title from root attributes using new header-name class
    $header.find(".header-name").text($resume.attr("name"));
    $header.find(".header-title").text($resume.attr("title"));

    // 2. Process Contact List
    const $contactItems = $header.find(".contact-items");
    $contactItems.empty();

    $resume.find("contact-list contact").each(function() {
        const type = $(this).attr("type");
        const val = $(this).attr("value");

        const $span = $("<span>").html(`<b>${type}: </b>`);

        if (val && val.startsWith("http")) {
            $span.append(formatURL(val, val));
        } else {
            $span.append(document.createTextNode(val));
        }

        $span.append("<br/>");
        $contactItems.append($span);
    });

    // 3. Email Logic
    const user = $resume.attr("email");
    const domain = $resume.attr("domain");

    if (user && domain) {
        const $emailSpan = $header.find(".email");
        $emailSpan.attr("data-user", user);
        $emailSpan.attr("data-domain", domain);
        $emailSpan.text(user +"@"+ domain);
    }
}

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
    // 1. Process Main History
    processCompanies($xml.find("work-history > company"), $("#main-work"));

    // 2. Process More History
    const $moreNodes = $xml.find("work-history-more > company");
    if ($moreNodes.length > 0) {
        $("#more-work-section").show();
        processCompanies($moreNodes, $("#work-history-more .more-content"));
    }
}

function processCompanies($nodes, $container) {
    $nodes.each(function() {
        const $comp = $(this);
        const $c = $("#company-template").clone().removeAttr('id');

        // Setup Company Header
        let head = formatURL($comp.attr("url"), $comp.attr("name"));
        if ($comp.attr("department")) head += `, ${$comp.attr("department")}`;
        $c.find(".comp-header").html(head);
        $c.find(".comp-pos").text($comp.attr("position"));
        $c.find(".comp-date").text(`${$comp.attr("startDate")} - ${$comp.attr("endDate")}`);

        // Process Assignments
        $comp.find("assignment").each(function() {
            const $asgn = $(this);
            const $a = $("#assignment-template").clone().removeAttr('id');
            const aid = $asgn.attr("id");
            const detailsId = aid + "-details";
            const $descDiv = $a.find(".asgn-desc");

            // Header & Env/Tools
            let head = formatURL($asgn.attr("url"), $asgn.attr("name"));
            if ($asgn.attr("department")) head += `, ${$asgn.attr("department")}`;
            $a.find(".asgn-header").html(head);
            $a.find(".env-val").text($asgn.find("assignment-environment").text().trim());
            $a.find(".tools-val").text($asgn.find("assignment-tools").text().trim());
            $descDiv.find(".desc-text").html($asgn.find("assignment-description").html());

            // Details Toggle Logic
            const $details = $asgn.find("assignment-details");
            if ($details.length > 0) {
                // Configure Show link
                $a.find(".action-show")
                  .addClass(detailsId)
                  .data("elementId", detailsId)
                  .show();

                // Configure Details Body
                const $body = $a.find(".details-body").addClass(detailsId);
                $details.find("detail").each(function() {
                    $body.find(".details-content").append($('<div class="level3">').html($(this).html()));
                });

                // Configure Hide link
                $body.find(".action-hide").data("elementId", detailsId);
            }

            $c.find(".assignments-container").append($a);
        });

        $container.append($c);
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

function renderFooter($xml) {
    const resume = $xml.find("resume")
    const rawDate = resume.attr("updated") || ""; // "$Date: 2025/05/04 $"

    // JS equivalent of substring-after(':') and substring-before('$')
    let cleanDate = "";
    if (rawDate.includes(":") && rawDate.includes("$")) {
        cleanDate = rawDate.split(":")[1].split("$")[0].trim();
    } else {
        cleanDate = rawDate; // Fallback if format is different
    }

    $("#footer .last-modified").text(cleanDate);
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
