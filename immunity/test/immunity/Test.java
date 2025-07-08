package immunity;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map.Entry;

public class Test {

	public static void main(String[] args) {
		HashMap<String,Integer> map = new HashMap<String, Integer>();
		map.put("rabA", 123);
		
		for(String item : map.keySet()) {
			//System.out.print*ln(item);
		}
		for(Entry<String, Integer> item2: map.entrySet()) {
			//System.out.print*ln(item2.getKey());
			//System.out.print*ln(item2.getValue());
		}
		Collection<Integer> values = map.values();
		//System.out.print*ln(values);
	}

}
