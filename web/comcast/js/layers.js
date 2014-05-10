//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////
function findObj(n, d) {
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////
function showDiv(divname, v) {
   if ((obj=findObj(divname))!=null) {
     //--alert('showDiv obj='+ obj);
     if (obj.style) {
       obj=obj.style;
       //v=(v=='show')?'visible':(v='hide')?'hidden':v;
       v=(v=='show')?'block':(v='hide')?'none':v;
     } 
     //obj.visibility=v;
     obj.display=v;
   }
  //--alert('showDiv - done');
  return false;
}

//////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////
function showAndHideDiv(divToShow, divToHide) {
  showDiv(divToShow, 'show');
  showDiv(divToHide, 'hide');
}
