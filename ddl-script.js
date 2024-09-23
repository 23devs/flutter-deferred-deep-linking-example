document.addEventListener('DOMContentLoaded', function() {
  fetch('https://api.ipify.org?format=json')
    .then(response => response.json())
    .then(data => {
        const ip = data.ip;
        const screenWidth = (screen.width) ? screen.width : '';
        const screenHeight = (screen.height) ? screen.height : '';

        const os = platform.os.family.toLowerCase();

        var widthEl = document.getElementById('width-p');
        widthEl.innerHTML += screenWidth;

        var heightEl = document.getElementById('height-p');
        heightEl.innerHTML += screenHeight;

        var ipEl = document.getElementById('ip-p');
        ipEl.innerHTML += ip;

        var osEl = document.getElementById('os-p');
        osEl.innerHTML += os;
    })
    .catch(error => {
        console.log('Error:', error);
    });
}, false);