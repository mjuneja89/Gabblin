// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require tether
//= require bootstrap
//= require jquery.turbolinks
//= require_tree .

$(document).ready(function() {
  if ($('nav.pagination').length) {
    $(window).scroll(function() {
      var url = $('nav.pagination a[rel=next]').attr('href');
      var spinner = $('<i class="fa fa-circle-o-notch fa-spin fa-3x fa-fw"></i>');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('.pagination').html(spinner);
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});


