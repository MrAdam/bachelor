<?
$mysqli = new mysqli('127.0.0.1','root','toor','bachelor');
  if ($mysqli->connect_error)
    die('Fejl: ('. $mysqli->connect_errno .') '. $mysqli->connect_error);
$persons = $mysqli->query('SELECT count(*) FROM person');
?>

<!DOCTYPE html>
<html>
<head>
  <title>Bachelor Thesis Stats</title>
</head>
<body>
  <table>
    <tr>
      <td># of persons</td>
      <td><? print($persons); ?></td>
    </tr>
  </table>
</body>
</html>
