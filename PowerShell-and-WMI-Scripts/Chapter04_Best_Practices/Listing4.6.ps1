function div {
 param (
   [int]$a,
   [int]$b
 )
 try { 
   $a+$b
   $a/$b 
 }
 #catch [DividebyZeroException] {"oops - divide by zero"}
 catch [Exception]{"It's gone wrong" }
 finally {"end"}
}

div 10 2
div 3 2
div 7 0