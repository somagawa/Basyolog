// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require bootstrap-sprockets
//= require jquery.jpostal
//= require_tree .


$(function() {
  function readURL(input) {
      if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
  $('#img_prev').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
      }
  }
  $("#file").change(function(){
      readURL(this);
  });
});

$(function() {
  function readURL(input) {
      if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
  $('#cover_img_prev').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
      }
  }
  $("#cover_file").change(function(){
      readURL(this);
  });
});

$(function() {
  $('#slider1').slick({
      dots: true,
      autoplay: true,
      autoplaySpeed: 4000,
  });
});

$(function() {
  $('#slider2').slick({
      autoplay: true,
      autoplaySpeed: 4000,
      slidesToShow: 3,
      slidesToScroll: 3,
      responsive: [{
        breakpoint: 768, //ブレークポイントが768px
        settings: {
          slidesToShow: 2, //表示するスライドの数
          slidesToScroll: 2, //スクロールで切り替わるスライドの数
        }
      }]
  });
});