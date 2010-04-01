(function($) {
  $.extend($.fn, {
    dlc_widget: function (options) {
      var defaults = {
        url:    '/account/widget',
        target: '_blank',
        width: 300,
        height: 100,
        'class': 'dlc-widget'
      };
      var o = $.extend(defaults, options);
      $(this).each(function(){
        var $drop = $(this);
        var $iframe = $('<iframe/>').attr('src', o.url).addClass(o['class']).height(o.height).width(o.width).css({
          overflow: 'hidden'
        })
        $drop.html($iframe);
      })
    }
  });
})(jQuery);