
public class Book {
	
	private String name;

	// Constructor
	public Book(String name) {
		this.name = name;
	}

	/**
	 * Javadoc
	 * @return
	 */
	public String getName() {
		return name;
	}
	
	/*
	 * Bla 
	 */
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

}
