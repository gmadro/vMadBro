function getFileParam() {
    var params = location.search.substring(1).split("&")[1];
    alert(params);
}