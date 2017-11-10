#!/usr/bin/env bash

           # Base URL of TeamForge site.
           site_url="https://test.net"

           # TeamForge authentication credentials.
           username="AdminID"
           password="XXXXXXXXX"

           # Requested scope (all)
           scope="urn:ctf:services:ctf urn:ctf:services:svn urn:ctf:services:gerrit urn:ctf:services:soap60"

           curl -d "grant_type=password&client_id=api-client&scope=$scope&username=$username&password=$password" $site_url/oauth/auth/token > token.txt
           token=`cat token.txt | cut -d "," -f1 | cut -d ":" -f2 | sed -e 's/^"//' -e 's/"$//'`
           echo $token

curl -X GET -H  'Accept: application/json' -H "Authorization: Bearer $token" 'https://test.net/ctfrest/foundation/v1/projects?sortby=dateCreated&fetchHierarchyPath=false&offset=0&count=1000' > LIST_OF_TF_PROJECTS_RO-COLLABNET.json

./pharse_tf_projlist.py >> /home/jenadmin/projid_mapping.csv

