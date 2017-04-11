uses "graph.h"
uses "sys.h"

label main
 push   "My graph"
 push   0
 push   0
 invoke INITGRAPH
 
 push   200
 push   126
 push   100
 push   100 
 invoke RECTANGLE
 
 push   110
 push   110
 invoke MoveTo
 
 push   "Graph test"
 invoke OutText

 push   10000
 invoke sleep
return