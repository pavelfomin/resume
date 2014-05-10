var months = new Array
 (
  "January"
 ,"February"
 ,"March"
 ,"April"
 ,"May"
 ,"June"
 ,"July"
 ,"August"
 ,"September"
 ,"October"
 ,"November"
 ,"December"
 );

function currDayWrite() {
 today = new Date();
 day = today.getDate();
 document.write(day);
 return day;
}

function currYearWrite() {
 today = new Date();
 year = today.getYear();
 if(navigator.appName == "Netscape") {
   year += 1900;
 }
 document.write(year)
 return year;
}

function currMonthWrite() {
 today = new Date();
 month = today.getMonth();
 document.write(months[month]);
 return months[month];
}

function currDate() {
currMonthWrite();
 document.write(" ");
currDayWrite();
 document.write(", ");
currYearWrite();
 return 0;
}

function currTime() {
 today = new Date();
 str = "";
 val = 0;

 val = today.getHours();
 if(val < 10) 
  str += "0"+ val;
 else
  str += val;

 str += ":";

 val = today.getMinutes();
 if(val < 10) 
  str += "0"+ val;
 else
  str += val;

 str += ":";

 val = today.getSeconds();
 if(val < 10) 
  str += "0"+ val;
 else
  str += val;

 document.write(str);
 return 0;
}
