function getFileParam() {
    var params = new URLSearchParams(document.location.search);
    var file = params.get("file");
    document.getElementById("file").innerHTML = file;
}