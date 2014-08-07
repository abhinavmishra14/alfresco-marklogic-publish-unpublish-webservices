xquery version "1.0-ml";

(:
: Module Name: Alfrescopub contorller.
:
: Module Version: 1.0
:
: Date: 10/05/2014
:
: Copyright (c) 2013-2014 Abhinav Kumar Mishra. All rights reserved.
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
module namespace alfrescopub = "http://example.com/alfresco/controller/alfrescopub";
import module namespace uit = "http://www.marklogic.com/ps/lib/lib-uitools" at "../lib/lib-uitools.xqy";
import module namespace alfrescopub-mdl = "http://example.com/alfresco/model/alfrescopub" at "/model/alfrescopub.xqy";
import module namespace util = "http://example.com/controller-util" at "/controller/controller-util.xqy";

declare option xdmp:update "true";

(:~
 : Publish content
 :
 : @param $params - the $params as parameters for publishing
 : @return - empty sequence () and response code 204
 :)
declare function alfrescopub:publish($params as element(uit:params)){
	xdmp:log("Publishing invoked.. ","debug"),
	
	let $reqest-body := util:required-param($params/uit:request-body, 'request-body')
	let $request-body-type := fn:data($reqest-body/@type)
	let $_:= xdmp:log(fn:concat("MIME-TYPE-> ",$request-body-type),"debug")
	return (
	    if($request-body-type eq "text") then 
			alfrescopub-mdl:publish(util:required-param($params/uit:uri, 'uri'),$reqest-body/text())
		else 
			alfrescopub-mdl:publish(util:required-param($params/uit:uri, 'uri'),$reqest-body/element())
		,
		xdmp:set-response-code(204,"Document published successfully!")
	)
};

(:~
 : UnPublish content
 :
 : @param $params - the $params as parameters for unpublishing
 : @return - empty sequence () and response code 200
 :)
declare function alfrescopub:unpublish($params as element(uit:params)){
	xdmp:log("Un-publishing invoked.. ","debug")
	,
	alfrescopub-mdl:unpublish(util:required-param($params/uit:uri, 'uri'))
	,
	xdmp:set-response-code(200,"Document un-published successfully!")
};


(:~
 : Gets the content
 :
 : @param $params - the $params as parameters for getting the content
 : @return - node
 :)
declare function alfrescopub:get($params as element(uit:params)){
	alfrescopub-mdl:get(util:required-param($params/uit:id, 'id'))
};
