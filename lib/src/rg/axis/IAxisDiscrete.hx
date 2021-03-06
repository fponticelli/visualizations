/**
 * ...
 * @author Franco Ponticelli
 */

package rg.axis;

interface IAxisDiscrete<T> extends IAxis<T>
{
	public var scaleDistribution(default, set) : ScaleDistribution;
	public function range(start : T, end : T) : Array<T>;
}