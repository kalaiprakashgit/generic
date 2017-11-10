import os
import xml.etree.ElementTree as et
import sys
myfile = sys.argv[1]
###base_path = os.path.dirname(os.path.realpath(__file__))
base_path = os.path.join('/home/sarsat02/', 'xml_files')
#print('base_path is:')
#print(base_path)

myxml_file = os.path.join(base_path, sys.argv[1])
#print('myxml_file is:')
#print(myxml_file)


tree = et.parse(myxml_file)
#print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
#print(myxml_file)

#print(1)

#tree = et.parse(myfile)

root = tree.getroot()

print('DS Code: ')
#############################################################################

for customfield in root.getiterator('customfield'):
              for child in customfield.getiterator('customfieldvalue'):
                             #print customfield.attrib
                             if 'customfield_10410' in str(customfield.attrib):
                                           #print customfield.attrib
                                           print child.text.replace("<br/>", "")
              
                                           break
                             else:
                                           continue
                             break
################################################################################
print('Environment Variables: ')

print('Linux Files:')

for customfield in root.getiterator('customfield'):
              for child in customfield.getiterator('customfieldvalue'):
                             #print customfield.attrib
                             if 'customfield_10411' in str(customfield.attrib):
                                           #print customfield.attrib
                                           print child.text.replace("<br/>", "")
              
                                           break
                             else:
                                           continue
                             break
print('Shared Job:')

for customfield in root.getiterator('customfield'):
              for child in customfield.getiterator('customfieldvalue'):
                             #print customfield.attrib
                             if 'customfield_10412' in str(customfield.attrib):
                                           #print customfield.attrib
                                           print child.text.replace("<br/>", "")
              
                                           break
                             else:
                                           continue
                             break

