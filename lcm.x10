import x10.io.Console;
import x10.io.FileReader;
import x10.io.File;
import x10.lang.Long;
import x10.lang.Math;
import x10.array.DistArray_Unique;
import x10.lang.Place;
public class lcm{
	static class TRSACT{
		public var item_order:Rail[Long];
		public var item_perm:Rail[Long];
		public var trsact:Rail[Rail[Long]];
		public var org_frq:Rail[Long];
		public var trsact_num:Long,item_max:Long,eles:Long;
		public var occ:Rail[Rail[Long]],occt:Rail[Long];
		public var frq:Rail[Long];
		public var itemset:Rail[Long],itemset_siz:Long;
		public var jump:Rail[Long],jump_siz:Long;
		public var sigma:Long;
		public def qsort_cmp_frq(var a:Long,var b:Long):Int{
			if (org_frq(a) > org_frq(b)) return x10.lang.Int.operator_as(-1);
			else if (org_frq(a)<org_frq(b))
				return x10.lang.Int.operator_as(1);
			else return x10.lang.Int.operator_as(0);
		}
		public def qsort_cmp_idx(var a:Long,var b:Long):Int
		{
			if(item_order(a)<item_order(b)) return x10.lang.Int.operator_as(-1);
			else if (item_order(a)>item_order(b))
				return x10.lang.Int.operator_as(1);
			else return x10.lang.Int.operator_as(0);
		}
		public def qsort_cmp__idx(var a:Long,var b:Long):Int{
			if(item_order(a)>item_order(b)) return x10.lang.Int.operator_as(-1);
			else if (item_order(a)<item_order(b))
				return x10.lang.Int.operator_as(1);
			else return x10.lang.Int.operator_as(0);
		}
		public def readFromFile(fileName:String){
			var file:File = new File(fileName);
			this.trsact_num = 0;
			var temp:Long =0;
			for(i in file.lines())
			{
				this.trsact_num++;
			}
			this.trsact = new Rail[Rail[Long]](this.trsact_num);
			for(i in file.lines())
			{
				var t:Rail[String] = i.split(" ");
				trsact(temp) = new Rail[Long](t.size+1);
				for(var j:Long =0;j<t.size;j++){
					trsact(temp)(j) = x10.lang.Long.parseLong(t(j));
					item_max = x10.lang.Math.max(item_max,trsact(temp)(j));
				}
				temp++;
			}
			item_max++;
			org_frq = new Rail[Long](item_max);
			for(var i:Long=0;i<trsact_num;i++)
			{
				for(var j:Long=0;j<trsact(i).size-1;j++){
					org_frq(trsact(i)(j))++;
				}
			}
			item_order = new Rail[Long](item_max);
			item_perm = new Rail[long](item_max,(i:Long)=>i);
			x10.util.RailUtils.sort(item_perm,(i:Long,j:Long)=>qsort_cmp_frq(i,j));
			for(temp =0;temp<item_max;temp++){
				item_order(item_perm(temp)) = temp;
			}
			for(var i:Long=0;i<trsact_num;i++)
			{
				trsact(i)(trsact(i).size-1) = item_max;
				x10.util.RailUtils.qsort(trsact(i),0,trsact(i).size-2,(k:Long,j:Long)=>qsort_cmp_idx(k,j));
			}

			// for(var i:Long=0;i<trsact_num;i++)
			// {
			// 	for(var j:Long=0;j<trsact(i).size;j++)
			// 		Console.OUT.printf("%d ",trsact(i)(j));
			// 	Console.OUT.println();
			// }
			
		}
		public def occ_deliv(var item:Long):void
		{
			var t:Long,i:Long,j:Long,tId:Long;
			for(t =0 ;t<occt(item);t++)
			{
				tId = occ(item)(t);
				for(j=0;(i=trsact(tId)(j))!=item;j++)
				{
					if(occt(i)==0) jump(jump_siz++) = i;
					occ(i)(occt(i)++) = tId;
				} 
			}
		}
		public def output_itemset(var freq:Long)
		{
			var i:Long;
			for(i=0;i<itemset_siz;i++) Console.OUT.printf("%d ",itemset(i));
			Console.OUT.printf("(%d)\n",freq);
		}
		public def LCM(var item:Long)
		{
			var i:Long,jt:Long,flag:Long;
			i=0;
			jt = jump_siz;
			flag=0;
			output_itemset(occt(item));
			occ_deliv(item);
			x10.util.RailUtils.qsort(jump,jt,jump_siz-1,(i:Long,j:Long)=>qsort_cmp__idx(i,j));
			while(jump_siz>jt)
			{
				i = jump(--jump_siz);
				if(occt(i)>=sigma){
					itemset(itemset_siz++) = i;
					LCM(i);
					itemset_siz--;
				}
				
				occt(i)=0;
			}
			
		}
		public def doWork(fileName:String,sigma:Long)
		{
			this.sigma = sigma;
			readFromFile(fileName);
			itemset = new Rail[Long](item_max);
			itemset_siz=0;
			occ = new Rail[Rail[Long]](item_max+1);
			occt = new Rail[Long](item_max+1);
			for(var i:Long =0;i<item_max;i++)
			{
				occ(i) = new Rail[Long](org_frq(i)+1);
			}
			occ(item_max) = new Rail[Long](trsact_num);
			for(var i:Long=0;i<trsact_num;i++) 
				occ(item_max)(i) = i;
			occt(item_max)=trsact_num;
			jump = new Rail[Long](item_max);
			jump_siz=0;
			LCM(item_max);
		}
	}
	public static def main(args:Rail[String]):void{
		if(args.size<2)
		{
			Console.OUT.println("Usage: ./EXEC-NAME FILENAME SIGMA");
			return;
		}
		var a:TRSACT;
		a  = new TRSACT();
		a.doWork(args(0),x10.lang.Long.parseLong(args(1)));
	 }

}