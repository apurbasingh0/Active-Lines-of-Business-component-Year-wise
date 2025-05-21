import { api, LightningElement, track } from 'lwc';
import getOppBUs from '@salesforce/apex/ActiveLinesofBusinessComponentController.getOppBUs';
import { NavigationMixin } from 'lightning/navigation';

export default class ActiveLinesofBusinessComponent extends NavigationMixin(LightningElement) {

    @api recordId;
    noBu=true;
    @track oppBu=[];
    load=true;
    @track selectedYear;
    @track yearOptions = [];

    
    noBlurClass='image-style';
    blurClass='image-style blur-effect';
    circleClass='icon-circle icon-circle-blue slds-m-around_xx-small slds-align_absolute-center';
    noCircleClass='icon-circle slds-m-around_xx-small slds-align_absolute-center';

    blueSquare="slds-grid slds-wrap icon-square icon-circle-blue slds-align--absolute-center";
    greySquare="slds-grid slds-wrap icon-square icon-circle-grey slds-align--absolute-center";

    iconList=['utility:image','utility:money','utility:screen','utility:moneybag','utility:desktop_and_phone',
                'utility:currency_input','utility:desktop_console'];

    connectedCallback(){
        this.generateYearOptions();
        this.selectedYear = this.getFinancialYear();
        this.getBUs();

    }

    // Calculate financial year dynamically based on the current date
    getFinancialYear() {
        const currentDate = new Date();
        const currentYear = currentDate.getFullYear();
        const currentMonth = currentDate.getMonth(); // January = 0, February = 1, ..., December = 11
        console.log('CurrentMonth'+this.currentMonth);

        // If the current month is January, February, or March, it's part of the previous financial year
        if (currentMonth < 3) {
        return (currentYear - 1).toString();
        }

        // Otherwise, it's part of the current financial year
        return currentYear.toString();
    }

    // get all active ptoducts by calling method 'getOppBUs'
    getBUs(){
        this.load=true;
        console.log('this.selectedYear2'+this.selectedYear);
        getOppBUs({recordId : this.recordId,seYear : this.selectedYear})
        .then(result=>{
            console.log('opportunity BUs',result);
            if(result.length==0){
                this.noBu=true;
            }else{
                var count=0;
                console.log('RESULT',result);
                this.oppBu=result.filter(item=>{
                    if(item.BUAmount>0){

                        console.log('Inside If ');
                        item.effect='active-effect';
                        console.log('item.effect',item.effect);
                        item.class='slds-icon_container slds-icon-custom-custom62 icon-style slds-align_absolute-center active-effect active-background';
                    }else{
                        console.log('Inside else ');
                
                        item.effect='inactive-effect';
                        console.log('item.effect',item.effect);
                        item.class='slds-icon_container slds-icon-custom-custom62 icon-style slds-align_absolute-center inactive-effect inactive-background';
                    }
                    item.iconUrl=this.iconList[count];
                    count++;
                    if(count==this.iconList.length){
                        count=0;
                    }
                    return item;
                    
                    
                });
                    
                this.noBu=false;
            }
            this.load=false;
        })
        .catch(error=>{
            console.log('error',error);
            this.showToastMessage('Error',error.message,'error');
            this.load=false;
        });
    }

    generateYearOptions() {
        const currentYear = new Date().getFullYear();
        const startYear = 2023;
        for (let year = startYear; year <= currentYear; year++) {
            this.yearOptions.push({ label: year.toString(), value: year.toString() });
        }
    }

    handleChange(event) {
        this.selectedYear = event.detail.value;
        console.log('this.selectedYear'+this.selectedYear);
        this.getBUs();
    }
    // redirect page to selected product rocord
   /* recordReference(event) { 
        var index = event.target.name; 
        this[NavigationMixin.Navigate]({ 
            type: 'standard__recordPage', 
            attributes: {  
                recordId: index, 
                actionName: 'view', 
            }, 
        }); 
    } */
}