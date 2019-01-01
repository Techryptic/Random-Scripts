<?php

/*
 * When you want to upload a file from a box that only has web access.
 *
 * change the php.ini file for apache to have the following values:
memory_limit = 2G
upload_max_filesize = 2G
post_max_size = 2G

 * then restart apache: systemctl restart apache2
 * Also, create an 'uploads' directory, that's writable to the appropriate user
 * Then: chown www-data:www-data uploads
 * Test upload on a small file first.
 */
?>

<!DOCTYPE html>
<html>
<head>
  <title>Upload your files</title>
</head>
<body>
  <form enctype="multipart/form-data" action="No-Access-Upload.php" method="POST">
    <p>Upload your file</p>
    <input type="file" name="uploaded_file"></input><br />
    <input type="submit" value="Upload"></input>
  </form>
</body>
</html>
<?php
  if(!empty($_FILES['uploaded_file']))
  {
    $path = "uploads/";
    $path = $path . basename( $_FILES['uploaded_file']['name']);
    if(move_uploaded_file($_FILES['uploaded_file']['tmp_name'], $path)) {
      echo "The file ".  basename( $_FILES['uploaded_file']['name']). 
      " has been uploaded";
    } else{
        echo "There was an error uploading the file, please try again!";
        print_r($_FILES);
    } 
  }
