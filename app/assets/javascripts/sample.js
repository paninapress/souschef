(function() {
    // consider using a debounce utility if you get too many consecutive events
    $(window).on('motion', function(ev, data) {
        console.log('detected motion at', new Date(), 'with data:', data);
        var spot = $(data.spot.el);
        spot.addClass('active');
        setTimeout(function() {
            spot.removeClass('active');
        }, 230);
    });

    $('#play').on('motion', function() {
        document.getElementById('recipeclip').play();
    });

    $('#pause').on('motion', function() {
        document.getElementById('recipeclip').pause();
    });

    $('#up').on('motion', function() {
        var x = $(window).scrollTop() + 30;
        $(window).scrollTop(x);
        
    });

    $('#down').on('motion', function() {
        var x = $(window).scrollTop() - 30;
        $(window).scrollTop(x);
      
    });
})();