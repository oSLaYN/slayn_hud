 var randomvar = false;
window.addEventListener("message", function (event) {
  switch (event.data.action) {
    case "updateStatusHud":
    if (event.data.show == true) {
      $("body").fadeIn(500);
      $("body").css("display", event.data.show ? "block" : "none");
      if (event.data.type == true) {
        $(".statusHud").removeClass("statusHudCar");
        $("#varVoice").css("margin-left", "0px");
        $("#varHealth").css("margin-left", "0px");
        $("#varArmor").css("margin-left", "0px");
        $("#varHunger").css("margin-left", "0px");
        $("#varThirst").css("margin-left", "0px");
        $("#varOxygen").css("margin-left", "0px");
        $("#varStress").css("margin-left", "0px");
        $("#varAmmo").css("margin-left", "0px");
        $("#varSeatbelt").css("margin-left", "0px");
        $(".vehiclekey").css("margin-left", "0px");
        $(".engineorange").css("margin-left", "0px");
        $(".enginred").css("margin-left", "0px");
        if (event.data.talking == true) {
          $("#varVoice").fadeIn(500);
        } else {
          $("#varVoice").fadeOut(500);
        }
        if (event.data.health < 90) {
          $("#varHealth").fadeIn(500);
        } else {
          $("#varHealth").fadeOut(500);
        }
        if (event.data.armour > 0) {
          $("#varArmor").fadeIn(500);
        } else {
          $("#varArmor").fadeOut(500);
        }
        if (event.data.hunger < 90) {
          $("#varHunger").fadeIn(500);
        } else {
          $("#varHunger").fadeOut(500);
        }
        if (event.data.thirst < 90) {
          $("#varThirst").fadeIn(500);
        } else {
          $("#varThirst").fadeOut(500);
        }
        if (event.data.oxygen < 90) {
          $("#varOxygen").fadeIn(500);
        } else {
          $("#varOxygen").fadeOut(500);
        }
        if (event.data.stress > 0) {
          $("#varStress").fadeIn(500);
        } else {
          $("#varStress").fadeOut(500);
        }
        if (event.data.ammo > 0) {
          $("#varAmmo").fadeIn(500);
        } else {
          $("#varAmmo").fadeOut(500);
        }
        if (event.data.incar == true) {
          $('.huds').fadeIn(500);
          $('#varSeatbelt').fadeIn(500);
          setProgressSpeed(event.data.speed,'.progress-speed');
          if (event.data.haskeys == true) {
            $('.vehiclekey').fadeOut(500);
          } else {
            $('.vehiclekey').fadeIn(500);
          }
          if (event.data.seatbelt == true) {
            widthHeightSplit(100, $("#circleSetSeatbelt"));
          } else {
            widthHeightSplit(0, $("#circleSetSeatbelt"));
          }
          if (event.data.engine > 75) {
            $('.engineorange').fadeOut(500);
            $('.enginered').fadeOut(500);
          } else if (event.data.engine <= 75 & event.data.engine > 35) {
            $('.enginered').fadeOut(500);
            $('.engineorange').fadeIn(500);
          } else if (event.data.engine <= 35) {
            $('.engineorange').fadeOut(500);
            $('.enginered').fadeIn(500);            
          }
        } else {
          $('#varSeatbelt').fadeOut(500);
          $('.huds').fadeOut(500);
        }
      } else {
        $(".statusHud").removeClass("statusHudCar");
        $("#varVoice").css("margin-left", "0px");
        $("#varHealth").css("margin-left", "0px");
        $("#varArmor").css("margin-left", "0px");
        $("#varHunger").css("margin-left", "0px");
        $("#varThirst").css("margin-left", "0px");
        $("#varOxygen").css("margin-left", "0px");
        $("#varStress").css("margin-left", "0px");
        $("#varAmmo").css("margin-left", "0px");
        $("#varSeatbelt").css("margin-left", "0px");
        $(".vehiclekey").css("margin-left", "0px");
        $(".engineorange").css("margin-left", "0px");
        $(".enginred").css("margin-left", "0px");
        if (event.data.talking == true) {
          $("#varVoice").fadeIn(500);
        } else {
          $("#varVoice").fadeOut(500);
        }
        if (event.data.incar == true) {
          $('.huds').fadeIn(500);
          $('#varSeatbelt').fadeIn(500);
          setProgressSpeed(event.data.speed,'.progress-speed');
          if (event.data.haskeys == true) {
            $('.vehiclekey').fadeOut(500);
          } else {
            $('.vehiclekey').fadeIn(500);
          }
          if (event.data.seatbelt == true) {
            widthHeightSplit(100, $("#circleSetSeatbelt"));
          } else {
            widthHeightSplit(0, $("#circleSetSeatbelt"));
          }
          if (event.data.engine > 75) {
            $('.engineorange').fadeOut(500);
            $('.enginered').fadeOut(500);
          } else if (event.data.engine <= 75 & event.data.engine > 35) {
            $('.enginered').fadeOut(500);
            $('.engineorange').fadeIn(500);
          } else if (event.data.engine <= 35) {
            $('.engineorange').fadeOut(500);
            $('.enginered').fadeIn(500);            
          }
        } else {
          $('#varSeatbelt').fadeOut(500);
          $('.huds').fadeOut(500);
        }
      }
      widthHeightSplit(event.data.voice, $("#circleSetVoice"));
      widthHeightSplit(event.data.health, $("#circleSetHealth"));
      widthHeightSplit(event.data.armour, $("#circleSetArmour"));
      widthHeightSplit(event.data.hunger, $("#circleSetHunger"));
      widthHeightSplit(event.data.thirst, $("#circleSetThirst"));
      widthHeightSplit(event.data.oxygen, $("#circleSetOxygen"));
      widthHeightSplit(event.data.stress, $("#circleSetStress"));
      widthHeightSplit(event.data.ammo, $("#circleSetAmmo"));
    } else {
      $("body").fadeOut(500);
    }
  }
});

function widthHeightSplit(value, ele) {
  let height = 30.0;
  let eleHeight = (value / 100) * height;
  let leftOverHeight = height - eleHeight;

  ele.css("height", eleHeight + "px");
  ele.css("top", leftOverHeight + "px");
}

function setProgressSpeed(value, element){
  var circle = document.querySelector(element);
  var radius = circle.r.baseVal.value;
  var circumference = radius * 2 * Math.PI;
  var html = $(element).parent().parent().find('span');
  var percent = value*100/480;

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent*73)/100) / 100 * circumference;
  circle.style.strokeDashoffset = -offset;

  html.text(value);
}