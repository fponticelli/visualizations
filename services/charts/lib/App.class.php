<?php

class App {
	public function __construct(){}
	static $MONGO_DB_NAME = "chartsrenderer1";
	static $RENDERABLES_COLLECTION = "renderables";
	static $BASE_URL = "http://localhost";
	static function main() {
		$wkhtmltopdfbin = "/usr/lib/wkhtmltopdf.app/Contents/MacOS/wkhtmltopdf"; $wkhtmltoimagebin = "/usr/lib/wkhtmltoimage.app/Contents/MacOS/wkhtmltoimage";
		$locator = new thx_util_TypeServiceLocator();
		$locator->memoize(_hx_qtype("model.WKHtmlToImage"), array(new _hx_lambda(array(&$locator, &$wkhtmltoimagebin, &$wkhtmltopdfbin), "App_0"), 'execute'));
		$locator->memoize(_hx_qtype("model.WKHtmlToPdf"), array(new _hx_lambda(array(&$locator, &$wkhtmltoimagebin, &$wkhtmltopdfbin), "App_1"), 'execute'));
		$locator->memoize(_hx_qtype("mongo.Mongo"), array(new _hx_lambda(array(&$locator, &$wkhtmltoimagebin, &$wkhtmltopdfbin), "App_2"), 'execute'));
		$locator->memoize(_hx_qtype("mongo.MongoDB"), array(new _hx_lambda(array(&$locator, &$wkhtmltoimagebin, &$wkhtmltopdfbin), "App_3"), 'execute'));
		$locator->memoize(_hx_qtype("model.RenderableGateway"), array(new _hx_lambda(array(&$locator, &$wkhtmltoimagebin, &$wkhtmltopdfbin), "App_4"), 'execute'));
		ufront_web_mvc_DependencyResolver::$current = new ufront_external_mvc_ThxDependencyResolver($locator);
		$config = new ufront_web_AppConfiguration("controller", true, "rg/services/viz/charts/"); $routes = new ufront_web_routing_RouteCollection(null); $app = new ufront_web_mvc_MvcApplication($config, $routes, null);
		$routes->addRoute("/", _hx_anonymous(array("controller" => "home", "action" => "index")), null);
		$routes->addRoute("/up/form", _hx_anonymous(array("controller" => "uploadForm", "action" => "display")), null);
		$routes->addRoute("/up.html", _hx_anonymous(array("controller" => "uploadAPI", "action" => "upload", "outputformat" => "html")), null);
		$routes->addRoute("/up.json", _hx_anonymous(array("controller" => "uploadAPI", "action" => "upload", "outputformat" => "json")), null);
		$routes->addRoute("/up/url.html", _hx_anonymous(array("controller" => "uploadAPI", "action" => "uploadFromUrl", "outputformat" => "html")), null);
		$routes->addRoute("/up/url.json", _hx_anonymous(array("controller" => "uploadAPI", "action" => "uploadFromUrl", "outputformat" => "json")), null);
		$routes->addRoute("/down/{uid}.{ext}", _hx_anonymous(array("controller" => "downloadAPI", "action" => "download")), null);
		$routes->addRoute("/info", _hx_anonymous(array("controller" => "setup", "action" => "info")), null);
		$routes->addRoute("/statusdb", _hx_anonymous(array("controller" => "setup", "action" => "mongodb")), null);
		$app->execute();
	}
	function __toString() { return 'App'; }
}
function App_0(&$locator, &$wkhtmltoimagebin, &$wkhtmltopdfbin) {
	{
		return new model_WKHtmlToImage($wkhtmltoimagebin);
	}
}
function App_1(&$locator, &$wkhtmltoimagebin, &$wkhtmltopdfbin) {
	{
		return new model_WKHtmlToPdf($wkhtmltopdfbin);
	}
}
function App_2(&$locator, &$wkhtmltoimagebin, &$wkhtmltopdfbin) {
	{
		return new mongo_Mongo();
	}
}
function App_3(&$locator, &$wkhtmltoimagebin, &$wkhtmltopdfbin) {
	{
		return new mongo_MongoDB($locator->get(_hx_qtype("mongo.Mongo"))->m->selectDB("chartsrenderer1"));
	}
}
function App_4(&$locator, &$wkhtmltoimagebin, &$wkhtmltopdfbin) {
	{
		return new model_RenderableGateway(new mongo_MongoCollection($locator->get(_hx_qtype("mongo.MongoDB"))->db->selectCollection("renderables")));
	}
}
