function getFileParam() {
    var params = location.search.substring(1).split("&")[0].split("=")[1];
    document.getElementById("file").innerHTML = `Run: ${params} with:`;
}
function convertForm() {
    const formData = new FormData();
    let jsonObject = {};

    for (const [key, value] of formData.entries()) {
        jsonObject[key] = value;
    }
}