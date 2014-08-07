xquery version "1.0-ml";

(:
 : Module Name: Alfrescopub re-writer.
 :
 : Module Version: 1.0
 :
 : Date: 10/05/2014
 :
 : Copyright (c) 2013-2014 Abhinav Kumar Mishra. All rights reserved.
 :
 : Module Overview: This main module will be used for processing requests coming from alfresco or any application.
 :)

(:~
 : This module will be used used for processing requests coming from alfresco or any application.
 :
 : @author Abhinav Kumar Mishra 
 : @since May 10, 2014
 : @version 1.0
 :)

(:~
 : Gets the request body type.
 :
 : @param $request-body  - the $request-body  xdmp:get-request-body()
 : @return - string
 :)
declare function local:get-request-bodytype($request-body) as xs:string {
    let $body-type := 
		if(fn:exists($request-body)) 
		then 
		  typeswitch($request-body/node())
			  case binary() return "binary"
			  case element() return "element"
			  case text() return "text"
			  default return ""
		else ""
	return $body-type
};

(:~
 : Module exists
 :
 : @param $uri - the $uri as uri of module
 : @return - boolean
 :)
declare function local:module-exists($uri as xs:string) as xs:boolean {
	if (xdmp:modules-database()) then
		xdmp:eval(fn:concat('fn:doc-available("', $uri, '")'), (),
			<options xmlns="xdmp:eval">
				<database>{xdmp:modules-database()}</database>
			</options>
		)
	else
		xdmp:uri-is-file($uri)
};

(:~
 : Gets the controller URI
 :
 : @param $controller-name - the $controller-name as name of requested controller
 : @return - URI
 :)
declare function local:get-controller-uri($controller-name as xs:string,$content-type as xs:string) as xs:string {
    if($content-type eq "binary") then (
	  fn:concat("/controller/", $controller-name,"-",$content-type,"-controller.xqy")
	) else (
	  fn:concat("/controller/", $controller-name,"-controller.xqy")
	)
};


let $request-url := xdmp:get-request-url()
let $request-path := xdmp:get-request-path()
let $query := if (fn:contains($request-url, "?")) then fn:substring-after($request-url, "?") else ()

let $_log := xdmp:log(fn:concat("Request URL: ",$request-url),"debug")

return if($request-url) then(
			let $request-paths := fn:tokenize($request-path,"/")
			let $controller-name  := $request-paths[2]
			let $content-type := local:get-request-bodytype(xdmp:get-request-body())
			let $controller-uri := local:get-controller-uri($controller-name,$content-type)
			let $controller-exists := local:module-exists($controller-uri)
			return (
			  xdmp:log(text{"Alfresco Publishing Controller:", $controller-uri, " Exists: ", $controller-exists}, "info"),
			  if ($controller-exists) then
				 let $action := $request-paths[3]
				 let $new-url :=
					fn:string-join((
						"/front-controller.xqy?controller=", $controller-name,
						if ($action) then ("&amp;action=",$action) else (), 
						if ($query) then ("&amp;",$query) else ()
					),'')
				 return $new-url
				 else( $request-url )
		   )
	   )
	   else(
			/default.xqy
	   )