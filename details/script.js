//specify url for your server
const apiUrl = "https://api-mobile-apps-examples.23devs.com";
const pageUrl = window.location.href;

// get device data
const screenWidth = window.screen.width ? window.screen.width : "";
const os = platform.os.family.toLowerCase();
const version = platform.os.version;

window.addEventListener(
    "DOMContentLoaded",
    load,
    { once: true }
);

async function load() {
    const data = {
        screenWidth,
        os,
        version,
        url: pageUrl,
    };

    try {
        let response = await fetch(
            `${apiUrl}/api/url-access-datas/set`,
            {
                method: "POST",
                headers: {
                    "Content-Type": "application/json;charset=utf-8",
                },
                body: JSON.stringify(data),
            }
        );

        let result = await response?.json();

        // redirect to the url provided by server (store specified for your platform)
        if (result?.redirectUrl) {
            window.location.href = result.redirectUrl;
        }
    } catch (e) {
        console.log(e);
        // you cah show here a message for user, e.g. that your app is currently not able to be downloaded 
        // provide some other way to open the link
        // or maybe you just show specific content of your website here 
        var errorEl = document.getElementById("error");
        errorEl.innerHTML += 'Something went wrong';
    }
}
