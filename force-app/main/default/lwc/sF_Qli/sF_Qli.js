import { LightningElement, api } from 'lwc';


export default class SF_Qli extends LightningElement {

    @api qliId;
    @api qliData;
    @api labelInfo;
    @api currencyIsoCode;
    @api isOption;
    @api isBundle;
    // hellow
    

    options = []
    buttonIcon = '+';
    expandOptions = false;
    currentQliItem;

    currencyFields = [];
    stringFields = [];
    inputableFields = [];
    otherFields = [];


    connectedCallback() {
        this.processQliInfo();
        this.processQliOptions();
        this.processColumns(this.currentQliItem[0]);
    }



    processQliInfo = () => {
        const qli = this.qliData.filter(item => {
            return item.Id === this.qliId;
        })
        this.currentQliItem = JSON.parse(JSON.stringify(qli));
        this.labelInfo = JSON.parse(JSON.stringify(this.labelInfo));
    }


    processQliOptions = () => {
        let bundlesQliList = [];
        let options = [];

        this.qliData.forEach(item => {
            if (item.IsBundle__c === true) {
                bundlesQliList.push(JSON.parse(JSON.stringify(item)));
            }
            else {
                options.push(JSON.parse(JSON.stringify(item)));
            }
        })

        bundlesQliList.forEach(bundle => {
            bundle['optionQlis'] = [];

            options.forEach(option => {
                if (option.Quote_Line_Item__c === bundle.Id) {
                    bundle.optionQlis.push(option);
                }
            })

        })

        let cunrrentBundle = {}
        bundlesQliList.forEach(item => {
            if (item.Id === this.qliId)
                cunrrentBundle = item;
        })

        this.options = cunrrentBundle.optionQlis;

    }

    processColumns = (qliItem) => {
        let mapQli = new Map();
        for (let key in qliItem) {
            mapQli.set(key, qliItem[key]);
        }

        console.log(mapQli, ' + map');
        this.labelInfo.forEach(item => {
            const qliObject = {
                type: item.type,
                qliFieldValue: mapQli.get(item.fieldName)
            };

            console.log(qliObject, ' + qli object')

            if (qliObject.type === 'CURRENCY') {
                this.currencyFields.push(qliObject);
            } else if (qliObject.type === 'DOUBLE') {
                this.inputableFields.push(qliObject)
            } else if (qliObject.type === 'STRING') {
                this.stringFields.push(qliObject)
            }
            else {
                this.otherFields.push(qliObject);
            }
        })
    }

    cloneQliWithOptions=()=>{

    }


    handelExpand = () => {
        console.log(this.isBundle);
        this.expandOptions = !this.expandOptions;
    }
}