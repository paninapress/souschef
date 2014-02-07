function playrecipe() {
                  var speech = function () {
        'use strict';
            //find which speech recognition constructor works
        if (typeof speechRecognition !== 'undefined') {
                return new speechRecognition();
            } else if (typeof mozSpeechRecognition !== 'undefined') {
                return new mozSpeechRecognition();
            } else if (typeof msSpeechRecognition !== 'undefined') {
                return new msSpeechRecognition();
            } else if (typeof webkitSpeechRecognition !== 'undefined') {
                return new webkitSpeechRecognition();
            }
            throw new Error('No speech recognition API detected.');
        };

    var recognition = speech();
    recognition.continuous = false;
    recognition.interimResults = true;
    recognition.lang = 'en-GB';
    recognition.start();

     recognition.addEventListener('result', function (event) {
                console.log(event);
                for (var i = event.resultIndex, len = event.results.length; i < len; i++) {
                    lastCommand.innerHTML = event.results[i][0].transcript;
                    lastCommand.style.color = '#ccc';
                    //use final result
                    if (event.results[i].isFinal) {
                        lastCommand.style.color = '#fff';
                        processSpeech(event.results[i][0].transcript);
                    }
                }
            }, false);

            recognition.addEventListener('start', function () {
                feedback.innerHTML = 'Talk to me';
                button.style.display = 'none';
                for (var i = 0, len = mic.length; i < len; i++) {
                    mic[i].style.fill = 'green';
                }
            }, false);

            recognition.addEventListener('speechstart', function () {
                feedback.innerHTML = 'Capturing';
            }, false);

            recognition.addEventListener('speechend', function (event) {
                feedback.innerHTML = 'I\'m not listening';
                button.style.display = 'block';
                for (var i = 0, len = mic.length; i < len; i++) {
                    mic[i].style.fill = '#fff';
                }
                   listenButton.addEventListener('click', function() {
          init();
        }, false);
                   
      var processSpeech = function (query) {
            if ((query.indexOf('freeze') > -1)){
                document.getElementById('recipeclip').pause();
            } else if (query.indexOf('stop') > -1) {
                console.log('stop');
                document.getElementById('recipeclip').stop();
            } else if (query.indexOf('play') > -1) {
                document.getElementById('recipeclip').play();
            } 
        };
});
                };

