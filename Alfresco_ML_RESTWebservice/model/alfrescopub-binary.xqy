xquery version "1.0-ml";

(:
: Module Name: Alfrescopub binary model.
:
: Module Version: 1.0
:
: Date: 11/05/2014
:
: Module Overview: This library module will be used for publishing the binary content from Alfresco to ML. 
:)

(:~
: This module will be used to publish binary content.
:
: @author Abhinav Kumar Mishra 
: @since May 10, 2014
: @version 1.0
:)
module namespace alfrescopub = "http://example.com/alfresco/model/alfrescopub-binary";

(:~
 : Publish Binary Content
 :
 : @param $params - the $params as parameters for publishing
 : @return - empty sequence ()
 :)
declare function alfrescopub:publish($uri as xs:string,$node-to-publish){
    xdmp:document-insert($uri,$node-to-publish,xdmp:default-permissions(),"http://example.com/alfresco/publishedcontent-binary")
};