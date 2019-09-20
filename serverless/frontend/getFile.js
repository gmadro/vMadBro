function getFileParam() {
    var params = location.search.substring(1).split("&")[0];
    document.getElementById("file").innerHTML = params;
}