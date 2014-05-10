// 
// 10/25/02 Added the time difference logic: needs to be worked out
// 01/22/02 URL updated to euro.svoboda.org
// 12/26/01 URL updated
// 08/07/01 Original creation
//

//
//Returns the URL for svoboda's latest news (Full option)
//
function getLatestNewsURLFromSvoboda() {
   var url = "http://euro.svoboda.org/hotnews/default.asp?full=True";

   var today = new Date();

   var day = today.getDate() + getTimeOffset(today, 3);
   var month = today.getMonth() + 1; //0 based
   var year = today.getYear();

   if(navigator.appName == "Netscape") {
     year += 1900;  //1900 based in Netscape but normal in IE
   }

   var datestamp = "&dd="+ day +"&mm="+ month +"&yy="+ year;
   var href = url + datestamp;

   return href;
}

//
//Redirects to URL returned from getLatestNewsURLFromSvoboda()
//
function getLatestNewsFromSvoboda() {
   top.location.href = getLatestNewsURLFromSvoboda();
}

//
//Returns the time offset in days between local and svoboda's time
//
function getTimeOffset(today, svobodaTimeZoneOffset) {
   var currentTimeZoneOffset = today.getTimezoneOffset()/60;
   var timeDifference = svobodaTimeZoneOffset - currentTimeZoneOffset;

   var dayOffset = 0;

   var hours = today.getHours() + timeDifference;

   if(hours >= 24) {
     dayOffset = 1;
   }

   if(hours < 0) {
     dayOffset = -1;
   }

   var test = "dayOffset="+ dayOffset +" hours="+ hours +" timeDifference="+ timeDifference + " currentTimeZoneOffset="+ currentTimeZoneOffset;

   //does not work properly
   //getTimezoneOffset() returns '5/6' for Central US instead of -5/6

   return 1; //currently, assumes that svoboda is 1 day ahead
}
