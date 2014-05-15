xquery version "1.0-ml";

(:
: Module Name: Alfrescopub model.
:
: Module Version: 1.0
:
: Date: 11/05/2014
:
: Module Overview: This library module will be used for publishing and unpublishing the content from Alfresco to ML. 
:)

(:~
: This module will be used to publish and unpublish content.
:
: @author Abhinav Kumar Mishra 
: @since May 10, 2014
: @version 1.0
:)
module namespace alfrescopub = "http://example.com/alfresco/model/alfrescopub";

(:~
 : Publish content
 :
 : @param $params - the $params as parameters for publishing
 : @return - empty sequence ()
 :)
declare function alfrescopub:publish($uri as xs:string,$node-to-publish){
    xdmp:document-insert($uri,$node-to-publish,xdmp:default-permissions(),"http://example.com/alfresco/publishedcontent")
};

(:~
 : UnPublish content
 :
 : @param $params - the $params as parameters for unpublishing
 : @return - empty sequence () and response code 200
 : @throws - XDMP-DOCNOTFOUND exception if the document not found for the given uri
 :)
declare function alfrescopub:unpublish($uri as xs:string){
    xdmp:document-delete($uri)
};