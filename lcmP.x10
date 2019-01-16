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
		public def reset_occ_deliv(var pl:Long,var item:Long):void
		{
			;
		}
		public def occ_deliv(val pl:Long,val item:Long):void
		{
			val trscRef = at(Place(0))
			{
				return GlobalRail(trsact);
			};
			at(Place(pl))
			{
				var t:Long,i:Long,j:Long;
				for(t=0;t<occt(pl)(item);t++)
				{
					val tId = occ(pl)(item)(t);
					for(j=0;;j++)
					{
						 val temp= j;
						i=at(trscRef.home){
							return trscRef()(tId)(temp);
						};
						if(i==item) break;
						if(occt(pl)(i)==0) jump(pl)(jump_siz(pl)++) = i;
						occ(pl)(i)(occt(pl)(i)++) = tId;
					}
				}
			}
		}
		public def output_itemset(val pl:Long,val freq:Long)
		{
			at(Place(pl))
			{
				var i:Long;
				for(i=0;i<itemset_siz(pl);i++) Console.OUT.printf("%d ",itemset(i));
				Console.OUT.printf("(%d)\n",freq);
			}
		}
		public def LCM(val pl:Long,val item:Long)
		{
			at(Place(pl))
			{
				var i:Long,jt:Long,flag:Long;
				i=0;
				jt= jump_siz(pl);
				flag =0;
				output_itemset(pl,occt(pl)(item));
				occ_deliv(pl,item);
				x10.util.RailUtils.qsort(jump(pl),jt,jump_siz(pl)-1,(i:Long,j:Long)=>qsort_cmp__idx(i,j));
				while(jump_siz(pl)>jt)
				{
					i = jump(pl)(--jump_siz(pl));
					if(occt(pl)(i)>=sigma)
					{
						itemset(pl)(itemset_siz(pl)++) = i;
						LCM(pl,i);
						itemset_siz(pl)--;
					}
					occt(pl)(i)=0;
				}
			}
		}
		public def doWork(fileName:String,sigma:Long)
		{
			this.sigma = sigma;
			readFromFile(fileName);
			
			val maxI = at(Place(0)){
				return item_max;
			};
			for(var i:Long=0;i<Place.numPlaces();i++)
			{
				itemset(i) = new Rail[Long](maxI);
				itemset_siz(i)=0;
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