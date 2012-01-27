(function($) {
  var defaults;
 
  $.event.fix = (function(originalFix) {
    return function(event) {
      event = originalFix.apply(this, arguments);
      if (event.type.indexOf('copy') === 0 || event.type.indexOf('paste') === 0) {
        event.clipboardData = event.originalEvent.clipboardData;
      }
      return event;
    };
  })($.event.fix);
 
  defaults = {
    callback: $.noop,
    matchType: /image.*/
  };
 
  $.fn.pasteImageReader = function(options) {
    if (typeof options === "function") {
      options = {
        callback: options
      };
    }
 
    options = $.extend({}, defaults, options);
 
    return this.each(function() {
      var $this, element;
      element = this;
      $this = $(this);
 
      $this.bind('paste', function(event) {
        var clipboardData, found;
        found = false;
        clipboardData = event.clipboardData;
 
        Array.prototype.forEach.call(clipboardData.types, function(type, i) {
          var file, reader;
          if (found) {
            return;
          }
 
          if (!type.match(options.matchType)) {
            return;
          }
 
          file = clipboardData.items[i].getAsFile();
          reader = new FileReader();
 
          reader.onload = function(evt) {
            options.callback.call(element, {
              filename: file.name,
              dataURL: evt.target.result
            });
          };
          reader.readAsDataURL(file);
          found = true;
        });
      });
    });
  };
})(jQuery);