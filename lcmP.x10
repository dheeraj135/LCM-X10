import x10.io.Console;
import x10.io.FileReader;
import x10.io.File;
public class lcmP{
	static class TRSACT{
		var item_order:Rail[Long];
		var item_perm:Rail[Long];
		var trsact:Rail[Rail[Long]];
		var org_frq:Rail[Long];
		var trsact_num:Long=0,item_max:Long=0,eles:Long=0;
		val itemset:x10.array.DistArray_Unique[Rail[Long]] = new x10.array.DistArray_Unique[Rail[Long]](Place.places());
		val itemset_siz:x10.array.DistArray_Unique[Long] = new x10.array.DistArray_Unique[Long](Place.places());
		val occ:x10.array.DistArray_Unique[Rail[Rail[Long]]] = new x10.array.DistArray_Unique[Rail[Rail[Long]]](Place.places());
		val occt:x10.array.DistArray_Unique[Rail[Long]] = new x10.array.DistArray_Unique[Rail[Long]](Place.places());
		val jump:x10.array.DistArray_Unique[Rail[Long]] = new x10.array.DistArray_Unique[Rail[Long]](Place.places());
		val jump_siz:x10.array.DistArray_Unique[Long] = new x10.array.DistArray_Unique[Long](Place.places());
		var frq:Rail[Long];
		var sigma:Long=0;
		public def qsort_cmp_frq(var aa:Long,var bb:Long):Int
		{
			val a = aa,b=bb;
			return at(Place(0)){
				if (org_frq(a) > org_frq(b)) return x10.lang.Int.operator_as(-1);
				else if (org_frq(a)<org_frq(b))
					return x10.lang.Int.operator_as(1);
				else return x10.lang.Int.operator_as(0);				
			};
		}
		public def qsort_cmp_idx(var aa:Long,var bb:Long):Int
		{
			val a = aa,b=bb;
			return at(Place(0)){
						if(item_order(a)<item_order(b)) return x10.lang.Int.operator_as(-1);
				else if (item_order(a)>item_order(b))
					return x10.lang.Int.operator_as(1);
				else return x10.lang.Int.operator_as(0);
			};
		}
		public def qsort_cmp__idx(var aa:Long,var bb:Long):Int{
			val a = aa,b =bb;
			return at(Place(0)){
						if(item_order(a)>item_order(b)) return x10.lang.Int.operator_as(-1);
				else if (item_order(a)<item_order(b))
					return x10.lang.Int.operator_as(1);
				else return x10.lang.Int.operator_as(0);
			};
		}
		public def readFromFile(fileName:String)
		{
			at(Place(0)){
			var file:File = new File(fileName);
			this.trsact_num=0;
			var temp:Long=0;
			for(i in file.lines())
			{
				this.trsact_num++;
			}
			this.trsact = new Rail[Rail[Long]](this.trsact_num);
			for(i in file.lines())
			{
				var t:Rail[String] = i.split(" ");
				trsact(temp) = new Rail[Long](t.size+1);
				for(var j:Long=0;j<t.size;j++){
					trsact(temp)(j) = x10.lang.Long.parseLong(t(j));
					item_max = x10.lang.Math.max(item_max,trsact(temp)(j));
				}
				temp++;
			}
			item_max++;
			org_frq = new Rail[Long](item_max);
			for(var i:Long=0;i<trsact_num;i++)
			{
				for(var j:Long=0;j<trsact(i).size-1;j++)
				{
					org_frq(trsact(i)(j))++;
				}
			}
			item_order = new Rail[Long](item_max);
			item_perm = new Rail[Long](item_max,(i:Long)=>i);
			x10.util.RailUtils.sort(item_perm,(i:Long,j:Long)=>qsort_cmp_frq(i,j));
			for(temp =0;temp<item_max;temp++){
				item_order(item_perm(temp)) = temp;
			}
						for(var i:Long=0;i<trsact_num;i++)
			{
				trsact(i)(trsact(i).size-1) = item_max;
				x10.util.RailUtils.qsort(trsact(i),0,trsact(i).size-2,(k:Long,j:Long)=>qsort_cmp_idx(k,j));
			}

			for(var i:Long=0;i<trsact_num;i++)
			{
				for(var j:Long=0;j<trsact(i).size;j++)
					Console.OUT.printf("%d ",trsact(i)(j));
				Console.OUT.println();
			}
		  }
		}
	}
	public static def main(args:Rail[String]):void
	{
		if(args.size<2)
		{
			Console.OUT.println("Usage: ./EXEC-NAME FILENAME SIGMA");
			return;
		}
		var a:TRSACT;
		a  = new TRSACT();
		a.readFromFile(args(0));
	}
}