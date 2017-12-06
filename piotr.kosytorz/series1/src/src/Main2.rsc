module Main2

import util::Webserver;


public void testServe(){

	serve(|http://localhost:5432|, Response (Request r){
		switch(r){
			case get(/analyze/) : return handleGet(r);
		}
    });

}

public Response handleGet(Request r){
	return response("Threshold: <r.parameters["threshold"]>");
}

public void testStopServe(){
	shutdown(|http://localhost:5432|);
}