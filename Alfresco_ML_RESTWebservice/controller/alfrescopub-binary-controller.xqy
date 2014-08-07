xquery version "1.0-ml";

(:
: Module Name: Alfrescopub binary contorller.
:
: Module Version: 1.0
:
: Date: 10/05/2014
:
: Copyright (c) 2013-2014 Abhinav Kumar Mishra. All rights reserved.
:
: Module Overview: This library module will be used for publishing and unpublishing the binary content from Alfresco to ML. 
:)

(:~
: This module will be used to publish and unpublish binary content.
:
: @author Abhinav Kumar Mishra 
: @since May 10, 2014
: @version 1.0
:)
module namespace alfrescopub-binary = "http://example.com/alfresco/controller/alfrescopub-binary";
import module namespace uit = "http://www.marklogic.com/ps/lib/lib-uitools" at "../lib/lib-uitools.xqy";
import module namespace util = "http://example.com/controller-util" at "/controller/controller-util.xqy";
import module namespace alfrescopub-binary-mdl = "http://example.com/alfresco/model/alfrescopub-binary" at "/model/alfrescopub-binary.xqy";

declare option xdmp:update "true";

(:~
 : Publish binary content
 :
 : @param $params - the $params as parameters for publishing
 : @return - empty sequence () and response code 204
 :)
declare function alfrescopub-binary:publish($params as element(uit:params),$binary-content){
	xdmp:log("Binary publishing invoked.. ","debug")
	,
	alfrescopub-binary-mdl:publish(util:required-param($params/uit:uri, 'uri'),$binary-content)
	,
	xdmp:set-response-code(204,"Document published successfully!")
};