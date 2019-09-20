function getFileParam() {
    var params = location.search.substring(1).split("&")[0].split("=")[1];
    document.getElementById("file").innerHTML = "Run the following code: ${params}";
}