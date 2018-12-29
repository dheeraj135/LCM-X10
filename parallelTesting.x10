import x10.io.Console;
import x10.lang.Place;
public class parallelTesting{
	public static def main(args:Rail[String]):void {
		val t:x10.array.DistArray_Unique[Rail[Long]] = new x10.array.DistArray_Unique[Rail[Long]](Place.places());
		for(var i:Long =0;i<Place.numPlaces();i++)
		{  val ii = i;
			val vl =	at(Place(ii)){
				t(ii) = new Rail[Long](10);
				t(ii)(1)=ii+1;
				Console.OUT.println(t(ii));
				return 999;
			};
			Console.OUT.println(vl);
		}
	}
}