<?php

define('SAMPLES_CHARTS_DIR', 'samples/charts/');
define('SAMPLES_DATA_DIR', 'samples/data/');
define('SAMPLE_EXT', '.js');
define('MANAGE_CODE', '67ww78bhFGY!543fv');
define('AUTHCODE_LOCALHOST', 'IGLBxMA3vSoTDWz+Fu3cjPZNmdpS+fYSlwyN7LvpssTRTRpE4Lt+hqO9nX6LaLf2SZZBVf7vFDTyUID1uWUdoPC73kAA9HVzsOZwxO5jY+NdazmeBwK64oD5vRkxth5vO3ejfjx0nkh7mgaoSwde0zri1V+b+SVHR92RidT5Isk=');

$viz_categories = array(
	'SK' => array("name" => 'Sankey',				"sequence" => 0),
	'GE' => array("name" => 'Geo Chart',			"sequence" => 10),
	'GB' => array("name" => 'Geo Bubble Chart',		"sequence" => 15),
	'FC' => array("name" => 'Funnel Chart',			"sequence" => 20),
	'HM' => array("name" => 'Heatmap',				"sequence" => 30),
	'BS' => array("name" => 'Stacked Bar Chart',	"sequence" => 35),
	'BC' => array("name" => 'Bar Chart',			"sequence" => 40),
	'BP' => array("name" => 'Bar Percent Chart',	"sequence" => 45),
	'SG' => array("name" => 'Stream Graph',			"sequence" => 50),
	'SP' => array("name" => 'Scatter Plot',			"sequence" => 60),
	'SB' => array("name" => 'Bubble Chart',			"sequence" => 65),
	'LS' => array("name" => 'Stacked Area Chart',	"sequence" => 70),
	'LA' => array("name" => 'Area Chart',			"sequence" => 73),
	'LP' => array("name" => 'Area Percent Chart',	"sequence" => 75),
	'LC' => array("name" => 'Line Chart',			"sequence" => 76),
	'PC' => array("name" => 'Pie Chart',			"sequence" => 80),
	'PD' => array("name" => 'Donut Chart',			"sequence" => 85),
	'PT' => array("name" => 'Pivot Table',			"sequence" => 90),
	'BB' => array("name" => 'Leaderboard',			"sequence" => 100)
);

if(in_array($_SERVER['SERVER_NAME'], array('localhost')) || intval($_SERVER['SERVER_NAME']) > 0)
{
	define('REPORTGRID_VIZ_API', '/rg/charts/js/reportgrid-charts.js?authCode='.urlencode(AUTHCODE_LOCALHOST));
	define('REPORTGRID_CSS_API', '/rg/charts/css/rg.css');
	$viz_categories['XX'] = array('name' => 'Test', 'sequence' => 1000);
} else {
	define('REPORTGRID_VIZ_API', 'http://api.reportgrid.com/js/reportgrid-charts.js');
	define('REPORTGRID_CSS_API', 'http://api.reportgrid.com/css/rg.css');
}

function categories()
{
	global $viz_categories;
	$result = array();
	foreach($viz_categories as $key => $value)
	{
		$result[] = array(category => $value['name'], code => $key);
	}
	return $result;
}

function categoryOptions($cat)
{
	$d = dir(SAMPLES_CHARTS_DIR);
	$results = array();
	while(false !== ($entry = $d->read())) {
		if($cat != ($p = substr($entry, 0, 2)))
			continue;
		$results[] = array('sample' => $entry, 'title' => extractTitle($entry));
	}
	usort($results, optionComparison);
	return $results;
}

function extractTitle($sample)
{
	return array_pop(explode('-', basename($sample, SAMPLE_EXT), 2));
}

function compareCategory($v)
{
	global $viz_categories;
	$c = @$viz_categories[substr($v, 0, 2)]['sequence'];
	if($c === null)
		return 1000;
	else
		return $c;
}

function sampleComparison($a, $b)
{
	$v = compareCategory($a['sample']) - compareCategory($b['sample']);
	if($v !== 0)
		return $v;
	else
		return $a['sample']>$b['sample'];
}

function optionComparison($a, $b)
{
	return substr($a['sample'], 2) > substr($b['sample'], 2);
}

function listSamples($filtered = true)
{
	$d = dir(SAMPLES_CHARTS_DIR);
	$results = array();
	while(false !== ($entry = $d->read())) {
		if(('.' == ($c = substr($entry, 0, 1))) || ($filtered && ($c == '_' || $c == '-')))
			continue;
		$results[] = array('sample' => $entry, 'title' => extractTitle($entry));
	}
	usort($results, sampleComparison);
	return $results;
}

function infoSample($sample)
{
	$result = parseContent(file_get_contents(SAMPLES_CHARTS_DIR.basename($sample)));
	$result['title']  = extractTitle($sample);
	$result['sample'] = $sample;
	return $result;
}

function parseContent($content)
{
	$info = array();
	$parts = explode('//**', $content);
	foreach($parts as $part)
	{
		$pair = explode("\n", $part, 2);
		// first line is the section
		$key = trim(strtolower($pair[0]));
		if(!$key) continue;
		// the rest is the content
		$value = trim($pair[1]);
		if($key == 'load')
		{
			$info['data'] = 'var data = '.file_get_contents(SAMPLES_DATA_DIR.$value.'.json').";";
		} else {
			$info[$key] = $value;
		}
	}

	return $info;
}

function display($sample)
{
	$info = infoSample($sample);
	$VIZ_API = REPORTGRID_VIZ_API;
	$CSS_API = REPORTGRID_CSS_API;
	require('template.php');
	exit;
}

function delete($list)
{
	if(in_array($_SERVER['SERVER_NAME'], array('localhost')))
	{
		echo "CAN'T DELETE ON LOCALHOST<br>";
		var_dump($list);
		return;
	}
	foreach($list as $item)
	{
		$file = SAMPLES_CHARTS_DIR.$item;
		unlink($file);
	}
}

function deleteAll()
{
	$result = array();
	foreach(listSamples(false) as $item)
		$result[] = $item['sample'];
	delete($result);
}

function manage()
{
	if(isset($_POST))
	{
		switch($_POST['action'])
		{
			case "delete":
				delete($_POST['selected']);
				break;
			case "deleteall":
				deleteAll();
				break;
		}
	}
	$list = listSamples(false);
	require('template-manage.php');
	exit();
}

function json($v)
{
	$json = json_encode($v);
	if($_GET['callback'])
	{
		echo $_GET['callback']."($json);";
	} else {
		echo $json;
	}
	exit;
}

if(!isset($_GET['action']))
{
	echo "<ul>\n";
	foreach(listSamples() as $item)
		echo "\t<li>{$item['title']}</li>\n";
	echo "</ul>";
	exit;
}

switch($_GET['action'])
{
	case 'list':
		json(listSamples());
	case 'categories':
		json(categories());
	case 'options':
		json(categoryOptions($_GET['category']));
	case 'info':
		json(infoSample($_GET['sample']));
	case 'display':
		display($_GET['sample']);
//	case 'manage':
//		if($_GET['code'] == MANAGE_CODE)
//			manage();
	default:
		echo "INVALID ACTION";
}