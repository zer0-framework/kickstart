var $ = (jQuery = require('jquery'));
require('jquery-pjax');
var exports = module.exports = {
    ready: function (cb) {
        $(document).ready(cb);
        $(document).on('pjax:end', cb);
    },
    init: function () {
        $.pjax.defaults.timeout = 30000;
        var $spinner = $('#spinner');
        $(document)
            .pjax('a:not(.no-pjax)', '#pjax-container')
            .on('pjax:beforeSend', function (event, jqXHR) {
                $spinner.show();
            })
            .on('pjax:beforeReplace', function (event, jqXHR) {
                $('#tracy-debug-bar').remove();
            })
            .on('pjax:complete', function () {
                $spinner.hide();
            });
    },
    reload: function () {
        $.pjax.reload('#pjax-container');
    }
};
