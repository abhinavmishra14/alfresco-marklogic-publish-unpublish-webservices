alfresco-marklogic-publish-unpublish-webservices
================================================

A generic rest web service which can handle publish and unpublish requests from alfresco publishing channel.

#Steps to use MarkLogic REST API.

1- Chekout/download the REST API from 

   Git Repository: https://github.com/abhinavmishra14/alfresco-marklogic-publish-unpublish-webservices.git
   
   Download: https://github.com/abhinavmishra14/alfresco-marklogic-publish-unpublish-webservices
  
  
2- Create a database named as "alfresco-pub".

3- Create a forest named as "alfresco-pub-forest"

4- Attach the "alfresco-pub-forest" with "alfresco-pub" database.

5- Create a role named as "alfresco-publisher" and assign following 'Execute Privileges' to the alfresco-publisher role under 'Execute Privileges' section.
  
   a- admin-module-read
   
   b- admin-module-write
   
   c- any-collection
   
   d- xdmp:add-response-header
   
   e- xdmp:eval
   
   f- xdmp:document-get
   
   g- any-uri
   
   h- xdmp:get-session-field
   
   i- xdmp:http-delete, xdmp:http-get , xdmp:http-head , xdmp:http-post , xdmp:http-put , xdmp:http-options
   
   j- xdmp:invoke
     
   
6- Save the role.

7- Assign following permissions to 'alfresco-publisher' role under 'default permissions' section.

   a- Select the role 'alfresco-publisher' and select 'update' from dropdown and save role.
   
   b- Select the role 'alfresco-publisher' and select 'insert' from dropdown and save role.
   
   c- Select the role 'alfresco-publisher' and select 'read' from dropdown and save role.
   
   d- Select the role 'alfresco-publisher' and select 'execute' from dropdown and save role.
   
8- Create a user as 'alfrescopub-admin' and assign the 'alfresco-publisher' role to it and save the user.
   
9- Create a HTTP Server on Marklogic server, name it as 'Alfresco-Publishing-HTTP'.

10- Select port number as '8004' (must not be in use by any app. if in use you can put any port number. but same should be configured on Alfresco Publishing Channel.)

11- Under the root section provide the path of api which you have downloaded from above location.

    for example: If the download location is "d:\alfresco-marklogic-publish-unpublish-webservices"
    
                 Then add the path "d:\alfresco-marklogic-publish-unpublish-webservices" under root section.

12- Select the modules as 'file-system'.

13- Select the database as 'alfresco-pub' created at (step-2).

14- Select the authentication 'application-level'.

15- Select the default user 'alfrescopub-admin' created at (step-8).

16- Add the /url-rewriter.xqy inside the url rewriter section.

17- Click 'OK' to save the changes on HTTP Server.

Your REST services are ready for use.

For publish uri should be : http://127.0.0.1/alfrescopub/publish?uri=someuri
for unpublish uri should be : http://127.0.0.1/alfrescopub/unpublish?uri=someuri


