xquery version "1.0-ml";

(:
: Module Name: Search model.
:
: Module Version: 1.0
:
: Date: 10/05/2014
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
module namespace search-mdl = "http://example.com/alfresco/model/search";

import module namespace uit = "http://www.marklogic.com/ps/lib/lib-uitools" at "../lib/lib-uitools.xqy";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

(:~
: Search 
:
: @param $query as a query to be searched
: @param $start as a start of the page
: @param $page-length as a max number of results to return 
: @return search result
:)
declare function search-mdl:search($query as xs:string,$start as xs:int,$page-length as xs:int){
   search:search($query,search-mdl:options(),$start,$page-length)
};


(:~
: Search options 
:
: @return options as element for search
:)
declare function search-mdl:options(){
    <options xmlns="http://marklogic.com/appservices/search">
	 <return-metrics>true</return-metrics>
     <return-facets>true</return-facets>
	 <return-query>true</return-query>
	 <return-constraints>true</return-constraints>
	 <constraint name="category">
	   <range type="xs:string" facet="true" collation="http://marklogic.com/collation/" >
		<element  name="book"/>
		  <attribute  name="category"/>					
	   </range>
     </constraint> 
	  <constraint name="year">
	   <range type="xs:int" facet="true"  >
		 <element name="year"/>
	   </range>
	 </constraint> 
	 <constraint name="price">
	   <range type="xs:double" facet="true" >
		 <element name="price"/>
	   </range>
	 </constraint> 
	</options>
};


declare function search-mdl:do-snippet($result as node(),$ctsquery as schema-element(cts:query),
     $options as element(search:transform-results)?) as element(search:snippet)
{
   <search:snippet>
	{
			
	}
	</search:snippet>	
};
