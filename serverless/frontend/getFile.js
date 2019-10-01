function getFileParam() {
    var params = location.search.substring(1).split("&")[0].split("=")[1];
    document.getElementById("file").innerHTML = `Run: ${params} with:`;
}
function convertForm() {
    var formData = JSON.stringify($("#runApp").serializeArray());
}
