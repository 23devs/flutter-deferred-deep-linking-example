document.addEventListener(
    "DOMContentLoaded",
    async () => {
        const screenWidth = window.screen.width ? window.screen.width : "";

        const os = platform.os.family.toLowerCase();
        const version = platform.os.version;

        var widthEl = document.getElementById("width-p");
        widthEl.innerHTML += screenWidth;

        var osEl = document.getElementById("os-p");
        osEl.innerHTML += os;

        var versionEl = document.getElementById("version-p");
        versionEl.innerHTML += version;

        console.log(window.location.href);

        const data = {
            screenWidth,
            os,
            version,
            url: window.location.href.replace(
                "https://mobile-apps-examples.23devs.com",
                ""
            ),
        };

        let response = await fetch(
            "https://api-mobile-apps-examples.23devs.com/api/url-access-datas/set",
            {
                method: "POST",
                headers: {
                    "Content-Type": "application/json;charset=utf-8",
                },
                body: JSON.stringify(data),
            }
        );

        let result = await response.json();
        console.log(result);
    },
    false
);
