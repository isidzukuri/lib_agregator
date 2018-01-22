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
//= require bootstrap-sprockets
//= require_tree .
//= require bootstrap-wysihtml5
//= require jquery-ui


$(window).load(function(){
    (function(d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) return;
      js = d.createElement(s); js.id = id;
      js.async = true;
      js.src = "//connect.facebook.net/uk_UA/all.js#xfbml=1";
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));

    !function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.async = true;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');
    
    window.___gcfg = {lang: 'uk'};
    
    (function() {
        var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
        po.src = 'https://apis.google.com/js/plusone.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
    })();

//     new Image().src = "https://counter.yadro.ru/hit?r"+
//     escape(document.referrer)+((typeof(screen)=="undefined")?"":
//     ";s"+screen.width+"*"+screen.height+"*"+(screen.colorDepth?
//     screen.colorDepth:screen.pixelDepth))+";u"+escape(document.URL)+
//     ";"+Math.random();

  

    if(window.tags_list){
      window.autocomplete_tags_data = $.map(window.tags_list, function (value, key) {
                  return {
                      label: value.uk,
                      value: value.uk,
                      href: "/tags/"+value.seo
                  }
              })

      $( "#tags_autocomplete" ).autocomplete({
        minLength: 2,
        delay: 500,
        source: window.autocomplete_tags_data,
        response: function( event, ui ) {
          $("#tags_results").empty();
          $.each(ui.content, function( index, tag ) {
            $("#tags_results").append("<a href='"+tag.href+"' class='label label-default'>"+tag.value+"</a>");
          });
          
          tags_results
        },
        open: function( event, ui ) {
          $(".ui-autocomplete").hide();
        } 
      });
    }


});

$(document).ready(function(){
  $('img').on("error", function () {
    $(this).parent().hide();
  });
});
