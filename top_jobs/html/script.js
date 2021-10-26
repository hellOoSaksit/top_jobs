var mode1time = 0;
var mode2time = 0;
var mode1Interval;
var mode2Interval;

 $(function() { 
    window.addEventListener("message", function(event) { 
        let e = event.data;

        if (e.action == "showUI") {
            if (e.Mode == 1) {
                createUIMode1(e)
            } else if (e.Mode == 2) {
                createUIMode2(e)
            }
        } else if (e.action == "showUIinf"){
            if (e.Mode == 1) {
                createUIMode1inf(e)
            }
        }
        else if (e.action == "closeUI") {
            if (e.Mode == 1) {
                closeUIMode1()
            } else if (e.Mode == 2) {
                closeUIMode2()
            }
        } else if (e.action == "statusUpdate") {
            $('#mode2status').html(e.Status);
        } else if (e.action == "playSound") {
            var audio = new Audio('sound/'+e.sound+'.mp3');
            audio.volume = e.volume;
            audio.play();
        }
    });

    function createUIMode1(data) {
        closeUIMode1();

        mode1time = (data.Time/1000)-1
        let name = data.Name;
        let time = ParseTime((data.Time/1000)-1);
      
        $(".ui").append('<div id="mode1ui" class="list"><div class="wrap">'+
            '<div class="jobname">'+name+'</div>'+
            '<div class="timeout"><i data-feather="clock"></i> <span id="mode1time">'+time+'</span></div>'+
        '</div></div>');
        feather.replace({ class: 'feather-icon', 'stroke-width': 2 })
        CoolDownMode1();
        $("#mode1ui").fadeIn();
    }

    function createUIMode1inf(data) {
        closeUIMode1();

        mode1time = (data.Time/1000)-1
        let name = data.Name;
        let time = ParseTime((data.Time/1000)-1);
      
        $(".ui").append('<div id="mode1ui" class="list"><div class="wrap">'+
            '<div class="jobname">'+name+'</div>'+
            // '<div class="timeout"><i data-feather="clock"></i> <span id="mode1time">'+time+'</span></div>'+
        '</div></div>');
        feather.replace({ class: 'feather-icon', 'stroke-width': 2 })
        CoolDownMode1();
        $("#mode1ui").fadeIn();
    }

    function createUIMode2(data) {
        closeUIMode2();
        
        mode2time = (data.Time/1000)-1
        let name = data.Name;
        let time = ParseTime((data.Time/1000)-1);
        let status = data.Status;
       
        $(".ui").append('<div id="mode2ui" class="list"><div class="wrap">'+
            '<div class="jobname">'+name+'</div>'+
            '<div class="timeout"><i data-feather="clock"></i> <span id="mode2time">'+time+'</span></div>'+
            '<div class="status"><i data-feather="mail"></i> <span id="mode2status">'+status+'</span></div>'+
        '</div></div>');
        feather.replace({ class: 'feather-icon', 'stroke-width': 2 })
        CoolDownMode2();
        $("#mode2ui").fadeIn();
       
    }

    function closeUIMode1() {
        clearInterval(mode1Interval);
        $("#mode1ui").remove();
    }

    function closeUIMode1inf() {
        clearInterval(mode2Interval);
        $("#mode1uiinf").remove();
    }

    function closeUIMode2() {
        clearInterval(mode2Interval);
        $("#mode2ui").remove();
    }

    function ParseTime(t) {
        let mn = Math.floor(t/60)
        let sec = t - (60 * mn)
        
        if (mn.toString().length < 2) {
            mn = "0"+mn;
        }

        if (sec.toString().length < 2) {
            sec = "0"+sec;
        }

        return mn+":"+sec
    }

    function CoolDownMode1() {
        mode1Interval = setInterval(() => {
            mode1time = mode1time - 1
            $('#mode1time').html(ParseTime(mode1time));
            if (mode1time < 1) {
                clearInterval(mode1Interval);
                closeUIMode1();
            }
        }, 1000);
    }

    function CoolDownMode2() {
        mode2Interval = setInterval(() => {
            mode2time = mode2time - 1
            $('#mode2time').html(ParseTime(mode2time));
            if (mode2time < 1) {
                clearInterval(mode2Interval);
                closeUIMode2();
            }
        }, 1000);
    }

 });