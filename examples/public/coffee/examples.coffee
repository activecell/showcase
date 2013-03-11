core = [
  shortLink: "base"
  title: "Base example"
]

showcaseObject = routes: {}
prepareLinks = (route, el) ->
  link = $("<a>").attr("href", "/#" + route.shortLink).text(route.title)
  el.append $("<li>").append(link)
  showcaseObject.routes[route.shortLink] = route.shortLink
  showcaseObject[route.shortLink] = ->
    $("#example_header").text route.title
    urlCoffee = "coffee/" + route.shortLink + ".coffee"
    url = "js/" + route.shortLink + ".js"
    script = $("<script>").attr("src", url)
    $("#example_view").empty().append script
    $("#temp").empty()

    $.get urlCoffee, (data) ->
      $("#example_js").text data
    $.get url, (data) ->
      $("example_view").text data

    $("#example_js").load urlCoffee, ->
      $(@).removeClass("rainbow")
      Rainbow.color()
    Rainbow.color()


$(document).ready ->
  _.map core, (route) ->
    prepareLinks route, $("#coreLinkList")

  Showcase = Backbone.Router.extend(showcaseObject)
  showcase = new Showcase()
  Backbone.history.start()

  showcase.navigate "/#base"  unless window.location.hash


