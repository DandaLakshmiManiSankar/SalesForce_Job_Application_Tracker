import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import TITLE_FIELD from '@salesforce/schema/Job__c.Title__c';
import COMPANY_FIELD from '@salesforce/schema/Job__c.Company__c';
import LOCATION_FIELD from '@salesforce/schema/Job__c.Location__c';
import TYPE_FIELD from '@salesforce/schema/Job__c.Type__c';
import SALARY_FIELD from '@salesforce/schema/Job__c.Salary__c';
import LINK_FIELD from '@salesforce/schema/Job__c.Link__c';

import queryJobs from '@salesforce/apex/JobController.queryJobs';
import upsertJobApplications from '@salesforce/apex/JobApplicationController.upsertJobApplications';
import deleteJobs from '@salesforce/apex/JobController.deleteJobs';
import deleteAllJobs from '@salesforce/apex/JobController.deleteAllJobs';

const ACTIONS = [
    { label: 'Save As Job Application', name: 'save' }
];

const COLS = [
    {
        label: 'Title', 
        fieldName: TITLE_FIELD.fieldApiName, 
        type: 'text', 
        wrapText: true, 
        editable: false, 
        displayReadOnlyIcon: true, 
        sortable: true, 
        cellAttributes: { alignment: 'left' }
    }, 
    {
        label: 'Company', 
        fieldName: COMPANY_FIELD.fieldApiName, 
        type: 'text', 
        wrapText: true, 
        editable: false, 
        displayReadOnlyIcon: true, 
        sortable: true, 
        cellAttributes: { alignment: 'left' }
    }, 
    {
        label: 'Location', 
        fieldName: LOCATION_FIELD.fieldApiName, 
        type: 'text', 
        wrapText: true, 
        editable: false, 
        displayReadOnlyIcon: true, 
        sortable: true, 
        cellAttributes: { alignment: 'left' }
    }, 
    {
        label: 'Type', 
        fieldName: TYPE_FIELD.fieldApiName, 
        type: 'text', 
        wrapText: true, 
        editable: false, 
        displayReadOnlyIcon: true, 
        sortable: true, 
        cellAttributes: { alignment: 'left' }
    }, 
    {
        label: 'Salary', 
        fieldName: SALARY_FIELD.fieldApiName, 
        type: 'text', 
        wrapText: true, 
        editable: false, 
        displayReadOnlyIcon: true, 
        sortable: true, 
        cellAttributes: { alignment: 'left' }
    }, 
    {
        label: 'Link', 
        fieldName: LINK_FIELD.fieldApiName, 
        type: 'url', 
        wrapText: false, 
        editable: false, 
        displayReadOnlyIcon: true, 
        sortable: true, 
        cellAttributes: { alignment: 'left' }
    }, 
    {
        type: 'action', 
        typeAttributes: { rowActions: ACTIONS, menuAlignment: 'auto' }
    }
];

export default class JobSearchResult extends LightningElement {
    columns = COLS;

    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

    recordIds = [];

    @wire(queryJobs) jobs;

    handleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const CLONE_DATA = [...this.jobs.data];

        CLONE_DATA.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));

        this.jobs.data = CLONE_DATA;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }

    sortBy(field, reverse, primer) {
        const KEY = primer 
            ? function (x) { return primer(x[field]); }
            : function (x) { return x[field]; };

        return function (a, b) {
            a = KEY(a);
            b = KEY(b);

            return reverse * ((a > b) - (b > a));
        };
    }

    async handleRowAction(event) {
        const ACTION = event.detail.action;
        const ROW = event.detail.row;

        switch (ACTION.name) {
            case 'save':
                try {
                    await upsertJobApplications({ recordIds: ROW.Id });

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success', 
                            message: 'Job Application saved', 
                            variant: 'success'
                        })
                    );
                } catch (e) {
                    this.handleErrorWhileUpsertingRecord(e);
                }

                try {
                    await deleteJobs({ recordIds: ROW.Id });
                } catch (e) {
                    this.handleErrorWhileDeletingRecord(e);
                }

                try {
                    await refreshApex(this.jobs);
                } catch (e) {
                    this.handleErrorWhileRefreshingRecord(e);
                }

                break;
            default:
                console.log('switch default');

                break;
        }
    }

    handleErrorWhileUpsertingRecord(e) {
        console.log('JSON.stringify(e) = ' + JSON.stringify(e));

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error while upserting records', 
                message: e.body.message, 
                variant: 'error'
            })
        );
    }

    handleErrorWhileDeletingRecord(e) {
        console.log('JSON.stringify(e) = ' + JSON.stringify(e));

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error while deleting records', 
                message: e.body.message, 
                variant: 'error'
            })
        );
    }

    handleErrorWhileRefreshingRecord(e) {
        console.log('JSON.stringify(e) = ' + JSON.stringify(e));

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error while refreshing records', 
                message: e.body.message, 
                variant: 'error'
            })
        );
    }

    handleRowSelection(event) {
        const SELECTED_ROWS = event.detail.selectedRows;
        const VALUE = event.detail.config.value;

        switch (event.detail.config.action) {
            case 'selectAllRows':
                for (let i = 0; i < SELECTED_ROWS.length; i++) {
                    this.recordIds = [...this.recordIds, SELECTED_ROWS[i].Id];
                }

                break;
            case 'deselectAllRows':
                this.recordIds = [];

                break;
            case 'rowSelect':
                this.recordIds = [...this.recordIds, VALUE];

                break;
            case 'rowDeselect':
                this.recordIds = this.recordIds.filter((recordId) => recordId != VALUE);

                break;
            default:
                console.log('switch default');

                break;
        }
    }

    async handleUpsertJobApplicationAndDeleteJobAndRefreshRecord(event) {
        event.preventDefault();

        if (this.recordIds == null || this.recordIds == '' || this.recordIds == []) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'No job selected', 
                    message: 'Select at least one job to save as job application', 
                    variant: 'error'
                })
            );

            return;
        }

        try {
            await upsertJobApplications({ recordIds: this.recordIds });

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success', 
                    message: 'Job Applications saved', 
                    variant: 'success'
                })
            );
        } catch (e) {
            this.handleErrorWhileUpsertingRecord(e);
        }

        try {
            await deleteJobs({ recordIds: this.recordIds });

            this.recordIds = [];
        } catch (e) {
            this.handleErrorWhileDeletingRecord(e);
        }

        try {
            await refreshApex(this.jobs);
        } catch (e) {
            this.handleErrorWhileRefreshingRecord(e);
        }
    }

    async handleClearAllResultsAndRefreshRecord(event) {
        event.preventDefault();

        try {
            await deleteAllJobs();

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success', 
                    message: 'All results cleared', 
                    variant: 'success'
                })
            );
        } catch (e) {
            this.handleErrorWhileDeletingRecord(e);
        }

        try {
            await refreshApex(this.jobs);
        } catch (e) {
            this.handleErrorWhileRefreshingRecord(e);
        }
    }
}