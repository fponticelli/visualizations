//** QUERY
ReportGrid.query
	.data([{ a : 1}, { b : 2 }])
	.store("first").clear()
	.data([{ c : 3}, { d : 4 }])
	.store("second").clear()
	.data([{ e : 5}, { f : 6 }])
	.store("third").clear()
	.retrieve("first")
	.retrieve("second")
	.retrieve("third")