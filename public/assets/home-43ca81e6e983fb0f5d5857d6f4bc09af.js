var current = "It's Our Wedding Day!";   //-->enter what you want the script to display when the target date and time are reached, limit to 20 characters
var year = 2015;    //-->Enter the count down target date YEAR
var month = 7;      //-->Enter the count down target date MONTH
var day = 25;       //-->Enter the count down target date DAY
var hour = 16;      //-->Enter the count down target date HOUR (24 hour clock)
var minute = 00;    //-->Enter the count down target date MINUTE
var tz = -6;        //-->Offset for your timezone in hours from UTC (see http://wwp.greenwichmeantime.com/index.htm to find the timezone offset for your location)

//    DO NOT CHANGE THE CODE BELOW!
var montharray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

function hide(id) {
    document.getElementById(id).style.display = "none";
}
function countdown(yr, m, d, hr, min) {
    theyear = yr;
    themonth = m;
    theday = d;
    thehour = hr;
    theminute = min;
    var today = new Date();
    var todayy = today.getYear();
    if (todayy < 1000) {
        todayy += 1900;
    }
    var todaym = today.getMonth();
    var todayd = today.getDate();
    var todayh = today.getHours();
    var todaymin = today.getMinutes();
    var todaysec = today.getSeconds();
    var todaystring1 = montharray[todaym] + " " + todayd + ", " + todayy + " " + todayh + ":" + todaymin + ":" + todaysec;
    var todaystring = Date.parse(todaystring1) + (tz * 1000 * 60 * 60);
    var futurestring1 = (montharray[m - 1] + " " + d + ", " + yr + " " + hr + ":" + min);
    var futurestring = Date.parse(futurestring1) - (today.getTimezoneOffset() * (1000 * 60));
    var dd = futurestring - todaystring;
    var dday = Math.floor(dd / (60 * 60 * 1000 * 24));
    var dhour = Math.floor((dd % (60 * 60 * 1000 * 24)) / (60 * 60 * 1000));
    var dmin = Math.floor(((dd % (60 * 60 * 1000 * 24)) % (60 * 60 * 1000)) / (60 * 1000));
    var dsec = Math.floor((((dd % (60 * 60 * 1000 * 24)) % (60 * 60 * 1000)) % (60 * 1000)) / 1000);
    if (dday <= 0 && dhour <= 0 && dmin <= 0 && dsec <= 0) {
        document.getElementById('count2').innerHTML = current;
        document.getElementById('count2').style.display = "block";
        document.getElementById('count2').style.width = "100%";
        hide('dday');
        hide('dhour');
        hide('dmin');
        hide('dsec');
        hide('days');
        hide('hours');
        hide('minutes');
        hide('seconds');
        hide('spacer1');
        hide('spacer2');
        return;
    }
    else {
        hide('count2');
        document.getElementById('dday').innerHTML = dday;
        document.getElementById('dhour').innerHTML = dhour;
        document.getElementById('dmin').innerHTML = dmin;
        document.getElementById('dsec').innerHTML = dsec;
        setTimeout("countdown(theyear,themonth,theday,thehour,theminute)", 1000);
    }
}
;
