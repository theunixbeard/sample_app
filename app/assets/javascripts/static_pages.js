//$(document).on "page:change", ->
//  alert "page has loaded!"

$(function() {
   initPage();
});
$(window).bind('page:change', function() {
  initPage();
})

function initPage() {
  console.debug("HEY");
  $("[data-input-length-count]").bind('input propertychange', function() {
    var count;
    if($("[data-input-length-count]").val()) {
      count = $("[data-input-length-count]").val().length;
    } else {
      count = 0;
    }
    var charactersLeft = 140 - count;
    var micropostCharacterCountdown = $("#micropostCharacterCountdown")
    micropostCharacterCountdown.html(charactersLeft +  " characters remaining...");
  });
};

