//** LOAD
impressions

//** QUERY
ReportGrid.query
	.data(data())
	.setField({
		gender : "sex",
		age    : "years"
	})