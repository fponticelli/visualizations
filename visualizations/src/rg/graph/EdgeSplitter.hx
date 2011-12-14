package rg.graph;

class EdgeSplitter
{
	public function new(){}

	public function split<TNodeData, TEdgeData>(layout : GraphLayout<TNodeData, TEdgeData>, ?splitf : GEdge<TNodeData, TEdgeData> -> GEdge<TNodeData, TEdgeData> -> Int -> Void) : GraphLayout<TNodeData, TEdgeData>
	{
		var layers = layout.layers(), cell, ocell;
		if(null == splitf)
			splitf = function(_,_,_) {};
		for(node in layout.graph.nodes)
		{
			cell = layout.cell(node);
			for(edge in node.positives())
			{
				ocell = layout.cell(edge.head);
				if(cell.layer == ocell.layer)
					continue; // same layer
				if(cell.layer == ocell.layer - 1)
					continue; // previous layer
				if(cell.layer == ocell.layer + 1)
					continue; // next layer
				var sign = (cell.layer < ocell.layer ? 1 : -1),
					diff =  Ints.abs(ocell.layer - cell.layer) -1;
				edge.split(diff, function(ea, eb, i) {
					layers[cell.layer + (1+i)*sign].push(ea.head.id);
					splitf(ea, eb, i);
				});
			}
		}
		return new GraphLayout(layout.graph, layers);
	}
}