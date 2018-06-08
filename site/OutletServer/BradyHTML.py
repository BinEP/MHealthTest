


class Tag() :

	def __init__(self, tagName) :
		self.tag = tagName
		self.attr = {}
		self.elems = []
		self.style = {}


	def string(self) :

		# For plaintext stuff
		if self.tag == "string" :
			return self.attr["text"][0]

		html = ""


		html += "<" + self.tag + " "

		# Style

		if(self.style) :
			html += "style=\""
			for key, val in self.style.items() :
				html += key + ": " + val + ";"

			html += "\""

		# Others
		# print "self attr" + str(self.attr)
		for (key, values) in self.attr.items() :
			html += key + "=\""

			# print "VALUES: " + str(values)
			html += " ".join(values)
			html += "\" "

		html += ">"

		# print "HTML THINGS\n\n\n\n\n\n" + html


		for elem in self.elems :
			ht1 = elem.string()
			html += ht1

		html += "</" + self.tag + ">"


		return html


	def addElem(self, elem) :
		self.elems.append(elem)

	def addAttr(self, name, val) :
		if name in self.attr :
			self.attr[name].append(str(val))
		else :
			self.attr[name] = [str(val)]

	def addStyle(self, prop, val) :
		self.style[prop] = str(val)


	def getAllAttr(self) :
		# Because I'm lazy and if I want to mess with stuff, I'll do it manually
		return self.attr

	def getAllElem(self) :
		# Because I'm lazy and if I want to mess with stuff, I'll do it manually
		return self.elems

	def getAllStyle(self) :
		return self.style





# print "testing"

# html = Tag("html")
# head = Tag("head")
# body = Tag("Body")
# div1 = Tag("div")
# div2 = Tag("div")

# div1.addElement(div2)

# div3 = Tag("div")
# div4 = Tag("div")
# div3.addElement(div4)

# body.addElement(div1)
# body.addElement(div3)

# html.addElement(head)
# html.addElement(body)

# print html.string()
