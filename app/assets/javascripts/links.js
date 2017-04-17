$(document).ready(() => {
  new LinksManager()
})

class LinksManager {
  constructor() {
    $("input[value='Lock It Up']").on("click", this.lockItUp.bind(this))
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
}
