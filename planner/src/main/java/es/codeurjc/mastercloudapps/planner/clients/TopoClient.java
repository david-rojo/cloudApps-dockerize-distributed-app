package es.codeurjc.mastercloudapps.planner.clients;

import java.util.concurrent.CompletableFuture;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import es.codeurjc.mastercloudapps.planner.models.LandscapeResponse;

@Service
public class TopoClient {

	@Value("${toposervice.host}")
    private String TOPOSERVICE_HOST;

    @Value("${toposervice.port}")
    private String TOPOSERVICE_PORT;

    @Async
    public CompletableFuture<String> getLandscape(String city) {
    	
    	String url = "http://" + TOPOSERVICE_HOST + ":" + TOPOSERVICE_PORT 
    			+ "/api/topographicdetails/" + city;
    	
    	RestTemplate restTemplate = new RestTemplate();
        LandscapeResponse response = restTemplate.getForObject(url, LandscapeResponse.class);
        return CompletableFuture.completedFuture(response.getLandscape());
    }
}
