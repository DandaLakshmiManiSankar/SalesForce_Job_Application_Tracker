@IsTest
private with sharing class TaxCalculationTest {
    @IsTest
    private static void salaryMinusStandardDeduction_of_zero_is_subject_to_no_federal_tax() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(1000);

        System.assertEquals(0.00, federalTax);
    }

    @IsTest
    private static void salaryMinusStandardDeduction_of_less_than_or_equal_to_11000_is_subject_to_federal_tax() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(24850);

        System.assertEquals(1100.00, federalTax);
    }

    @IsTest
    private static void salaryMinusStandardDeduction_of_less_than_or_equal_to_44725_is_subject_to_federal_tax() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(58575);

        System.assertEquals(5147.00, federalTax);
    }

    @IsTest
    private static void salaryMinusStandardDeduction_of_less_than_or_equal_to_95375_is_subject_to_federal_tax() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(109225);

        System.assertEquals(16290.00, federalTax);
    }

    @IsTest
    private static void salaryMinusStandardDeduction_of_less_than_or_equal_to_182100_is_subject_to_federal_tax() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(195950);

        System.assertEquals(37104.00, federalTax);
    }

    @IsTest
    private static void salaryMinusStandardDeduction_of_less_than_or_equal_to_231250_is_subject_to_federal_tax() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(245100);

        System.assertEquals(52832.00, federalTax);
    }

    @IsTest
    private static void salaryMinusStandardDeduction_of_less_than_or_equal_to_578125_is_subject_to_federal_tax() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(591975);

        System.assertEquals(174238.25, federalTax);
    }

    @IsTest
    private static void salaryMinusStandardDeduction_of_greater_than_578125_is_subject_to_federal_tax() {
        Decimal federalTax = TaxCalculation.calculateFederalTax(591976);

        System.assertEquals(174238.62, federalTax);
    }

    @IsTest
    private static void salary_of_10000_is_subject_to_Social_Security_tax() {
        Decimal socialSecurityTax = TaxCalculation.calculateSocialSecurityTax(10000);

        System.assertEquals(620.00, socialSecurityTax);
    }

    @IsTest
    private static void salary_of_20000_is_subject_to_Medicare_tax() {
        Decimal medicareTax = TaxCalculation.calculateMedicareTax(20000);

        System.assertEquals(290.00, medicareTax);
    }

    @IsTest
    private static void insert_job_application_with_salary_updates_taxes() {
        // GIVEN
        Job_Application__c jobApplicationToInsert = new Job_Application__c();

        jobApplicationToInsert.Salary__c = 24850;

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplicationToInsert;
        }

        Test.stopTest();

        // THEN
        final Decimal SALARY = 24850;

        Job_Application__c retrievedJobApplication = [
            SELECT 
                Id, 
                Salary__c, 
                Federal_Income_Tax__c, 
                Social_Security_Tax__c, 
                Medicare_Withholding__c 
            FROM Job_Application__c 
            WHERE Salary__c = :SALARY 
            WITH USER_MODE 
            LIMIT 1
        ];

        System.assertEquals(1100.00, retrievedJobApplication.Federal_Income_Tax__c.setScale(2, System.RoundingMode.HALF_UP));
        System.assertEquals(1540.70, retrievedJobApplication.Social_Security_Tax__c.setScale(2, System.RoundingMode.HALF_UP));
        System.assertEquals(360.33, retrievedJobApplication.Medicare_Withholding__c.setScale(2, System.RoundingMode.HALF_UP));
    }
}