//** LOAD
top10-emoticons-twitter

//** VIZ
var data = data();

ReportGrid.barChart("#chart1", {
	axes : ["emoticon", "count"],
	datapoints : data,
	options : {
		horizontal : true,
		download : true
	}
});

ReportGrid.barChart("#chart2", {
	axes : ["count", "emoticon"],
	datapoints : data,
	options : {
		horizontal : true,
		labelorientation : "align",
		download : true
	}
});

ReportGrid.barChart("#chart3", {
	axes : ["emoticon", "count"],
	datapoints : data,
	options : {
		horizontal : false,
		download : true
	}
});

ReportGrid.barChart("#chart4", {
	axes : ["count", "emoticon"],
	datapoints : data,
	options : {
		horizontal : false,
		labelorientation : "align",
		download : true
	}
});

//** HTML
<div id="chart1" class="chart"></div>
<div id="chart2" class="chart"></div>
<div id="chart3" class="chart"></div>
<div id="chart4" class="chart"></div>

//** STYLE
.chart
{
	width:  400px;
	height: 240px;
	display: block;
	float:  left;
}