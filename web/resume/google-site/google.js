<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script language="JavaScript">
 //Set the email text based on the data attributes.
 $(document).find('.email').each (function() {
  var user = $(this).data("user");
  var domain = $(this).data("domain");
  $(this).text(user +"@"+ domain);
 });
 
 //Shows the element defined by the data attribute, then hides itself.
 $(".action-show").click(function() {
  var id = $(this).data("elementId");
  $("."+ id).show();
  $(this).hide();
  return false; //to avoid href action
 });

 //Hides the element defined by the data attribute, then restores the corresponding link to show details.
 $(".action-hide").click(function() {
  var id = $(this).data("elementId");
  $("."+ id).hide();
  $("a.action-show."+ id).show();
  return false; //to avoid href action
 });
</script>
