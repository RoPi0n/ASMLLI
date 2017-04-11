uses "graph.h"
uses "sys.h"
uses "crt.h"

label main
 push   "My graph"
 push   0
 push   0
 invoke INITGRAPH
 
 push   3
 invoke SetColor
 
 push   10
 push   0
 push   10
 invoke SetTextStyle
 
 push   110
 push   110
 invoke MoveTo
 
 push   "Graph test"
 invoke OutText

 invoke crt.readkey
 invoke CloseGraph
 invoke halt
return