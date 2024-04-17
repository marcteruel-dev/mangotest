@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock {
    private String jsonResponse;
    private Integer statusCode;

    public MockHttpResponseGenerator(String jsonResponse, Integer statusCode) {
        this.jsonResponse = jsonResponse;
        this.statusCode = statusCode;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        res.setStatusCode(statusCode);
        res.setBody(jsonResponse);
        return res;
    }
}