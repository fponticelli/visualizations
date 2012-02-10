<?php

class controller_SetupController extends ufront_web_mvc_Controller {
	public function __construct($mongo) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->mongo = $mongo;
	}}
	public $mongo;
	public function dropRenderables() {
		$this->dropCollection("renderables");
		return $this->redirectToStatus();
	}
	public function dropCache() {
		$this->dropCollection("cache");
		return $this->redirectToStatus();
	}
	public function dropCollections() {
		$this->dropCollection("renderables");
		$this->dropCollection("cache");
		return $this->redirectToStatus();
	}
	public function redirectToStatus() {
		return new ufront_web_mvc_ForwardResult(null, _hx_anonymous(array("controller" => "setup", "action" => "mongodb")));
	}
	public function dropCollection($collection) {
		$db = new mongo_MongoDB($this->mongo->m->selectDB("chartsrenderer1")); $collection1 = new mongo_MongoCollection($db->db->selectCollection($collection));
		$collection1->c->drop();
	}
	public function createCollections() {
		$dbname = "chartsrenderer1"; $db = new mongo_MongoDB($this->mongo->m->selectDB($dbname)); $cacheCollections = new _hx_array($db->db->listCollections()); $renderablesCollectionName = "renderables"; $cacheCollectionName = "cache";
		$renderableCollection = new mongo_MongoCollection($db->db->selectCollection($renderablesCollectionName));
		if(php_Lib::objectOfAssociativeArray($renderableCollection->c->validate())->ok < 1) {
			$renderableCollection = new mongo_MongoCollection($db->db->createCollection($renderablesCollectionName));
			$renderableCollection->ensureIndexOn("uid", _hx_anonymous(array("unique" => true)));
			$renderableCollection->ensureIndexOn("lastUsage", null);
		}
		$cacheCollection = new mongo_MongoCollection($db->db->selectCollection($cacheCollectionName));
		if(php_Lib::objectOfAssociativeArray($cacheCollection->c->validate())->ok < 1) {
			$cacheCollection = new mongo_MongoCollection($db->db->createCollection($cacheCollectionName));
			$renderableCollection->ensureIndexOn("uid", _hx_anonymous(array("unique" => true)));
			$cacheCollection->ensureIndexOn("expiresOn", null);
		}
		return new ufront_web_mvc_ForwardResult(null, _hx_anonymous(array("controller" => "setup", "action" => "mongodb")));
	}
	public function mongodb() {
		$dbname = "chartsrenderer1"; $db = new mongo_MongoDB($this->mongo->m->selectDB($dbname)); $cacheCollections = new _hx_array($db->db->listCollections()); $renderablesCollectionName = "renderables"; $cacheCollectionName = "cache"; $renderablesExists = true; $cacheExists = true;
		$renderableCollection = new mongo_MongoCollection($db->db->selectCollection($renderablesCollectionName));
		if(php_Lib::objectOfAssociativeArray($renderableCollection->c->validate())->ok < 1) {
			$renderablesExists = false;
		}
		$cacheCollection = new mongo_MongoCollection($db->db->selectCollection($cacheCollectionName));
		if(php_Lib::objectOfAssociativeArray($cacheCollection->c->validate())->ok < 1) {
			$cacheExists = false;
		}
		$content = _hx_anonymous(array("baseurl" => "http://localhost", "url" => new ufront_web_mvc_view_UrlHelperInst($this->controllerContext->requestContext), "db" => _hx_anonymous(array("name" => $dbname, "collections" => $cacheCollections)), "renderables" => _hx_anonymous(array("name" => $renderablesCollectionName, "exists" => $renderablesExists, "count" => (($renderablesExists) ? $renderableCollection->c->count() : -1))), "cache" => _hx_anonymous(array("name" => $cacheCollectionName, "exists" => $cacheExists, "count" => (($cacheExists) ? $cacheCollection->c->count() : -1)))));
		return new ufront_web_mvc_ContentResult(_hx_deref(new template_MongoDBStatus())->execute($content), null);
	}
	public function topRenderables() {
		$dbname = "chartsrenderer1"; $db = new mongo_MongoDB($this->mongo->m->selectDB($dbname)); $gate = new model_RenderableGateway(new mongo_MongoCollection($db->db->selectCollection("renderables")));
		return Dynamics::string($gate->topByUsage(10));
	}
	public function info() {
		return $this->collectPhpInfo();
	}
	public function collectPhpInfo() {
		ob_start();
		phpinfo();
		return ob_get_clean();
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
	static $__rtti = "<class path=\"controller.SetupController\" params=\"\">\x0A\x09<extends path=\"ufront.web.mvc.Controller\"/>\x0A\x09<mongo><c path=\"mongo.Mongo\"/></mongo>\x0A\x09<dropRenderables public=\"1\" set=\"method\" line=\"17\"><f a=\"\"><c path=\"ufront.web.mvc.ForwardResult\"/></f></dropRenderables>\x0A\x09<dropCache public=\"1\" set=\"method\" line=\"23\"><f a=\"\"><c path=\"ufront.web.mvc.ForwardResult\"/></f></dropCache>\x0A\x09<dropCollections public=\"1\" set=\"method\" line=\"29\"><f a=\"\"><c path=\"ufront.web.mvc.ForwardResult\"/></f></dropCollections>\x0A\x09<redirectToStatus set=\"method\" line=\"36\"><f a=\"\"><c path=\"ufront.web.mvc.ForwardResult\"/></f></redirectToStatus>\x0A\x09<dropCollection set=\"method\" line=\"41\"><f a=\"collection\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></dropCollection>\x0A\x09<createCollections public=\"1\" set=\"method\" line=\"48\"><f a=\"\"><c path=\"ufront.web.mvc.ForwardResult\"/></f></createCollections>\x0A\x09<mongodb public=\"1\" set=\"method\" line=\"78\"><f a=\"\"><c path=\"ufront.web.mvc.ContentResult\"/></f></mongodb>\x0A\x09<topRenderables public=\"1\" set=\"method\" line=\"126\"><f a=\"\"><c path=\"String\"/></f></topRenderables>\x0A\x09<info public=\"1\" set=\"method\" line=\"134\"><f a=\"\"><c path=\"String\"/></f></info>\x0A\x09<collectPhpInfo set=\"method\" line=\"139\"><f a=\"\"><c path=\"String\"/></f></collectPhpInfo>\x0A\x09<new public=\"1\" set=\"method\" line=\"11\"><f a=\"mongo\">\x0A\x09<c path=\"mongo.Mongo\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></new>\x0A</class>";
	function __toString() { return 'controller.SetupController'; }
}
