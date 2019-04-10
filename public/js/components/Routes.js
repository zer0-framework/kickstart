(function (root, factory) {
    if (typeof define === "function" && define.amd) {
        define('Routes', ['jquery'], factory);
    } else if (typeof exports === "object") {
        module.exports = factory(require("jquery"));
    } else {
        window.Routes = factory(root.jQuery);
    }
}(this, function ($) {
    var routes = require('../Routes.cfg');
    var routeException = function(message) {
        this.message = message;
    };
    return exports = module.exports = {
        url: function (routeName, params, query) {
            if (typeof params === 'string') {
                params = {action: params};
            }

            var route = routes[routeName] || null;
            if (!route) {
                throw new routeException('Route not found');
            }
            var tr = {};
            $.each(route.defaults || {}, function(key, value) {
                tr['{' + key + '}'] = value;
            });
            $.each(params || {}, function(key, value) {
                tr['{' + key + '}'] = value;
            });
            if (tr['{action}'] == null) {
                tr['[action}'] = '';
            }
            var url = require('locutus/php/strings/strtr')(route.path, tr);
            if (query) {
                url += '?' + $.param(query);
            }
            return url;
        }
    };
}));
