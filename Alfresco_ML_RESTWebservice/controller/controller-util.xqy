xquery version "1.0-ml";

(:
: Module Name: Controller UTIL.
:
: Module Version: 1.0
:
: Date: 11/05/2014
:
: Module Overview: This library module will be used for providing the utility methods to app. 
:)

(:~
: This module will be used for providing the utility methods to app. 
:
: @author Abhinav Kumar Mishra 
: @since May 10, 2014
: @version 1.0
:)
module namespace util = "http://example.com/controller-util";
declare namespace error = "http://marklogic.com/xdmp/error";
declare namespace uit = "http://www.marklogic.com/ps/lib/lib-uitools";

declare option xdmp:mapping "false";

(:~
: Check for required parameter
:
: @param $value as item()* Parameter value
: @param $param-name as xs:string Parameter name
: @return as item()* Value if it exists, else raise MISSINGPARAM error
:)
declare function util:required-param($value as item()*, $param-name as xs:string) as item()*
{
	if (fn:exists($value)) then
		$value
	else
		fn:error(xs:QName("MISSINGPARAM"), fn:concat("Required parameter '", $param-name, "' is missing"))
};

