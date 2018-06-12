function toggleDone(elem) {
	var stage = elem.getAttribute("data-stage");
	var step = elem.getAttribute("data-step");
	var done = elem.getAttribute("data-done");

	console.log(done);

	if (done == "1") {
		elem.style.background = getComputedStyle(elem).getPropertyValue("--red");
		elem.setAttribute("data-done", "0");
	} else {
		elem.style.background = getComputedStyle(elem).getPropertyValue("--green");
		elem.setAttribute("data-done", "1");
	}
	

	// elem.classList.toggle("glyphicon glyphicon-ok");


	// alert("Stage: " + stage + "\tStep: " + step);

	openNext(elem);

}

function openNext(currentStepDiv) {


	// console.log("Open next");

	// console.log(currentStepDiv.parentNode);

	var children = currentStepDiv.parentNode.childNodes;
	var next = true;
	// console.log(children);


	for (i = 1; i < children.length; i++) { 
	    next = next && (children[i].getAttribute("data-done") == "1");
		// console.log(children[i]);
		// console.log(next);
	}
	

	if (next) {
		var nextDiv = currentStepDiv.parentNode.nextSibling.getAttribute("data-stage")
		// console.log(nextDiv);
		// console.log("should open");



		var nav = document.getElementById("navList");
		children = nav.childNodes;

		for (i = 1; i < children.length; i++) { 
			var child = children[i].firstChild
			if (child.getAttribute("href") == ("#tab-stage" + nextDiv)) {
				// console.log("THIS ONE");
				// console.log(child);
				console.log("Opening the next stage");

				alert("Did you actually di this?");
				child.classList.remove("disabled");
				return;
			}
		    
			// console.log(children[i].firstChild);
		}
	}


}