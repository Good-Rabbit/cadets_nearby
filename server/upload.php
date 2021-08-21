<?php
 
    $image = $_POST['image'];
    $name = $_POST['name'];
 
    $img = base64_decode($image);
 
    $name = "<location in server>".$name;
    file_put_contents($name, $img);
 
    echo "Image Uploaded Successfully.";
 
?>