
public class Document {
	
	private String name;

	// Constructor
	public Document(String name) {
		this.name = name;
	}

	/**
	 * Javadoc
	 * @return
	 */
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public void testIf() {
		if(name == "if") {
			System.out.println("if");
		}else if(name == "elseif") {
			System.out.println("elseif");
		}else {
			System.out.println("else");
		}	
	}
	
	public void testSwitch() {
		switch(name) {
			case "1":
			break;
			case  "2":
			break;
			default:
			break;
		}
	}
	
	private int[] value;
	public void blabla() {
		long temp = (((long)value[0]) << 32) | (value[1] & 0xFFFFFFFFL);
	}

}
