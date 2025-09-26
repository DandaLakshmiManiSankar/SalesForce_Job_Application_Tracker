import { LightningElement , track} from 'lwc';
import calculateFederalTax from '@salesforce/apex/TaxCalculation.calculateFederalTax';
import calculateSocialSecurityTax from '@salesforce/apex/TaxCalculation.calculateSocialSecurityTax';
import calculateMedicareTax from '@salesforce/apex/TaxCalculation.calculateMedicareTax';
export default class CalculateTakeHome extends LightningElement {
    @track salary;
    @track fedTax;
    @track ssTax = 0.00;
    @track medicareTax = 0.00;
    @track takeHomePayYearly = 0.00; 
    @track takeHomePaySixMonths = 0.00;
    @track takeHomePayMonthly = 0.00;
    @track takeHomePayBiWeekly = 0.00;
    @track isSubmitted = false;


    convertNumberToCurrency(number){
        const formatter = new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD',
        });
        const formattedNumber = formatter.format(number);
    }

    handleSalaryChange(event) {
        this.salary = event.target.value;
        this.isSubmitted = false;
    }

    calculateTaxes() {
        if (!isNaN(this.salary)) {
            Promise.all([
                calculateFederalTax({ salary: this.salary }),
                calculateSocialSecurityTax({ salary: this.salary }),
                calculateMedicareTax({ salary: this.salary })
            ])
            .then(results => {
                this.fedTax = results[0];
                this.ssTax = results[1];
                this.medicareTax = results[2];

                // Calculate takeHomePayYearly
                if(this.salary >= 0){
                    this.takeHomePayYearly = this.salary - this.fedTax -
                                             this.medicareTax - this.ssTax;
                }
                //Calculate Monthly TakeHome Pay every 6 months
                if(this.salary >= 0){
                    this.takeHomePaySixMonths = this.takeHomePayYearly / 2;
                }
                //Calculate Monthly TakeHome Pay Monthly
                if(this.salary >= 0){
                    this.takeHomePayMonthly = this.takeHomePayYearly / 12;
                }
                //Calculate Monthly TakeHome Pay bi-weekly
                if(this.salary >= 0){
                    this.takeHomePayBiWeekly = this.takeHomePayYearly / 26;
                }
                // Show tax information
                this.isSubmitted = true;
            })
            .catch(error => {
                console.error('Error calculating taxes:', error);
            });
        } else {
            this.fedTax = null;
            this.ssTax = null;
            this.medicareTax = null;
        }
    }

    resetHandler(){
        this.fedTax = 0.00;
        this.ssTax = 0.00;
        this.medicareTax = 0.00;
        this.takeHomePayYearly = 0.00;
        this.takeHomePaySixMonths = 0.00;
        this.takeHomePayMonthly = 0.00;
        this.takeHomePayBiWeekly = 0.00;
        this.isSubmitted = false;
        this.salary ='';
    }



    
}