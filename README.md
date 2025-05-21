"# Active-Lines-of-Business-component-Year-wise" 
# 🔍 Active Lines of Business Lightning Component

This Salesforce project includes an LWC (Lightning Web Component) and Apex backend logic to display the active Lines of Business (LoBs) based on closed-won opportunities and their invoice data for a selected financial year.

---

## 📦 Project Structure

- **LWC Component:** `ActiveLinesofBusinessComponent`
- **Apex Controller:** `ActiveLinesofBusinessComponentController`
- **Data Source:** `Opportunity`, `Quote`, `PLSI_Invoice__c`
- **UI Framework:** Salesforce Lightning Design System (SLDS)

---

## 🚀 Features

- Dynamically fetches business units (LoBs) based on invoice data for a selected financial year.
- Intuitive and responsive UI using Salesforce LWC.
- Year selector dropdown allows viewing LoB data for multiple fiscal years.
- Handles asynchronous data fetch with a loading spinner.
- Applies active/inactive visual effects based on invoice value.
- Clean UX with contextual icons per LoB.

---

## 🧠 Technical Overview

### Apex Controller: `ActiveLinesofBusinessComponentController`

- **Method:** `getOppBUs(Id recordId, Integer seYear)`
- Fetches related Opportunities (`Closed Won`, `Completed`) for the selected Account (`recordId`).
- Aggregates taxable invoice values by LoB from `PLSI_Invoice__c` based on the invoice date and financial year range.
- Returns a list of `BUsWrapper` containing:
  - `BUName` – Name of the business unit
  - `BUAmount` – Total taxable value
  - `InvoiceDateW` – Invoice date of first occurrence

### LWC: `ActiveLinesofBusinessComponent`

- Uses `@api recordId` to retrieve LoBs for the Account record it's placed on.
- Dynamically calculates the current financial year in JavaScript.
- Provides year filtering and responsive loading.
- Assigns icons and SLDS-based styles dynamically.
- Uses combobox for year selection and loops over the results to display as business tiles.

---

## 📊 UI Output

Displays tiles for each active Business Unit:

- **Icons:** Based on SLDS Utility Icons
- **Color Code:**
  - **Blue:** Active (BUAmount > 0)
  - **Grey:** Inactive (BUAmount = 0)
- **Hover Effects:** Style-enhanced transitions

---

## 🧪 Testing & Considerations

- No external dependencies or managed packages required.
- Ensure mock data exists in `Opportunity`, `Quote`, and `PLSI_Invoice__c` for accurate results in sandbox/dev.
- Use `Test.isRunningTest()` and `SeeAllData=false` in Apex test classes.

---

## 🧱 Dependencies

- Custom Object: `PLSI_Invoice__c`
- Custom Fields:
  - `PLSI_Quotation_Name__c`
  - `PLSI_Invoice_Date__c`
  - `Taxable_Value__c`
  - `Division__c`
- Opportunity Stages: Must include `'Closed Won'`, `'Completed'`

---


