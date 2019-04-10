var $ = (jQuery = require('jquery'));
var exports = module.exports = {
    init: function () {
        $(document).on('pjax:beforeSend', function (event, jqXHR) {
            jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name=csrf-token]').attr('content'));
        });
        $.ajaxSetup({
            beforeSend: function (jqXHR, settings) {
                var match = settings.url.match(/^(http[s]:)?\/\/([^/]+)/i);
                if (!match || match[2] === window.location.host) {
                    jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name=csrf-token]').attr('content'));
                }
                return true;
            }
        });
    },
};
