import java.util.stream.Collectors; 
import java.util.stream.Stream; 
import java.io.*;
import java.nio.file.*;

import com.google.common.collect.*;

/*
import org.phenopackets.schema.v1.*;
import org.phenopackets.schema.v1.core.*;
*/
import org.enviropackets.schema.v0.*;

import com.google.protobuf.util.JsonFormat;


public class EnviroPacketV0 {

    public static void main(String[] args){

	//Create Example EnviroPacket
	Enviropacket HadalWasp = new EnviroPacketV0().HadalZone();
    
	/** Serialize to Protobuf */
        
	Path path = Paths.get("./out.pb");
	try (OutputStream outputStream = Files.newOutputStream(path)) {     
	    HadalWasp.writeTo(outputStream);
	} catch (IOException e) {
	    e.printStackTrace();
	}

	/** Serialize to JSON */        
        
	try {
	    String jsonString = JsonFormat.printer().includingDefaultValueFields().print(HadalWasp);
	    System.out.println(jsonString);
	} catch (Exception e) {
	    e.printStackTrace();
	}
    }

    /** convenience function to help creating OntologyClass objects. */

    /*
    public static OntologyClass ontologyClass(String id, String label) {
        return OntologyClass.newBuilder()
            .setId(id)
            .setLabel(label)
            .build();
    }
    */

    public Enviropacket HadalZone() {
	String transmission = "Here we go";
	return Enviropacket.newBuilder().setMessage(transmission).build();
    }
}
