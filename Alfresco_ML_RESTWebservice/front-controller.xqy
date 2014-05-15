xquery version "1.0-ml";

(:
: Module Name: Front Controller.
:
: Module Version: 1.0
:
: Date: 11/05/2014
:
: Module Overview: This main module will be used for handling requests such as publish/unpublish coming from alfresco or any application
:)

(:~
: This module will be used for handling requests such as publish/unpublish coming from alfresco or any application
:
: @author Abhinav Kumar Mishra 
: @since May 10, 2014
: @version 1.0
:)
import module namespace uit = "http://www.marklogic.com/ps/lib/lib-uitools" at "/lib/lib-uitools.xqy";

declare namespace ctl = "http://example.com/alfresco";
declare namespace htm = "http://www.w3.org/1999/xhtml";
declare namespace error = "http://marklogic.com/xdmp/error";

(:~ Convert error into html page or as simple element :)
declare variable $ctl:REPORT-HTML-ERRORS as xs:boolean := fn:true();

declare option xdmp:mapping "false";

(:~
: Handle formatting the error message as html or as element(error)
:
: @param $response-code - the response code
: @param $title - the title
: @param $response-text - the response text
: @return element containing error
:)
declare function ctl:report-error($response-code as xs:integer, $title as xs:string, $response-text as xs:string) as element()
{
  if ($ctl:REPORT-HTML-ERRORS) then
    ctl:html-wrapper($response-code, $title, $response-text)
  else
    <error code="{$response-code}" title="{$title}">{$response-text}</error>
};

(:~
: Wrap the specified string in html for friendly message display.
:
: @param $response-code - the response code
: @param $title - the title
: @param $response-text - the response text
: @return element(htm:html) An element(htm:html) containing the html response.
:)
declare function ctl:html-wrapper($response-code as xs:integer, $title as xs:string, $response-text as xs:string) as element()
{
  xdmp:add-response-header("Content-Type", "text/html"),
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head><title>HTTP {$response-code}{' '}{$title}</title></head>
    <body>
		<h3>{$response-code}{' '}{$title}</h3>
		<p>{$response-text}</p>
	</body>
  </html>
};


(:~
: Sets the cache headers
:
:)
declare function ctl:set-cache-headers()
{
  xdmp:add-response-header("Last-Modified", fn:string(fn:current-dateTime())),
  xdmp:add-response-header("Cache-Control", "no-cache"),
  xdmp:add-response-header("Pragma", "no-cache"),
  xdmp:add-response-header("Expires", "-1")
};

(:~
: Executes a named controller using REST methods interface
:
: @param $params - the params to process in the request
: @return result from the invoked controller
:)
declare function ctl:get-controller($params as element(uit:params))
{
   let $controller as xs:string := $params/uit:controller
   let $action as xs:string  := ($params/uit:action, "main")[1]
   let $runme := 
        fn:concat(
          ' xquery version "1.0-ml";
            import module namespace controller = "http://example.com/alfresco/controller/', $controller,'"',
          ' at "/controller/', $controller,'-controller.xqy";',
          ' declare namespace uit = "http://www.marklogic.com/ps/lib/lib-uitools";',
          ' declare variable $params as element(uit:params) external;',
          ' controller:',$action, '($params)'
        )
   return 
      try
        {
         xdmp:eval($runme,
            (xs:QName("params"),$params),
               <options xmlns="xdmp:eval">
                 <isolation>different-transaction</isolation>
                 <prevent-deadlocks>true</prevent-deadlocks>
               </options>
             )
        }
        catch($ex)
        {
            xdmp:log(fn:concat("Exception at ctl:get-controller function : " ,  $ex/error:message) , "error"),
			
			if ($ex/error:code = "XDMP-UNDFUN") then
				ctl:report-error(501, "Unsupported action", fn:concat("Action ", $params/uit:action, " is not supported"))
			else
			
			if ($ex/error:name eq "MISSINGPARAM") then
				ctl:report-error(404, "Missing param", $ex/error:message)
			else
			if ($ex/error:name eq "NOTFOUND") then
				ctl:report-error(404, "Not found", $ex/error:message)
			else (
				ctl:report-error(500, "Unexpected error", $ex/error:message),
				xdmp:rethrow()
			)
        }
};

(:~
: Executes a named controller using REST methods interface
:
: @param $params - the params to process in the request
: @param $binary-content - the binary content
: @return result from the invoked controller
:)
declare function ctl:get-binary-controller($params as element(uit:params),$binary-content,$content-type as xs:string)
{
   let $controller as xs:string := $params/uit:controller
   let $action as xs:string  := ($params/uit:action, "main")[1]
   let $runme := 
        fn:concat(
          ' xquery version "1.0-ml";
            import module namespace controller = "http://example.com/alfresco/controller/',$controller,'-',$content-type,'"',
          ' at "/controller/', $controller,'-',$content-type,'-controller.xqy";',
          ' declare namespace uit = "http://www.marklogic.com/ps/lib/lib-uitools";',
          ' declare variable $params as element(uit:params) external;',
		  ' declare variable $binary-content external;',
          ' controller:',$action, '($params,$binary-content)'
        )
   return 
      try
        {
         xdmp:eval($runme,
            (xs:QName("params"),$params,xs:QName("binary-content"),$binary-content),
               <options xmlns="xdmp:eval">
                 <isolation>different-transaction</isolation>
                 <prevent-deadlocks>true</prevent-deadlocks>
               </options>
             )
        }
        catch($ex)
        {
            xdmp:log(fn:concat("Exception at ctl:get-binary-controller function : " ,  $ex/error:message) , "error"),
			
			if ($ex/error:code = "XDMP-UNDFUN") then
				ctl:report-error(501, "Unsupported action", fn:concat("Action ", $params/uit:action, " is not supported"))
			else
			
			if ($ex/error:name eq "MISSINGPARAM") then
				ctl:report-error(404, "Missing param", $ex/error:message)
			else
			if ($ex/error:name eq "NOTFOUND") then
				ctl:report-error(404, "Not found", $ex/error:message)
			else (
				ctl:report-error(500, "Unexpected error", $ex/error:message),
				xdmp:rethrow()
			)
        }
};

(:~
 : Controller exists
 :
 : @param $uri - the $uri as uri of module
 : @return - boolean
 :)
declare function ctl:controller-exists($controller-uri as xs:string) as xs:boolean {
	if (xdmp:modules-database()) then
		xdmp:eval(fn:concat('fn:doc-available("', $controller-uri, '")'), (),
			<options xmlns="xdmp:eval">
				<database>{xdmp:modules-database()}</database>
			</options>
		)
	else
		xdmp:uri-is-file($controller-uri)
};

(:~
 : Gets the request body type.
 :
 : @param $request-body  - the $request-body  xdmp:get-request-body()
 : @return - string
 :)
declare function ctl:get-request-bodytype($request-body ) as xs:string {
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

let $params := uit:load-params()
let $controller := $params/uit:controller
let $body := xdmp:get-request-body()
let $content-type:= ctl:get-request-bodytype($body)
return (
	if ($content-type eq "binary") then (
		(:Handle the binary contents:)
		let $exists := ctl:controller-exists(fn:concat("/controller/", $controller ,"-",$content-type,"-controller.xqy"))
		return 
		  if($controller and $exists) then (
		    (:Delegate request to binary content controller:)
			 ctl:get-binary-controller($params,$body,$content-type)
		  )
		  else ()
	) else (
		let $exists := ctl:controller-exists(fn:concat("/controller/", $controller ,"-controller.xqy"))
		return 
		  if($controller and $exists) then
			let $controller-result := ctl:get-controller($params)
			return
			  (:Call the view if controller result it element:)
			  if($controller-result instance of element()) then (
				(:Configure your view layer here, call the view controller and pass the result to be processed via view controller:)
				(:TODO- Return the $controller-result for now :)
				$controller-result
			  ) else (
				$controller-result
			  )
		  else ()
	)
)