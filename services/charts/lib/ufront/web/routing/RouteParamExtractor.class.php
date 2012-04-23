<?php

class ufront_web_routing_RouteParamExtractor {
	public function __construct($ast) {
		if(!php_Boot::$skip_constructor) {
		if(null === $ast) {
			throw new HException(new thx_error_NullArgument("ast", "invalid null argument '{0}' for method {1}.{2}()", _hx_anonymous(array("fileName" => "RouteParamExtractor.hx", "lineNumber" => 17, "className" => "ufront.web.routing.RouteParamExtractor", "methodName" => "new"))));
		}
		$this->ast = $ast;
	}}
	public $ast;
	public $data;
	public function extract($uri) {
		if(null === $uri) {
			throw new HException(new thx_error_NullArgument("uri", "invalid null argument '{0}' for method {1}.{2}()", _hx_anonymous(array("fileName" => "RouteParamExtractor.hx", "lineNumber" => 23, "className" => "ufront.web.routing.RouteParamExtractor", "methodName" => "extract"))));
		}
		$segments = _hx_explode("/", $uri);
		if($segments->length <= 1) {
			throw new HException(new thx_error_Error("the uri must begin with a '/' character", null, null, _hx_anonymous(array("fileName" => "RouteParamExtractor.hx", "lineNumber" => 27, "className" => "ufront.web.routing.RouteParamExtractor", "methodName" => "extract"))));
		}
		$this->data = new Hash();
		$segments->shift();
		$segment = null;
		$patterns = $this->ast->copy();
		while(true) {
			$pattern = $patterns->shift();
			$isrest = null !== $pattern && $pattern->rest;
			if(null !== $segment) {
				if($isrest) {
					$segment .= "/" . $segments->join("/");
				}
			} else {
				if($isrest) {
					$segment = $segments->join("/");
					$segments = new _hx_array(array());
				} else {
					$segment = $segments->shift();
				}
			}
			if(null === $segment) {
				if(null === $pattern) {
					break;
				}
				if($pattern->optional) {
					continue;
				} else {
					return null;
				}
			} else {
				if(null === $pattern) {
					return null;
				}
			}
			if($this->tryExtractParts($segment, $pattern->parts)) {
				$segment = null;
				continue;
			} else {
				if($pattern->optional) {
					continue;
				} else {
					return null;
				}
			}
			unset($pattern,$isrest);
		}
		return $this->data;
	}
	public function tryExtractParts($segment, $parts) {
		$pattern = $this->buildPattern($parts);
		$re = new EReg($pattern->pattern, "");
		if(!$re->match($segment)) {
			return false;
		}
		{
			$_g1 = 0; $_g = $pattern->map->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				$value = $re->matched($i + 1);
				if(null === $value || "" === $value) {
					continue;
				}
				$this->data->set($pattern->map[$i], urldecode($value));
				unset($value,$i);
			}
		}
		return true;
	}
	public function buildPattern($parts) {
		$pattern = new StringBuf();
		$map = new _hx_array(array());
		{
			$x = "^";
			if(is_null($x)) {
				$x = "null";
			} else {
				if(is_bool($x)) {
					$x = (($x) ? "true" : "false");
				}
			}
			$pattern->b .= $x;
		}
		{
			$_g1 = 0; $_g = $parts->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				$�t = ($parts[$i]);
				switch($�t->index) {
				case 0:
				$value = $�t->params[0];
				{
					if(0 === $i) {
						$x = thx_text_ERegs::escapeERegChars($value);
						if(is_null($x)) {
							$x = "null";
						} else {
							if(is_bool($x)) {
								$x = (($x) ? "true" : "false");
							}
						}
						$pattern->b .= $x;
					} else {
						$x = thx_text_ERegs::escapeERegChars($value);
						if(is_null($x)) {
							$x = "null";
						} else {
							if(is_bool($x)) {
								$x = (($x) ? "true" : "false");
							}
						}
						$pattern->b .= $x;
					}
				}break;
				case 1:
				$name = $�t->params[0];
				{
					$map->push($name);
					{
						$x = "(.+?)";
						if(is_null($x)) {
							$x = "null";
						} else {
							if(is_bool($x)) {
								$x = (($x) ? "true" : "false");
							}
						}
						$pattern->b .= $x;
					}
				}break;
				case 2:
				$name = $�t->params[0];
				{
					$map->push($name);
					{
						$x = "(.+?)" . "?";
						if(is_null($x)) {
							$x = "null";
						} else {
							if(is_bool($x)) {
								$x = (($x) ? "true" : "false");
							}
						}
						$pattern->b .= $x;
					}
				}break;
				case 3:
				$left = $�t->params[1]; $name = $�t->params[0];
				{
					$map->push($name);
					{
						$x = "(?:" . thx_text_ERegs::escapeERegChars($left) . "(.+?)" . ")?";
						if(is_null($x)) {
							$x = "null";
						} else {
							if(is_bool($x)) {
								$x = (($x) ? "true" : "false");
							}
						}
						$pattern->b .= $x;
					}
				}break;
				case 4:
				$right = $�t->params[1]; $name = $�t->params[0];
				{
					$map->push($name);
					{
						$x = "(?:" . "(.+?)" . thx_text_ERegs::escapeERegChars($right) . ")?";
						if(is_null($x)) {
							$x = "null";
						} else {
							if(is_bool($x)) {
								$x = (($x) ? "true" : "false");
							}
						}
						$pattern->b .= $x;
					}
				}break;
				case 5:
				$right = $�t->params[2]; $left = $�t->params[1]; $name = $�t->params[0];
				{
					$map->push($name);
					{
						$x = "(?:" . thx_text_ERegs::escapeERegChars($left) . "(.+?)" . thx_text_ERegs::escapeERegChars($right) . ")?";
						if(is_null($x)) {
							$x = "null";
						} else {
							if(is_bool($x)) {
								$x = (($x) ? "true" : "false");
							}
						}
						$pattern->b .= $x;
					}
				}break;
				case 6:
				$name = $�t->params[0];
				{
					$map->push($name);
					{
						$x = "(.+?)";
						if(is_null($x)) {
							$x = "null";
						} else {
							if(is_bool($x)) {
								$x = (($x) ? "true" : "false");
							}
						}
						$pattern->b .= $x;
					}
				}break;
				case 7:
				$name = $�t->params[0];
				{
					$map->push($name);
					{
						$x = "(.+?)" . "?";
						if(is_null($x)) {
							$x = "null";
						} else {
							if(is_bool($x)) {
								$x = (($x) ? "true" : "false");
							}
						}
						$pattern->b .= $x;
					}
				}break;
				case 8:
				$left = $�t->params[1]; $name = $�t->params[0];
				{
					$map->push($name);
					{
						$x = "(?:" . thx_text_ERegs::escapeERegChars($left) . "(.+?)" . ")?";
						if(is_null($x)) {
							$x = "null";
						} else {
							if(is_bool($x)) {
								$x = (($x) ? "true" : "false");
							}
						}
						$pattern->b .= $x;
					}
				}break;
				case 9:
				$right = $�t->params[1]; $name = $�t->params[0];
				{
					$map->push($name);
					{
						$x = "(?:" . "(.+?)" . thx_text_ERegs::escapeERegChars($right) . ")?";
						if(is_null($x)) {
							$x = "null";
						} else {
							if(is_bool($x)) {
								$x = (($x) ? "true" : "false");
							}
						}
						$pattern->b .= $x;
					}
				}break;
				case 10:
				$right = $�t->params[2]; $left = $�t->params[1]; $name = $�t->params[0];
				{
					$map->push($name);
					{
						$x = "(?:" . thx_text_ERegs::escapeERegChars($left) . "(.+?)" . thx_text_ERegs::escapeERegChars($right) . ")?";
						if(is_null($x)) {
							$x = "null";
						} else {
							if(is_bool($x)) {
								$x = (($x) ? "true" : "false");
							}
						}
						$pattern->b .= $x;
					}
				}break;
				}
				unset($i);
			}
		}
		{
			$x = "\$";
			if(is_null($x)) {
				$x = "null";
			} else {
				if(is_bool($x)) {
					$x = (($x) ? "true" : "false");
				}
			}
			$pattern->b .= $x;
		}
		return _hx_anonymous(array("map" => $map, "pattern" => $pattern->b));
	}
	public function e($s) {
		return thx_text_ERegs::escapeERegChars($s);
	}
	public function r($s) {
		return thx_text_ERegs::escapeERegChars($s);
	}
	public function l($s) {
		return thx_text_ERegs::escapeERegChars($s);
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->�dynamics[$m]) && is_callable($this->�dynamics[$m]))
			return call_user_func_array($this->�dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call �'.$m.'�');
	}
	static $PARAM_PATTERN = "(.+?)";
	static $REST_PATTERN = "(.+?)";
	function __toString() { return 'ufront.web.routing.RouteParamExtractor'; }
}
