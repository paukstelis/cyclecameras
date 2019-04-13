<?php
$camera = $_GET['camera'];
exec("sh ./cyclecamera.sh $camera");
sleep(1);
header( 'Location: http://mysitehere:8001/?action=stream' );
?>

