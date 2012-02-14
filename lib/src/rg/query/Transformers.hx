package rg.query;

using Arrays;

class Transformers
{
	public static function crossStack(data : Array<Array<Dynamic>>)
	{
		if(data.length <= 1)
			return data;
		var src = data.shift();
		while(data.length > 0)
		{
			var values = data.shift(),
				results = [];
			for(item in src)
			{
				for(value in values)
				{
					results.push(Objects.copyTo(value, Objects.copyTo(item, {})));
				}
			}
			src = results;
		}
		return [src];
/*
		var results = [];
		for(item in data)
		{
			for(value in values)
			{
				results.push(Objects.copyTo(value, Objects.copyTo(item, {})));
			}
		}
		return results;
*/
	}

	public static function split(data : Array<Dynamic>, f : Dynamic -> String) : Array<Array<Dynamic>>
	{
		var map     = new Hash(),
			result  = [];
		data.each(function(dp, _) {
			var name = f(dp),
				pos  = map.get(name);
			if(null == pos)
			{
				pos = result.length;
				map.set(name, pos);
				result.push([]);
			}
			result[pos].push(dp);
		});

		return result;
	}

	public static function map(handler : Dynamic -> ?Int -> Dynamic)
	{
		return function(data : Array<Dynamic>) return data.map(handler);
	}

	public static function filter(handler : Dynamic -> Bool)
	{
		return function(data : Array<Dynamic>) return data.filter(handler);
	}

	public static function filterValues(o : Dynamic)
	{
		var entries = Objects.entries(o);
		entries.each(function(entry, _) {
			if(!Reflect.isFunction(entry.value))
			{
				var test = entry.value;
				entry.value = function(v) return v == test;
			}
		});
		function handler(d : Dynamic)
		{
			for(entry in entries)
			{
				if(!entry.value(Reflect.field(d, entry.key)))
					return false;
			}
			return true;
		}
		return function(data : Array<Dynamic>) return data.filter(handler);
	}

	public static function filterValue(name : String, o : Dynamic)
	{
		if(!Reflect.isFunction(o))
		{
			var test = o;
			o = function(v) return v == test;
		}
		function handler(d : Dynamic)
		{
			if(!o(Reflect.field(d, name)))
				return false;
			return true;
		}
		return function(data : Array<Dynamic>) return data.filter(handler);
	}

	public static function setField(name : String, o : Dynamic)
	{
		if(!Reflect.isFunction(o))
		{
			var value = o;
			o = function(obj, index) return value;
		}
		function handler(d : Dynamic, _)
		{
			Reflect.setField(d, name, o(Reflect.field(d, name), d));
		}
		return function(data : Array<Dynamic>)
		{
			data.each(handler);
			return data;
		}
	}

	public static function setFields(o : Dynamic)
	{
		var fields = Reflect.fields(o),
			fs = [];
		for(field in fields)
		{
			var f = Reflect.field(o, field);
			if(!Reflect.isFunction(f))
				fs.push(callback(function(value : Dynamic, d : Dynamic, _) {
					return value;
				}, f));
			else
				fs.push(f);
		}
		function handler(d : Dynamic, _)
		{
			for(j in 0...fields.length)
			{
				Reflect.setField(d, fields[j], fs[j](Reflect.field(d, fields[j]), _));
			}
		}
		return function(data : Array<Dynamic>)
		{
			data.each(handler);
			return data;
		}
	}

	public static function sort(handler : Dynamic -> Dynamic -> Int)
	{
		return function(data : Array<Dynamic>) return data.order(handler);
	}

	public static function limit(offset : Int, count : Int)
	{
		return function(data : Array<Dynamic>)
		{
			if (offset >= data.length)
				return [];
			var end = offset + count > data.length ? data.length : offset + count;
			return data.slice(offset, end);
		}
	}

	public static function reverse(arr : Array<Dynamic>)
	{
		arr.reverse();
		return arr;
	}

	public static function uniquef(?fun : Dynamic -> Dynamic -> Bool)
	{
		return function(arr : Array<Dynamic>)
		{
			var i = 0, j;
			while(i < arr.length - 1)
			{
				var cur = arr[i];
				j = arr.length - 1;
				while(j > i)
				{
					if(fun(cur, arr[j]))
					{
						arr.splice(j, 1);
					}
					j--;
				}
				i++;
			}
			return arr;
		};
	}

	public static function rotate(?matchingf : Dynamic -> Dynamic -> Bool){
		if(Std.is(matchingf, String))
		{
			var field : String = cast matchingf;
			matchingf = function(a, b) return Reflect.field(a, field) == Reflect.field(b, field);
		}
		var m = null == matchingf ? function(_, _, i, k) return i == k : function(a, b, _, _) return matchingf(a, b);
		return function(data : Array<Array<Dynamic>>)
		{
			var traversed = [],
				da = data[0];
			for(i in 0...da.length)
			{
				var a = da[i],
					traversal = [a];
				for(j in 1...data.length)
				{
					var db = data[j];
					for(k in 0...db.length)
					{
						var b = db[k];
						if(m(a, b, i, k))
						{
							traversal.push(b);
							break;
						}
					}
				}
				traversed.push(traversal);
			}
			return traversed;
		}
	}
}