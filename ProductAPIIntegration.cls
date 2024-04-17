public class ProductAPIIntegration {
    public static void fetchAndInsertProducts() {
        List<Product2> productsToInsert = new List<Product2>();
        
        String apiUrl = 'https://raw.githubusercontent.com/marcteruel-dev/mangotest/main/products.json';
        String jsonResponse = callAPI(apiUrl);
        
        if (jsonResponse != null) {
            productsToInsert = parseAndInsertProducts(jsonResponse);
            if (!productsToInsert.isEmpty()) {
                insert productsToInsert;
            }										
        } else {
            System.debug('Error al llamar a la API: la respuesta fue nula');
        }
    }
    
    private static String callAPI(String apiUrl) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('GET');
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        Integer statusCode = response.getStatusCode();
        if (statusCode != 200) {
            System.debug('Error al llamar a la API: Código de estado ' + statusCode);
            return null;
        }
        
        return response.getBody();
    }
    
    private static List<Product2> parseAndInsertProducts(String jsonResponse) {
        List<Product2> productsToInsert = new List<Product2>();
        
        List<Object> parsedJson = (List<Object>) JSON.deserializeUntyped(jsonResponse);
        
        for (Object obj : parsedJson) {
            Map<String, Object> productData = (Map<String, Object>) obj;
            Product2 product = new Product2(
                Name = (String) productData.get('Product Name'),
                IsActive = (Boolean) productData.get('Active'),
                ProductCode = (String) productData.get('Product Code'),
                Family = (String) productData.get('Product Family'),
                Description = (String) productData.get('Product Description')
            );
            productsToInsert.add(product);
        }
        
        return productsToInsert;
    }
}