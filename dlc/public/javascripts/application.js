(function($) {
  $(document).ready(function(){
    $('.baseline-travel input').change(function(e){
      var $baseline = $(this).parents('.baseline-travel:first');
      var alone = parseFloat($('input:eq(0)', $baseline).val());
      var green = parseFloat($('input:eq(1)', $baseline).val()) || 0;
      if (alone) {
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
      if (t_miles) {
        $('.foot .number', $form).text(((g_miles/(t_miles+g_miles))*100+'').substr(0,5));
        $('.foot .line-percent', $form).show();
      } else {
        $('.foot .line-percent', $form).hide();
      }
    }).trigger('change');
  });
})(jQuery);