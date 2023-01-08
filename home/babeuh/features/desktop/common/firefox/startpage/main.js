const locale = { hc: "h24" };

function gebi(id) {
    return document.getElementById(id);
}

function time() {
    let now = new Date();
    let options = { hour: "numeric", minute: "numeric", second: "numeric", timeZone: "Europe/Paris", hour12: false};
    gebi("time").innerHTML = now.toLocaleTimeString(locale, options);
    setTimeout(time, 100)
}

function date() {
    let options = { day: "numeric", month: "long", timeZone: "Europe/Paris", year: "numeric"};
    let now = new Date();
    gebi("date").innerHTML = now.toLocaleDateString(locale, options);
    setTimeout(date, 1000);
}

function startWeather(position) {
    const latitude = position.coords.latitude;
    const longitude = position.coords.longitude;
    const location = (await (await fetch(`***REMOVED***`)).text()).split("<city>")[1].split("</city>")[0];
    weather(location)
}

function weather(town) {
    fetch("https://wttr.in/" + town + "?format=%c+%t")
        .then(response => response.text())
        .then(text => {
            document.getElementById("weather").innerHTML = text;
        })
    setTimeout(()=>{weather(loc)}, 1200000)
}

function randChoice(arr) {
    return arr[Math.floor(Math.random()*arr.length)];
}

function submitForm() {
    searchQ = gebi("search-q");
    if (searchQ.value.startsWith("https://") || searchQ.value.startsWith("http://")) {
	window.open(searchQ.value, "_blank")
    } else {
        window.open(`https://duckduckgo.com/?q=${searchQ.value}`, "_blank")
    }
    searchQ.value=""
}

function main() {
    time();
    date();
    navigator.geolocation.getCurrentPosition(startWeather);
    window.onfocus = () => {
        window.setTimeout(() => gebi("search-q").focus(), 0);
    }
}
