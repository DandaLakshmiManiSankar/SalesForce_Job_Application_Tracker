public with sharing class TaxCalculation {
    @AuraEnabled(cacheable=true)
    public static Decimal calculateFederalTax(Decimal salary) {
        Decimal federalTax = 0;

        Decimal salaryMinusStandardDeduction = salary - 13850;

        if (salaryMinusStandardDeduction == null || salaryMinusStandardDeduction <= 0) {
            return federalTax;
        } else if (salaryMinusStandardDeduction <= 11000) {
            federalTax = (salaryMinusStandardDeduction * 0.10);
        } else if (salaryMinusStandardDeduction <= 44725) {
            federalTax = ((salaryMinusStandardDeduction - 11000) * 0.12 + 1100);
        } else if (salaryMinusStandardDeduction <= 95375) {
            federalTax = ((salaryMinusStandardDeduction - 44725) * 0.22 + 5147);
        } else if (salaryMinusStandardDeduction <= 182100) {
            federalTax = ((salaryMinusStandardDeduction - 95375) * 0.24 + 16290);
        } else if (salaryMinusStandardDeduction <= 231250) {
            federalTax = ((salaryMinusStandardDeduction - 182100) * 0.32 + 37104);
        } else if (salaryMinusStandardDeduction <= 578125) {
            federalTax = ((salaryMinusStandardDeduction - 231250) * 0.35 + 52832);
        } else if (salaryMinusStandardDeduction > 578125) {
            federalTax = ((salaryMinusStandardDeduction - 578125) * 0.37 + 174238.25);
        }

        return federalTax.setScale(2, System.RoundingMode.HALF_UP);
    }

    @AuraEnabled(cacheable=true)
    public static Decimal calculateSocialSecurityTax(Decimal salary) {
        Decimal socialSecurityTax = 0.00;
        if (salary > 0){
            socialSecurityTax = (salary * 0.062);
            socialSecurityTax.setScale(2, System.RoundingMode.HALF_UP);
        }
        return socialSecurityTax;
    }

    @AuraEnabled(cacheable=true)
    public static Decimal calculateMedicareTax(Decimal salary) {
        Decimal medicareTaxes = 0.00;
        if (salary > 0){
            medicareTaxes = (salary * 0.0145);
            medicareTaxes.setScale(2, System.RoundingMode.HALF_UP);
        }
        return medicareTaxes;
    }

    public static void calculatePayrollTaxes(List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (newJobApplication.Salary__c != null) {
                newJobApplication.Federal_Income_Tax__c = TaxCalculation.calculateFederalTax(newJobApplication.Salary__c);
                newJobApplication.Social_Security_Tax__c = TaxCalculation.calculateSocialSecurityTax(newJobApplication.Salary__c);
                newJobApplication.Medicare_Withholding__c = TaxCalculation.calculateMedicareTax(newJobApplication.Salary__c);
            }
        }
    }
}