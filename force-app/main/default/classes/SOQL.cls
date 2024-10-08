/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Lakshmi Kammili
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() 
    {
        return [SELECT Id, LastName, Company, Phone, Email FROM Lead LIMIT 1000];
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName(String firstName) {
        return [SELECT Id, FirstName, LastName,Name FROM Contact WHERE FirstName = :firstName];
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName(List<String> lastNames)
    {
        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName IN :lastNames];
        List<Id> contactIds = new List<Id>();

        // Extract Ids from Contact records.
        for (Contact contact : contacts) 
        {
            contactIds.add(contact.Id);
        }
        
        return contactIds;
    }
    

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity>getClosedWonOpportunitiesByAccount(String accountId)
    {
        return [SELECT Id, Name, StageName, CloseDate, Amount, AccountId 
        FROM Opportunity 
        WHERE AccountId = :accountId 
        AND StageName = 'Closed Won'];
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount(String condition) 
    {
        String query = 'SELECT COUNT() FROM Account ' + condition;
        return (Integer)Database.countQuery(query);
    
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> getTasksDueNextWeek(Date startDate)
    {
        // Calculate the end date for 7 days from the start date
        Date endDate = startDate.addDays(7);
        // Query tasks where the due date is between the start date and 7 days from that date
    List<Task> taskList = [SELECT Id, Subject, ActivityDate 
    FROM Task 
    WHERE ActivityDate >= :startDate 
    AND ActivityDate <= :endDate];

    // Create a map of Task Ids to Task records
    Map<Id, Task> taskMap = new Map<Id, Task>();
    for (Task t : taskList) 
    {
    taskMap.put(t.Id, t);
    }

    return taskMap;
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain(String emailDomain)
    {
        return [SELECT Id, Name, Email FROM Contact WHERE Email LIKE :('%' + emailDomain)];
    
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) 
    {
        // Query Opportunities where the Name contains the keyword
        List<Opportunity> opportunities = [
            SELECT Id, Name, StageName, CloseDate 
            FROM Opportunity 
            WHERE Name LIKE :('%' + keyword + '%')
        ];
        return opportunities;
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() 
    {
        // Query Cases where the Case Origin is not Web, Email, or Blank
        List<Case> cases = [
            SELECT Id, CaseNumber, Origin 
            FROM Case 
            WHERE Origin != 'Web' 
            AND Origin != 'Email' 
            AND Origin != ''
        ];
        return cases;
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle(String leadSource, String keyword) 
    {
        // Query Leads where the Lead Source matches or the Title contains the keyword
        List<Lead> leads = [
            SELECT Id, FirstName, LastName, LeadSource, Title, Company, Phone, Email
            FROM Lead 
            WHERE LeadSource = :leadSource 
            OR Title LIKE :('%' + keyword + '%')
        ];
        return leads;
    }    

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) 
    {
        // Create a list to hold the Contact LastNames
        List<String> contactLastNames = new List<String>();

        // Query the Contacts
        List<Contact> contacts = [
            SELECT LastName 
            FROM Contact 
            WHERE AccountId = :accountId
        ];
        // Loop through each Contact and add the LastName to the list
        for (Contact contact : contacts) {
            contactLastNames.add(contact.LastName);
        }

        // Return the list of Contact LastNames
        return contactLastNames;
        }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) 
    {
        Decimal totalRevenue = 0;

        // Query opportunities based on the provided stage
        List<Opportunity> opportunities = [SELECT Amount FROM Opportunity WHERE StageName = :stage OR Amount > 10000];
    
        // Calculate the total revenue
        for (Opportunity opp : opportunities) {
            totalRevenue += opp.Amount;
        }
    
        return totalRevenue;
    }
    

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() 
    {
        // Query to retrieve the first 10 Accounts ordered by Name
    List<Account> accounts = [SELECT Id, Name FROM Account ORDER BY Name LIMIT 10];
    return accounts;
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() 
    {
        // Query to retrieve Opportunities with Amount greater than 100,000, ordered by CloseDate, limited to 5 records
    List<Opportunity> opportunities = [SELECT Id, Name, Amount, CloseDate FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate LIMIT 5];
    return opportunities;
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() 
    {
        // Query to retrieve Contacts with the most recent Birthdate, ordered by Birthdate, limited to 3 records
    List<Contact> contacts = [SELECT Id, Name, Birthdate FROM Contact ORDER BY Birthdate DESC LIMIT 3];
    return contacts;
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() 
    {
        // Query to retrieve Cases in the Open Status, ordered by CreatedDate, limited to 10 records with an offset of 5
    List<Case> cases = [SELECT Id, CaseNumber, Status, CreatedDate FROM Case WHERE Status = 'Open' ORDER BY CreatedDate LIMIT 10 OFFSET 5];
    return cases;
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) 
    {
        // Create a set to hold the Case Ids
        Set<Id> caseIds = new Set<Id>();

        // Query the Cases associated with the Account
        List<Case> cases = [SELECT Id FROM Case WHERE AccountId = :accountId];
        // Loop through each Case and add the Id to the set
        for (Case c : cases) 
        {
            caseIds.add(c.Id);
        }
    
        return caseIds; // Return the set of Case IDs
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) 
    {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();
        
        // Query the Accounts not in the specified country
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE BillingCountry != :country];
        // Loop through each Account and add the Id and Name to the map
        for (Account acc : accounts) 
        {
            accountIdsToNames.put(acc.Id, acc.Name);
        }
    
        return accountIdsToNames; // Return the map of Account IDs to Account Names
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) 
    { 
        // Query the Contact with the given Id and retrieve the related Account Name
    Contact contactRecord = [SELECT Account.Name FROM Contact WHERE Id = :contactId LIMIT 1];
    
    // Return the Account Name of the Contact
    return contactRecord.Account.Name;
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) 
    {
        // Query the Account and related Opportunities
    Account accountRecord = [
        SELECT Id, Name, 
            (SELECT Id, Name FROM Opportunities) 
        FROM Account 
        WHERE Id = :accountId 
        LIMIT 1
    ];

    return accountRecord; // Return the Account record with related Opportunities
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) 
    {
        // Query the Account to get the Billing State
        Account accountRecord = [SELECT BillingState FROM Account WHERE Id = :accountId LIMIT 1];

        // Store the Account's BillingState
        String billingState = accountRecord.BillingState;

        // Query the Contacts that have the same Mailing State as the Account's Billing State
        List<Contact> contacts = [SELECT Id, Name, MailingState FROM Contact WHERE MailingState = :billingState];

        return contacts; // Return the list of contacts
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) 
    {
        // Query the Leads to get their emails
        List<Lead> leads = [SELECT Email FROM Lead WHERE Id IN :leadIds];

        // Create a set to hold email domains from the Leads
        Set<String> emailDomains = new Set<String>();

        // Loop through each Lead
    for (Lead lead : leads) 
    {
        // Get the email from the Lead
        String email = lead.Email;

        // Check if the email is not null
        if (email != null) 
        {
        // Extract the domain from the email
        String domain = email.substring(email.indexOf('@') + 1);
        emailDomains.add(domain);
        }
    }
        // Query the Accounts with matching website domains
        List<Account> accounts = [SELECT Id, Name, Website FROM Account WHERE Website != null];
        List<Account> matchingAccounts = new List<Account>();
    
    // Loop through each Account to find matching domains
    for (Account account : accounts) 
    {
        String website = account.Website;
        if (website != null) 
        {
            // Extract the domain from the website
            String websiteDomain = website.replace('http://', '').replace('https://', '').replace('www.', '');
            if (emailDomains.contains(websiteDomain)) {
                matchingAccounts.add(account);
            }
        }
    }

    return matchingAccounts; // Return the list of matching Accounts
}

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) 
    {
        // Query the original Opportunity Line Items
        List<OpportunityLineItem> origLineItems = [SELECT Id, OpportunityId, Quantity, PricebookEntryId,UnitPrice
        FROM OpportunityLineItem 
        WHERE OpportunityId = :origOppId];

        // Create a list to hold the new line items
        List<OpportunityLineItem> newLineItems = new List<OpportunityLineItem>();
        
        // Loop through each cloned Opportunity Id
    for (Id cloneOppId : cloneOppIds) 
    {
        // Loop through each original line item
        for (OpportunityLineItem origLineItem : origLineItems) 
        {
            // Clone the original line item
            OpportunityLineItem newLineItem = origLineItem.clone(false, true, false, false);
            newLineItem.OpportunityId = cloneOppId;

            // Generate a random number between 1 and 3 and add it to the quantity
            Integer randomQuantity = Math.round(Math.random() * 2) + 1;
            newLineItem.Quantity = origLineItem.Quantity + randomQuantity;

            // Set the UnitPrice (TotalPrice will be calculated automatically)
            newLineItem.UnitPrice = origLineItem.UnitPrice;

            // Add the new line item to the list
            newLineItems.add(newLineItem);
        }
    }
    // Insert the new line items
    insert newLineItems;

    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() 
    {        
    // Query the Opportunities with Stage 'Closed Won'
    List<Opportunity> closedWonOpportunities = [SELECT Id, Name, Account.Name, Owner.Name 
    FROM Opportunity 
    WHERE StageName = 'Closed Won'];

    return closedWonOpportunities; // Return the list of filtered Opportunities
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() 
    {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> closedWonOpps = [SELECT Id, AccountId FROM Opportunity WHERE StageName = 'Closed Won'];

        // Create a set of Account Ids from the Opportunities
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : closedWonOpps) 
        {
            accountIds.add(opp.AccountId);
        }

        // Query the Contacts
        List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds];

        // Loop through each Contact and add the Account Id and Contact to the map
        Map<Id, Id> accountToContactMap = new Map<Id, Id>();
        for (Contact contact : contacts) 
        {
            if (!accountToContactMap.containsKey(contact.AccountId)) 
            {
                accountToContactMap.put(contact.AccountId, contact.Id);
            }
        }

    // Loop through each Opportunity
    // Update the Opportunity primary contact from accountToContactMap
    for (Opportunity opp : closedWonOpps) 
    {
        if (accountToContactMap.containsKey(opp.AccountId)) 
        {
            opp.Primary_Contact__c = accountToContactMap.get(opp.AccountId);
        }
    }

        // Update the Opportunities
        update closedWonOpps;
    }
}