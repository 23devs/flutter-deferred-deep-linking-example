document.addEventListener('DOMContentLoaded', function() {
  fetch('https://api.ipify.org?format=json')
    .then(response => response.json())
    .then(data => {
        const ip = data.ip;
        const screenWidth = window.screen.width ? window.screen.width : '';

        const os = platform.os.family.toLowerCase();
        const version = platform.os.version;

        var widthEl = document.getElementById('width-p');
        widthEl.innerHTML += screenWidth;

        var ipEl = document.getElementById('ip-p');
        ipEl.innerHTML += ip;

        var osEl = document.getElementById('os-p');
        osEl.innerHTML += os;

        var versionEl = document.getElementById('version-p');
        versionEl.innerHTML += version;

        console.log(window.location.href);
    })
    .catch(error => {
        console.log('Error:', error);
    });
}, false);
