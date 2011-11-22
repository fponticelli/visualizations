/**
 * ...
 * @author Franco Ponticelli
 */

package rg.data.source.rgquery;

interface ITrackReportGrid 
{
	public function track(path : String, events : { }, ?success : Void -> Void, ?error : String -> Void, ?token : String) : Void;
}