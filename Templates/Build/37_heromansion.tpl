<?php
if($_GET['gid']==37 && isset($_GET['del'])){
	$database->removeOases($_GET['del']);
    mysql_query("UPDATE ".TB_PREFIX."wdata SET occupied = 0 WHERE id = ".$_GET['del']."");
}

?>
<div class="clear"></div>
<h4>آبادی‌های تسخیر شده از دهکده‌ی <?php echo $village->vname; ?></h4>

<table id="oasesOwned" cellpadding="1" cellspacing="1">
	<thead><tr><td>نوع</td><td>وفاداری</td><td>تسخیر شده</td><td>مختصات</td><td>منابع</td></tr></thead>
	<tbody>
<?php
$prefix = "".TB_PREFIX."odata";
$sql = mysql_query("SELECT * FROM $prefix WHERE owner = $session->uid AND conqured = $village->wid ORDER BY lastupdated ASC");
$query = mysql_num_rows($sql);
if($query>0){
while($row = mysql_fetch_array($sql)){ 
    $wref = $row["wref"];
    $type = $row["type"];
    $conqured = $row["conqured"];
    $lastupdated = $row["lastupdated"];
    $loyalty = $row["loyalty"];
    $owner = $row["owner"];
?>
    <tr>
				<td class="type">
					<a onclick="return (function(){
				('آیا مطمئن هستید؟').dialog(
				{
					onOkay: function(dialog, contentElement)
					{
						window.location.href = 'build.php?gid=37&amp;c=<?php echo $generator->getMapCheck($wref); ?>&amp;del=<?php echo $wref; ?>'}
				});
				return false;
			})()">
						<img class="del" src="img/x.gif" alt="حذف">
					</a>
<?php
switch($type) {
case 1:
case 2:
case 3:
$tname =  "جنگل";
break;
case 4:
case 5:
case 6:
$tname =  "تپه";
break;
case 7:
case 8:
case 9:
$tname =  "معدن";
break;
case 10:
case 11:
case 12:
$tname =  "دریاچه";
break;
}
?>
					<a href="karte.php?d=<?php echo $wref; ?>&c=<?php echo $generator->getMapCheck($wref); ?>"><?php echo $tname; ?></a>
				</td>
				<td class="zp"><?php echo $loyalty; ?>%</td>
				<td class="owned"><?php echo date('y/m/d',$lastupdated); ?> <?php echo date('H:i',$lastupdated); ?></td>
				<td class="coords">
                <?php
$coor = $database->getCoor($wref);
switch($type) {
case 1:
$tt =  "<span><img class='r1' src='img/x.gif' title='چوب'> 25%</span>";
break;
case 2:
$tt =  "<span><img class='r1' src='img/x.gif' title='چوب'> 50%</span>";
break;
case 3:
$tt =  "<span><img class='r1' src='img/x.gif' title='چوب'> 25%</span><span><img class='r4' src='img/x.gif' title='گندم'> 25%</span>";
break;
case 4:
$tt =  "<span><img class='r2' src='img/x.gif' title='خشت'> 25%</span>";
break;
case 5:
$tt =  "<span><img class='r2' src='img/x.gif' title='خشت'> 50%</span>";
break;
case 6:
$tt =  "<span><img class='r2' src='img/x.gif' title='خشت'> 25%</span><span><img class='r4' src='img/x.gif' title='گندم'> 25%</span>";
break;
case 7:
$tt =  "<span><img class='r3' src='img/x.gif' title='آهن'> 25%</span>";
break;
case 8:
$tt =  "<span><img class='r3' src='img/x.gif' title='آهن'> 50%</span>";
break;
case 9:
$tt =  "<span><img class='r3' src='img/x.gif' title='آهن'> 25%</span><span><img class='r4' src='img/x.gif' title='گندم'> 25%</span>";
break;
case 10:
case 11:
$tt =  "<span><img class='r4' src='img/x.gif' title='گندم'> 25%</span>";
break;
case 12:
$tt =  "<span><img class='r4' src='img/x.gif' title='گندم'> 50%</span>";
break;
}
?>
                <a class="" href="karte.php?x=<?php echo $coor['x']; ?>&amp;y=<?php echo $coor['y']; ?>">
                <span class="coordinates coordinatesAligned">
                <span class="coordinatesWrapper">
                <span class="coordinateY"><?php echo $coor['y']; ?>)</span>
                <span class="coordinatePipe">|</span>
                <span class="coordinateX">(<?php echo $coor['x']; ?></span>
                </span></span>
                <span class="clear">‎</span></a>
                </td>
				<td class="res"><?php echo $tt; ?></td>
                </tr>
<?php } } ?>
                </tbody></table>
<?php
	if($query == 0){
    	echo '<div class="nextOases none">1. آبادی بعدی از عمارت قهرمان سطح 10</div><div class="nextOases none">2. آبادی بعدی از عمارت قهرمان سطح 15</div><div class="nextOases none">3. آبادی بعدی از عمارت قهرمان سطح 20</div>';
	}if($query == 1){
    	echo '<div class="nextOases none">2. آبادی بعدی از عمارت قهرمان سطح 15</div><div class="nextOases none">3. آبادی بعدی از عمارت قهرمان سطح 20</div>';
	}elseif($query == 2){
    	echo '<div class="nextOases none">3. آبادی بعدی از عمارت قهرمان سطح 20</div>';
    }else{
    	echo '';
    }
?>


<h4 class="spacer">آبادی های دیگر قابل تسخیر از دهکده‌ی <?php echo $village->vname; ?></h4>



<table id="oasesSurround" cellpadding="1" cellspacing="1">
	<thead><tr><td>نوع</td><td>صاحب</td><td>دهکده</td><td>مختصات</td><td>منابع</td></tr></thead>
    <tbody>
<?php
    $getoasis = mysql_query("SELECT * FROM ".TB_PREFIX."wdata WHERE oasistype > 0");
    $coor2 = $database->getCoor($village->wid);

	function getDistance($coorx1, $coory1, $coorx2, $coory2) {
		$max = 2 * WORLD_MAX + 1;
		$x1 = intval($coorx1);
		$y1 = intval($coory1);
		$x2 = intval($coorx2);
		$y2 = intval($coory2);
		$distanceX = min(abs($x2 - $x1), abs($max - abs($x2 - $x1)));
		$distanceY = min(abs($y2 - $y1), abs($max - abs($y2 - $y1)));
		$dist = sqrt(pow($distanceX, 2) + pow($distanceY, 2));
		return round($dist, 1);
	}
        
        
		while($row2 = mysql_fetch_array($getoasis)) {
			$dist = getDistance($coor2['x'], $coor2['y'], $row2['x'], $row2['y']);
			$rows[$dist] = $row2;
        }
        
        ksort($rows);  
        
        $limit = 1;
        foreach($rows as $dist => $row2) {
        	if($limit <= 10){
            $basearray = $database->getOMInfo($row2['id']);
            echo "<tr><td class=\"type\">";
            switch($basearray['type']) {
                case 1:
                case 2:
                case 3:
                $tname =  "جنگل";
                break;
                case 4:
                case 5:
                case 6:
                $tname =  "تپه";
                break;
                case 7:
                case 8:
                case 9:
                $tname =  "معدن";
                break;
                case 10:
                case 11:
                case 12:
                $tname =  "دریاچه";
                break;
            }
            echo "<a href=\"karte.php?d=".$row2['id']."&c=".$generator->getMapCheck($row2['id'])."\">".$tname."</a></td>";
            
            if($basearray['owner']==3){
                $oOwner = "-";
            }else{
                $oOwner = $database->getUserField($basearray['owner'],username,0);
            }
            echo "<td class=\"nam\">".$oOwner."</td>";
            if($basearray['conqured']==0){
                $oVillage = "-";
            }else{
                $oVillage = $database->getVillage($basearray['conqured']);
            }
            echo "<td class=\"vil\">".$oVillage['name']."</td>";
            echo "<td class=\"coords\">";
            echo "<a href=\"karte.php?z=".$row2['id']."\">
                  <span class=\"coordinates coordinatesAligned\"><span class=\"coordinatesWrapper\">
                  <span class=\"coordinateY\">".$row2['x'].")</span>
                  <span class=\"coordinatePipe\">|</span>
                  <span class=\"coordinateX\">(".$row2['y']."</span></span></span><span class=\"clear\">‎</span></a>";
            echo "</td>";
            switch($basearray['type']) {
                case 1:
                $ttt =  "<span><img class='r1' src='img/x.gif' title='چوب'> 25%</span>";
                break;
                case 2:
                $ttt =  "<span><img class='r1' src='img/x.gif' title='چوب'> 50%</span>";
                break;
                case 3:
                $ttt =  "<span><img class='r1' src='img/x.gif' title='چوب'> 25%</span><span><img class='r4' src='img/x.gif' title='گندم'> 25%</span>";
                break;
                case 4:
                $ttt =  "<span><img class='r2' src='img/x.gif' title='خشت'> 25%</span>";
                break;
                case 5:
                $ttt =  "<span><img class='r2' src='img/x.gif' title='خشت'> 50%</span>";
                break;
                case 6:
                $ttt =  "<span><img class='r2' src='img/x.gif' title='خشت'> 25%</span><span><img class='r4' src='img/x.gif' title='گندم'> 25%</span>";
                break;
                case 7:
                $ttt =  "<span><img class='r3' src='img/x.gif' title='آهن'> 25%</span>";
                break;
                case 8:
                $ttt =  "<span><img class='r3' src='img/x.gif' title='آهن'> 50%</span>";
                break;
                case 9:
                $ttt =  "<span><img class='r3' src='img/x.gif' title='آهن'> 25%</span><span><img class='r4' src='img/x.gif' title='گندم'> 25%</span>";
                break;
                case 10:
                case 11:
                $ttt =  "<span><img class='r4' src='img/x.gif' title='گندم'> 25%</span>";
                break;
                case 12:
                $ttt =  "<span><img class='r4' src='img/x.gif' title='گندم'> 50%</span>";
                break;
            }
            echo "<td class=\"res\">".$ttt."</td>";
            echo "</tr>";
           	$limit++;
        }
        }
?>

	</tbody>
</table>