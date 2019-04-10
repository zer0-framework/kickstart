
if (!window.console) console = {
    log: function () {
    }
};
module.exports = function () {
    var shoe = require('shoe');
    var dnode = require('dnode');

    var connectTimeout, tries = 0;
    var socket = {
        connect: function () {
            var stream = shoe('/socket');
            var d = dnode();
            d.on('remote', function (remote) {
                tries = 0;
                if (!remote.services) {
                    console.log("bad remote", remote);
                    return;
                }
                remote.services(function (services) {
                    $(document).trigger('socket:connected', [services]);
                });
            });
            d.on('end', function () {
                $(document).trigger('socket:disconnected');
                var ms = 0;
                if (tries > 2) {
                    ms = 10e3;
                }
                else if (tries > 0) {
                    ms = 3e3;
                } else {
                    ms = 1;
                }
                ++tries;
                connectTimeout = setTimeout(function () {
                    socket.connect();
                }, ms);
            });
            d.pipe(stream).pipe(d);
        },
        stop: function () {
            socket.stop();
        }
    };
    return socket;
}();
