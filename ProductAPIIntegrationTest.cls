@isTest
private class ProductAPIIntegrationTest {
    @isTest
    static void testFetchAndInsertProducts_Successful() {
        // Mock de respuesta de la API
        String mockApiResponse = '[{"Product Name":"Widget X","Active":true,"Product Code":"WX123","Product Family":"Widgets","Product Description":"Widget X is a high-performance widget designed for various industrial applications."},{"Product Name":"Gizmo Y","Active":false,"Product Code":"GY456","Product Family":"Gizmos","Product Description":"Gizmo Y is a compact and versatile device suitable for household use."},{"Product Name":"Thingamajig Z","Active":true,"Product Code":"TZ789","Product Family":"Thingamajigs","Product Description":"Thingamajig Z is an advanced gadget with state-of-the-art features."}]';

        // Mock de la llamada a la API
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockApiResponse, 200));

        Test.startTest();
        ProductAPIIntegration.fetchAndInsertProducts();
        Test.stopTest();

        // Verificar que los productos se hayan insertado correctamente
        List<Product2> insertedProducts = [SELECT Id, Name, IsActive, ProductCode, Family, Description FROM Product2];
        System.assertEquals(3, insertedProducts.size());
        assertProduct(insertedProducts[0], 'Widget X', true, 'WX123', 'Widgets', 'Widget X is a high-performance widget designed for various industrial applications.');
        assertProduct(insertedProducts[1], 'Gizmo Y', false, 'GY456', 'Gizmos', 'Gizmo Y is a compact and versatile device suitable for household use.');
        assertProduct(insertedProducts[2], 'Thingamajig Z', true, 'TZ789', 'Thingamajigs', 'Thingamajig Z is an advanced gadget with state-of-the-art features.');
    }

    @isTest
    static void testFetchAndInsertProducts_NullResponse() {
        // Mock de la llamada a la API con respuesta nula
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator('{}', 400));

        Test.startTest();
        ProductAPIIntegration.fetchAndInsertProducts();
        Test.stopTest();

        // Verificar que no se insertaron productos
        List<Product2> insertedProducts = [SELECT Id FROM Product2];
        System.assertEquals(0, insertedProducts.size());
    }

    static void assertProduct(Product2 product, String expectedName, Boolean expectedActive, String expectedProductCode, String expectedFamily, String expectedDescription) {
        System.assertEquals(expectedName, product.Name);
        System.assertEquals(expectedActive, product.IsActive);
        System.assertEquals(expectedProductCode, product.ProductCode);
        System.assertEquals(expectedFamily, product.Family);
        System.assertEquals(expectedDescription, product.Description);
    }
}