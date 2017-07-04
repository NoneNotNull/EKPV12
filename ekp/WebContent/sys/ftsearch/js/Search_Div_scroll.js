function GetPageScrollTop() 
{ 
var x, y; 
if(window.pageYOffset) 
{    // all except IE    
   y = window.pageYOffset;    
      
   } else if(document.documentElement && document.documentElement.scrollTop) 
   {    // IE 6 Strict    
   y = document.documentElement.scrollTop;    
   
   } else if(document.body) {    // all other IE    
   y = document.body.scrollTop;    
   
   } 
   //return {X:x, Y:y};
   return y;
   
}

function GetPageScrollLeft() 
{ 
   var x, y; 
if(window.pageYOffset) 
{
   x = window.pageXOffset; 
   
   } else if(document.documentElement && document.documentElement.scrollTop) 
   {    // IE 6 Strict    
    
   x = document.documentElement.scrollLeft; 
   
   } else if(document.body) {    // all other IE    
  
   x = document.body.scrollLeft;  
   
   } 
   //return {X:x, Y:y};
   return x;
   
}
