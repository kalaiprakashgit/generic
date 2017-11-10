#!/usr/local/bin/python3.6
'''
	Parsing Json output to get Project Name from the json file.
'''
import json
#jsonFileToParse = 'List_Of_TeamForge_Projects.json'
jsonFileToParse = 'LIST_OF_TF_PROJECTS_RO-COLLABNET.json'

readFile = open(jsonFileToParse) 	#'r' makes the filehandler be in a read format

theJSON = json.load(readFile)

counter = 0
otherCount = 1
while True: #Run Forever until exception
	###########
	try:
            #print((theJSON['items'][counter]['id']),',',(theJSON['items'][counter]['title'])) 
            print(str(theJSON['items'][counter]['id'])+','+ str(theJSON['items'][counter]['title'])) 
	except IndexError as inderr:
		break
	except Exception as genExec:
		print('General Exception: ', genExec)
	#############
	counter+=1
	otherCount+=1
