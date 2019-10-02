function getFileParam() {
    var params = location.search.substring(1).split("&")[0].split("=")[1];
    document.getElementById("file").innerHTML = params;
}
function convertForm() {
    var formData = JSON.stringify($("#runApp").serializeArray());
    alert(formData);
}
