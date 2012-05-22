jQuery ->
  $("#all").click ->
    $.getScript("http://#{domain}")
    $(".active").removeClass("active")
    $("#all").addClass("active")
  $("#images").click ->
    $.getScript("http://#{domain}?type=Image")
    $(".active").removeClass("active")
    $("#images").addClass("active")
  $("#messages").click ->
    $.getScript("http://#{domain}?type=Message")
    $(".active").removeClass("active")
    $("#messages").addClass("active")
  $("#links").click ->
    $.getScript("http://#{domain}?type=Link")
    $(".active").removeClass("active")
    $("#links").addClass("active")
  $("#tweets").click ->
    $.getScript("http://#{domain}?type=Tweet")
    $(".active").removeClass("active")
    $("#tweets").addClass("active")

  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next > a').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').text("Fetching more growls...")
        $.getScript(url)
    $(window).scroll
