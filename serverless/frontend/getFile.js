function getFileParam() {
    var params = location.search.substring(1).split("&")[0].split("=")[1];
    document.getElementById("file").innerHTML = params;
}
function restPost(url = '', data = {}) {
    const response = await fetch(url', {
        method: 'POST',
        body: JSON.stringify(data), 
        headers: {
            'Content-Type': 'application/json'
        }
    });
    return await response.json()
}
