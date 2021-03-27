@isTest
private class myClassTest {
    
    @isTest
    static void isTest() {

        Test.startTest();
        Decimal celsius = myClass.FahrenheitToCelsius(70);
        System.assertEquals(21.11,celsius);
        Test.stopTest();
    }
}