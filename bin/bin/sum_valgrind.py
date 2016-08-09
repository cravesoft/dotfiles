import sys
import re

###################################################################################################

def help():
	helpMsg = """-------------------------
Summarize the valgrind output
Usage :
1) Use valgrind : valgrind -v --leak-check=full --track-origins=yes --log-file=OUTPUT_FILENAME MY_PROGRAM
2) Summarize the output : python ToolsSummarizeValgrind.py OUTPUT_FILENAME
-------------------------"""
	return helpMsg

###################################################################################################

possibleErrors=dict()
possibleErrors["Invalid read of size \S+"]="memory corruption"
possibleErrors["bytes in \S+ blocks are definitely lost"]="memory leak"
possibleErrors["Conditional jump or move depends on uninitialised value\(s\)"]="uninitialised value"
possibleErrors["bytes in \S+ blocks are possibly lost"]="possible memory leak"
possibleErrors["Uninitialised value was created by a (heap|stack) allocation"]="TO_BE_IGNORED"
possibleErrors["Address 0x\S+ is \S+ bytes (before|after) a block of size \S+ alloc'd"]="TO_BE_IGNORED"
otherErrorsGroupName="other issue"

criticityOrder = ["memory corruption", "memory leak", "uninitialised value", "possible memory leak", "other issue"]

###################################################################################################

class Error():
	def __init__(self, description, callStack):

		# remove some parts of the error description
		index=description.find("in loss record")
		self.description = list()
		if(index != -1):
			self.description.append(description[0:index])
		else:
			self.description.append(description)

		# get the error group
		self.group="other issue"
		for errorGroup in possibleErrors:
			if re.search(errorGroup, description):
				self.group=possibleErrors[errorGroup]
		self.callStack=callStack

		# find the lib name : try to find library_name_function, the lib name is the name before the underscore
		revertedCallStack = callStack[::-1]
		self.libname=""
		res=re.search("_(\S+)", revertedCallStack)
		if(res):
			self.libname=res.group(1)[::-1]

	def AddDescription(self, description):
		# when the same error occurs several times, add the description to the first error object
		self.description.append(description)

	def __str__(self):
		# print
		return "callStack : %s\ndetails : \n\t%s\n\t" % (self.callStack, "\n\t".join(self.description), )

###################################################################################################

def cleanLine(line):
	regres=re.match("==\d+==    (at|by) 0x[0-9A-F]+:\s+([^(]*)", line)
	if(regres):
		return(regres.group(1), regres.group(2))
	else:
		regres=re.match("==\d+==\s+(.*)", line)
		if(regres):
			return("text", regres.group(1))
		else:
			return("unknown", line)

###################################################################################################

def formatCallStack(f, firstLine):
	callStack = [firstLine]
	nbCallStack = 1
	(type_, line) = cleanLine(f.readline())
	while type_=="by":
		if(not line.startswith("???")) and (nbCallStack<5):
			callStack.append(line)
			nbCallStack += 1
		(type_, line) = cleanLine(f.readline())
	callStack.reverse()
	return ("/ ".join(callStack), line)

###################################################################################################

def summarize(filename):
	try:
		f = open(filename, "r")

		errors = {}
		previousLine=""
		line=f.readline()
		while(len(line)>0):
			(type_, line) = cleanLine(line)
			if type_ == "at":
				errorDescription = previousLine
				(callStack, line) = formatCallStack(f, line)
				error = Error(errorDescription, callStack)

				if error.group != "TO_BE_IGNORED":
					errorKey = "%s %s %s" % (error.group, error.libname, error.callStack)
					if errorKey in errors:
						errors[errorKey].AddDescription(error.description[0])
					else:
						errors[errorKey] = error

			previousLine=line
			line=f.readline()
		f.close()


		for group in criticityOrder:
			print "=================\n%s\n=================\n" % group
			for key in sorted(errors.iterkeys()):
				if key.startswith(group):
					print "%s\n" % errors[key]

	except IOError:
		print "********* ERROR *********\nFile not found : %s\n" % filename
		print help()

###################################################################################################

if __name__ == "__main__":
	if len(sys.argv)==2 and sys.argv[1]!="-h" and sys.argv[1]!="--help":
		summarize(sys.argv[1])
	else:
		print help()

###################################################################################################

