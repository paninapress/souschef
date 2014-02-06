/*jslint browser:true */
/*global SC */
var demo = (function () {
    'use strict';
    
    var heading = document.getElementsByTagName('h1')[0],
        description = document.getElementById('description'),
        image = document.getElementById('artwork'),
        feedback = document.getElementById('feedback'),
        soundFeedback = document.getElementById('sound-feedback'),
        lastCommand = document.getElementById('last-command'),
        avatar = document.getElementById('avatar'),
        username = document.getElementById('username'),
        userUri = document.getElementById('username-link'),
        trackLink = document.getElementById('track-link'),
        mic = document.getElementsByClassName('mic'),
        button = document.getElementsByTagName('button')[0],

        soundHandler = {
            Sound: undefined,
            Tracks: undefined,
            index: 0,
    
            play: function (track) {
                SC.stream(track.id, {
                    autoPlay: true,
                    onfinish: function () {
                        soundHandler.next();
                    }
                }, function (sound) {
                    soundHandler.Sound = sound;
                    console.log(sound);
                });
                
                soundFeedback.innerHTML = 'Playing';

                heading.innerHTML = track.title;

                description.innerHTML = track.description;
                image.src = track.artwork_url || track.waveform_url;
                avatar.src = track.user.avatar_url;
                avatar.title = track.user.username;
                userUri.setAttribute('href', track.user.uri);
                trackLink.setAttribute('href', track.permalink_url);
            },

            pause: function () {
                this.Sound.pause();
                soundFeedback.innerHTML = 'Paused';
            },

            resume: function () {
                this.Sound.resume();
                soundFeedback.innerHTML = 'Playing';
            },

            stop: function () {
                this.Sound.stop();
                soundFeedback.innerHTML = 'Stopped';
            },

            retrieveTracks: function (query) {
                soundFeedback.innerHTML = 'Getting tracks';
                SC.get('/tracks', { q: query }, function (tracks) {
                    if (tracks.length) {
                        console.log('retrieved', tracks[0]);
                        soundHandler.index = 0;
                        //set new tracks array
                        soundHandler.Tracks = tracks;
                        //play first track
                        soundHandler.play(tracks[0]);
                    } else {
                        heading.innerHTML = 'Could not find a matching song';
                    }
                });
            },

            next: function () {
                this.stop();
                this.index++;
                this.play(this.Tracks[this.index]);
            }
        },

        processSpeech = function (query) {
            if ((query.indexOf('pause') > -1 && soundHandler.Sound) || (query.indexOf('paul') > -1 && soundHandler.Sound)) {
                soundHandler.pause();
            } else if (query.indexOf('stop') > -1 && soundHandler.Sound) {
                console.log('stop');
                soundHandler.stop();
            } else if (query.indexOf('play') > -1 && soundHandler.Sound) {
                soundHandler.resume();
            } else if (query.indexOf('play') > -1) {
                soundHandler.retrieveTracks(query.replace('play', ''));
            } else if ((soundHandler.Sound && query.indexOf('next') > -1) || (soundHandler.Sound && query.indexOf('skip') > -1)) {
                soundHandler.next();
            }
        },

        speech = function () {
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
        },

        init = function () {
            var recognition = speech();
            console.log(recognition);
            //listen once
            recognition.continuous = false;
            recognition.interimResults = true;
            //i'm english
            recognition.lang = 'en-GB';
            //start listening
            recognition.start();

            //on each result
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
                init();
            }, false);
        };

    // initialise SoundCloud client with app credentials
    SC.initialize({
        client_id: 'ac8669182009af95cd79f673e366d9b1',
        redirect_uri: 'http://lab.fetimo.com/speech/app/'
    });

    button.addEventListener('click', function () {
        init();
    }, false);

    return {
        init: init
    };
})();