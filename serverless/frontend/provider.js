function showUpload() {
    var x = document.getElementById("cloudProvider").value
    switch(x) {
        case "aws":
            document.getElementById("aws").style.display = "block";
            document.getElementById("azure").style.display = "none";
            document.getElementById("gcp").style.display = "none";
            break;
        case "azure":
            document.getElementById("aws").style.display = "none";
            document.getElementById("azure").style.display = "block";
            document.getElementById("gcp").style.display = "none";
            break;
        case "gcp":
            document.getElementById("aws").style.display = "none";
            document.getElementById("azure").style.display = "none";
            document.getElementById("gcp").style.display = "block";
            break;
        default:
            document.getElementById("aws").style.display = "none";
            document.getElementById("azure").style.display = "none";
            document.getElementById("gcp").style.display = "none";
    }
}