package rg.query;

using Arrays;

class Query extends BaseQuery<Query>
{
	public static function create()
	{
		var start = new Query(),
			query = start._createQuery(function(data : Array<Array<Dynamic>>, handler : Array<Array<Dynamic>> -> Void) { handler(data); }, start);
		start._next = query;
		return query;
	}

	function new()
	{
		super(null, this);
	}

	override public function execute(handler : Array<Dynamic> -> Void) : Void
	{
		executeHandler(this, handler);
	}

	public static function executeHandler(instance : BaseQuery<Dynamic>, handler : Array<Dynamic> -> Void)
	{
		var current : BaseQuery<Dynamic> = instance._next;
		function execute(result : Array<Array<Dynamic>>)
		{
			if(null == current._next)
			{
				handler(result.flatten());
				return;
			}
			current = current._next;
			current._async(result, execute);
		}
		execute([]);
	}
}

class BaseQuery<This>
{
	var _first : BaseQuery<This>;
	var _next : BaseQuery<This>;
	var _async : AsyncStack;
	var _store : Hash<Array<Array<Dynamic>>>;

	public function new(async : AsyncStack, first : BaseQuery<This>)
	{
		this._async = async;
		this._first = first;
		this._store = new Hash();
	}

	public function load(handler : (Array<Dynamic> -> Void) -> Void)
	{
		return asyncStack(function(stack, h) {
			handler(function(data) {
				stack.push(data);
				h(stack);
			});
		});
	}

	public function data(values : Array<Dynamic>)
	{
		if(!Std.is(values, Array))
			values = [values];
		return asyncStack(function(stack, h) {
			stack.push(values);
			h(stack);
		});
	}

	public function cross()
	{
		return transformStack(Transformers.crossStack);
	}

	public function map(handler : Dynamic -> ?Int -> Dynamic)
	{
		return transform(Transformers.map(handler));
	}

	public function audit(f : Array<Dynamic> -> Void)
	{
		return transform(function(d : Array<Dynamic>) : Array<Dynamic> {
			f(d);
			return d;
		});
	}

	public function renameFields(o : Dynamic)
	{
		var pairs = Reflect.fields(o).map(function(d, _) {
			return {
				src : d,
				dst : Reflect.field(o, d)
			};
		});
		return map(function(src : Dynamic, ?_) : Dynamic {
			var out = {};
			for(pair in pairs)
			{
				Reflect.setField(out, pair.dst, Reflect.field(src, pair.src));
			}
			return out;
		});
	}

	public function transform(t : Transformer)
	{
		return asyncStack(asyncTransform(t));
	}

	public function transformStack(t : StackTransformer)
	{
		return asyncStack(asyncTransformStack(t));
	}

	public function asyncStack(f : AsyncStack)
	{
		var query = _createQuery(f, this._first);
		this._next = query;
		return _this(query);
	}

	public function asyncAll(f : Async)
	{
		return asyncStack(function(data : Array<Array<Dynamic>>, handler : Array<Array<Dynamic>> -> Void) {
			var tot    = data.length,
				pos    = 0,
				result = [];
			function complete(i : Int, r : Array<Dynamic>)
			{
				result[i] = r;
				if(++pos == tot)
				{
					handler(result);
//					handler(result.flatten());
				}
			}
			for(i in 0...data.length)
			{
				f(data[i], callback(complete, i));
			}
		});
	}

	public function asyncEach(f : Dynamic -> (Array<Dynamic> -> Void) -> Void)
	{
		return asyncAll(function(data : Array<Dynamic>, handler : Array<Dynamic> -> Void) {
			var tot    = data.length,
				pos    = 0,
				result = [];
			function complete(i : Int, r : Array<Dynamic>)
			{
				// preserve the order of the operations
				result[i] = r;
				if(++pos == tot)
				{
					handler(result.flatten());
				}
			}
			for(i in 0...data.length)
			{
				f(data[i], callback(complete, i));
			}
		});
	}

	public function setField(name : String, f : Dynamic)
	{
		return transform(Transformers.setField(name, f));
	}

	public function setFields(o : Dynamic)
	{
		return transform(Transformers.setFields(o));
	}

	public function addIndex(?name : String, ?start : Int)
	{
		if(null == name) name = "index";
		if(null == start) start = 0;
		return transform(Transformers.setField(name, function(_, _, i) return start + i));
	}

	public function filter(f : Dynamic -> Bool)
	{
		return transform(Transformers.filter(f));
	}

	public function filterValues(f : Dynamic)
	{
		return transform(Transformers.filterValues(f));
	}


	public function filterValue(name : String, f : Dynamic)
	{
		return transform(Transformers.filterValue(name, f));
	}

	public function sort(f : Dynamic -> Dynamic -> Int)
	{
		return transform(Transformers.sort(f));
	}

	public function sortField(field : String, ?reverse : Bool)
	{
		return sortFields([field], [reverse]);
	}

	public function sortFields(fields : Array<String>, ?reverse : Dynamic)
	{
		var rarr : Array<Bool>;
		if(null == reverse)
			rarr = Ints.range(0, fields.length).map(function(_, _) return false);
		else if(!Std.is(reverse, Array))
			rarr = Ints.range(0, fields.length).map(function(_, _) return reverse);
		else
			rarr = reverse;
		while(rarr.length < fields.length)
			rarr.push(false);
		return sort(function(a, b) {
			var r, field;
			for(i in 0...fields.length)
			{
				field = fields[i];
				r = (rarr[i] ? -1 : 1) * Dynamics.compare(Reflect.field(a, field), Reflect.field(b, field));
				if(r != 0)
					return r;
			}
			return 0;
		});
	}

	public function limit(?offset : Int, count : Int)
	{
		if(null == count)
		{
			count = offset;
			offset = 0;
		}
		return transform(Transformers.limit(offset, count));
	}

	public function reverse()
	{
		return transform(Transformers.reverse);
	}

	public function unique(?f : Dynamic -> Dynamic -> Bool)
	{
		if(null == f)
			f = Dynamics.same;
		return transform(Transformers.uniquef(f));
	}

	public function reduce(startf : Dynamic -> Dynamic, reducef : Dynamic -> Dynamic -> Int -> Dynamic)
	{
		return transform(function(data : Array<Dynamic>) {
			return [Arrays.reduce(data.slice(1), reducef, startf(data[0]))];
		});
	}

	// stack operations

	public function merge()
	{
		return asyncStack(asyncTransformStack(function(data : Array<Array<Dynamic>>){
			return [data.flatten()];
		}));
	}

	public function discard(?howmany : Int)
	{
		if(null == howmany) howmany = 1;
		return asyncStack(asyncTransformStack(function(data : Array<Array<Dynamic>>){
			for(i in 0...howmany)
				data.pop();
			return data;
		}));
	}

	public function keep(?howmany : Int)
	{
		if(null == howmany) howmany = 1;
		return asyncStack(asyncTransformStack(function(data : Array<Array<Dynamic>>){
			return data.slice(0, howmany);
		}));
	}

	public function split(f : Dynamic -> String)
	{
		if(Std.is(f, String))
		{
			var name : String = cast f;
			f = function(o) {
				return Reflect.field(o, name);
			}
		}
		return asyncStack(asyncTransformStack(function(data : Array<Array<Dynamic>>){
			var result = [];
			for(arr in data)
			{
				result = result.concat(Transformers.split(arr, f));
			}
			return result;
		}));
	}

	public function stackOperation(operationf : Dynamic -> Dynamic -> Void, ?matchingf : Dynamic -> Dynamic -> Bool)
	{
		return stackTraverse(function(data : Array<Dynamic>) {
			for(i in 0...data.length-1)
				operationf(data[i], data[i+1]);
		}, matchingf);
	}

	public function stackTraverse(traversef : Array<Dynamic> -> Void, ?matchingf : Dynamic -> Dynamic -> Bool)
	{
		var t = Transformers.rotate(matchingf);
		return asyncStack(asyncTransformStack(function(data : Array<Array<Dynamic>>){
			var result = t(data);
			for(arr in result)
				traversef(arr);
			return data;
		}));
	}

	public function stackRotate(?matchingf : Dynamic -> Dynamic -> Bool)
	{
		var t = Transformers.rotate(matchingf);
		return asyncStack(asyncTransformStack(function(data : Array<Array<Dynamic>>){
			return t(data);
		}));
	}

	public function stackReverse()
	{
		return asyncStack(asyncTransformStack(function(data : Array<Array<Dynamic>>){
			data.reverse();
			return data;
		}));
	}
/*
	public function stackReduce(startf : Dynamic -> Dynamic, reducef : Dynamic -> Dynamic -> Dynamic, matchingf : Dynamic -> Dynamic -> Bool)
	{
		return asyncStack(asyncTransformStack(function(data : Array<Array<Dynamic>>){
			var result = [],
				da = data[0];
			for(i in 0...da.length)
			{
				var a = da[i],
					s = startf(a);
				for(j in 1...data.length)
				{
					var db = data[j];
					for(k in 0...db.length)
					{
						var b = db[k];
						if(matchingf(a, b))
							s = reducef(s, b);
					}
				}
				result.push(s);
			}
			return result;
		}));
	}
*/
/*
	public function accumulate(groupby : String, on : String, forproperty : String, atproperty : String)
	{
		var map = new Hash();
		var q = sortFields([groupby, on]);
		return _query(q).transform(function(data : Array<Array<Dynamic>>){
			var v : Float, f : String;
			data.each(function(dp, _) {
				v = map.get(f = "" + Reflect.field(dp, on));
				if(null == v) v = 0.0;
				Reflect.setField(dp, atproperty, v);
				map.set(f, v + Reflect.field(dp, forproperty));
			});
			return data;
		});
	}
*/
	public function store(?name : String)
	{
		if(null == name)
			name = "";
		return transformStack(function(arr : Array<Array<Dynamic>>) {
			_first._store.set(name, arr.copy());
			return arr;
		});
	}

	public function retrieve(?name : String)
	{
		if(null == name)
			name = "";
		return transformStack(function(arr : Array<Array<Dynamic>>) {
			return arr.concat(_first._store.get(name));
		});
	}

	public function clear()
	{
		return transformStack(function(_) {
			return [];
		});
	}

	public function execute(handler : Array<Dynamic> -> Void)
	{
		_first.execute(handler);
	}

	inline function _query(t : This) : BaseQuery<This> return cast t

	function _createQuery(async : AsyncStack, first : BaseQuery<This>) : BaseQuery<This>
	{
		return new BaseQuery(async, first);
	}

	static function asyncTransform(t : Transformer) : AsyncStack
	{
		return function(data : Array<Array<Dynamic>>, handler : Array<Array<Dynamic>> -> Void)
		{
			for(i in 0...data.length)
				data[i] = t(data[i]);
			handler(data);
		}
	}

	static function asyncTransformStack(t : StackTransformer) : AsyncStack
	{
		return function(data : Array<Array<Dynamic>>, handler : Array<Array<Dynamic>> -> Void)
		{
			handler(t(data));
		}
	}

	public function toString() return Type.getClassName(Type.getClass(this)).split(".").pop() + Std.format(" [next: ${null != _next}, async: ${null != _async}]")

	inline function _this(q) : This return cast q
}

typedef StackTransformer = Array<Array<Dynamic>> -> Array<Array<Dynamic>>;
typedef Transformer = Array<Dynamic> -> Array<Dynamic>;

typedef AsyncStack = Array<Array<Dynamic>> -> (Array<Array<Dynamic>> -> Void) -> Void;
typedef Async = Array<Dynamic> -> (Array<Dynamic> -> Void) -> Void;