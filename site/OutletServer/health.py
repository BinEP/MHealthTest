from flask import Flask
from BradyHTML import Tag
import dataEntrySQL as sql

app = Flask(__name__, static_url_path="/static", static_folder='static')

# app = Flask(__name__)

fontSize = 60

@app.route('/')
def page() :


	html = """<!doctype html>

	<html>

	<head>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<link rel="stylesheet" href="/static/health.css" type="text/css">
		<script type="text/javascript" src="/static/health.js"></script>
	</head>

	<body onload="cssThings();">
		<div class=".container-fluid">	
			<h1>My First Bootstrap Page</h1>
			<p>This is some text.</p>
			ggg
			<p>step 1	</p>

	"""

	# <ul class="nav nav-tabs" role="tablist">
	listOfTabs = Tag("ul")
	listOfTabs.addAttr("class", "nav nav-tabs")
	listOfTabs.addAttr("role", "tablist")
	listOfTabs.addAttr("id", "navList")

	contentDiv = Tag("div")
	contentDiv.addAttr("class", "tab-content")

	surgeryID = 2
	db = sql.Database()
	# (id, name)
	stages = sql.getStages(surgeryID, db) 

	first = True



	# Timestamp all the events of when it was clicked off

	# <li class="nav-item"><a href="#tab-stage1" class="nav-link active" data-toggle="tab" role="tab">Stage 1</a>
	for (ident, surgID, name, i) in stages :
		listElem = Tag("li")
		listElem.addAttr("class", "nav-item")
		elemLink = Tag("a")
		elemLink.addAttr("href", "#tab-stage" + str(i))
		elemLink.addAttr("class", "nav-link")
		if first :
			elemLink.addAttr("class", "active")
		else :
			elemLink.addAttr("class", "disabled")
			# None


		elemLink.addAttr("data-toggle", "tab")
		elemLink.addAttr("role", "tab")

		textTag = Tag("string")
		textTag.addAttr("text", "Stage " + str(i))

		# Putting it together
		elemLink.addElem(textTag)
		listElem.addElem(elemLink)
		listOfTabs.addElem(listElem)





		# Now for the list of content divs, just a list, won't add to stuff yet

		# <div class="tab-pane fade show active" role="tabpanel" id="tab-stage1">
		stageDiv = Tag("div")
		stageDiv.addAttr("data-stage", i)
		stageDiv.addAttr("class", "tab-pane fade")
		if first :
			stageDiv.addAttr("class", "show active")

		stageDiv.addAttr("role", "tabpanel")
		stageDiv.addAttr("id", "tab-stage" + str(i))


		textTag = Tag("string")
		textTag.addAttr("text", name)
		textTag.addStyle("font-size", str(fontSize) + "px")

		stageDiv.addElem(textTag)


		# <div data-stage="1" data-step="1" class="row steps" onclick="toggleDone(this)"> &nbsp;&nbsp;&nbsp;&nbsp;<p>step 1 stage 1	</p> </div>
		steps = sql.getSteps(ident, db)
		for (stepIdent, surgID, stageID, roleID, stepText, stepNum) in steps :
			
			
			stepDiv = Tag("div")
			stepDiv.addAttr("data-stage", i)
			stepDiv.addAttr("data-step", stepNum)
			stepDiv.addAttr("data-done", "0")
			stepDiv.addAttr("class", "row steps")
			stepDiv.addAttr("onclick", "toggleDone(this)")
			stepDiv.addStyle("font-size", str(fontSize) + "px")
			
			# <p>step 1 stage 1	</p>
			stepP = Tag("p")
			stepTextString = Tag("string")
			# textThing1.addAttr("text", "step " + str(stepNum) + " stage " + str(i))
			stepTextString.addAttr("text", stepText)

			stepP.addElem(stepTextString)

			textThing2 = Tag("string")
			textThing2.addAttr("text", "&nbsp;&nbsp;&nbsp;&nbsp;")

			stepDiv.addElem(textThing2)
			stepDiv.addElem(stepP)

			stageDiv.addElem(stepDiv)

		contentDiv.addElem(stageDiv)


			



		first = False

	containerDiv = Tag("div")
	containerDiv.addAttr("class", ".container-fluid stages")

	containerDiv.addElem(listOfTabs)
	containerDiv.addElem(contentDiv)


	html += containerDiv.string()

	html += '<br><br><button type="button" class="btn btn-primary">Download Data</button>'

	html += """<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
	</body></html>"""


	print "things"
	

	return html



























