xquery version "1.0-ml";

(:
: Module Name: Search contorller.
:
: Module Version: 1.0
:
: Date: 10/05/2014
:
: Copyright (c) 2013-2014 Abhinav Kumar Mishra. All rights reserved.
:
: Module Overview: This library module will be used for searching the content published from Alfresco to ML. 
:)

(:~
: This module will be used to search the content published from Alfresco to ML
:
: @author Abhinav Kumar Mishra
: @since May 10, 2014
: @version 1.0
:)
module namespace search = "http://example.com/alfresco/controller/search";
import module namespace uit = "http://www.marklogic.com/ps/lib/lib-uitools" at "../lib/lib-uitools.xqy";
import module namespace search-mdl = "http://example.com/alfresco/model/search" at "/model/search.xqy";
import module namespace util = "http://example.com/controller-util" at "/controller/controller-util.xqy";


(:~
: Search 
:
: @param $params as list of parameters for search
: @return search result
:)
declare function search:search($params as element(uit:params)){
	search-mdl:search(util:required-param($params/uit:query, 'query'),$params/uit:start,$params/uit:page-length)
};