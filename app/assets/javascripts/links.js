$(document).ready(() => {
  new LinksManager()
})

class LinksManager {
  constructor() {
    $("input[value='Lock It Up']").on("click", this.lockItUp.bind(this))
    $("body").on("click", "input[value='Mark as Read']", this.markAsRead.bind(this))
    $("body").on("click", "input[value='Mark as Unread']", this.markAsUnread.bind(this))
    $("#link-filter").on("keyup", this.textFilter.bind(this))
    $("#show-read").on("click", this.showRead.bind(this))
    $("#show-unread").on("click", this.showUnread.bind(this))
		this.checkForHotties()
  }

	checkForHotties() {
		$.ajax({
      url: "https://hotlinks-schutte.herokuapp.com/api/v1/hottest_links",
			method: "GET"
		})
		.done(this.updateHotties)
		.fail(error => console.error(error))
	}

	updateHotties(response) {
		$(".hot, .top").remove()
		$(".lockbox article")
			.find(`a:contains(${response[0].url})`)
			.parents("article")
			.prepend("<p class='top'>top link</p>")

		response.forEach(link => {
      $(".lockbox article")
				.find(`a:contains(${link.url})`)
				.parents("article")
				.prepend("<p class='hot'>hot</p>")
    })
	}

  lockItUp(event) {
    event.preventDefault()

    const url = $("#link_url:valid").val()
    const title = $("#link_title:valid").val()
    const link = { link: { url: url, title: title } }
    
    url && title ? this.createLink(link) : this.handleErrors()
  }

  createLink(link) {
    $.ajax({
      url: "api/v1/links",
      method: "POST",
      data: link
    })
    .done(response => {
      $("#link_url, #link_title").val("")
      $(".lockbox").prepend(response)
      $(".create-link #link_url, #link_title").val("")
    })
    .fail(error => console.log(error))
  }

  handleErrors() {
    $(".create-link p").text("")
    const urlMsg = $("#link_url")[0].validationMessage
    const titleMsg = $("#link_title")[0].validationMessage

    urlMsg && $("#link_url").after(`<p class="flash danger">${urlMsg}</p>`)
    titleMsg && $("#link_title").after(`<p class="flash danger">${titleMsg}</p>`)
  }
  
  markAsUnread(event) {
    event.preventDefault();

    const linkId = $(event.target).siblings("#link_id").val()
    const link = { link: { read: false } }

    this.updateReadStatus(link, linkId)
  }

  markAsRead(event) {
    event.preventDefault();

    const linkId = $(event.target).siblings("#link_id").val()
    const link = { link: { read: true } }

    this.updateReadStatus(link, linkId)
  }

  updateReadStatus(link, linkId) {
    $.ajax({
      type: "PATCH",
      url: "/api/v1/links/" + linkId,
      data: link,
    })
    .done(this.updateLinkStatus.bind(this))
    .fail(this.displayFailure);
  }

  updateLinkStatus(link) {
		this.checkForHotties()
		link.read && this.postHotlinks(link.url)
    const buttonText = link.read ? "Mark as Unread" : "Mark as Read"
    const $linkCard = $(`#link${link.id}`)
    link.read ? $linkCard.addClass("read") : $linkCard.removeClass("read")
    $linkCard.find('p').text(`Read? ${link.read}`)
    $linkCard.find('.read-unread').val(buttonText)
  }

  postHotlinks(url) {
		const link = { link: { url: url } }
    $.ajax({
      url: "https://hotlinks-schutte.herokuapp.com/api/v1/links",
			method: "POST",
			data: link
    })
    .done(response => console.log(response))
    .fail(error => console.log(error))
  }

  displayFailure(failureData){
    console.log("FAILED attempt to update Link: " + failureData.responseText);
  }

  textFilter(event) {
		const query = $("#link-filter").val().toLowerCase()
		
		$(".lockbox article").hide()

		const matches = $(".lockbox article").filter(article => {
			const title = $(".lockbox article")[article].querySelector("h4").innerText.toLowerCase()
			const url = $(".lockbox article")[article].querySelector("a").innerText.toLowerCase()
			return title.includes(query) || url.includes(query)
		})

		matches.show()
  }

  showRead(event) {
    const $articles = $(".lockbox article")
    $articles.hide()
    $articles.filter(".read").show()
  }

  showUnread(event) {
    const $articles = $(".lockbox article")
    $articles.show()
    $articles.filter(".read").hide()
  }
}


