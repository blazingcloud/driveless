(function($) {
  $(document).ready(function(){
    
    //$('#com-drivelesschallenge-widget').dlc_widget();
    
    $('.copy-trip-to-form').click(function(e){
      e.preventDefault();
      e.stopImmediatePropagation();
      var $toCopy = $(this).parents('.trip-entry');
      var $form   = $('.new_trip');
      var where = $('.where', $toCopy).text(),
          how   = $('.how', $toCopy).text(),
          distance = parseFloat($('.distance', $toCopy).text());
      $('option:contains("'+where+'")').attr('selected', 'selected');
      $('option:contains("'+how+'")').attr('selected', 'selected');
      $('#trip_distance').val(distance);
      $('.trip-form').stop().css({backgroundColor: '#ccffcc'}).animate({backgroundColor: '#ffffff'}, 2000);
    });
    
    $('a.activate-section').click(function(e){
      e.preventDefault();
      e.stopImmediatePropagation();
      var link = $(this).attr('href').substr(1).split(/-/);
      var container = $('.' + link[0]);
      var section   = $('.' + link[1]);
      section.show().siblings().hide();
      $(this).removeClass('inactive').parent().find('a.button').not(this).addClass('inactive')
    })
    
    $('.datepicker').datepicker()
    
    $('.baseline-travel input').change(function(e){
      var $baseline = $(this).parents('.baseline-travel:first');
      var alone = parseFloat($('input:eq(0)', $baseline).val()) || 0;
      var green = parseFloat($('input:eq(1)', $baseline).val()) || 0;
      if (alone || green) {
        $('.number', $baseline).text(((green/(alone+green))*100+'').substr(0,5));
        $('.line-percent',$baseline).show();
      } else {
        $('.line-percent',$baseline).hide();
      }
      var $form  = $baseline.parents('.baseline');
      var t_miles = _.reduce($('.baseline-travel input.alone', $form).get(), 0, function(t,i){return t+(parseFloat($(i).val()) || 0)});
      var g_miles = _.reduce($('.baseline-travel input.green', $form).get(), 0, function(t,i){return t+(parseFloat($(i).val()) || 0)});
      $('.total-miles', $form).text(t_miles);
      $('.total-green', $form).text(g_miles);
      $('.total-combined-miles', $form).text(t_miles + g_miles);
      if (t_miles) {
        $('.foot .number', $form).text(((g_miles/(t_miles+g_miles))*100+'').substr(0,5));
        $('.foot .line-percent', $form).show();
      } else {
        $('.foot .line-percent', $form).hide();
      }
/*      $('.goal-total').change(function(e){
        if (!$('.green-total').val()) return;
        if (!$('.goal-green').val()) {
          $('.goal-green').val((parseFloat($('.total-combined-miles').text()) || 0) - (parseFloat($('.goal-total').val()) || 0))
        }
      })*/
    }).trigger('change');
  });
})(jQuery);