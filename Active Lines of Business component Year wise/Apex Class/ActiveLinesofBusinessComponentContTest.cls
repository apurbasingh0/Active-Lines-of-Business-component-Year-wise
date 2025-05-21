@isTest
private class ActiveLinesofBusinessComponentContTest {
    
    @isTest
    static void testGetOppBUs() {
        try {
            // Create an Account and Opportunity records
            Account account = new Account(Name = 'Test Account');
            insert account;
            System.debug('### Account created: ' + account);

            PLSI_Dealer__c deal = new PLSI_Dealer__c(Name = 'TestSpecifierDealer');
            insert deal;
            System.debug('### Dealer created: ' + deal);

            Opportunity opportunity1 = new Opportunity(AccountId = account.Id, Name = 'Test Opportunity 1', PLSI_Dealer__c = deal.id, Select_BU__c = 'WIRES CABLES AND TAPES', Approval_Status__c = 'Approved', StageName = 'Prospecting', CloseDate = Date.today());
            Opportunity opportunity2 = new Opportunity(AccountId = account.Id, Name = 'Test Opportunity 2', PLSI_Dealer__c = deal.id, Select_BU__c = 'WIRES CABLES AND TAPES', Approval_Status__c = 'Approved', StageName = 'Prospecting', CloseDate = Date.today());
            insert new List<Opportunity> { opportunity1, opportunity2 };
            // Update the StageName to Closed Won
            opportunity1.StageName = 'Closed Won';
            opportunity2.StageName = 'Closed Won';
            
            // Perform the update
            update new List<Opportunity> { opportunity1, opportunity2 };
			System.debug('### Opportunities updated to Closed Won: ' + opportunity1 + ', ' + opportunity2);
            Product2 product1 = new Product2(Name = 'Test Product 1', ProductCode = 'TP1', Division__c = 'WIRES CABLES AND TAPES', PLSI_ItemId__c = '1565622');
            Product2 product2 = new Product2(Name = 'Test Product 2', ProductCode = 'TP2', Division__c = 'CABLE MANAGEMENT SYSTEM', PLSI_ItemId__c = '1565623');
            Product2 product3 = new Product2(Name = 'Test Product 3', ProductCode = 'TP3', Division__c = 'WIRING DEVICE', PLSI_ItemId__c = '1565624');
            Product2 product4 = new Product2(Name = 'Test Product 4', ProductCode = 'TP4', Division__c = 'SWITCH GEAR', PLSI_ItemId__c = '1565625');
            Product2 product5 = new Product2(Name = 'Test Product 5', ProductCode = 'TP5', Division__c = 'WATER HEATER', PLSI_ItemId__c = '1565626');
            Product2 product6 = new Product2(Name = 'Test Product 6', ProductCode = 'TP6', Division__c = 'LIGHTING', PLSI_ItemId__c = '1565627');
            Product2 product7 = new Product2(Name = 'Test Product 7', ProductCode = 'TP7', Division__c = 'IAQ', PLSI_ItemId__c = '1565628');
            insert new List<Product2> { product1, product2, product3, product4, product5, product6, product7};
            System.debug('### Products created: ' + product1 + ', ' + product2);
            
            // Debug the Division__c field for each product
            System.debug('### Product 1 Division: ' + product1.Division__c);
            System.debug('### Product 2 Division: ' + product2.Division__c);
            System.debug('### Product 3 Division: ' + product3.Division__c);
            System.debug('### Product 4 Division: ' + product4.Division__c);
            
            // Query the records again to get the formula field value
            List<Product2> products = [SELECT Division__c FROM Product2 WHERE Id IN :new List<Id>{product1.Id, product2.Id,product3.Id, product4.Id,product5.Id, product6.Id, product7.Id}];
            
            // Debug the Division__c values from the queried records
            for (Product2 prod : products) {
                System.debug('### Product Division: ' + prod.Division__c);
            }
            
            
            Quote quote1 = new Quote(OpportunityId = opportunity1.Id, Name = 'Test Quote 1', Quote_Type__c = 'SPA');
            //Quote quote2 = new Quote(OpportunityId = opportunity2.Id, Name = 'Test Quote 2', Quote_Type__c = 'SPA');
            insert new List<Quote> { quote1 };
            System.debug('### Quote created: ' + quote1);
            
            Integer testYear = Date.today().year();
            Date startDate = Date.newInstance(testYear, 4, 1);
            Date endDate = Date.newInstance(testYear + 1, 3, 31);
            
            List<PLSI_Invoice__c> invoices = new List<PLSI_Invoice__c>();
            invoices.add(new PLSI_Invoice__c(Name = 'Test Invoice 1', PLSI_Quotation_Name__c = quote1.Id, Sales_Quantity__c = 45, Sales_Price__c = 45000, Sales_Amount__c = 45000, Taxable_Value__c = 100, Item_Name__c = product1.Id, PLSI_Invoice_Date__c =startDate.addDays(1)));
            invoices.add(new PLSI_Invoice__c(Name = 'Test Invoice 2', PLSI_Quotation_Name__c = quote1.Id, Sales_Quantity__c = 45, Sales_Price__c = 45000, Sales_Amount__c = 45000, Taxable_Value__c = 200, Item_Name__c = product2.Id, PLSI_Invoice_Date__c = endDate.addDays(-1)));
            invoices.add(new PLSI_Invoice__c(Name = 'Test Invoice 3', PLSI_Quotation_Name__c = quote1.Id, Sales_Quantity__c = 45, Sales_Price__c = 45000, Sales_Amount__c = 45000, Taxable_Value__c = 200, Item_Name__c = product3.Id, PLSI_Invoice_Date__c =startDate.addDays(1)));
            invoices.add(new PLSI_Invoice__c(Name = 'Test Invoice 4', PLSI_Quotation_Name__c = quote1.Id, Sales_Quantity__c = 45, Sales_Price__c = 45000, Sales_Amount__c = 45000, Taxable_Value__c = 100, Item_Name__c = product4.Id, PLSI_Invoice_Date__c =startDate.addDays(1)));
            invoices.add(new PLSI_Invoice__c(Name = 'Test Invoice 5', PLSI_Quotation_Name__c = quote1.Id, Sales_Quantity__c = 45, Sales_Price__c = 45000, Sales_Amount__c = 45000, Taxable_Value__c = 200, Item_Name__c = product5.Id, PLSI_Invoice_Date__c =startDate.addDays(1)));
            invoices.add(new PLSI_Invoice__c(Name = 'Test Invoice 6', PLSI_Quotation_Name__c = quote1.Id, Sales_Quantity__c = 45, Sales_Price__c = 45000, Sales_Amount__c = 45000, Taxable_Value__c = 200, Item_Name__c = product6.Id, PLSI_Invoice_Date__c = endDate.addDays(-1)));
            invoices.add(new PLSI_Invoice__c(Name = 'Test Invoice 7', PLSI_Quotation_Name__c = quote1.Id, Sales_Quantity__c = 45, Sales_Price__c = 45000, Sales_Amount__c = 45000, Taxable_Value__c = 200, Item_Name__c = product7.Id, PLSI_Invoice_Date__c = endDate.addDays(-1)));
            insert invoices;
            System.debug('### Invoices created: ' + invoices);
            
            // Query the invoices to retrieve the Division__c field after insert
            List<PLSI_Invoice__c> queriedInvoices = [SELECT Division__c, Taxable_Value__c, PLSI_Invoice_Date__c FROM PLSI_Invoice__c WHERE Id IN :invoices];
            
            // Debug the Division__c field for each invoice
            for (PLSI_Invoice__c invoice : queriedInvoices) {
                System.debug('### Invoice Division: ' + invoice.Division__c);
                System.debug('### Invoice Division: ' + invoice.PLSI_Invoice_Date__c);
                System.debug('### Invoice Division: ' + invoice.Taxable_Value__c);
            }
            
            // Extract the year from the CreatedDate of the first invoice
            //Integer invoiceYear = invoices[0].PLSI_Invoice_Date__c.year();
			System.debug('### Invoice year extracted: ' + testYear);
            
            // Call the getOppBUs method from the ActiveLinesofBusinessComponentController class
            Test.startTest();
            List<ActiveLinesofBusinessComponentController.BUsWrapper> BUsWrapperList = ActiveLinesofBusinessComponentController.getOppBUs(account.Id, testYear);
            Test.stopTest();
			System.debug('### BUsWrapperList returned: ' + BUsWrapperList);
            // Verify the results
            System.assertEquals(7, BUsWrapperList.size(), 'Unexpected number of BUs returned.');
           System.debug('### Verification passed for BUsWrapperList size.');
        
            //System.assertNotEquals(0, BUsWrapperList[0].BUAmount, 'Unexpected WCT amount returned.');
            //System.assertNotEquals(0, BUsWrapperList[1].BUAmount, 'Unexpected CMS amount returned.');
        } catch (Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
            System.assert(false, 'Test failed due to an exception: ' + e.getMessage());
        }
    }
    
}