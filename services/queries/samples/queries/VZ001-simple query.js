//** QUERY
ReportGrid.query
	.values({
		path : "/query/test",
		event : "impression",
		property : "gender"
	})
	.count()

//** VIZ
ReportGrid.barChart("#chart", {
	axes : ['gender', 'count'],
	load : loader
})